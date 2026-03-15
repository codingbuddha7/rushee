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
4. **No `@Entity` on domain model classes — ever.** JPA entities live in `infrastructure/persistence/`.
5. **No Spring annotations in `domain/` packages — ever.**
6. **No public setters on Aggregate Roots or Entities.** State changes through behaviour methods only.
7. **Dependencies only flow inward** — domain has no knowledge of application or infrastructure.

### Architecture Rules (Frontend)
8. **No API calls in components or services that bypass the data layer — ever.**
9. **No framework imports in `domain/` files — ever.** Pure TypeScript / pure Dart only.
10. **No magic values.** Always use design token constants (AppColors, AppTypography, AppSpacing).

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
23. **Backend coverage ≥ 80% (JaCoCo).** Frontend domain + application ≥ 75%.
24. **`ddl-auto: validate`** in all non-local Spring profiles.
25. **Flyway migration required** for every `@Entity` change.

---

## Hooks

| Hook | Fires on | Behaviour |
|------|----------|-----------|
| `guard-domain-purity` | Writing `*.java` in `**/domain/**` | **BLOCKS** `@Entity`, `@Service`, Spring/JPA imports in domain layer |
| `guard-no-hardcoded-secrets` | Writing `*.java`, `*.yml`, `*.properties`, `*.dart` | **BLOCKS** passwords, API keys, tokens in source |
| `guard-no-code-before-feature-card` | Writing `*.java` in `src/main/java` | **WARNS** production Java without a Feature Card |
| `guard-openapi-contract-sync` | Writing `*-api.yaml` | **WARNS** — run `./regenerate-clients.sh` and contract tests |
| `remind-migration-on-entity-change` | Writing `*Entity.java` | **WARNS** — create a Flyway migration |
| `auto-run-tests-after-edit` | Writing `*Test.java`, `*_test.dart` | **WARNS** — run the test suite |
| `session-start-discipline-reminder` | Every session start | **INFO** Displays pipeline banner and suggests next command |

---

## Phase Gates

| Phase | Gate check | Artifacts | PR? |
|-------|-----------|-----------|-----|
| 0 — UX Discovery | `docs/ux/personas.md` exists with ≥ 1 persona; screen inventory, navigation map, wireframes present | `docs/ux/` | Optional |
| 1 — Event Storm | `docs/architecture/context-map.md` exists | `docs/architecture/` | Optional |
| 1b — DDD Model | `docs/domain/<context>/domain-model.md` + domain skeleton classes | `docs/domain/` | Optional |
| 2b — API Design | OpenAPI spec valid: `npx @openapitools/openapi-generator-cli validate -i backend/src/main/resources/api/<name>-api.yaml` | `*-api.yaml` | **Recommended** |
| 3b — ATDD | Cucumber RED: `cd backend && ./mvnw test -Dtest=*Cucumber*` | step-def classes | **Recommended** |
| 4 — Backend | All tests GREEN: `./mvnw test` | backend code | **Recommended** |
| 4f — Frontend | App builds: `ng build` (Angular default) | frontend code | **Recommended** |

---

## Tech Stack

| Layer | Default | Alternatives |
|-------|---------|-------------|
| **Frontend** | Angular (NgRx / signals) | React, Svelte |
| **Backend** | Spring Boot 3.x + Java 17 | FastAPI (Python), NestJS (TS), Go, Rust |
| **Mobile** | — | Flutter 3.7+ / Dart 3.0+ |
| **API contract** | OpenAPI 3.1 | — (pipeline requires OpenAPI) |
| **Backend testing** | JUnit 5 + Mockito + Cucumber-JVM 7.x | — |
| **Coverage** | JaCoCo 0.8.x | — |
| **Schema migration** | Flyway 9.x+ | — |
| **Architecture tests** | ArchUnit 1.x | — |
| **Security** | Spring Security + OAuth2 | — |
| **Build** | Maven 3.8+ | Gradle (bring your own) |
