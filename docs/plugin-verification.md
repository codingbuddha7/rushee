# Rushee plugin verification report

Verification of the Claude/Cursor plugin project for completeness, consistency, and recommendations. Run from plugin repo root.

**Platform support:** Hooks and scripts use `#!/usr/bin/env bash` and are intended to run on **Windows (Git Bash or WSL), macOS, and Linux**. See README § Installation for details.

---

## 1. Plugin configuration

| Check | Status |
|-------|--------|
| `.claude-plugin/plugin.json` exists | ✅ |
| `.cursor-plugin/plugin.json` exists | ✅ |
| Both configs list same commands, agents, skills, hooks | ✅ |
| All command paths in plugin.json exist under `commands/` | ✅ |
| All agent paths in plugin.json exist under `agents/` | ✅ |
| All skill folder names in plugin.json have `skills/<name>/SKILL.md` | ✅ |
| `hooks/hooks.json` exists and each script path exists | ✅ |

---

## 2. Artifact counts (updated)

| Artifact | plugin.json | On disk | README / marketplace |
|----------|-------------|---------|----------------------|
| Commands | 16 | 16 | 16 ✅ |
| Agents | 18 | 18 | 18 ✅ |
| Skills | 27 | 27 | 27 ✅ |
| Hooks | 7 (in hooks.json) | 7 scripts | 7 ✅ |

Previously README and marketplace said "25 skills, 17 agents, 15 commands"; corrected to 27, 18, 16.

---

## 3. Documentation and cross-references

| Check | Status |
|-------|--------|
| README Phase gates section links to `docs/phase-gates-and-prs.md` | ✅ |
| `docs/phase-gates-and-prs.md` exists and is not in .gitignore | ✅ |
| Pipeline-bootstrapper references phase gates and optional PRs | ✅ |
| Status command mentions phase gates (docs/phase-gates-and-prs.md) | ✅ |

---

## 4. Hooks

| Hook | Script exists | Event / pattern |
|------|----------------|-----------------|
| session-start-discipline-reminder | session-start.sh | SessionStart |
| guard-no-code-before-feature-card | guard-feature-card.sh | PreToolUse, **/src/main/java/**/*.java |
| guard-domain-purity | guard-domain-purity.sh | PreToolUse, **/domain/**/*.java |
| guard-no-hardcoded-secrets | guard-no-hardcoded-secrets.sh | PreToolUse, **/*.{java,yml,properties,dart} |
| guard-openapi-contract-sync | guard-openapi-contract-sync.sh | PostToolUse, **/*-api.yaml |
| remind-migration-on-entity-change | remind-migration-on-entity-change.sh | PostToolUse, **/infrastructure/persistence/**/*Entity.java |
| auto-run-tests-after-edit | remind-run-tests.sh | PostToolUse, **/*Test.java, **/*_test.dart |

Path patterns work for both `backend/src/` and project-root `src/` layouts.

---

## 5. Recommendations applied

1. **Phase gates and optional PRs** — Documented in README (Section 3), `docs/phase-gates-and-prs.md`, pipeline-bootstrapper (Step 0c and Step 5), and status command.
2. **Artifact counts** — README and `.claude-plugin/marketplace.json` updated to 27 skills, 18 agents, 16 commands, 7 hooks.

---

## 6. Optional / follow-up recommendations (implemented)

- **Cursor-specific:** ✅ **Done.** `AGENTS.md` at plugin root. If Cursor supports a project-level agent instruction file, consider adding a short pointer to “Run from project root; follow Rushee pipeline; see README.”
- **Phase-gate automation:** ✅ **Done.** `scripts/phase-gate.sh` that runs the Phase 2b (OpenAPI validate) and Phase 3b (Cucumber RED) checks Usage: phase-gate.sh 2b|3b|4 [BACKEND_DIR] [FDD_ID]. Documented in docs/phase-gates-and-prs.md.
- **Version alignment:** ✅ **Done.** README Section 4 notes to keep version in sync in all three config files.
- **Demo app:** ✅ **Done.** README Section 9 links to `demo-app/STEPS.md` as a worked example (ecommerce: products, cart, place order).

---

## 7. Quick verification commands

From plugin repo root:

```bash
# All commands exist
for c in start bootstrap ux-discovery event-storm ddd-model feature api-design bdd-spec atdd-run tdd-cycle flutter-feature parallel debug security-check status extend; do
  test -f "commands/${c}.md" && echo "✅ $c" || echo "❌ $c"
done

# All hook scripts exist
for s in session-start guard-feature-card guard-domain-purity guard-no-hardcoded-secrets guard-openapi-contract-sync remind-migration-on-entity-change remind-run-tests; do
  test -f "hooks/${s}.sh" && echo "✅ ${s}.sh" || echo "❌ ${s}.sh"
done
```

---

*Last verification: plugin structure, configs, docs, phase gates, and counts.*
