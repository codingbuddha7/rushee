#!/usr/bin/env bash
# guard-openapi-contract-sync.sh
# Fires when any *-api.yaml file is modified
# WARNS developer to regenerate both API clients before committing

FILE="${RUSHEE_FILE:-}"

# Only trigger on OpenAPI spec files
if [[ "$FILE" != *"-api.yaml" ]] && [[ "$FILE" != *".openapi.yaml" ]]; then
  exit 0
fi

echo ""
echo "⚡ RUSHEE — OpenAPI Contract Changed: $FILE"
echo "══════════════════════════════════════════════════════════"
echo ""
echo "  The OpenAPI spec is the single source of truth for BOTH codebases."
echo "  You MUST regenerate both API clients before committing."
echo ""
echo "  ┌─────────────────────────────────────────────────────┐"
echo "  │  Run: ./regenerate-clients.sh                       │"
echo "  │                                                     │"
echo "  │  Or manually:                                       │"
echo "  │                                                     │"
echo "  │  Backend (Spring Boot):                             │"
echo "  │    ./mvnw generate-sources && ./mvnw compile -q     │"
echo "  │                                                     │"
echo "  │  Flutter:                                           │"
echo "  │    openapi-generator-cli generate \\                 │"
echo "  │      -i $FILE \\                                     │"
echo "  │      -g dart-dio -o mobile/lib/.../generated        │"
echo "  │    flutter pub run build_runner build               │"
echo "  └─────────────────────────────────────────────────────┘"
echo ""
echo "  After regenerating: run contract tests on both sides"
echo "  Backend:  ./mvnw test -Dtest='*ContractTest'"
echo "  Flutter:  flutter test test/contract/"
echo ""
echo "  ⚠️  Breaking change? Follow the versioning protocol:"
echo "  Add /api/v2/ endpoint, deprecate /api/v1/ with Sunset header."
echo ""
echo "══════════════════════════════════════════════════════════"
echo ""

# WARN only — does not block (developer must take manual action)
exit 0
