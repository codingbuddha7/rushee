# Rushee Reference

Five tables. No prose. Everything you need to look up quickly.

---

## Commands

### Entry & Status

| Command | What it does |
|---------|-------------|
| `/rushee:start` | Guided entry point — scans repo, recommends next step. Run this whenever you're unsure what to do. |
| `/rushee:status` | Full pipeline status + 8-gate backend review + frontend review |
| `/rushee:skill-check [FDD-NNN]` | Phase readiness check — returns "Ready" or suggests skills to develop |
| `/rushee:skill-map` | Full skill tree and phase–skill table |
| `/rushee:bootstrap` | Brownfield onboarding — scans existing codebase, maps to pipeline, suggests entry point |
| `/rushee:extend <type> <name>` | Add new skills, commands, or agents to Rushee |
| `/rushee:debug <description>` | Classifies failure (7 backend + 5 frontend categories), forms hypothesis, minimal fix |
| `/rushee:parallel <FDD-NNN>` | Dispatches parallel agents for independent implementation streams |

### Junior Path (set `level: junior` in CLAUDE.md)

| Command | Phase | What it does |
|---------|-------|-------------|
| `/rushee:feature-brief` | 0 | Three questions, ~10 min — produces Feature Card without DDD knowledge |

### Full Pipeline (mid / senior)

| Command | Phase | What it does |
|---------|-------|-------------|
| `/rushee:ux-discovery` | 0 | UX personas, job stories, screen inventory, wireframe specs |
| `/rushee:event-storm` | 1 | Bounded context map, domain event classification |
| `/rushee:ddd-model <context>` | 1b | Tactical DDD model: aggregates, entities, VOs, domain events |
| `/rushee:feature <description>` | 2 | Feature Card with acceptance criteria and screen links |
| `/rushee:api-design <FDD-NNN>` | 2b | OpenAPI 3.1 contract — the law for both codebases |
| `/rushee:bdd-spec <FDD-NNN>` | 3 | Gherkin scenarios in domain language |
| `/rushee:atdd-run <FDD-NNN>` | 3b | Step definitions wired — acceptance tests confirmed RED |
| `/rushee:tdd-cycle <FDD-NNN>` | 4 | Backend TDD: outside-in, controller → service → repository |
| `/rushee:angular-feature <FDD-NNN>` | 4f | Angular frontend: domain → application → data → presentation |
| `/rushee:security-check <FDD-NNN>` | 5 | OWASP Top 10 (backend) + frontend security review |

### Other Frontends and Backends (same pipeline, same contract)

| Command | Stack |
|---------|-------|
| `/rushee:react-feature <FDD-NNN>` | React (Vite, TypeScript) |
| `/rushee:svelte-feature <FDD-NNN>` | Svelte / SvelteKit |
| `/rushee:flutter-feature <FDD-NNN>` | Flutter (Dart) |
| `/rushee:fastapi-tdd-cycle <FDD-NNN>` | Python / FastAPI |
| `/rushee:nest-tdd-cycle <FDD-NNN>` | TypeScript / NestJS |
| `/rushee:go-tdd-cycle <FDD-NNN>` | Go (Echo / Gin) |
| `/rushee:rust-tdd-cycle <FDD-NNN>` | Rust (Actix / Axum) |

---

## 25 Non-Negotiable Rules

### UX Rules
1. **No Feature Card before user journey is mapped** — screens in the Feature Card must exist in the Screen Inventory.
2. **No Figma design before wireframe spec** — text spec reviewed by a non-developer before Figma opens.
3. **UX discovery drives domain design** — domain events come from job stories, not database tables.

### Architecture Rules (Backend)
4. **No persistence framework annotations on domain model classes — ever.** Domain models are plain objects. Persistence entities belong in `infrastructure/persistence/`.
5. **No framework annotations or imports in `domain/` packages — ever.**
6. **No public setters on Aggregate Roots or Entities.** State changes through behaviour methods only.
7. **Dependencies only flow inward** — domain has no knowledge of application or infrastructure.

### Architecture Rules (Frontend)
8. **No API calls in components or services that bypass the data layer — ever.**
9. **No framework imports in `domain/` files — ever.** Domain code is pure business logic only.
10. **No magic values.** Always use named design token constants.

### Contract Rules
11. **No hand-written DTOs on either side.** Both codebases generate from the OpenAPI spec.
12. **No controller code before OpenAPI spec is saved.**
13. **No frontend data source before OpenAPI spec is saved.**
14. **Breaking API change = new API version (`/v2/`)** + deprecation period on `/v1/`.
15. **No merge without regenerating both clients** after any spec change.

### Process Rules
16. **No production code before a Feature Card.**
17. **No implementation before acceptance tests are RED.**
18. **No technical language in Gherkin** — no HTTP, no URLs, no class names, no SQL.

### Security Rules
19. **No hardcoded secrets anywhere.**
20. **Tokens and credentials: secure storage only** — never in localStorage or equivalent.
21. **No merge without `security-reviewer` APPROVED.**

### Quality Rules
22. **No merge without `ops-reviewer` PRODUCTION READY.**
23. **Backend test coverage ≥ 80%. Frontend domain + application layer coverage ≥ 75%.** Use your stack's coverage tool.
24. **Schema validation mode enabled in all non-local environments.** Never allow auto-migration in production.
25. **Schema migration required for every data model change.** Never modify a live schema without a versioned migration script.

---

## Hooks

> The current hooks target the default Java + Angular/Dart stack. Use `/rushee:extend` to add equivalent hooks for other stacks.

| Hook | When | Fires on | Behaviour |
|------|------|----------|-----------|
| `guard-domain-purity` | Pre-write | `**/domain/**/*.java` (default stack) | **BLOCKS** persistence/framework annotations in `domain/` layer |
| `guard-no-hardcoded-secrets` | Pre-write | `**/*.{java,yml,properties,dart}` (default stack) | **BLOCKS** passwords, API keys, tokens in source |
| `guard-no-code-before-feature-card` | Pre-write | `**/src/main/java/**/*.java` (default stack) | **WARNS** production code written before Feature Card |
| `guard-openapi-contract-sync` | Post-write | `**/*-api.yaml,**/*.openapi.yaml` | **WARNS** — regenerate clients and run contract tests |
| `remind-migration-on-entity-change` | Post-write | `**/infrastructure/persistence/**/*` (default stack) | **WARNS** — create a schema migration |
| `auto-run-tests-after-edit` | Post-write | `**/*Test.java,**/*Spec.java,**/*_test.dart` (default stack) | **WARNS** — run the test suite |
| `session-start-discipline-reminder` | Session start | — | **INFO** Displays pipeline banner and suggests next command |

---

## Phase Gates

| Phase | Gate check | Artifacts | PR? |
|-------|-----------|-----------|-----|
| 0 — UX Discovery | `docs/ux/personas.md` exists with ≥ 1 persona; screen inventory, navigation map, wireframes present | `docs/ux/` | Optional |
| 1 — Event Storm | `docs/architecture/context-map.md` exists | `docs/architecture/` | Optional |
| 1b — DDD Model | `docs/domain/<context>/domain-model.md` + domain skeleton classes | `docs/domain/` | Optional |
| 2 — Feature Card | Feature Card exists: `docs/features/FDD-NNN.md` | `docs/features/` | Optional |
| 2b — API Design | OpenAPI spec valid: `npx @openapitools/openapi-generator-cli validate -i <path-to-spec>.yaml` | `*-api.yaml` | **Recommended** |
| 3 — BDD Spec | Feature file exists under test resources | `*.feature` | Optional |
| 3b — ATDD | Acceptance tests RED: run your stack's BDD test command | step-def classes | **Recommended** |
| 4 — Backend | All tests GREEN: run your stack's test command | backend code | **Recommended** |
| 4f — Frontend | Frontend builds with no errors | frontend code | **Recommended** |
| 5 — Security | `security-reviewer` returns APPROVED | security review notes | Before merge |

---

## Tech Stack

| Layer | Default | Alternatives |
|-------|---------|-------------|
| **Frontend** | Angular (NgRx / signals) | React, Svelte (web); Flutter (mobile) |
| **Backend** | Spring Boot 3.x (Java 17) | FastAPI (Python), NestJS (TS), Go, Rust |
| **API contract** | OpenAPI 3.1 | — (required by pipeline) |
| **BDD / acceptance tests** | Cucumber (JVM, pytest-bdd, Godog — stack default) | Any BDD framework for your stack |
| **Unit tests** | Stack default (JUnit 5, pytest, Jest, Vitest, etc.) | — |
| **Coverage** | Stack default (JaCoCo, pytest-cov, Istanbul, c8, etc.) | Target: ≥ 80% backend, ≥ 75% domain + app layers |
| **Schema migration** | Stack default (Flyway, Alembic, TypeORM migrations, etc.) | Any versioned migration tool |
| **Architecture tests** | Stack default (ArchUnit, import-linter, dependency-cruiser, etc.) | Any layer enforcement tool |
| **Security** | Stack default (Spring Security, FastAPI-Security, Passport.js, etc.) | — |
