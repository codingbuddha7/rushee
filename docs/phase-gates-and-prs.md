# Phase gates and optional PR verification

**Platforms:** These checks run on **Windows (Git Bash or WSL), macOS, and Linux**. On Windows CMD/PowerShell, run the Maven commands manually (e.g. `mvnw.cmd test ...`) or use the phase-gate script from Git Bash/WSL.

Rushee does **not** require a pull request after every phase. It does recommend:

1. **Phase gates** — verify that each phase’s outputs exist and pass minimal checks before starting the next phase.
2. **Optional PRs** — after Phase 2b, 3b, 4, and 4f, open a PR for review if you have a mentor; otherwise commit and continue.

The next phase is **blocked only on the phase gate**, not on “PR merged.”

---

## Phase gates (what to check before continuing)

### After Phase 0 — UX Discovery

- [ ] `docs/ux/personas.md` exists and has at least one persona.
- [ ] `docs/ux/job-stories.md` (or equivalent) exists with job stories.
- [ ] `docs/ux/screen-inventory.md` and `docs/ux/navigation-map.md` exist.
- [ ] Wireframe specs exist under `docs/ux/wireframe-specs/` or `docs/ux/wireframes/` for screens in scope.

**No automated check.** Manually confirm the files are present and coherent. Optionally commit and open a PR for visibility.

---

### After Phase 1 — Event storm / Phase 1b — DDD model

- [ ] `docs/architecture/context-map.md` exists (Phase 1).
- [ ] `docs/domain/<context>/domain-model.md` and domain skeleton classes exist (Phase 1b).

**No automated check.** Commit when done. Optional PR if someone can review the domain design.

---

### After Phase 2b — API design

- [ ] OpenAPI spec exists at `backend/src/main/resources/api/*-api.yaml` (or project root equivalent).
- [ ] **Phase gate:** Validate the spec so the next phase (BDD) and codegen don’t fail.

**Lightweight automated check (optional but recommended):**

From your project root, run the phase-gate script in the Rushee plugin (if you have it locally), or run the commands below manually:

```bash
# Option A: script (from your project root; adjust path to your Rushee plugin)
bash path/to/rushee/scripts/phase-gate.sh 2b [backend]

# Option B: manual
npx @openapitools/openapi-generator-cli validate -i backend/src/main/resources/api/notes-api.yaml
# Or use any OpenAPI 3.x validator (e.g. online or editor) to ensure the YAML is valid.
```

- **Optional PR:** Strongly recommended. A quick review of the contract here prevents rework in BDD and implementation.

---

### After Phase 3b — ATDD (step definitions wired, RED)

- [ ] Feature file(s) exist under `backend/src/test/resources/features/`.
- [ ] Step definition class(es) exist (e.g. `*Steps.java`); every step throws `PendingException` or fails for the right reason.
- [ ] **Phase gate:** Run Cucumber and confirm acceptance tests are RED (pending/failed), not green.

**Lightweight automated check:**

```bash
# Option A: script (from your project root)
bash path/to/rushee/scripts/phase-gate.sh 3b backend FDD-001

# Option B: manual
cd backend && ./mvnw test -Dtest=*Cucumber* -Dcucumber.filter.tags="@FDD-001"
# Expected: scenarios pending or failing; no application logic in step defs.
```

- **Optional PR:** Recommended. Small “step defs only, RED” PR makes it clear that implementation comes in the next phase.

---

### After Phase 4 — Backend implementation

- [ ] All Cucumber acceptance tests for the feature are GREEN.
- [ ] Unit/integration tests exist and pass.
- [ ] **Phase gate:** `./mvnw test` (and any other backend checks) pass.

- **Optional PR:** Recommended. Code review and CI (e.g. run tests on PR) before starting Flutter or moving to the next feature.

---

### After Phase 4f — Flutter implementation

- [ ] Flutter app builds: `cd mobile && flutter build apk` or `flutter build web` (as applicable).
- [ ] **Phase gate:** No build errors; optional run of tests/lint.

- **Optional PR:** Recommended. Full-stack feature is ready for review and merge.

---

## When to open a PR (summary)

| Phase   | Phase gate focus              | Open a PR?                          |
|---------|-------------------------------|-------------------------------------|
| 0       | Artifacts exist               | Optional (visibility)               |
| 1 / 1b  | Context map, domain model     | Optional                            |
| 2b      | OpenAPI valid                 | **Recommended** — contract review   |
| 3b      | Cucumber RED                  | **Recommended** — step-defs only    |
| 4       | Backend tests green           | **Recommended** — code review + CI  |
| 4f      | Flutter builds                | **Recommended** — ready to ship     |

If you don’t have a reviewer, commit after the phase gate and continue. The pipeline never blocks on “PR merged.”
