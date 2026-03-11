#!/usr/bin/env bash
# guard-feature-card.sh
# Warns when production Java files are being written without a Feature Card

FILE_PATH="$1"

# Only check production source files (not test files)
if [[ "$FILE_PATH" == *"src/main/java"* ]] && [[ "$FILE_PATH" == *".java" ]]; then

  # Check if docs/features/ has any feature cards
  FEATURE_COUNT=$(find docs/features -name "FDD-*.md" 2>/dev/null | wc -l)

  if [ "$FEATURE_COUNT" -eq 0 ]; then
    echo "⚠️  DISCIPLINE CHECK: You're about to write production code but no Feature Card exists."
    echo "   Run: /rushee:feature <description>"
    echo "   This will create a Feature Card before any code is written."
    echo "   (Proceeding anyway — but consider following the FDD→BDD→ATDD→TDD discipline)"
  fi
fi

exit 0
