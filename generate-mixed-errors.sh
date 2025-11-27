#!/bin/bash

echo "🎲 Generating Random Mixed Errors for RightWatch..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Configuration
APP_BASE_URL="http://localhost:3000"
ERRORS=(
    "/api/login"
    "/api/secure-endpoint"
    "/api/users/12345"
    "/api/database/query-timeout"
    "/api/database/deadlock"
    "/api/checkout"
    "/api/external/rate-limit"
    "/api/external/unavailable"
    "/api/validation/create"
    "/api/memory/heap-limit"
    "/api/cache/redis-down"
    "/api/network/dns-failure"
    "/api/security/brute-force"
    "/api/config/missing-env"
    "/api/business/insufficient-inventory"
    "/api/files/not-found"
)

ERROR_NAMES=(
    "Auth token error"
    "Permission denied"
    "Database connection"
    "Query timeout"
    "Database deadlock"
    "Payment timeout"
    "API rate limit"
    "External service down"
    "Validation error"
    "Out of memory"
    "Cache unavailable"
    "DNS failure"
    "Security threat"
    "Config error"
    "Business logic error"
    "File not found"
)

echo "Generating 30 random errors..."
echo ""

for i in {1..30}; do
    # Pick a random error
    INDEX=$((RANDOM % ${#ERRORS[@]}))
    ENDPOINT="${ERRORS[$INDEX]}"
    ERROR_NAME="${ERROR_NAMES[$INDEX]}"

    # Determine method
    if [[ "$ENDPOINT" == *"/checkout"* ]] || [[ "$ENDPOINT" == *"/validation"* ]]; then
        curl -s -X POST "$APP_BASE_URL$ENDPOINT" -H "Content-Type: application/json" > /dev/null
    else
        curl -s "$APP_BASE_URL$ENDPOINT" > /dev/null
    fi

    echo "  ⚠️  [$i/30] $ERROR_NAME"

    # Random sleep between 1-3 seconds
    sleep $((RANDOM % 3 + 1))
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Generated 30 random mixed errors!"
echo ""
echo "📊 RightWatch AI will:"
echo "  1. Detect error patterns in SigNoz"
echo "  2. Group similar errors together"
echo "  3. Create GitHub issues for each pattern"
echo "  4. Trigger n8n workflow for AI solutions"
echo ""
echo "⏱️  Check results in 5-10 minutes:"
echo "  - SigNoz: http://localhost:8080"
echo "  - GitHub: https://github.com/manishrightsteps/monitor/issues"
echo "  - n8n: https://n8n.easytechinnovate.site"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
