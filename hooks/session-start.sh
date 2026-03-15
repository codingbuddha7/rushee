#!/usr/bin/env bash
# session-start.sh — Rushee v2.2 pipeline banner + smart state detection

echo ""
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║           🚀  RUSHEE  v2.2  — Full-Stack Mode  🚀               ║"
echo "║       Flutter + Spring Boot Engineering Discipline              ║"
echo "╠══════════════════════════════════════════════════════════════════╣"
echo "║  PIPELINE:                                                       ║"
echo "║  Phase 0  /rushee:ux-discovery   → Personas, journeys, screens  ║"
echo "║  Phase 1  /rushee:event-storm    → Bounded contexts & events    ║"
echo "║           /rushee:ddd-model      → Aggregates & domain model    ║"
echo "║  Phase 2  /rushee:feature        → Feature Card (FDD)           ║"
echo "║           /rushee:api-design     → OpenAPI contract (both sides)║"
echo "║  Phase 3  /rushee:bdd-spec       → Gherkin scenarios            ║"
echo "║           /rushee:atdd-run       → Acceptance tests RED         ║"
echo "║  Phase 4  /rushee:tdd-cycle      → Backend TDD (outside-in)     ║"
echo "║           /rushee:flutter-feature→ Flutter clean arch + tests   ║"
echo "║  Phase 5  /rushee:security-check → OWASP backend + mobile       ║"
echo "║           /rushee:status         → 8-gate + 5-gate review       ║"
echo "║                                                                  ║"
echo "║  SKIP PHASES:  /rushee:bootstrap phase-<N> [FDD-NNN]            ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

# ─────────────────────────────────────────────────────────────────────
# SMART PIPELINE STATE DETECTION
# ─────────────────────────────────────────────────────────────────────

PHASE_REACHED=0

if [ -f "docs/ux/personas.md" ] || [ -f "docs/ux/job-stories.md" ]; then
  PHASE_REACHED=1
fi
if [ -f "docs/architecture/context-map.md" ]; then
  PHASE_REACHED=2
fi
if ls docs/domain/*/domain-model.md >/dev/null 2>&1; then
  PHASE_REACHED=3
fi

FEATURE_COUNT=$(find docs/features -name "FDD-*.md" 2>/dev/null | wc -l | tr -d ' ')
if [ "$FEATURE_COUNT" -gt 0 ]; then
  PHASE_REACHED=4
fi

API_SPEC_COUNT=$(find . -path "*/resources/api/*-api.yaml" 2>/dev/null | wc -l | tr -d ' ')
if [ "$API_SPEC_COUNT" -gt 0 ]; then
  PHASE_REACHED=5
fi

FEATURE_FILE_COUNT=$(find . -path "*/src/test/resources/features/*.feature" 2>/dev/null | wc -l | tr -d ' ')
if [ "$FEATURE_FILE_COUNT" -gt 0 ]; then
  PHASE_REACHED=6
fi

STEP_COUNT=$(find . -path "*/src/test/java/*Steps.java" 2>/dev/null | wc -l | tr -d ' ')
if [ "$STEP_COUNT" -gt 0 ]; then
  PHASE_REACHED=7
fi

PROD_CLASS_COUNT=$(find . -path "*/src/main/java/*.java" ! -path "*/domain/*" ! -path "*/test/*" 2>/dev/null | wc -l | tr -d ' ')
if [ "${PROD_CLASS_COUNT:-0}" -gt 5 ]; then
  PHASE_REACHED=8
fi

FLUTTER_COUNT=$(find . \( -path "*/mobile/lib/*" -o -path "lib/features/*" \) -name "*.dart" 2>/dev/null | wc -l | tr -d ' ')
if [ "${FLUTTER_COUNT:-0}" -gt 0 ]; then
  PHASE_REACHED=9
fi

LATEST_FDD=$(ls docs/features/FDD-*.md 2>/dev/null | sort | tail -1 | xargs basename 2>/dev/null | sed 's/\.md//')

# ─────────────────────────────────────────────────────────────────────
# SURFACE THE RIGHT NEXT STEP
# ─────────────────────────────────────────────────────────────────────

case $PHASE_REACHED in
  0)
    echo "  📍 STATE: New project — no Rushee artifacts found yet"
    echo ""
    echo "  ▶  SUGGESTED NEXT COMMAND:"
    echo "     /rushee:ux-discovery                 (start from the user)"
    echo "     /rushee:bootstrap phase-1             (skip UX → event-storm)"
    echo "     /rushee:bootstrap retrofit            (existing codebase)"
    ;;
  1)
    echo "  📍 STATE: UX Discovery complete"
    echo ""
    echo "  ▶  SUGGESTED NEXT COMMAND:"
    echo "     /rushee:event-storm                  (domain events from UX ready)"
    echo "     /rushee:bootstrap phase-1            (go straight to event-storm)"
    ;;
  2)
    echo "  📍 STATE: Context map exists"
    echo ""
    echo "  ▶  SUGGESTED NEXT COMMAND:"
    CONTEXTS=$(ls docs/domain/ 2>/dev/null | head -3 | tr '\n' ' ')
    echo "     /rushee:ddd-model <context>          (contexts available: ${CONTEXTS:-none yet})"
    echo "     /rushee:bootstrap phase-2            (skip domain model)"
    ;;
  3)
    echo "  📍 STATE: Domain model(s) complete"
    echo ""
    echo "  ▶  SUGGESTED NEXT COMMAND:"
    echo "     /rushee:feature <description>        (create Feature Card)"
    ;;
  4)
    echo "  📍 STATE: $FEATURE_COUNT Feature Card(s) found"
    echo ""
    echo "  ▶  SUGGESTED NEXT COMMAND:"
    echo "     /rushee:api-design ${LATEST_FDD:-FDD-NNN}  (design OpenAPI contract)"
    ;;
  5)
    echo "  📍 STATE: API contract(s) exist"
    echo ""
    echo "  ▶  SUGGESTED NEXT COMMAND:"
    echo "     /rushee:bdd-spec ${LATEST_FDD:-FDD-NNN}    (write Gherkin scenarios)"
    ;;
  6)
    echo "  📍 STATE: Gherkin scenarios exist ($FEATURE_FILE_COUNT file(s))"
    echo ""
    echo "  ▶  SUGGESTED NEXT COMMAND:"
    echo "     /rushee:atdd-run ${LATEST_FDD:-FDD-NNN}    (wire step defs → RED)"
    ;;
  7)
    echo "  📍 STATE: Step definitions exist ($STEP_COUNT file(s)) — ready for TDD"
    echo ""
    echo "  ▶  SUGGESTED NEXT COMMAND:"
    echo "     /rushee:tdd-cycle ${LATEST_FDD:-FDD-NNN}   (backend TDD — outside-in)"
    echo "     /rushee:flutter-feature ${LATEST_FDD:-FDD-NNN} (Flutter — run in parallel)"
    ;;
  8)
    echo "  📍 STATE: Backend implementation in progress"
    echo ""
    echo "  ▶  SUGGESTED NEXT COMMAND:"
    echo "     /rushee:flutter-feature ${LATEST_FDD:-FDD-NNN} (Flutter stream — run now)"
    echo "     /rushee:security-check ${LATEST_FDD:-FDD-NNN}  (after both streams done)"
    ;;
  9)
    echo "  📍 STATE: Both backend + Flutter in progress"
    echo ""
    echo "  ▶  SUGGESTED NEXT COMMAND:"
    echo "     /rushee:security-check ${LATEST_FDD:-FDD-NNN}  (OWASP review)"
    echo "     /rushee:status                                  (full 8+5 gate review)"
    ;;
esac

echo ""

# Feature Card summary
if [ "$FEATURE_COUNT" -gt 0 ]; then
  echo "  📋 Feature Cards:"
  find docs/features -name "FDD-*.md" 2>/dev/null | sort | while read f; do
    ID=$(basename "$f" .md)
    TITLE=$(grep "^# Feature:" "$f" 2>/dev/null | sed 's/# Feature: //' | cut -c1-40)
    STATUS=$(grep "^\*\*Status\*\*:" "$f" 2>/dev/null | sed 's/\*\*Status\*\*: //')
    printf "     %-10s %-41s %s\n" "$ID" "${TITLE:-(no title)}" "${STATUS:-UNKNOWN}"
  done
  echo ""
fi

echo "  📌 Rules: No code before Feature Card  ·  No controller before OpenAPI spec"
echo "            No impl before RED tests  ·  No @Entity in domain  ·  No secrets"
echo ""

# First-time / skill-check prompt (agent does Q&A when /rushee:start or /rushee:skill-check runs)
if [ ! -f ".rushee-profile" ] 2>/dev/null; then
  echo "  💡 First time or want a tailored path? Run: /rushee:start — then /rushee:skill-check for readiness."
  echo ""
fi

exit 0
