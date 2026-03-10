# Rushee — Spring Boot Engineering Discipline Plugin

> *"Code is written once, read a hundred times, and maintained forever.
> Rushee ensures the discipline to get it right the first time."*

A Claude Code plugin that enforces the complete engineering discipline for Spring Boot projects:

**Strategic DDD → Tactical DDD → FDD → API Contract → BDD → ATDD → TDD → Security → Observability**

---

## The Full Pipeline

```
Strategic DDD        → What are we building? Where does it live?
  ↓ event-storm        Bounded contexts, context map, subdomain classification

Tactical DDD         → How is the domain modelled?
  ↓ ddd-model          Aggregates, entities, value objects, domain events

Feature Design       → What exactly are we building?
  ↓ feature            Feature Card (FDD) with acceptance criteria

API Contract         → What is the interface?
  ↓ api-design         OpenAPI 3.1 spec BEFORE any controller code

BDD                  → How should it behave in business language?
  ↓ bdd-spec           Gherkin .feature file with domain-only language

ATDD                 → Prove we agree — tests RED first
  ↓ atdd-run           Cucumber step definitions, confirm RED

TDD                  → Build it one test at a time
  ↓ tdd-cycle          Outside-in: Controller → Service → Repository

Final Review         → Did we build it right?
                       8-gate review: DDD · SOLID · Spring · Tests · BDD · Security · Ops · DB
```

---

## Installation

```bash
git clone https://github.com/<your-username>/rushee .claude/plugins/rushee
```

---

## Commands

### Project Setup
| Command | Purpose |
|---------|---------|
| `/rushee:event-storm` | Event Storming — discover bounded contexts |
| `/rushee:ddd-model <context>` | Tactical DDD — design aggregates & domain model |

### Feature Pipeline
| Command | Purpose |
|---------|---------|
| `/rushee:feature <desc>` | Create Feature Card (FDD) |
| `/rushee:api-design <FDD-NNN>` | Design OpenAPI contract first |
| `/rushee:bdd-spec <FDD-NNN>` | Write Gherkin scenarios (BDD) |
| `/rushee:atdd-run <FDD-NNN>` | Wire step definitions, confirm RED |
| `/rushee:tdd-cycle <FDD-NNN>` | Implement outside-in (TDD) |
| `/rushee:security-check <FDD-NNN>` | OWASP security gate |
| `/rushee:status` | Progress dashboard for all features |

---

## Agents (11)

| Agent | Role |
|-------|------|
| `event-stormer` | Facilitates Event Storming session |
| `domain-modeller` | Designs tactical DDD model |
| `api-designer` | Contract-first API design |
| `feature-analyst` | Writes Feature Cards |
| `gherkin-writer` | Authors Gherkin scenarios |
| `spec-guardian` | Validates Gherkin for technical leakage |
| `acceptance-enforcer` | Wires Cucumber steps, confirms RED |
| `tdd-implementer` | Outside-in TDD implementation loop |
| `security-reviewer` | OWASP A01-A10 security gate |
| `ops-reviewer` | Production-readiness: logging/metrics/tracing |
| `spring-reviewer` | Chief reviewer — orchestrates all 8 gates |

---

## Skills (15)

| Layer | Skill | Triggers on |
|-------|-------|------------|
| Strategic | `ddd-strategic-design` | "new project", "bounded context", "event storming" |
| Strategic | `ddd-ubiquitous-language` | Naming anything, "glossary", naming drift |
| Tactical | `ddd-tactical-design` | "aggregate", "entity vs value object", "domain model" |
| Tactical | `api-design-contract-first` | "new endpoint", "REST API", "controller", "OpenAPI" |
| Delivery | `fdd-feature-design` | "implement", "add feature", "new feature" |
| Delivery | `bdd-gherkin-spec` | "Gherkin", "scenarios", "BDD spec" |
| Delivery | `atdd-acceptance-first` | "step definitions", "wire Cucumber", "ATDD" |
| Delivery | `tdd-red-green-refactor` | Production class creation, "unit test" |
| Architecture | `clean-architecture-ports-adapters` | "which layer", "hexagonal", "@Entity on domain" |
| Architecture | `event-driven-architecture` | "domain event", "Kafka", "Saga", "Outbox" |
| Architecture | `solid-principles-enforcer` | Code review, class over 150 lines |
| Architecture | `spring-boot-patterns` | Spring idioms, architectural decisions |
| Quality | `database-migration-discipline` | New entity, "@Entity", schema changes, "Flyway" |
| Quality | `security-by-design` | Auth, OAuth2, "secure endpoint", "OWASP" |
| Quality | `observability-and-ops` | "logging", "metrics", "tracing", "production ready" |

---

## Hooks (6)

| Hook | Blocks/Warns |
|------|-------------|
| `session-start-discipline-reminder` | Displays full pipeline banner |
| `guard-no-code-before-feature-card` | Warns: production Java without Feature Card |
| `guard-domain-purity` | **BLOCKS**: `@Entity`/Spring annotations in `domain/` |
| `guard-no-hardcoded-secrets` | **BLOCKS**: passwords/keys/tokens in source files |
| `remind-migration-on-entity-change` | Reminds: create Flyway migration on JPA entity change |
| `auto-run-tests-after-edit` | Reminds: run tests after editing test files |

---

## Non-Negotiable Rules

1. No production code before a Feature Card
2. No controller before an OpenAPI spec
3. No implementation before acceptance tests are RED
4. No `@Entity` on domain model classes — ever
5. No Spring annotations in `domain/` packages — ever
6. No hardcoded secrets anywhere — ever
7. No technical language in Gherkin
8. No merge without security-reviewer APPROVED
9. No merge without ops-reviewer PRODUCTION READY
10. No merge with JaCoCo coverage below 80%

---

MIT License. Replace `<your-github-username>` in `.claude-plugin/marketplace.json` before publishing.
