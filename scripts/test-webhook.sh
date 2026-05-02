#!/usr/bin/env bash
set -euo pipefail

# Test the Corvus Player webhook + email flow without a real Paddle purchase.
# Generates a valid HMAC-SHA256 signature and sends a fake transaction.completed event.

WORKER_URL="https://corvus-license.soyelale.workers.dev"
TEST_EMAIL="${1:-avisame90341@icloud.com}"
TEST_TXN_ID="txn_test_$(date +%s)"

echo "=== Corvus Player Webhook Test ==="
echo "Worker:  $WORKER_URL"
echo "Email:   $TEST_EMAIL"
echo "Txn ID:  $TEST_TXN_ID"
echo ""

# Get the webhook secret
echo -n "Enter PADDLE_WEBHOOK_SECRET: "
read -rs WEBHOOK_SECRET
echo ""

if [[ -z "$WEBHOOK_SECRET" ]]; then
    echo "Error: Secret cannot be empty"
    exit 1
fi

# Build the payload
BODY=$(cat <<JSON
{
  "event_type": "transaction.completed",
  "data": {
    "id": "$TEST_TXN_ID",
    "customer_id": "ctm_test_123",
    "checkout": {
      "customer_email": "$TEST_EMAIL"
    },
    "items": [
      {
        "price": {
          "product_id": "pro_01kqj3tcf4cxyhd1g83z3zfenw"
        }
      }
    ]
  }
}
JSON
)

# Generate Paddle-style signature: ts=TIMESTAMP;h1=HMAC-SHA256(ts:body)
TS=$(date +%s)
SIGNED_PAYLOAD="${TS}:${BODY}"
H1=$(printf '%s' "$SIGNED_PAYLOAD" | openssl dgst -sha256 -hmac "$WEBHOOK_SECRET" -hex 2>/dev/null | awk '{print $NF}')
SIGNATURE="ts=${TS};h1=${H1}"

echo ">>> Sending webhook..."
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$WORKER_URL/webhook" \
    -H "Content-Type: application/json" \
    -H "Paddle-Signature: $SIGNATURE" \
    -d "$BODY")

HTTP_CODE=$(echo "$RESPONSE" | tail -1)
RESPONSE_BODY=$(echo "$RESPONSE" | head -n -1)

echo "    Status: $HTTP_CODE"
echo "    Response: $RESPONSE_BODY"
echo ""

if [[ "$HTTP_CODE" != "200" ]]; then
    echo "Webhook failed. Check the secret and try again."
    exit 1
fi

echo ">>> Verifying license in KV..."
VERIFY=$(curl -s "$WORKER_URL/verify?key=$TEST_TXN_ID")
echo "    $VERIFY"
echo ""

echo "=== Done ==="
echo "Check $TEST_EMAIL for the license email."
echo "License key: $TEST_TXN_ID"
