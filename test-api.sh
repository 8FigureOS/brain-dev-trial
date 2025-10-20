#!/bin/bash

# Test script for Knowledge Extraction API
# Usage: ./test-api.sh [base_url]
# Example: ./test-api.sh http://localhost:3000

BASE_URL="${1:-http://localhost:3000}"

echo "🧪 Testing Knowledge Extraction API"
echo "Base URL: $BASE_URL"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Helper function to test endpoint
test_endpoint() {
    local name=$1
    local method=$2
    local endpoint=$3
    local data=$4
    
    echo -n "Testing: $name... "
    
    if [ -z "$data" ]; then
        response=$(curl -s -w "\n%{http_code}" -X $method "$BASE_URL$endpoint")
    else
        response=$(curl -s -w "\n%{http_code}" -X $method "$BASE_URL$endpoint" \
            -H "Content-Type: application/json" \
            -d "$data")
    fi
    
    status_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$status_code" -ge 200 ] && [ "$status_code" -lt 300 ]; then
        echo -e "${GREEN}✓ PASS${NC} (HTTP $status_code)"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC} (HTTP $status_code)"
        echo "Response: $body"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📡 BASIC CONNECTIVITY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_endpoint "Health Check" GET "/health"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📥 INGESTION TESTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 1: Simple ingestion
INGEST_DATA='{
  "transcript_id": "test-001",
  "title": "Test Budget Meeting",
  "occurred_at": "2025-10-20T10:00:00Z",
  "duration_minutes": 30,
  "participants": [
    {
      "name": "Alice Johnson",
      "email": "alice@example.com",
      "role": "speaker"
    },
    {
      "name": "Bob Smith",
      "email": "bob@example.com",
      "role": "participant"
    }
  ],
  "transcript": "Alice: Let us discuss the Q4 budget. We need to allocate $50k for marketing. Bob, can you prepare the proposal by Friday? Bob: Yes, I will have it ready. Alice: Great. We also decided to hire two new engineers for the product team.",
  "metadata": {
    "platform": "zoom"
  }
}'

test_endpoint "Ingest Transcript" POST "/api/ingest" "$INGEST_DATA"

# Test 2: Duplicate ingestion (should fail or handle gracefully)
echo ""
test_endpoint "Duplicate Prevention" POST "/api/ingest" "$INGEST_DATA"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📖 QUERY TESTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_endpoint "List Transcripts" GET "/api/transcripts"
test_endpoint "Get Transcript by ID" GET "/api/transcripts/test-001"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 SEARCH TESTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_endpoint "Semantic Search - Budget" GET "/api/search?q=budget%20planning"
test_endpoint "Semantic Search - Hiring" GET "/api/search?q=hiring%20engineers"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 ANALYTICS TESTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_endpoint "Topic Analytics" GET "/api/analytics/topics"
test_endpoint "Participant Analytics" GET "/api/analytics/participants"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧪 VALIDATION TESTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test invalid data
INVALID_DATA='{
  "transcript_id": "test-invalid",
  "title": "",
  "occurred_at": "invalid-date",
  "participants": []
}'

echo -n "Testing: Invalid Data Rejection... "
response=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/ingest" \
    -H "Content-Type: application/json" \
    -d "$INVALID_DATA")
status_code=$(echo "$response" | tail -n1)

if [ "$status_code" -ge 400 ] && [ "$status_code" -lt 500 ]; then
    echo -e "${GREEN}✓ PASS${NC} (HTTP $status_code - correctly rejected)"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC} (HTTP $status_code - should reject invalid data)"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 TEST SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

TOTAL=$((TESTS_PASSED + TESTS_FAILED))
echo "Total Tests: $TOTAL"
echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Failed: ${RED}$TESTS_FAILED${NC}"

if [ $TESTS_FAILED -eq 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 All tests passed!${NC}"
    exit 0
else
    echo ""
    echo -e "${YELLOW}⚠️  Some tests failed. Check the output above.${NC}"
    exit 1
fi

