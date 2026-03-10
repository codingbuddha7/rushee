---
name: spring-git-workflow
description: >
  This skill should be used for all Git branching, worktree, and PR operations on
  Spring Boot projects. Triggers on: "create branch", "git worktree", "start feature branch",
  "make a PR", "merge feature", "finish branch", "pull request", "git workflow",
  "branch strategy", or when starting or completing any FDD feature card.
  One feature card = one branch = one PR. Always.
version: 1.0.0
allowed-tools: [Read, Write, Bash, Glob]
---

# Spring Git Workflow Skill

## Branch Strategy — One Feature Card, One Branch

Every FDD feature card gets its own isolated Git branch and worktree.
This prevents half-finished features from blocking other work.

```
main
 ├── feature/FDD-001-place-order          ← one branch per feature card
 ├── feature/FDD-002-cancel-order
 └── feature/FDD-003-track-shipment
```

---

## Phase 1 — Start a Feature Branch

Run when `/rushee:feature` produces a new Feature Card:

```bash
# 1. Ensure main is clean and up to date
git checkout main
git pull origin main

# 2. Create branch with FDD naming convention
FEATURE_ID="FDD-001"
FEATURE_SLUG="place-order"
BRANCH="feature/${FEATURE_ID}-${FEATURE_SLUG}"

git checkout -b "$BRANCH"
echo "Branch created: $BRANCH"

# 3. Create a git worktree for parallel work (optional — recommended for large teams)
# Allows working on FDD-002 while FDD-001 is in review
git worktree add "../rushee-${FEATURE_ID}" "$BRANCH"
```

### Worktree Layout
```
project-root/                     ← main branch (clean, always deployable)
../project-FDD-001-place-order/   ← worktree: feature in progress
../project-FDD-002-cancel-order/  ← worktree: another feature in parallel
```

---

## Phase 2 — Commit Discipline During Development

### Commit at each Rushee pipeline milestone:

```bash
# After Feature Card created
git add docs/features/FDD-NNN.md
git commit -m "docs(FDD-NNN): add feature card for <title>"

# After OpenAPI spec written
git add src/main/resources/api/
git commit -m "docs(FDD-NNN): add OpenAPI contract for <feature>"

# After Gherkin scenarios written
git add src/test/resources/features/
git commit -m "test(FDD-NNN): add Gherkin scenarios for <feature>"

# After step definitions wired (RED)
git add src/test/java/**/steps/
git commit -m "test(FDD-NNN): wire Cucumber step definitions [RED]"

# After each TDD cycle (small, frequent commits)
git add src/main/java/ src/test/java/
git commit -m "feat(FDD-NNN): implement <specific behaviour> [GREEN]"

# After refactor
git commit -m "refactor(FDD-NNN): <what was cleaned up>"

# After Flyway migration
git add src/main/resources/db/migration/
git commit -m "db(FDD-NNN): add migration V<N>__<description>"
```

### Conventional Commit Types for Rushee
| Prefix | When to use |
|--------|------------|
| `feat(FDD-NNN):` | New production behaviour |
| `test(FDD-NNN):` | Test-only changes |
| `refactor(FDD-NNN):` | Code restructuring, no behaviour change |
| `docs(FDD-NNN):` | Feature cards, OpenAPI specs, ADRs |
| `db(FDD-NNN):` | Flyway migration scripts |
| `fix(FDD-NNN):` | Bug fix during feature development |
| `chore(FDD-NNN):` | Build config, dependency updates |

---

## Phase 3 — Pre-PR Checklist

Run before creating a Pull Request:

```bash
#!/bin/bash
# pre-pr-check.sh

echo "=== RUSHEE PRE-PR CHECKLIST ==="

# 1. All tests green
echo "Running tests..."
./mvnw test -q
if [ $? -ne 0 ]; then echo "❌ Tests FAILED — fix before PR"; exit 1; fi
echo "✅ All tests pass"

# 2. Coverage threshold
./mvnw verify jacoco:report -q
COVERAGE=$(grep -A1 "Total" target/site/jacoco/index.html | grep -oP '\d+%' | head -1)
echo "Coverage: $COVERAGE"

# 3. Architecture tests (ArchUnit)
./mvnw test -Dtest="*ArchitectureTest" -q
if [ $? -ne 0 ]; then echo "❌ Architecture tests FAILED"; exit 1; fi
echo "✅ Architecture tests pass"

# 4. No domain layer violations
VIOLATIONS=$(grep -rn "import org.springframework\|import jakarta.persistence" \
  src/main/java/*/domain/ --include="*.java" 2>/dev/null | wc -l)
if [ "$VIOLATIONS" -gt 0 ]; then
  echo "❌ Domain layer violations: $VIOLATIONS Spring/JPA imports found"
  exit 1
fi
echo "✅ Domain layer clean"

# 5. No hardcoded secrets
SECRETS=$(grep -rn "password\s*=\s*['\"][^$]" src/ --include="*.java" --include="*.yml" 2>/dev/null | wc -l)
if [ "$SECRETS" -gt 0 ]; then
  echo "❌ Possible hardcoded secrets found"
  exit 1
fi
echo "✅ No hardcoded secrets"

# 6. Feature card exists
FDD_ID=$(git branch --show-current | grep -oP 'FDD-\d+')
if [ -n "$FDD_ID" ] && [ ! -f "docs/features/${FDD_ID}.md" ]; then
  echo "❌ Feature card docs/features/${FDD_ID}.md not found"
  exit 1
fi
echo "✅ Feature card exists"

echo ""
echo "=== ALL CHECKS PASSED — Ready for PR ==="
```

---

## Phase 4 — Create the Pull Request

### PR Title Convention
```
feat(FDD-NNN): <title from Feature Card>
```

### PR Description Template
Save as `.github/pull_request_template.md` in your project:

```markdown
## Feature Card
Closes docs/features/FDD-NNN.md

## Summary
<!-- One paragraph: what this PR does and why -->

## Rushee Pipeline Status
- [ ] ✅ Feature Card approved (FDD-NNN)
- [ ] ✅ OpenAPI contract reviewed
- [ ] ✅ Gherkin scenarios approved
- [ ] ✅ Acceptance tests confirmed RED before implementation
- [ ] ✅ All Cucumber scenarios GREEN
- [ ] ✅ All unit tests GREEN
- [ ] ✅ JaCoCo coverage ≥ 80%
- [ ] ✅ Security review APPROVED
- [ ] ✅ Ops review PRODUCTION READY
- [ ] ✅ spring-reviewer APPROVED (all 8 gates)

## Architecture
- [ ] No Spring/JPA imports in domain layer
- [ ] No public setters on aggregates
- [ ] No hardcoded secrets

## Test Evidence
```
./mvnw test          ← paste result here
Coverage: XX%        ← paste JaCoCo summary here
```

## Migration
- [ ] N/A — no schema changes
- [ ] ✅ Flyway migration V<N>__<description>.sql included
```

---

## Phase 5 — Finish the Branch

After PR is merged:

```bash
# Switch back to main and pull
git checkout main
git pull origin main

# Delete the local feature branch
git branch -d feature/FDD-NNN-feature-name

# Remove worktree if one was created
git worktree remove ../project-FDD-NNN-feature-name

# Delete remote branch
git push origin --delete feature/FDD-NNN-feature-name

echo "Branch cleaned up. Ready for next feature."
```

---

## Parallel Feature Development with Worktrees

When multiple features are in progress simultaneously:

```bash
# Dev A works on FDD-001 in worktree
git worktree add ../project-FDD-001 feature/FDD-001-place-order
cd ../project-FDD-001
# full IDE / Claude Code session here

# Dev B works on FDD-002 in separate worktree simultaneously
git worktree add ../project-FDD-002 feature/FDD-002-cancel-order
cd ../project-FDD-002
# completely independent — no interference

# List all active worktrees
git worktree list
```

Each worktree is a fully independent working directory with its own compiled classes,
test results, and IDE state. Changes in one never affect the other.
