#!/usr/bin/env bash
# remind-migration-on-entity-change.sh
# Reminds developer to create a Flyway migration when a JPA entity is modified

FILE_PATH="$1"

# Check if this is a JPA entity file (in persistence/infrastructure layer)
if [[ "$FILE_PATH" == *"JpaEntity"* ]] || [[ "$FILE_PATH" == *"Entity.java" ]]; then

  # Check if a migration was also recently created
  LATEST_MIGRATION=$(find src/main/resources/db/migration -name "V*.sql" 2>/dev/null | sort -V | tail -1)

  if [ -z "$LATEST_MIGRATION" ]; then
    echo "⚠️  MIGRATION CHECK: You modified a JPA entity but no Flyway migrations exist."
    echo "   File: $FILE_PATH"
    echo ""
    echo "   Every schema change needs a migration script."
    echo "   Create: src/main/resources/db/migration/V1__<description>.sql"
    echo ""
    echo "   See skill: database-migration-discipline"
  else
    echo "ℹ️  MIGRATION REMINDER: You modified a JPA entity."
    echo "   File: $FILE_PATH"
    echo "   Latest migration: $LATEST_MIGRATION"
    echo ""
    echo "   Does this entity change require a new migration script?"
    echo "   If yes: create src/main/resources/db/migration/V<next>__<description>.sql"
  fi

fi

exit 0