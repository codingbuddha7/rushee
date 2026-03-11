#!/usr/bin/env bash
# phase-gate.sh — Run Rushee phase gates (Phase 2b: OpenAPI validate; Phase 3b: Cucumber RED; Phase 4: tests green).
# Run from your project root (the app using Rushee).
#
# Usage:
#   ./scripts/phase-gate.sh 2b [BACKEND_DIR]              # Validate OpenAPI spec(s). BACKEND_DIR default: backend
#   ./scripts/phase-gate.sh 3b [BACKEND_DIR] [FDD_ID]     # Run Cucumber, expect RED. FDD_ID e.g. FDD-001 (optional)
#   ./scripts/phase-gate.sh 4 [BACKEND_DIR]               # Run full backend tests (expect green)
#
# If this script lives in the Rushee plugin repo, run from your app root:
#   bash /path/to/rushee/scripts/phase-gate.sh 2b
# Or copy scripts/phase-gate.sh into your project and run from project root.

set -e

PHASE="${1:-}"
BACKEND_DIR="${2:-backend}"
FDD_ID="${3:-}"

# Run Maven from BACKEND_DIR: support Unix (./mvnw), Windows (mvnw.cmd), or system mvn
run_mvn() {
  ( cd "$BACKEND_DIR" && (
    if [ -x "./mvnw" ] 2>/dev/null || [ -f "./mvnw" ]; then
      ./mvnw "$@"
    elif [ -f "./mvnw.cmd" ]; then
      cmd //c "mvnw.cmd $*"
    else
      mvn "$@"
    fi
  ) )
}

if [ -z "$PHASE" ]; then
  echo "Usage: $0 <2b|3b|4> [BACKEND_DIR] [FDD_ID for 3b only]"
  echo "  Run from your project root. BACKEND_DIR default: backend"
  echo "  Windows: run from Git Bash or WSL; or use mvnw.cmd in BACKEND_DIR manually."
  exit 1
fi

case "$PHASE" in
  2b)
    echo "=== Phase gate 2b: Validate OpenAPI spec(s) ==="
    SPEC_DIR="$BACKEND_DIR/src/main/resources/api"
    if [ ! -d "$SPEC_DIR" ]; then
      echo "❌ Not found: $SPEC_DIR"
      exit 1
    fi
    FAIL=0
    for spec in "$SPEC_DIR"/*-api.yaml "$SPEC_DIR"/*.openapi.yaml; do
      [ -f "$spec" ] || continue
      echo "Validating: $spec"
      if command -v npx &>/dev/null; then
        npx --yes @openapitools/openapi-generator-cli validate -i "$spec" || FAIL=1
      else
        echo "⚠️  npx not found. Install Node.js or validate manually: $spec"
        FAIL=1
      fi
    done
    if [ $FAIL -eq 0 ]; then
      echo "✅ Phase 2b gate passed: OpenAPI spec(s) valid."
    else
      exit 1
    fi
    ;;
  3b)
    echo "=== Phase gate 3b: Cucumber RED (step defs only, no app logic) ==="
    if [ ! -f "$BACKEND_DIR/pom.xml" ]; then
      echo "❌ Not found: $BACKEND_DIR/pom.xml. Is BACKEND_DIR correct?"
      exit 1
    fi
    TAG_ARG=""
    if [ -n "$FDD_ID" ]; then
      TAG_ARG="-Dcucumber.filter.tags=@${FDD_ID}"
    fi
    run_mvn test -Dtest=*Cucumber* $TAG_ARG -q
    echo "✅ Phase 3b: Cucumber ran. Confirm scenarios are RED (pending/fail), then proceed to TDD."
    ;;
  4)
    echo "=== Phase gate 4: Backend tests green ==="
    if [ ! -f "$BACKEND_DIR/pom.xml" ]; then
      echo "❌ Not found: $BACKEND_DIR/pom.xml."
      exit 1
    fi
    run_mvn test -q
    echo "✅ Phase 4 gate passed: all backend tests green."
    ;;
  *)
    echo "Unknown phase: $PHASE. Use 2b, 3b, or 4."
    exit 1
    ;;
esac
