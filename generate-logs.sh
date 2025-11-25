#!/bin/bash

echo "📊 Generating Mixed Test Logs (Success + Errors)..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Configuration
APP_BASE_URL="http://localhost:3000"
TOTAL_REQUESTS=30
DELAY=2
ERROR_RATE=30  # 30% errors, 70% success

# Endpoints
HEALTH_URL="$APP_BASE_URL/health"
ERROR_URL="$APP_BASE_URL/error"

# Counters
SUCCESS_COUNT=0
ERROR_COUNT=0

# Check if app is running
echo "Checking if app is running..."
if ! curl -s "$HEALTH_URL" > /dev/null 2>&1; then
    echo "❌ Error: App is not running on $APP_BASE_URL"
    echo "Please start the app first: cd app && npm start"
    exit 1
fi

echo "✅ App is running"
echo ""
echo "Generating $TOTAL_REQUESTS requests ($ERROR_RATE% errors, $((100-ERROR_RATE))% success)..."
echo ""

# Generate mixed logs
for i in $(seq 1 $TOTAL_REQUESTS); do
    # Generate random number 1-100
    RANDOM_NUM=$((RANDOM % 100 + 1))

    if [ $RANDOM_NUM -le $ERROR_RATE ]; then
        # Generate ERROR
        RESPONSE=$(curl -s -w "\n%{http_code}" "$ERROR_URL")
        HTTP_CODE=$(echo "$RESPONSE" | tail -n1)

        if [ "$HTTP_CODE" -eq 500 ]; then
            echo "🔴 Request $i/$TOTAL_REQUESTS - ERROR - HTTP $HTTP_CODE - Logged"
            ((ERROR_COUNT++))
        else
            echo "⚠️  Request $i/$TOTAL_REQUESTS - ERROR - HTTP $HTTP_CODE - Unexpected"
        fi
    else
        # Generate SUCCESS
        RESPONSE=$(curl -s -w "\n%{http_code}" "$HEALTH_URL")
        HTTP_CODE=$(echo "$RESPONSE" | tail -n1)

        if [ "$HTTP_CODE" -eq 200 ]; then
            echo "🟢 Request $i/$TOTAL_REQUESTS - SUCCESS - HTTP $HTTP_CODE"
            ((SUCCESS_COUNT++))
        else
            echo "⚠️  Request $i/$TOTAL_REQUESTS - SUCCESS - HTTP $HTTP_CODE - Unexpected"
        fi
    fi

    if [ $i -lt $TOTAL_REQUESTS ]; then
        sleep $DELAY
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Generated $TOTAL_REQUESTS requests successfully!"
echo ""
echo "📈 Statistics:"
echo "  🟢 Success: $SUCCESS_COUNT requests (HTTP 200)"
echo "  🔴 Errors:  $ERROR_COUNT requests (HTTP 500)"
echo "  📊 Error Rate: $(( (ERROR_COUNT * 100) / TOTAL_REQUESTS ))%"
echo ""
echo "📊 Next Steps:"
echo "  1. Check SigNoz UI: http://localhost:8080"
echo "  2. View Logs tab - filter by service: rightstep-app"
echo "  3. See both INFO (success) and ERROR (failure) logs"
echo "  4. Wait 5-15 minutes for AI Analyzer to detect errors"
echo "  5. Check GitHub issues: https://github.com/manishrightsteps/monitor/issues"
echo ""
echo "⏰ AI Analyzer runs every 5 minutes and detects ERROR patterns"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
