export default {
    async fetch(request, env) {
        const url = new URL(request.url);
        const corsHeaders = {
            "Access-Control-Allow-Origin": env.CORS_ORIGIN || "*",
            "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
            "Access-Control-Allow-Headers": "Content-Type",
        };

        if (request.method === "OPTIONS") {
            return new Response(null, { status: 204, headers: corsHeaders });
        }

        try {
            let response;

            if (url.pathname === "/webhook" && request.method === "POST") {
                response = await handleWebhook(request, env);
            } else if (url.pathname === "/verify" && (request.method === "GET" || request.method === "POST")) {
                response = await handleVerify(request, url, env);
            } else if (url.pathname === "/health") {
                response = json({ status: "ok" });
            } else {
                response = json({ error: "Not found" }, 404);
            }

            Object.entries(corsHeaders).forEach(([k, v]) => response.headers.set(k, v));
            return response;
        } catch (err) {
            console.error("Unhandled error:", err);
            return json({ error: "Internal server error" }, 500);
        }
    },
};

// ─── Paddle Webhook ──────────────────────────────────────────────

async function handleWebhook(request, env) {
    const signature = request.headers.get("Paddle-Signature");
    if (!signature) return json({ error: "Missing signature" }, 401);

    const body = await request.text();

    const valid = await verifyPaddleSignature(body, signature, env.PADDLE_WEBHOOK_SECRET);
    if (!valid) return json({ error: "Invalid signature" }, 401);

    const event = JSON.parse(body);

    if (event.event_type === "transaction.completed") {
        const txn = event.data;

        // Paddle delivers every notification to every destination; without
        // this a purchase of any other app mints a licence here.
        if (!isOurProduct(txn, env.PRODUCT_ID)) {
            return json({ received: true, ignored: "different product" });
        }

        const licenseKey = txn.id;

        // Paddle's `transaction.completed` payload carries `customer_id`, NOT
        // the buyer's email: `checkout.customer_email` is null and there is no
        // nested `customer` object, so all three lookups below return nothing on
        // a real webhook. Without the API lookup the licence is stored with
        // `email: null` and silently emailed to nobody.
        //
        // Same defect found and fixed in the Ekual worker on 2026-08-10, where
        // it had gone unnoticed for months and cost real customers their keys.
        let email = txn.checkout?.customer_email
            || txn.customer?.email
            || extractEmailFromCustomData(txn);

        if (!email && txn.customer_id) {
            email = await fetchCustomerEmail(txn.customer_id, env.PADDLE_API_KEY);
        }

        // Delivery outcome is persisted so an undelivered licence is auditable
        // instead of invisible.
        let emailStatus;
        if (!email) {
            emailStatus = "no_email_resolved";
            console.error(
                `LICENSE EMAIL NOT SENT: no email resolved for transaction ${licenseKey} (customer ${txn.customer_id || "unknown"}). Is PADDLE_API_KEY set on this worker?`
            );
        } else if (!env.RESEND_API_KEY) {
            emailStatus = "no_resend_key";
            console.error(`LICENSE EMAIL NOT SENT: RESEND_API_KEY missing (transaction ${licenseKey})`);
        } else {
            try {
                await sendLicenseEmail(email, licenseKey, env);
                emailStatus = "sent";
            } catch (err) {
                emailStatus = "send_failed";
                console.error(`LICENSE EMAIL SEND FAILED for ${licenseKey}:`, err);
            }
        }

        await env.LICENSES.put(
            licenseKey,
            JSON.stringify({
                email: email || null,
                emailStatus,
                transactionId: txn.id,
                customerId: txn.customer_id || null,
                productId: txn.items?.[0]?.price?.product_id || null,
                createdAt: new Date().toISOString(),
            })
        );
    }

    return json({ received: true });
}

// ─── License Verification ────────────────────────────────────────

async function handleVerify(request, url, env) {
    // POST keeps license keys out of URLs and infrastructure access logs.
    // GET remains temporarily supported for older app versions.
    let key;
    if (request.method === "POST") {
        const contentType = request.headers.get("Content-Type") || "";
        if (!contentType.toLowerCase().startsWith("application/json")) {
            return json({ valid: false, error: "Expected application/json" }, 415);
        }
        const body = await request.json().catch(() => null);
        key = typeof body?.key === "string" ? body.key : null;
    } else {
        key = url.searchParams.get("key");
    }
    if (!key) return json({ valid: false, error: "Missing key" }, 400);

    const stored = await env.LICENSES.get(key);
    if (!stored) return json({ valid: false }, 404);

    const data = JSON.parse(stored);
    return json({ valid: true, email: maskEmail(data.email) });
}


// ─── Product Scoping ─────────────────────────────────────────────

/**
 * True when this transaction is for the product THIS worker serves.
 *
 * Paddle delivers EVERY notification to EVERY configured destination, so without
 * this a purchase of any CorvusDevs app mints a valid licence in every other
 * app's store. Checks every line item, not just the first.
 *
 * Returns true when `expectedProductId` is unset, so a missing config var
 * degrades to the old behaviour rather than refusing to issue licences at all.
 */
function isOurProduct(txn, expectedProductId) {
    if (!expectedProductId) {
        console.error(
            "PRODUCT_ID is not configured on this worker, cannot scope licences to a product, so a purchase of ANY product will mint a licence here. Set it in the deploy config [vars]."
        );
        return true;
    }
    const ids = (txn.items || []).map((i) => i?.price?.product_id).filter(Boolean);
    return ids.includes(expectedProductId);
}

// ─── Customer Lookup ─────────────────────────────────────────────

/**
 * Resolve a customer's email from their Paddle customer_id.
 *
 * Required because the webhook payload never carries the email itself. Returns
 * null on any failure; the caller records that rather than throwing, so a lookup
 * outage can never cost us the licence record itself.
 */
async function fetchCustomerEmail(customerId, apiKey) {
    if (!apiKey) {
        console.error(
            "PADDLE_API_KEY is not configured on this worker, cannot resolve customer email. Set it with: wrangler secret put PADDLE_API_KEY"
        );
        return null;
    }
    try {
        const res = await fetch(`https://api.paddle.com/customers/${customerId}`, {
            headers: { Authorization: `Bearer ${apiKey}` },
        });
        if (!res.ok) {
            console.error(
                `Paddle customer lookup failed for ${customerId}: HTTP ${res.status} ${await res.text()}`
            );
            return null;
        }
        const body = await res.json();
        return body?.data?.email || null;
    } catch (err) {
        console.error(`Paddle customer lookup threw for ${customerId}:`, err);
        return null;
    }
}

// ─── Paddle Signature Verification ──────────────────────────────

async function verifyPaddleSignature(body, signatureHeader, secret) {
    const parts = {};
    signatureHeader.split(";").forEach((part) => {
        const idx = part.indexOf("=");
        if (idx !== -1) {
            parts[part.substring(0, idx)] = part.substring(idx + 1);
        }
    });

    const ts = parts["ts"];
    const h1 = parts["h1"];
    if (!ts || !h1) return false;

    const age = Math.abs(Date.now() / 1000 - parseInt(ts, 10));
    if (age > 300) return false;

    const signedPayload = `${ts}:${body}`;

    const key = await crypto.subtle.importKey(
        "raw",
        new TextEncoder().encode(secret),
        { name: "HMAC", hash: "SHA-256" },
        false,
        ["sign"]
    );

    const sig = await crypto.subtle.sign(
        "HMAC",
        key,
        new TextEncoder().encode(signedPayload)
    );

    const computed = Array.from(new Uint8Array(sig))
        .map((b) => b.toString(16).padStart(2, "0"))
        .join("");

    return computed === h1;
}

// ─── Email (Resend) ──────────────────────────────────────────────
//
// MUST use Resend (a real ESP), NOT Cloudflare Email Workers
// (`cloudflare:email` + `env.EMAIL.send()`). The CF binding only delivers
// to destination addresses pre-verified on the same Cloudflare account,
// so it silently fails for arbitrary paying customers. See
// ~/.claude/skills/paddle-license-worker.md for the full rationale.

async function sendLicenseEmail(to, licenseKey, env) {
    const from = env.FROM_EMAIL || "Corvus Player <noreply@shopa.pro>";
    const res = await fetch("https://api.resend.com/emails", {
        method: "POST",
        headers: {
            Authorization: `Bearer ${env.RESEND_API_KEY}`,
            "Content-Type": "application/json",
        },
        body: JSON.stringify({
            from,
            to: [to],
            subject: "Your Corvus Player Supporter License Key",
            html: buildEmailHtml(licenseKey),
        }),
    });
    if (!res.ok) {
        const text = await res.text().catch(() => "");
        throw new Error(`Resend ${res.status}: ${text}`);
    }
}

function buildEmailHtml(licenseKey) {
    return `<!DOCTYPE html>
<html>
<head><meta charset="utf-8"></head>
<body style="margin:0;padding:0;background:#0a0a0c;font-family:-apple-system,BlinkMacSystemFont,'SF Pro Display','Helvetica Neue',sans-serif">
<table width="100%" cellpadding="0" cellspacing="0" style="background:#0a0a0c;padding:40px 20px">
<tr><td align="center">
<table width="480" cellpadding="0" cellspacing="0" style="background:#111114;border-radius:16px;border:1px solid #252530;overflow:hidden">
    <tr><td style="padding:40px 32px 24px;text-align:center">
        <div style="font-size:40px;margin-bottom:16px">🎬</div>
        <h1 style="color:#e8e8ed;font-size:24px;font-weight:700;margin:0 0 8px">Thank you for supporting Corvus Player</h1>
        <p style="color:#7c7c84;font-size:15px;margin:0">Thank you for your purchase!</p>
    </td></tr>
    <tr><td style="padding:0 32px 32px">
        <div style="background:#19191e;border:1px solid #252530;border-radius:12px;padding:20px;text-align:center">
            <p style="color:#7c7c84;font-size:13px;margin:0 0 8px;text-transform:uppercase;letter-spacing:1px">Your License Key</p>
            <p style="color:#5a9dff;font-size:18px;font-weight:600;font-family:'SF Mono',Menlo,monospace;margin:0;word-break:break-all">${licenseKey}</p>
        </div>
    </td></tr>
    <tr><td style="padding:0 32px 32px">
        <h3 style="color:#e8e8ed;font-size:15px;margin:0 0 12px">How to activate:</h3>
        <ol style="color:#7c7c84;font-size:14px;line-height:1.8;margin:0;padding-left:20px">
            <li>Open Corvus Player</li>
            <li>Go to <strong style="color:#e8e8ed">Settings → Advanced → License</strong></li>
            <li>Paste your license key and click <strong style="color:#e8e8ed">Activate</strong></li>
        </ol>
    </td></tr>
    <tr><td style="padding:0 32px 32px;text-align:center">
        <a href="https://corvusdevs.github.io/Corvus-Player/" style="display:inline-block;background:#2d7ff9;color:#fff;text-decoration:none;padding:12px 28px;border-radius:10px;font-size:15px;font-weight:600">Download Corvus Player</a>
    </td></tr>
    <tr><td style="padding:0 32px 24px;border-top:1px solid #252530;padding-top:24px">
        <p style="color:#7c7c84;font-size:12px;text-align:center;margin:0">
            Keep this email for your records. You can reuse this key if you reinstall.<br>
            Questions? <a href="mailto:corvusdevs@outlook.com" style="color:#5a9dff;text-decoration:none">corvusdevs@outlook.com</a>
        </p>
    </td></tr>
</table>
</td></tr>
</table>
</body>
</html>`;
}

// ─── Helpers ─────────────────────────────────────────────────────

function json(data, status = 200) {
    return new Response(JSON.stringify(data), {
        status,
        headers: { "Content-Type": "application/json" },
    });
}

function maskEmail(email) {
    if (!email) return null;
    const [user, domain] = email.split("@");
    if (!domain) return "***";
    const visible = user.substring(0, Math.min(3, user.length));
    return `${visible}***@${domain}`;
}

function extractEmailFromCustomData(txn) {
    try {
        if (txn.custom_data?.email) return txn.custom_data.email;
        if (txn.checkout?.custom_data?.email) return txn.checkout.custom_data.email;
    } catch { /* ignore */ }
    return null;
}
