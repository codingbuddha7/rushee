---
name: spring-parallel-agents
description: >
  This skill should be used when a feature has multiple independent implementation
  tasks that can be done simultaneously, or when multiple features in the same sprint
  need to be worked on in parallel. Triggers on: "work in parallel", "dispatch agents",
  "multiple features at once", "parallel development", "split this work", "run concurrently",
  "parallel implementation", or when a feature has 3+ independent layers to implement.
version: 1.0.0
allowed-tools: [Read, Write, Bash, Glob]
---

# Spring Parallel Agents Skill

## When to Use Parallel Agents

Use parallel agents when work is **truly independent** — different classes, different layers,
different bounded contexts. Never run agents in parallel on the same file.

### Safe to parallelise
- Controller tests + Repository tests (different files, different layers)
- Multiple Cucumber step definition files (different domain areas)
- Multiple bounded contexts in the same sprint
- Domain model + Infrastructure mapper + Application service (no shared state)

### Never parallelise
- Two agents touching the same Java class
- Domain model design (must be sequential — each decision affects the next)
- Any pair that shares a Flyway migration file

---

## Pattern 1 — Parallel Layer Implementation

After acceptance tests are RED and the domain model is approved,
implement all three layers simultaneously:

```
Feature: Place Order (FDD-001)
│
├── Agent A: OrderController + @WebMvcTest               ← web layer
├── Agent B: OrderApplicationService + Mockito tests     ← application layer  
└── Agent C: JpaOrderRepository + @DataJpaTest           ← persistence layer
```

### Dispatch instructions for each agent

**Agent A — Web Layer**
```
You are implementing the web layer for FDD-001 (Place Order).
Your scope is ONLY:
  - src/main/java/<pkg>/infrastructure/web/OrderController.java
  - src/test/java/<pkg>/web/OrderControllerTest.java

The OpenAPI spec is at: src/main/resources/api/order-api.yaml
The application service interface is at: src/main/java/<pkg>/application/OrderApplicationService.java

Rules:
- Implement OrderController implementing the generated OrdersApi interface
- Write @WebMvcTest for all happy path and error cases
- Mock the application service — do not instantiate it
- Do not touch any other files
- Signal DONE when all your tests are GREEN
```

**Agent B — Application Layer**
```
You are implementing the application layer for FDD-001 (Place Order).
Your scope is ONLY:
  - src/main/java/<pkg>/application/OrderApplicationService.java
  - src/test/java/<pkg>/application/OrderApplicationServiceTest.java

The domain model is at: src/main/java/<pkg>/domain/
The repository port is at: src/main/java/<pkg>/domain/port/out/OrderRepository.java

Rules:
- Implement the use case: validate command, call domain, save via repository
- Write plain JUnit tests with Mockito — NO Spring context
- Mock the repository port
- Do not touch domain classes or infrastructure classes
- Signal DONE when all your tests are GREEN
```

**Agent C — Persistence Layer**
```
You are implementing the persistence layer for FDD-001 (Place Order).
Your scope is ONLY:
  - src/main/java/<pkg>/infrastructure/persistence/JpaOrderRepository.java
  - src/main/java/<pkg>/infrastructure/persistence/OrderJpaEntity.java
  - src/main/java/<pkg>/infrastructure/persistence/mapper/OrderPersistenceMapper.java
  - src/test/java/<pkg>/persistence/OrderRepositoryTest.java
  - src/main/resources/db/migration/V<N>__create_orders_table.sql

Rules:
- Implement the OrderRepository port
- Write @DataJpaTest — use H2 in-memory for tests
- Create the Flyway migration script
- Do not touch domain classes
- Signal DONE when all your tests are GREEN
```

---

## Pattern 2 — Parallel Feature Sprint

When a sprint has multiple independent feature cards:

```
Sprint 3
│
├── Worktree A (FDD-004): feature/FDD-004-add-discount-codes
│     Claude Code session 1 — full Rushee pipeline
│
├── Worktree B (FDD-005): feature/FDD-005-order-history-api  
│     Claude Code session 2 — full Rushee pipeline
│
└── Worktree C (FDD-006): feature/FDD-006-email-notifications
      Claude Code session 3 — full Rushee pipeline
```

```bash
# Set up three worktrees for parallel sprint work
git worktree add ../project-FDD-004 -b feature/FDD-004-add-discount-codes
git worktree add ../project-FDD-005 -b feature/FDD-005-order-history-api
git worktree add ../project-FDD-006 -b feature/FDD-006-email-notifications

# Open three Claude Code sessions (three terminal windows)
cd ../project-FDD-004 && claude  # Session 1
cd ../project-FDD-005 && claude  # Session 2
cd ../project-FDD-006 && claude  # Session 3
```

Each session runs the complete Rushee pipeline independently.
Merge order: whichever finishes first (after /rushee:status review passes).

---

## Pattern 3 — Parallel Step Definition Implementation

When a feature file has many scenarios, split them by domain area:

```gherkin
# features/order/FDD-001-place-order.feature has 12 scenarios:
# - 4 about validation (customer, products, quantities)
# - 4 about pricing (discounts, tax, totals)
# - 4 about persistence (saves, events, idempotency)
```

```
├── Agent A: Implement validation step definitions + tests
├── Agent B: Implement pricing step definitions + tests
└── Agent C: Implement persistence step definitions + tests
```

Each agent works on a separate `*Steps.java` file. No conflicts.

---

## Synchronisation Points

Parallel agents must sync at these points before proceeding:

```
SYNC POINT 1 — After domain model approved
  All agents read: docs/domain/<context>/domain-model.md
  All agents read: docs/ubiquitous-language/<context>.md
  Only then start parallel implementation

SYNC POINT 2 — After all parallel agents signal DONE
  Run: ./mvnw test  (all tests together — catches integration issues)
  Fix any conflicts before integration tests

SYNC POINT 3 — Before PR
  Run: /rushee:security-check
  Run: spring-reviewer (all 8 gates on the combined code)
```

---

## Conflict Prevention Rules

1. **Each agent owns its files** — define file ownership before dispatching
2. **Domain model is read-only for implementation agents** — only `domain-modeller` modifies it
3. **One Flyway migration per agent maximum** — coordinate version numbers upfront
4. **Shared interfaces (ports) are frozen before parallelising** — no changing `OrderRepository` while Agent C implements it
5. **Merge agents sequentially even if developed in parallel** — Agent A → Agent B → Agent C, each merging to the feature branch

---

## Two-Stage Review for Each Agent

Before accepting any agent's output:

**Stage 1 — Spec Compliance**
- Does the implementation match the Feature Card acceptance criteria?
- Does it implement the OpenAPI contract correctly?
- Does it pass the relevant Cucumber scenarios?

**Stage 2 — Code Quality**
- Does it follow the clean architecture dependency rule?
- Does it pass the SOLID principles check?
- Are there any Spring/JPA imports in the wrong layer?

Both stages must pass before the agent's code is merged to the feature branch.
