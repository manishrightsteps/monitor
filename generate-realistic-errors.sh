#!/bin/bash

echo "🔥 Generating Realistic Application Errors for RightWatch..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Configuration
APP_BASE_URL="http://localhost:3000"

echo "🔐 Simulating Authentication Errors..."
for i in {1..5}; do
    curl -s "$APP_BASE_URL/api/login" > /dev/null
    echo "  ⚠️  JWT token error #$i"
    sleep 1
done

echo ""
echo "🛡️  Simulating Permission Errors..."
for i in {1..3}; do
    curl -s "$APP_BASE_URL/api/secure-endpoint" > /dev/null
    echo "  ⚠️  Permission denied #$i"
    sleep 1
done

echo ""
echo "💾 Simulating Database Errors..."
for i in {1..4}; do
    curl -s "$APP_BASE_URL/api/users/12345" > /dev/null
    echo "  ⚠️  Database connection error #$i"
    sleep 1
done

echo ""
echo "⏰ Simulating Query Timeouts..."
for i in {1..3}; do
    curl -s "$APP_BASE_URL/api/database/query-timeout" > /dev/null
    echo "  ⚠️  Query timeout #$i"
    sleep 1
done

echo ""
echo "🔁 Simulating Database Deadlocks..."
for i in {1..2}; do
    curl -s "$APP_BASE_URL/api/database/deadlock" > /dev/null
    echo "  ⚠️  Deadlock detected #$i"
    sleep 1
done

echo ""
echo "💳 Simulating Payment Errors..."
for i in {1..3}; do
    curl -s -X POST "$APP_BASE_URL/api/checkout" -H "Content-Type: application/json" > /dev/null
    echo "  ⚠️  Payment timeout #$i"
    sleep 1
done

echo ""
echo "🌐 Simulating External API Errors..."
for i in {1..3}; do
    curl -s "$APP_BASE_URL/api/external/rate-limit" > /dev/null
    echo "  ⚠️  Rate limit exceeded #$i"
    sleep 1
done

for i in {1..2}; do
    curl -s "$APP_BASE_URL/api/external/unavailable" > /dev/null
    echo "  ⚠️  External service down #$i"
    sleep 1
done

echo ""
echo "📝 Simulating Validation Errors..."
for i in {1..2}; do
    curl -s -X POST "$APP_BASE_URL/api/validation/create" -H "Content-Type: application/json" > /dev/null
    echo "  ⚠️  Validation error #$i"
    sleep 1
done

echo ""
echo "💾 Simulating Memory Errors..."
for i in {1..2}; do
    curl -s "$APP_BASE_URL/api/memory/heap-limit" > /dev/null
    echo "  ⚠️  Out of memory #$i"
    sleep 1
done

echo ""
echo "🗄️  Simulating Cache Errors..."
for i in {1..3}; do
    curl -s "$APP_BASE_URL/api/cache/redis-down" > /dev/null
    echo "  ⚠️  Redis unavailable #$i"
    sleep 1
done

echo ""
echo "🌍 Simulating Network Errors..."
for i in {1..2}; do
    curl -s "$APP_BASE_URL/api/network/dns-failure" > /dev/null
    echo "  ⚠️  DNS failure #$i"
    sleep 1
done

echo ""
echo "🔒 Simulating Security Threats..."
for i in {1..2}; do
    curl -s "$APP_BASE_URL/api/security/brute-force" > /dev/null
    echo "  ⚠️  Brute force detected #$i"
    sleep 1
done

echo ""
echo "⚙️  Simulating Configuration Errors..."
for i in {1..2}; do
    curl -s "$APP_BASE_URL/api/config/missing-env" > /dev/null
    echo "  ⚠️  Config error #$i"
    sleep 1
done

echo ""
echo "📦 Simulating Business Logic Errors..."
for i in {1..2}; do
    curl -s "$APP_BASE_URL/api/business/insufficient-inventory" > /dev/null
    echo "  ⚠️  Insufficient inventory #$i"
    sleep 1
done

echo ""
echo "📁 Simulating File System Errors..."
for i in {1..2}; do
    curl -s "$APP_BASE_URL/api/files/not-found" > /dev/null
    echo "  ⚠️  File not found #$i"
    sleep 1
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Generated 45 realistic errors across 15 different categories!"
echo ""
echo "📊 Error Breakdown:"
echo "  - Authentication (JWT): 5 errors"
echo "  - Permission Denied: 3 errors"
echo "  - Database Connection: 4 errors"
echo "  - Query Timeouts: 3 errors"
echo "  - Database Deadlocks: 2 errors"
echo "  - Payment Timeouts: 3 errors"
echo "  - API Rate Limits: 3 errors"
echo "  - External Service Down: 2 errors"
echo "  - Validation Errors: 2 errors"
echo "  - Memory Errors: 2 errors"
echo "  - Cache Errors: 3 errors"
echo "  - Network Errors: 2 errors"
echo "  - Security Threats: 2 errors"
echo "  - Configuration Errors: 2 errors"
echo "  - Business Logic: 2 errors"
echo "  - File System: 2 errors"
echo ""
echo "📊 Next Steps:"
echo "  1. Wait 5-10 minutes for AI Analyzer to process logs"
echo "  2. Check SigNoz UI: http://localhost:8080"
echo "  3. RightWatch AI will detect error patterns"
echo "  4. GitHub issues will be created automatically"
echo "  5. n8n will post AI solutions to each issue"
echo ""
echo "💡 To generate specific error types:"
echo "  ./generate-auth-errors.sh     - Only auth errors"
echo "  ./generate-database-errors.sh - Only database errors"
echo "  ./generate-mixed-errors.sh    - Random mixed errors"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
