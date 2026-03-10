#!/bin/bash
# guard-no-hardcoded-secrets.sh
# Blocks hardcoded passwords, API keys, and secrets from being committed

FILE_PATH="$1"
FILE_CONTENT="$2"

# Check all Java and YAML/properties files
if [[ "$FILE_PATH" == *".java" ]] || [[ "$FILE_PATH" == *".yml" ]] || [[ "$FILE_PATH" == *".yaml" ]] || [[ "$FILE_PATH" == *".properties" ]]; then

  FOUND=0

  # Password literals (not references to env vars)
  if echo "$FILE_CONTENT" | grep -qiE "password\s*[=:]\s*['\"][^$\{][^'\"]{3,}['\"]"; then
    echo "❌ SECURITY VIOLATION: Possible hardcoded password detected."
    FOUND=1
  fi

  # Secret/key literals
  if echo "$FILE_CONTENT" | grep -qiE "(secret|api.key|apikey|api_key)\s*[=:]\s*['\"][^$\{][^'\"]{3,}['\"]"; then
    echo "❌ SECURITY VIOLATION: Possible hardcoded secret or API key detected."
    FOUND=1
  fi

  # Bearer tokens or JWT-looking strings
  if echo "$FILE_CONTENT" | grep -qE "Bearer [A-Za-z0-9\-_\.]{20,}|eyJ[A-Za-z0-9\-_\.]{30,}"; then
    echo "❌ SECURITY VIOLATION: Possible hardcoded JWT or Bearer token detected."
    FOUND=1
  fi

  if [ "$FOUND" -eq 1 ]; then
    echo "   File: $FILE_PATH"
    echo ""
    echo "   Use environment variables instead:"
    echo "   password: \${DB_PASSWORD}"
    echo "   api-key: \${EXTERNAL_API_KEY}"
    echo ""
    echo "   See skill: security-by-design — Layer 3: Secrets Management"
    exit 1
  fi

fi

exit 0