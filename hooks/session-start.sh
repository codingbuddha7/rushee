#!/bin/bash
# session-start.sh — Rushee plugin discipline banner

echo ""
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                   🚀  RUSHEE  v2.0  🚀                          ║"
echo "║          Spring Boot Engineering Discipline — Active             ║"
echo "╠══════════════════════════════════════════════════════════════════╣"
echo "║                                                                  ║"
echo "║  FULL PIPELINE (start here for new projects):                   ║"
echo "║  /rushee:event-storm    → Map bounded contexts & domain events  ║"
echo "║  /rushee:ddd-model      → Design aggregates & domain model      ║"
echo "║                                                                  ║"
echo "║  FEATURE PIPELINE (for each feature in a context):              ║"
echo "║  /rushee:feature        → Feature Card (FDD)                    ║"
echo "║  /rushee:api-design     → OpenAPI contract first                ║"
echo "║  /rushee:bdd-spec       → Gherkin scenarios (BDD)               ║"
echo "║  /rushee:atdd-run       → Acceptance tests RED (ATDD)           ║"
echo "║  /rushee:tdd-cycle      → Implement outside-in (TDD)            ║"
echo "║  /rushee:security-check → OWASP security gate                   ║"
echo "║                                                                  ║"
echo "║  /rushee:status         → Progress across all features          ║"
echo "║                                                                  ║"
echo "╠══════════════════════════════════════════════════════════════════╣"
echo "║  NON-NEGOTIABLE RULES:                                          ║"
echo "║  ✗ No code before a Feature Card                                ║"
echo "║  ✗ No controller before an OpenAPI spec                         ║"
echo "║  ✗ No implementation before acceptance tests are RED            ║"
echo "║  ✗ No merge before security-reviewer APPROVED                   ║"
echo "║  ✗ No @Entity on domain classes — ever                         ║"
echo "║  ✗ No public setters on aggregates — ever                       ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

# Show quick status if features exist
if [ -d "docs/features" ]; then
  FEATURE_COUNT=$(find docs/features -name "FDD-*.md" 2>/dev/null | wc -l)
  if [ "$FEATURE_COUNT" -gt 0 ]; then
    echo "  📋 $FEATURE_COUNT feature card(s) found. Run /rushee:status for details."
    echo ""
  fi
fi

# Warn if context map is missing (project likely not started with event-storm)
if [ ! -f "docs/architecture/context-map.md" ]; then
  echo "  ⚠️  No context map found. Consider running /rushee:event-storm first."
  echo ""
fi

exit 0
