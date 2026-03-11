#!/usr/bin/env bash
# remind-run-tests.sh
# After editing a test file, remind to actually run it

FILE_PATH="$1"

if [[ "$FILE_PATH" == *"Test.java" ]] || [[ "$FILE_PATH" == *"IT.java" ]] || [[ "$FILE_PATH" == *"Steps.java" ]]; then
  CLASS_NAME=$(basename "$FILE_PATH" .java)
  echo ""
  echo "🔴 Test file edited: $CLASS_NAME"
  echo "   Run it now: ./mvnw test -Dtest=$CLASS_NAME"
  echo "   It should FAIL (RED) before you write production code."
fi

exit 0
