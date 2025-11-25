#!/bin/bash

echo "🔥 Generating Realistic Application Errors..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Configuration
APP_BASE_URL="http://localhost:3000"

echo "Simulating Database Connection Errors..."
for i in {1..5}; do
    curl -s "$APP_BASE_URL/api/users/12345" > /dev/null
    echo "  ⚠️  Database connection error #$i"
    sleep 2
done

echo ""
echo "Simulating Payment Gateway Timeouts..."
for i in {1..3}; do
    curl -s -X POST "$APP_BASE_URL/api/checkout" -H "Content-Type: application/json" > /dev/null
    echo "  ⏱️  Payment timeout error #$i"
    sleep 2
done

echo ""
echo "Simulating Authentication Failures..."
for i in {1..4}; do
    curl -s "$APP_BASE_URL/api/orders" > /dev/null
    echo "  🔒 Auth failure #$i"
    sleep 2
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Generated 12 realistic errors!"
echo ""
echo "📊 Error Breakdown:"
echo "  - Database Connection Errors: 5"
echo "  - Payment Gateway Timeouts: 3"
echo "  - Authentication Failures: 4"
echo ""
echo "📊 Next Steps:"
echo "  1. Wait 10 seconds for logs to batch and export"
echo "  2. Check SigNoz UI: http://localhost:8080"
echo "  3. AI Analyzer will detect patterns"
echo "  4. GitHub issue will be created automatically"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
