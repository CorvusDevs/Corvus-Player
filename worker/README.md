# Corvus License Worker

Cloudflare Worker that handles Paddle webhooks, stores licenses in KV, sends email receipts via Resend, and verifies licenses for the app.

## Setup

### 1. Prerequisites
```bash
npm install -g wrangler
wrangler login
```

### 2. Create KV Namespace
```bash
cd worker
wrangler kv namespace create LICENSES
```
Copy the `id` into `wrangler.toml`.

### 3. Set Secrets
```bash
wrangler secret put PADDLE_WEBHOOK_SECRET   # From Paddle > Developer Tools > Notifications
wrangler secret put PADDLE_API_KEY          # From Paddle > Developer Tools > Authentication
wrangler secret put RESEND_API_KEY          # From resend.com (free: 100 emails/day)
```

### 4. Configure Email
1. Sign up at [resend.com](https://resend.com) (free tier: 100 emails/day)
2. Add and verify your domain (corvusdevs.com)
3. Copy the API key and set it as a secret above
4. Update `FROM_EMAIL` in `wrangler.toml` if needed

### 5. Deploy
```bash
wrangler deploy
```

### 6. Configure Custom Domain (Optional)
In Cloudflare Dashboard: Workers & Pages → corvus-license → Settings → Triggers → Add Custom Domain → `license.corvusdevs.com`

### 7. Set Paddle Webhook URL
In Paddle Dashboard → Developer Tools → Notifications → New Destination:
- URL: `https://license.corvusdevs.com/webhook` (or your workers.dev URL)
- Events: `transaction.completed`

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | `/webhook` | Paddle webhook receiver |
| GET | `/verify?key=txn_xxx` | License verification (used by the app) |
| GET | `/health` | Health check |

## Testing Locally
```bash
wrangler dev
# Then POST to http://localhost:8787/webhook with a test payload
```
