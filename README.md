# Rushee v2.2 — Full-Stack Flutter + Spring Boot Engineering Discipline

> *"Start with the user. End with production. Never skip a step."*

**Rushee** is a [Claude Code](https://claude.ai/code) plugin that enforces a complete,
professional engineering discipline for full-stack **Flutter + Spring Boot** projects —
from first UX sketch to production deployment. Every stage is guided, every shortcut
is blocked, and both codebases stay in sync through a shared OpenAPI contract.

---

## Table of Contents

1. [What is Rushee?](#1-what-is-rushee)
2. [Installation](#2-installation)
3. [The Full-Stack Pipeline](#3-the-full-stack-pipeline)
4. [Repository Structure](#4-repository-structure)
5. [Commands Reference](#5-commands-reference)
6. [Skills Reference](#6-skills-reference)
7. [Agents Reference](#7-agents-reference)
8. [Hooks Reference](#8-hooks-reference)
9. [Step-by-Step Full-Stack Walkthrough](#9-step-by-step-walkthrough)
10. [Non-Negotiable Rules](#10-non-negotiable-rules)
11. [Project Structure — Backend](#11-backend-project-structure)
12. [Project Structure — Flutter Mobile](#12-flutter-project-structure)
13. [The OpenAPI Contract Bridge](#13-the-openapi-contract-bridge)
14. [Flutter Architecture Deep Dive](#14-flutter-architecture)
15. [UX Design Workflow](#15-ux-design-workflow)
16. [Debugging with Rushee](#16-debugging-with-rushee)
17. [Running Features in Parallel](#17-parallel-features)
18. [Extending Rushee](#18-extending-rushee)
19. [Technology Stack](#19-technology-stack)
20. [FAQ](#20-faq)

---

## 1. What is Rushee?

Rushee is a Claude Code plugin — a collection of **25 skills**, **17 agents**,
**14 commands**, and **7 hooks** that enforce a structured engineering methodology
across a full-stack Flutter + Spring Boot project.

### The Problem Rushee Solves

Without discipline, full-stack AI-assisted development produces:
- UX designed **after** the backend model (UI becomes a form over a database)
- Flutter widgets that call APIs directly (no clean architecture)
- Hand-written DTOs on both sides that drift out of sync silently
- No tests on the Flutter side, or tests that never go RED first
- JWT tokens stored in `SharedPreferences` (a security vulnerability)
- Magic colour values and font sizes scattered across the Flutter codebase
- Spring Boot domain classes polluted with `@Entity` and `@Service` annotations

Rushee prevents all of this by making the right approach the only approach.

### The Three Codebases, One Discipline

```
┌──────────────────────────────────────────────────────────────────┐
│  UX LAYER          Figma design tokens, screen inventory,        │
│                    navigation maps, wireframe specs              │
│                    (Rushee phase: ux-discovery)                  │
├──────────────────────────────────────────────────────────────────┤
│  FLUTTER CLIENT    Dart · Clean Architecture · BLoC              │
│                    domain → application → data → presentation    │
│                    (Rushee phase: flutter-feature)               │
│                              ↕ OpenAPI Contract (the bridge)     │
│  SPRING BOOT API   Java · DDD · Hexagonal Architecture           │
│                    domain → application → infrastructure         │
│                    (Rushee phase: tdd-cycle)                     │
└──────────────────────────────────────────────────────────────────┘
```

### Skills vs Commands vs Agents vs Hooks

| Artifact | What it is | When it fires |
|----------|-----------|---------------|
| **Skill** | A SKILL.md with patterns, rules, code examples | **Automatically** — Claude reads it when your conversation matches the trigger |
| **Command** | A named action you invoke explicitly | **Manually** — you type `/rushee:<command>` |
| **Agent** | A specialised AI persona for a complex task | **On demand** — invoked by commands or other agents |
| **Hook** | A shell script that fires on file system events | **Automatically** — fires on write, session start, etc. |

---

## 2. Installation

### Prerequisites

- **Claude Code**: `npm install -g @anthropic-ai/claude-code`
- **Java 17+** and **Maven 3.8+** for the Spring Boot project
- **Flutter 3.7+** and **Dart 3.0+** for the mobile app
- **Git** with a monorepo or two-repo setup
- **openapi-generator-cli** for contract code generation (optional but recommended)

### Option A — Clone directly into your project (recommended)

```bash
# Navigate to your project root
cd /path/to/your-project

# Clone Rushee
git clone https://github.com/codingbuddha7/rushee .claude/plugins/rushee

# Start Claude Code
claude
```

You should see the Rushee session banner immediately:

```
╔══════════════════════════════════════════════════════════════════╗
║              🚀  RUSHEE  v2.2  — Full-Stack Mode 🚀             ║
║    Spring Boot Backend + Flutter Mobile Engineering Discipline   ║
╠══════════════════════════════════════════════════════════════════╣
║  FULL PIPELINE (start here for new projects):                   ║
║  /rushee:ux-discovery   → User journeys, personas, screen map   ║
║  /rushee:event-storm    → Bounded contexts & domain events      ║
║  ...                                                            ║
```

### Option B — Claude Code marketplace

```bash
/plugin marketplace add codingbuddha7/rushee-marketplace
/plugin install rushee@rushee-marketplace
```

### Monorepo Layout (recommended)

```
your-project/
├── backend/          ← Spring Boot project (Maven)
├── mobile/           ← Flutter project
├── docs/             ← UX, domain, feature docs (shared)
│   ├── ux/
│   ├── architecture/
│   ├── domain/
│   └── features/
└── .claude/
    └── plugins/
        └── rushee/   ← this plugin
```

---

## 3. The Full-Stack Pipeline

Every feature passes through every stage. No stage is optional.
No stage can start before its predecessor is complete.

```
╔══════════════════════════════════════════════════════════════════╗
║                    THE RUSHEE FULL-STACK PIPELINE               ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  PHASE 0 — UX DISCOVERY  (once per project, then per epic)      ║
║  ─────────────────────────────────────────────────────────────  ║
║  /rushee:ux-discovery                                           ║
║    → Personas (who uses this app?)                              ║
║    → Job Stories (what are they trying to accomplish?)          ║
║    → Domain events extracted from job stories                   ║
║    → Screen Inventory (every screen named before Figma opens)   ║
║    → Navigation map (how screens connect)                       ║
║    → Wireframe specs (text description before Figma design)     ║
║    Output: docs/ux/personas.md                                  ║
║            docs/ux/screen-inventory.md                          ║
║            docs/ux/navigation-map.md                            ║
║            docs/ux/wireframes/S{NN}-<screen-name>.md            ║
║                                                                  ║
║  PHASE 1 — DOMAIN DESIGN  (once per bounded context)            ║
║  ─────────────────────────────────────────────────────────────  ║
║  /rushee:event-storm                                            ║
║    → Context map: bounded contexts and relationships            ║
║    → Domain events: Core / Supporting / Generic classification  ║
║    Output: docs/architecture/context-map.md                     ║
║                                                                  ║
║  /rushee:ddd-model <context>                                    ║
║    → Aggregates, Entities, Value Objects, Domain Events         ║
║    → Repository interfaces (pure Java, no frameworks)           ║
║    → Ubiquitous language glossary                               ║
║    Output: domain skeleton classes                              ║
║            docs/domain/<context>/domain-model.md               ║
║                                                                  ║
║  PHASE 2 — FEATURE + CONTRACT  (once per Feature Card)          ║
║  ─────────────────────────────────────────────────────────────  ║
║  /rushee:feature <description>                                  ║
║    → Feature Card with acceptance criteria AND screen links     ║
║    Output: docs/features/FDD-NNN.md                             ║
║                                                                  ║
║  /rushee:api-design <FDD-NNN>                                   ║
║    → OpenAPI 3.1 spec — the law for BOTH codebases              ║
║    → Reviewed before any controller or Flutter data source      ║
║    Output: backend/src/main/resources/api/<context>-api.yaml    ║
║                                                                  ║
║  PHASE 3 — BDD / ATDD  (backend)                                ║
║  ─────────────────────────────────────────────────────────────  ║
║  /rushee:bdd-spec <FDD-NNN>                                     ║
║    → Gherkin scenarios in pure domain language                  ║
║    → Validated: no HTTP verbs, URLs, class names, SQL           ║
║    Output: backend/src/test/resources/features/...              ║
║                                                                  ║
║  /rushee:atdd-run <FDD-NNN>                                     ║
║    → Step definitions wired — acceptance tests confirmed RED    ║
║    Output: step definitions with PendingException               ║
║                                                                  ║
║  PHASE 4 — PARALLEL IMPLEMENTATION  (backend + Flutter)         ║
║  ─────────────────────────────────────────────────────────────  ║
║                                                                  ║
║  ┌─────────────────────────┐  ┌──────────────────────────────┐  ║
║  │ BACKEND STREAM          │  │ FLUTTER STREAM               │  ║
║  │ /rushee:tdd-cycle       │  │ /rushee:flutter-feature      │  ║
║  │                         │  │                              │  ║
║  │ Outside-in TDD:         │  │ Regenerate API client        │  ║
║  │  Controller tests       │  │ Domain entities (Dart)       │  ║
║  │  Service tests          │  │ Use cases + unit tests       │  ║
║  │  Repository tests       │  │ BLoC + unit tests            │  ║
║  │  Flyway migration       │  │ Widget tests (mocked BLoC)   │  ║
║  │  Cucumber GREEN ✅      │  │ Screen integration test      │  ║
║  └─────────────────────────┘  └──────────────────────────────┘  ║
║                  ↕ both implement from same OpenAPI spec ↕       ║
║                                                                  ║
║  PHASE 5 — SECURITY + FINAL REVIEW                              ║
║  ─────────────────────────────────────────────────────────────  ║
║  /rushee:security-check <FDD-NNN>                               ║
║    → OWASP Top 10 (backend) + OWASP Mobile Top 10 (Flutter)     ║
║                                                                  ║
║  /rushee:status                                                 ║
║    → spring-reviewer (8 gates) + flutter-reviewer (5 gates)     ║
║    → APPROVED → merge                                           ║
╚══════════════════════════════════════════════════════════════════╝
```

### The Golden Rule: UX → Domain → Contract → Code

```
User journey reveals domain events.
Domain events shape the domain model.
Domain model shapes the OpenAPI contract.
OpenAPI contract generates code for both codebases.
```

Never reverse this order. Never start from the database schema. Never start from
the API spec. Always start from what the user is trying to accomplish.

---

## 4. Repository Structure

### Recommended Monorepo Layout

```
your-project/
│
├── backend/                       ← Spring Boot Maven project
│   ├── pom.xml
│   └── src/
│
├── mobile/                        ← Flutter project
│   ├── pubspec.yaml
│   └── lib/
│
├── docs/                          ← All documentation (shared, version-controlled)
│   ├── ux/
│   │   ├── personas.md            ← Who uses this app
│   │   ├── screen-inventory.md    ← Every screen tracked here
│   │   ├── navigation-map.md      ← How screens connect
│   │   └── wireframes/
│   │       ├── S01-splash.md
│   │       ├── S02-login.md
│   │       └── S13-cart-review.md
│   ├── architecture/
│   │   ├── context-map.md         ← Bounded context relationships
│   │   ├── event-timeline.md      ← Domain event flow
│   │   ├── subdomains.md          ← Core/Supporting/Generic
│   │   └── decisions/             ← Architecture Decision Records
│   ├── domain/
│   │   └── <context>/
│   │       └── domain-model.md    ← Aggregate design docs
│   ├── features/
│   │   ├── FDD-001.md             ← Feature Card: Place Order
│   │   ├── FDD-002.md             ← Feature Card: Cancel Order
│   │   └── FDD-003.md
│   └── reviews/
│       └── FDD-001-security.md    ← Security review record
│
├── regenerate-clients.sh          ← CRITICAL: regenerates both API clients
│
└── .claude/
    └── plugins/
        └── rushee/                ← This plugin
```

---

## 5. Commands Reference

### Phase 0 — UX Discovery

---

#### `/rushee:ux-discovery`

Start a new project or epic from the user's perspective.

**When to run**: At the very beginning of every project, and at the start of any
new epic or major feature set. Before Event Storming. Before writing any code.

**What happens**: The `ux-analyst` agent guides you through defining personas,
writing Job Stories, extracting domain events from those stories, building a
Screen Inventory, mapping navigation, and writing wireframe specs for every screen
in scope.

**Output**:
- `docs/ux/personas.md` — who uses the app, their context, goals, constraints
- `docs/ux/screen-inventory.md` — every screen named, assigned to a persona and job story
- `docs/ux/navigation-map.md` — how all screens connect
- `docs/ux/wireframes/S{NN}-<screen>.md` — text wireframe spec per screen

**Why this comes first**: User journeys reveal domain events. Those events are the
input to `/rushee:event-storm`. Every domain event that appears in your backend was
first discovered in a user's journey — or it shouldn't exist at all.

```
/rushee:ux-discovery
> "Tell me about the people who will use this app."
You: "Two personas: shoppers placing grocery orders, and store managers fulfilling them"
[Agent builds persona profiles, extracts job stories, discovers 14 domain events,
 creates screen inventory with 16 screens, writes wireframe specs]
> "UX Discovery complete. You have 14 domain events ready for /rushee:event-storm"
```

---

### Phase 1 — Domain Design

---

#### `/rushee:event-storm`

Map bounded contexts and domain events.

**When to run**: After UX Discovery. Pass the domain events list from your job stories
as the starting point — the session will be dramatically faster.

**Output**: `docs/architecture/context-map.md`, `docs/architecture/subdomains.md`

```
/rushee:event-storm
[Agent imports domain events from UX discovery]
[Facilitates timeline building, context identification, relationship mapping]
> "4 bounded contexts identified: Order, Payment, Inventory, Notification"
```

---

#### `/rushee:ddd-model <context-name>`

Design the tactical domain model for a bounded context.

**When to run**: After Event Storming, for each Core or Supporting subdomain.

**What happens**: The `domain-modeller` agent designs aggregates, entities, value
objects, domain events, and repository interfaces. Generates skeleton classes with
zero Spring/JPA annotations.

**Output**: `docs/domain/<context>/domain-model.md`, domain skeleton Java classes

```
/rushee:ddd-model order-management
[Agent designs: Order (aggregate root), OrderLine (entity), Money (value object),
 OrderId (value object), OrderStatus (enum), OrderPlaced (domain event),
 OrderRepository (output port interface)]
```

---

### Phase 2 — Feature & Contract

---

#### `/rushee:feature <description>`

Create a Feature Card for a new piece of functionality.

**When to run**: For every feature, before writing any code on either side.

**The v2.2 Feature Card** includes a Screens section linking each feature to its
Figma-approved screens in the Screen Inventory.

**Output**: `docs/features/FDD-NNN.md`

```markdown
## FDD-001: Place Order

### Screens
| Screen ID | Screen Name         | Figma Status   |
|-----------|---------------------|----------------|
| S13       | Cart Review Screen  | ✅ Approved    |
| S14       | Checkout Screen     | ✅ Approved    |
| S15       | Order Confirmation  | ✅ Approved    |

### Backend Endpoints
POST /api/v1/orders → 201 OrderDto

### Acceptance Criteria
1. A registered customer with a non-empty cart can place an order
2. An order with no items is rejected with a clear error
...
```

---

#### `/rushee:api-design <FDD-NNN>`

Design the OpenAPI contract before writing any controller or Flutter data source.

**When to run**: After Feature Card exists. Before any backend controller code.
Before any Flutter `RemoteDataSource` class.

**Critical**: The OpenAPI spec is the **only bridge** between the two codebases.
It generates the Spring Boot API interfaces via `openapi-generator-maven-plugin`
and the Flutter models + API client via `openapi-generator dart-dio`.
Neither side hand-writes DTOs.

**Output**: `backend/src/main/resources/api/<context>-api.yaml`

**Hook activated**: After saving the spec, `guard-openapi-contract-sync` hook
reminds you to run `./regenerate-clients.sh` to regenerate both clients.

---

### Phase 3 — BDD / ATDD (Backend)

---

#### `/rushee:bdd-spec <FDD-NNN>`

Write Gherkin scenarios in domain language.

**When to run**: After Feature Card + API contract approved.

**What happens**: `gherkin-writer` produces scenarios. `spec-guardian` validates
every step — rejecting HTTP verbs, URLs, class names, and SQL. Pure domain language only.

**Output**: `backend/src/test/resources/features/<domain>/FDD-NNN-<title>.feature`

---

#### `/rushee:atdd-run <FDD-NNN>`

Wire step definitions and confirm acceptance tests are RED.

**When to run**: After Gherkin is approved.

**Rule**: If tests are green at this point, the implementation already exists.
Something is wrong. Acceptance tests must fail before implementation begins.

**Output**: `*Steps.java` with `PendingException` bodies, confirmed failing

---

### Phase 4 — Implementation (Both Streams)

---

#### `/rushee:tdd-cycle <FDD-NNN>`

Implement the backend feature using outside-in TDD.

**When to run**: After acceptance tests are RED.

**What happens**: `tdd-implementer` works outside-in — controller → service →
repository. One failing test at a time. Checks Cucumber acceptance tests every
3-4 unit test cycles. Stops when all acceptance tests are GREEN.

**Never starts implementation** without seeing acceptance tests fail first.

---

#### `/rushee:flutter-feature <FDD-NNN>`

Implement the Flutter mobile feature for a Feature Card.

**When to run**: After Feature Card + OpenAPI contract + Figma screens are all approved.
Can run **in parallel** with `/rushee:tdd-cycle` since both implement from the same spec.

**What happens**:
1. Verifies prerequisites: Feature Card, Screen Inventory entry, OpenAPI spec, design tokens
2. Regenerates the Flutter API client from the spec (`openapi-generator dart-dio`)
3. Implements the domain layer in Dart (entities, repository interface)
4. Implements use cases + unit tests (pure Dart, no Flutter)
5. Implements BLoC + unit tests (mocktail mocks use cases)
6. Implements widgets + widget tests (pump BLoC with mock states)
7. Implements screen + integration test (against real or mocked API)
8. Runs `flutter-reviewer` 5-gate quality check

**Flutter test types implemented**:

| Test type | Flutter tool | Spring Boot equivalent |
|-----------|-------------|----------------------|
| Use case unit tests | `flutter_test` + `mocktail` | JUnit + Mockito |
| BLoC unit tests | `bloc_test` + `mocktail` | (application service tests) |
| Widget tests | `flutter_test pump()` | `@WebMvcTest` |
| Integration tests | `integration_test` package | `@SpringBootTest` + CucumberIT |

**Output**: Complete Flutter feature implementation with tests at every layer

```
/rushee:flutter-feature FDD-001
[Agent verifies prerequisites]
[Agent regenerates API client from order-api.yaml]
[Agent generates Order entity (Dart, pure), OrderRepository (abstract)]
[Agent writes PlaceOrderUseCase + unit test — RED → implement — GREEN]
[Agent writes OrderBloc + bloc_test — RED → implement — GREEN]
[Agent writes CartReviewScreen widget tests — RED → implement — GREEN]
[Agent runs flutter-reviewer 5 gates]
> Gate F1 Architecture ✅  Gate F2 State ✅  Gate F3 Contract ✅
> Gate F4 Tests ✅  Gate F5 Security ✅
> FLUTTER REVIEW: APPROVED
```

---

### Quality Gates

---

#### `/rushee:debug <description>`

Systematically debug a failing test or exception on either backend or Flutter.

**When to run**: Any time any test fails. Do not guess. Classify first.

**Backend failure categories**: Spring wiring (A), JPA/Transactions (B),
Wrong value (C), NPE (D), Cucumber (E), HTTP test (F), Test isolation (G)

**Flutter failure categories**: Provider/BLoC wiring (H), async state (I),
widget rendering (J), golden test drift (K), integration test timing (L)

---

#### `/rushee:parallel <FDD-NNN>`

Dispatch parallel agents for independent implementation tasks.

**When to run**: When a feature has independent work units, or a sprint has
multiple independent Feature Cards.

**Most powerful use case for full-stack**: Dispatch backend stream (`tdd-implementer`)
and Flutter stream (`flutter-implementer`) simultaneously after the API contract is
approved and acceptance tests are RED.

```
/rushee:parallel FDD-001
[Dispatcher assigns:]
  Backend Agent  → Spring Boot controller → service → repository → Cucumber GREEN
  Flutter Agent  → Dart entities → use cases → BLoC → widgets → integration GREEN
[Both implement from the same OpenAPI spec — no conflicts by design]
```

---

#### `/rushee:security-check <FDD-NNN>`

Run OWASP security review on both the backend and the Flutter client.

**Backend** (OWASP Top 10): injection, broken auth, exposed data, XXE, misconfiguration,
XSS, insecure deserialization, outdated components, logging, SSRF.

**Flutter** (OWASP Mobile Top 10): token storage (`flutter_secure_storage` required),
certificate pinning, cleartext traffic, screenshot prevention on sensitive screens,
no PII in logs.

**Output**: APPROVED or CHANGES REQUIRED with severity (HIGH / MEDIUM / LOW)

---

#### `/rushee:extend <type> <name>`

Add new skills, commands, or agents to Rushee.

```
/rushee:extend skill resilience-patterns
/rushee:extend skill flutter-offline-first
/rushee:extend command contract-test
```

---

#### `/rushee:status`

Full pipeline status + 8-gate backend review + 5-gate Flutter review.

---

## 6. Skills Reference

Skills fire **automatically** when your conversation matches their trigger phrases.

### UX Layer (NEW in v2.2)

| Skill | Triggers on... |
|-------|---------------|
| **ux-discovery-first** | "user journey", "persona", "wireframe", "UX design", "screen flow", "what does the app look like", "how does the user...", "job story", "screen inventory", "navigation", "onboarding" |
| **design-to-code-contract** | "implement the design", "Figma", "match the design", "design tokens", "theme", "color", "typography", "spacing", "padding", "border radius", "dark mode", "Material 3", "ThemeData", "pixel perfect" |

### Flutter Architecture Layer (NEW in v2.2)

| Skill | Triggers on... |
|-------|---------------|
| **flutter-clean-architecture** | "Flutter", "Dart", "widget", "screen", "BLoC", "Riverpod", "state management", "flutter layer", "flutter use case", "flutter repository", "go_router", "dio", "flutter clean arch" |
| **flutter-testing-discipline** | "flutter test", "widget test", "BLoC test", "golden test", "integration_test", "mocktail", "pump()", "flutter coverage", "bloc_test" |
| **mobile-security-by-design** | "store token", "JWT Flutter", "SharedPreferences", "flutter_secure_storage", "certificate pinning", "biometric", "OWASP Mobile", "keystore", "keychain", "screenshot prevention" |
| **openapi-contract-sync** | "add a field", "change the response", "fromJson", "toJson", "dto", "serialization", "api contract", "breaking change", "api versioning", "retrofit", "regenerate", "model mismatch", any edit to `*-api.yaml` |

### Strategic Layer

| Skill | Triggers on... |
|-------|---------------|
| **ddd-strategic-design** | "new project", "new microservice", "bounded context", "event storming", "domain design", "context map" |
| **ddd-ubiquitous-language** | "what should I call this", "naming", "glossary", "the business calls it X but code says Y", naming inconsistency |
| **ddd-tactical-design** | "aggregate design", "entity or value object", "domain model", "rich domain model", "anemic model", "where does this business rule go" |

### Delivery Layer

| Skill | Triggers on... |
|-------|---------------|
| **api-design-contract-first** | "new endpoint", "REST API", "controller", "OpenAPI", "write an endpoint" |
| **fdd-feature-design** | "implement", "add feature", "new feature", "build" |
| **bdd-gherkin-spec** | "Gherkin", "scenarios", "BDD spec", "write scenarios", "feature file" |
| **atdd-acceptance-first** | "step definitions", "wire Cucumber", "ATDD", "acceptance tests" |
| **tdd-red-green-refactor** | Creating any production class, "unit test", "TDD", "write a test for" |

### Engineering Quality Layer

| Skill | Triggers on... |
|-------|---------------|
| **spring-git-workflow** | "create branch", "git worktree", "PR", "merge feature", "branch strategy" |
| **spring-parallel-agents** | "work in parallel", "dispatch agents", "multiple features at once" |
| **spring-systematic-debugging** | Any stack trace, "test fails", "exception", "bug", "debug", "why is this failing" |
| **clean-architecture-ports-adapters** | "which layer", "hexagonal", "ports and adapters", "@Entity on domain", "dependency rule" |
| **event-driven-architecture** | "domain event", "Kafka", "RabbitMQ", "Saga", "Outbox", "cross-context" |
| **solid-principles-enforcer** | "code review", "refactor", class over 150 lines, too many constructor params |
| **spring-boot-patterns** | Spring idioms, "@Autowired", "@Transactional", "layered architecture" |

### Quality Gates Layer

| Skill | Triggers on... |
|-------|---------------|
| **database-migration-discipline** | "@Entity", "add column", "Flyway", "schema change", "create table" |
| **security-by-design** | "Spring Security", "authentication", "JWT", "OAuth2", "OWASP", "password" |
| **observability-and-ops** | "logging", "metrics", "tracing", "Actuator", "Micrometer", "production ready" |

### Meta Layer

| Skill | Triggers on... |
|-------|---------------|
| **extending-rushee** | "add a skill", "Rushee doesn't cover", "customise Rushee", "how do I teach Rushee" |

---

## 7. Agents Reference

| Agent | Invoked by | Purpose |
|-------|-----------|---------|
| **ux-analyst** | `/rushee:ux-discovery` | Guides persona definition, job story mapping, screen inventory, navigation map, wireframe specs |
| **event-stormer** | `/rushee:event-storm` | Event Storming facilitation, context mapping, subdomain classification |
| **domain-modeller** | `/rushee:ddd-model` | Tactical DDD design — aggregates, entities, VOs, domain events. No Spring annotations in domain |
| **api-designer** | `/rushee:api-design` | Produces OpenAPI 3.1 spec. Blocks code until spec is reviewed and saved |
| **feature-analyst** | `/rushee:feature` | Interviews developer, writes Feature Card with acceptance criteria AND screen links |
| **gherkin-writer** | `/rushee:bdd-spec` | Writes Gherkin in domain language. Hands to spec-guardian |
| **spec-guardian** | After gherkin-writer | Rejects HTTP verbs, URLs, class names, SQL in Gherkin |
| **acceptance-enforcer** | `/rushee:atdd-run` | Checks Maven deps, generates PendingException skeletons, confirms RED |
| **tdd-implementer** | `/rushee:tdd-cycle` | Outside-in TDD: one test at a time. Backend only |
| **flutter-implementer** | `/rushee:flutter-feature` | Outside-in Flutter: use cases → BLoC → widgets → screens. Tests at every layer |
| **flutter-reviewer** | After flutter-implementer | Runs 5-gate Flutter quality review |
| **debugger** | `/rushee:debug` | Classifies failure (7 backend + 5 Flutter categories), forms hypothesis, applies minimal fix |
| **parallel-dispatcher** | `/rushee:parallel` | Defines file ownership, per-agent instructions, worktree setup |
| **security-reviewer** | `/rushee:security-check` | OWASP Top 10 (backend) + OWASP Mobile Top 10 (Flutter) |
| **ops-reviewer** | From spring-reviewer | Logging, metrics, tracing, health indicators, config review |
| **spring-reviewer** | `/rushee:status` | Chief backend reviewer — 8 gates. Calls flutter-reviewer for full-stack features |
| **rushee-extender** | `/rushee:extend` | Adds new skills/commands/agents following Rushee quality standards |

---

## 8. Hooks Reference

| Hook | Fires | Behaviour |
|------|-------|-----------|
| **session-start-discipline-reminder** | Every session start | Displays pipeline banner. Warns if no context map or screen inventory exists |
| **guard-no-code-before-feature-card** | Writing `*.java` in `src/main/java` | **WARNS** — production Java without a Feature Card |
| **guard-domain-purity** | Writing `*.java` in `**/domain/**` | **BLOCKS** — `@Entity`, `@Service`, Spring/JPA imports in domain layer |
| **guard-no-hardcoded-secrets** | Writing `*.java`, `*.yml`, `*.properties`, `*.dart` | **BLOCKS** — passwords, API keys, tokens in source files |
| **guard-openapi-contract-sync** | After writing `*-api.yaml` | **WARNS** — reminds to run `./regenerate-clients.sh` and run contract tests on both sides |
| **remind-migration-on-entity-change** | After writing `*Entity.java` | **WARNS** — create a Flyway migration |
| **auto-run-tests-after-edit** | After writing `*Test.java`, `*_test.dart` | **WARNS** — run the test suite |

### regenerate-clients.sh

Create this script at your project root. The `guard-openapi-contract-sync` hook
points to it every time you change a spec:

```bash
#!/bin/bash
# regenerate-clients.sh
# Run this every time any *-api.yaml file changes

set -e

SPEC_FILE="${1:-backend/src/main/resources/api/order-api.yaml}"
FLUTTER_OUTPUT="mobile/lib/features/order/data/generated"

echo "=== Regenerating API clients from: $SPEC_FILE ==="

echo "--- Backend (Spring Boot): generating interfaces ---"
cd backend && ./mvnw generate-sources -q && cd ..
echo "✅ Backend interfaces generated"

echo "--- Flutter: generating models + API client ---"
openapi-generator-cli generate \
  -i "$SPEC_FILE" \
  -g dart-dio \
  -o "$FLUTTER_OUTPUT" \
  --additional-properties=pubName=api_client,nullSafe=true
cd mobile && flutter pub run build_runner build --delete-conflicting-outputs -q && cd ..
echo "✅ Flutter client generated"

echo "=== Running contract tests ==="
echo "--- Backend contract tests ---"
cd backend && ./mvnw test -Dtest="*ContractTest" -q && cd ..
echo "✅ Backend contract tests pass"

echo "--- Flutter contract tests ---"
cd mobile && flutter test test/contract/ --no-pub && cd ..
echo "✅ Flutter contract tests pass"

echo ""
echo "=== Both clients regenerated and verified ==="
```

---

## 9. Step-by-Step Walkthrough

Here is a complete worked example building a grocery ordering app from scratch.

### Starting a New Project

```
claude   (from project root — Rushee banner appears)

> ⚠️ No UX discovery found. Consider running /rushee:ux-discovery first.
> ⚠️ No context map found.
```

### Step 0 — UX Discovery

```
/rushee:ux-discovery

> "Tell me about the people who will use this app."
You: "Two types: shoppers ordering groceries on mobile, store managers managing stock"

> "For the Shopper persona — what's their situation when they open the app?"
You: "Usually on their phone, commuting or at home, wants to order quickly"

[Agent writes Amara (Returning Shopper) and Marcus (Store Manager) personas]

> "Now let's map Amara's jobs. When does she open the app? What is she trying to do?"
You: "She opens it to reorder her weekly groceries without searching each time"

> "Job Story JS-001: When I open the app after a week away, I want to see my
>  previous order ready to repeat, so I can reorder without searching.
>  Domain events found: OrderHistoryViewed, ReorderRequested
>  Screens required: Order History Screen, Reorder Confirmation Screen
>  
>  What's the next job story?"

[Agent builds 8 job stories across 2 personas]
[Agent extracts 14 domain events]
[Agent builds screen inventory: 16 screens]
[Agent writes wireframe specs for MVP screens S01–S16]

> "UX Discovery complete:
>  ✅ 2 personas defined
>  ✅ 8 job stories written
>  ✅ 14 domain events ready for event-storm
>  ✅ Screen inventory: 16 screens
>  ✅ Wireframe specs: 16 screens
>  
>  Next: /rushee:event-storm (pass these 14 domain events as input)"
```

### Step 1 — Event Storming

```
/rushee:event-storm

[Agent starts with the 14 domain events from UX discovery]
[Builds timeline: OrderBrowsed → CartUpdated → OrderPlaced → PaymentProcessed → ...]
[Identifies 4 bounded contexts: Order, Payment, Inventory, Notification]
[Classifies: Order=Core, Payment=Core, Inventory=Supporting, Notification=Generic]

> "4 contexts mapped. Core domains: Order, Payment.
>  Next: /rushee:ddd-model order-management"
```

### Step 2 — Domain Model

```
/rushee:ddd-model order-management

[Agent designs: Order (aggregate), OrderLine (entity), Money + OrderId (VOs),
 OrderStatus (enum), OrderPlaced/Cancelled (domain events),
 OrderRepository (output port)]
[Generates Java skeleton classes with ZERO Spring/JPA annotations]

> "Domain model approved. Next: /rushee:feature"
```

### Step 3 — Feature Card

```
/rushee:feature "Allow customers to place an order with multiple product lines"

[Agent writes FDD-001 with acceptance criteria AND screen links to S13, S14, S15]

> "FDD-001 created. Screens: S13 Cart Review ✅, S14 Checkout ✅, S15 Confirmation ✅
>  Next: /rushee:api-design FDD-001"
```

### Step 4 — API Contract

```
/rushee:api-design FDD-001

[api-designer drafts OpenAPI spec: POST /api/v1/orders → 201 OrderDto]
> "Is this contract correct? POST /api/v1/orders with CartId + payment details
>  returning OrderDto {orderId, status, totalAmount, placedAt}?"
You: "Add estimatedDelivery to the response"
[Agent updates spec]
[Spec saved → guard-openapi-contract-sync hook fires]

> "⚡ Contract saved. Run: ./regenerate-clients.sh
>  This regenerates both the Spring Boot API interface and the Flutter Dart client."

./regenerate-clients.sh   (run in terminal)
> ✅ Backend interfaces generated
> ✅ Flutter client generated
> ✅ Contract tests pass

> "Both clients generated. Next: /rushee:bdd-spec FDD-001 (backend)
>              and simultaneously: /rushee:flutter-feature FDD-001 (Flutter)"
```

### Step 5 — BDD + ATDD (Backend)

```
/rushee:bdd-spec FDD-001

[gherkin-writer produces 4 scenarios in domain language]
[spec-guardian validates: rejects 2 steps for technical language, fixed]
> "Scenarios saved. Next: /rushee:atdd-run FDD-001"

/rushee:atdd-run FDD-001

[acceptance-enforcer generates PlaceOrderSteps.java with PendingException]
[runs ./mvnw test -Dtest="CucumberIT"]
> Tests run: 4, Errors: 4 — PENDING ✅
> "Acceptance tests confirmed RED. Ready for implementation."
```

### Step 6 — Parallel Implementation

```
/rushee:parallel FDD-001

[parallel-dispatcher defines two independent streams]
[No shared files between streams — only the generated API client is shared,
 and it's read-only during implementation]

BACKEND stream owns:
  backend/src/main/java/.../infrastructure/web/OrderController.java
  backend/src/main/java/.../application/OrderApplicationService.java
  backend/src/main/java/.../infrastructure/persistence/JpaOrderRepository.java
  All test files for the above

FLUTTER stream owns:
  mobile/lib/features/order/domain/entities/order.dart
  mobile/lib/features/order/application/usecases/place_order_usecase.dart
  mobile/lib/features/order/presentation/bloc/order_bloc.dart
  mobile/lib/features/order/presentation/screens/cart_review_screen.dart
  All test files for the above
```

Run two Claude Code sessions simultaneously:

```bash
# Terminal 1 — Backend
cd your-project && claude
/rushee:tdd-cycle FDD-001

# Terminal 2 — Flutter (same project root, different stream)
cd your-project && claude
/rushee:flutter-feature FDD-001
```

Both sessions work independently. Neither blocks the other. Both implement
from the same OpenAPI spec.

### Step 7 — Backend TDD (in Terminal 1)

```
[tdd-implementer writes OrderControllerTest @WebMvcTest — RED]
[implements minimal OrderController — GREEN]
[writes OrderApplicationServiceTest — RED → implements — GREEN]
[writes OrderRepositoryTest @DataJpaTest — RED → implements — GREEN]
[creates V1__create_orders_table.sql Flyway migration]
[runs CucumberIT]
> CucumberIT: Tests run: 4, Failures: 0 ✅ ALL GREEN
> "Backend stream complete. Run /rushee:status when Flutter stream is also done."
```

### Step 8 — Flutter Implementation (in Terminal 2)

```
[flutter-implementer regenerates Dart client from spec]
[creates Order entity (Dart, Equatable)]
[writes PlaceOrderUseCase + unit test (mocktail) — RED → implements — GREEN]
[writes OrderBloc + bloc_test — RED → implements — GREEN]
[writes CartReviewScreen widget tests — RED → implements — GREEN]
[writes integration test against real backend (or WireMock)]
[runs flutter-reviewer]
> Gate F1 ✅  F2 ✅  F3 ✅  F4 ✅  F5 ✅
> FLUTTER REVIEW: APPROVED
> "Flutter stream complete."
```

### Step 9 — Security Check

```
/rushee:security-check FDD-001

BACKEND:
> ✅ @Valid on @RequestBody
> ✅ @PreAuthorize on endpoint
> ✅ No hardcoded secrets
> ✅ OWASP A01-A10: all pass

FLUTTER:
> ✅ JWT stored in flutter_secure_storage (not SharedPreferences)
> ✅ Certificate pinning configured
> ✅ No PII in logs
> ✅ Payment screen: screenshotPrevent = true
> VERDICT: APPROVED
```

### Step 10 — Final Review

```
/rushee:status

BACKEND — spring-reviewer (8 gates):
> Gate 1 DDD & Architecture    ✅
> Gate 2 SOLID Principles      ✅
> Gate 3 Spring Patterns       ✅
> Gate 4 Test Quality          ✅  (89% coverage)
> Gate 5 BDD/ATDD Quality      ✅
> Gate 6 Security              ✅  (APPROVED)
> Gate 7 Ops Readiness         ✅
> Gate 8 Database Migrations   ✅
> BACKEND: ✅ APPROVED

FLUTTER — flutter-reviewer (5 gates):
> Gate F1 Architecture Purity  ✅
> Gate F2 State Management     ✅
> Gate F3 Contract Compliance  ✅
> Gate F4 Test Coverage        ✅  (78% coverage)
> Gate F5 Mobile Security      ✅
> FLUTTER: ✅ APPROVED

OVERALL: ✅ APPROVED — Ready to merge FDD-001
```

---

## 10. Non-Negotiable Rules

### UX Rules
1. **No Feature Card before user journey is mapped** — screens in the Feature Card must exist in the Screen Inventory.
2. **No Figma design before wireframe spec** — text spec reviewed by a non-developer before Figma opens.
3. **UX discovery drives domain design** — domain events come from job stories, not database tables.

### Architecture Rules (Backend)
4. **No `@Entity` on domain model classes — ever.** JPA entities live in `infrastructure/persistence/`. *(Hook: BLOCKS)*
5. **No Spring annotations in `domain/` packages — ever.** *(Hook: BLOCKS)*
6. **No public setters on Aggregate Roots or Entities.** State changes through behaviour methods only.
7. **Dependencies only flow inward** — domain has no knowledge of application, infrastructure, or Flutter.

### Architecture Rules (Flutter)
8. **No API calls in widgets or BLoC — ever.** Only in `RemoteDataSource`.
9. **No Flutter imports in `domain/` Dart files — ever.** Pure Dart only.
10. **No `setState()` in screens that use BLoC.** All state in BLoC.
11. **No hardcoded `Color(0xFF...)`, font sizes, or spacing values.** Always use AppColors, AppTypography, AppSpacing tokens.

### Contract Rules
12. **No hand-written DTOs on either side.** Both codebases generate from the OpenAPI spec. *(Hook: WARNS on spec change)*
13. **No controller code before OpenAPI spec is saved.**
14. **No Flutter `RemoteDataSource` before OpenAPI spec is saved.**
15. **Breaking API change = new API version (`/v2/`)** + deprecation period on `/v1/`.

### Process Rules
16. **No production code before a Feature Card.** *(Hook: WARNS)*
17. **No implementation before acceptance tests are RED.**
18. **No technical language in Gherkin** — no HTTP, no URLs, no class names, no SQL.

### Security Rules
19. **No hardcoded secrets anywhere.** *(Hook: BLOCKS on `.java`, `.yml`, `.dart`)*
20. **JWT and tokens: `flutter_secure_storage` only** — never `SharedPreferences`.
21. **No merge without `security-reviewer` APPROVED.**

### Quality Rules
22. **No merge without `ops-reviewer` PRODUCTION READY.**
23. **Backend coverage ≥ 80% (JaCoCo).** Flutter domain + application ≥ 75%.
24. **`ddl-auto: validate`** in all non-local Spring profiles.
25. **Flyway migration required** for every `@Entity` change. *(Hook: REMINDS)*

---

## 11. Backend Project Structure

```
backend/src/
├── main/
│   ├── java/com/yourcompany/yourapp/
│   │   └── <context>/              ← one folder per bounded context
│   │       ├── domain/             ← PURE JAVA — zero framework imports
│   │       │   ├── model/
│   │       │   │   ├── Order.java              ← Aggregate Root
│   │       │   │   ├── OrderLine.java          ← Child Entity
│   │       │   │   ├── OrderId.java            ← Value Object (record)
│   │       │   │   ├── Money.java              ← Value Object (record)
│   │       │   │   └── OrderStatus.java        ← Enum
│   │       │   ├── event/
│   │       │   │   ├── OrderPlaced.java        ← Domain Event (record)
│   │       │   │   └── OrderCancelled.java
│   │       │   ├── exception/
│   │       │   │   └── OrderDomainException.java
│   │       │   └── port/
│   │       │       ├── in/PlaceOrderUseCase.java    ← Input port
│   │       │       └── out/OrderRepository.java     ← Output port (interface)
│   │       ├── application/        ← Use case orchestration
│   │       │   ├── OrderApplicationService.java
│   │       │   ├── command/PlaceOrderCommand.java   ← Input (record)
│   │       │   └── dto/OrderDto.java               ← Output (record)
│   │       └── infrastructure/     ← ALL framework code here
│   │           ├── web/
│   │           │   └── OrderController.java         ← @RestController
│   │           ├── persistence/
│   │           │   ├── JpaOrderRepository.java      ← implements OrderRepository
│   │           │   ├── OrderJpaEntity.java          ← @Entity (NOT domain)
│   │           │   └── mapper/OrderPersistenceMapper.java
│   │           ├── messaging/
│   │           │   └── OrderEventPublisher.java
│   │           └── config/OrderModuleConfig.java
│   └── resources/
│       ├── api/
│       │   └── order-api.yaml      ← OpenAPI 3.1 spec (source of truth)
│       ├── db/migration/
│       │   ├── V1__create_orders_table.sql
│       │   └── V2__create_order_lines_table.sql
│       └── application.yml
└── test/
    └── java/com/yourcompany/yourapp/<context>/
        ├── steps/PlaceOrderSteps.java      ← Cucumber steps
        ├── web/OrderControllerTest.java    ← @WebMvcTest
        ├── application/OrderServiceTest.java ← JUnit + Mockito
        └── persistence/OrderRepoTest.java  ← @DataJpaTest
```

---

## 12. Flutter Project Structure

```
mobile/lib/
├── core/                               ← Cross-cutting concerns
│   ├── error/
│   │   ├── failures.dart               ← Sealed class hierarchy
│   │   └── exceptions.dart
│   ├── network/
│   │   ├── api_client.dart             ← Dio + interceptors + cert pinning
│   │   └── api_constants.dart          ← Base URLs (from environment config)
│   ├── theme/
│   │   ├── app_theme.dart              ← ThemeData built from tokens
│   │   ├── app_colors.dart             ← ColorScheme (from Figma — NOT hardcoded)
│   │   ├── app_typography.dart         ← TextTheme (from Figma)
│   │   ├── app_spacing.dart            ← Spacing constants (from Figma)
│   │   └── app_radius.dart             ← Border radius constants
│   ├── router/
│   │   └── app_router.dart             ← go_router configuration
│   └── di/
│       └── injection_container.dart    ← GetIt service locator
│
└── features/
    └── order/                          ← ONE folder per bounded context
        ├── domain/                     ← PURE DART — zero Flutter imports
        │   ├── entities/
        │   │   └── order.dart          ← Equatable, immutable
        │   ├── repositories/
        │   │   └── order_repository.dart  ← abstract class
        │   └── usecases/
        │       ├── place_order_usecase.dart
        │       └── get_order_usecase.dart
        ├── data/                       ← Implementation — Dio, Hive, etc.
        │   ├── datasources/
        │   │   ├── order_remote_datasource.dart  ← uses generated API client
        │   │   └── order_local_datasource.dart   ← Hive offline cache
        │   ├── models/                           ← generated from OpenAPI spec
        │   │   └── [auto-generated by openapi-generator]
        │   └── repositories/
        │       └── order_repository_impl.dart    ← implements domain interface
        └── presentation/
            ├── bloc/
            │   ├── order_bloc.dart
            │   ├── order_event.dart    ← sealed class
            │   └── order_state.dart    ← sealed class
            ├── screens/
            │   ├── cart_review_screen.dart   ← S13
            │   ├── checkout_screen.dart      ← S14
            │   └── order_confirm_screen.dart ← S15
            └── widgets/
                ├── order_summary_card.dart   ← named to match Figma component
                └── cart_line_item.dart

test/
├── features/
│   └── order/
│       ├── domain/
│       │   └── usecases/place_order_usecase_test.dart  ← pure Dart, mocktail
│       ├── presentation/
│       │   ├── bloc/order_bloc_test.dart               ← bloc_test
│       │   └── screens/cart_review_screen_test.dart    ← widget test
│       └── contract/
│           └── order_api_contract_test.dart            ← validates JSON shapes
└── golden/                                             ← pixel regression
    └── cart_review_screen.png
```

---

## 13. The OpenAPI Contract Bridge

The OpenAPI spec at `backend/src/main/resources/api/<context>-api.yaml` is
**the single most important file in the entire project**. It is the contract
between the backend team and the Flutter team. Neither side owns it unilaterally.

### How it generates both codebases

```
order-api.yaml
     │
     ├── Spring Boot (openapi-generator-maven-plugin)
     │   └── generates OrdersApi interface
     │       └── OrderController implements OrdersApi
     │           └── if spec changes → compile error → forced fix
     │
     └── Flutter (openapi-generator dart-dio)
         └── generates OrderModel + OrdersApiClient
             └── OrderRemoteDataSource uses OrdersApiClient
                 └── if spec changes → regenerate → type errors → forced fix
```

### The Two Types of API Change

**Non-breaking (backward compatible):**
```yaml
# Adding a NEW optional field — safe
OrderResponse:
  properties:
    orderId:          { type: string }
    status:           { type: string }
    estimatedDelivery: { type: string, format: date }  ← NEW optional field
```
Action: Add to spec → regenerate both clients → add to any existing Flutter
model tests → deploy backend → Flutter works with and without the new field.

**Breaking (requires versioning):**
```yaml
# Removing or renaming a field — BREAKING
# Old: orderId  →  New: id   ← Flutter crashes if orderId disappears
```
Action: Add new `/api/v2/orders` endpoint with the new shape → keep `/api/v1/orders`
working → add `Sunset` header to v1 → update Flutter to v2 → deprecate v1 after
all clients are updated.

### The Contract Test

Write one contract test in Flutter that validates the JSON shape matches the spec:

```dart
// test/contract/order_api_contract_test.dart
void main() {
  group('Order API Contract', () {
    test('POST /api/v1/orders response matches OrderResponse schema', () async {
      final response = await orderApiClient.placeOrder(request);
      // If the spec changed and clients weren't regenerated, this throws
      expect(response.orderId, isNotNull);
      expect(response.status, isNotNull);
      expect(response.totalAmount, isNotNull);
    });
  });
}
```

---

## 14. Flutter Architecture

Flutter's clean architecture in Rushee is a direct mirror of Spring Boot's hexagonal architecture.

### Layer Mapping

| Spring Boot | Flutter | Rule |
|-------------|---------|------|
| `domain/model/Order.java` | `domain/entities/order.dart` | Pure language, no framework imports |
| `domain/port/out/OrderRepository.java` | `domain/repositories/order_repository.dart` | Abstract interface only |
| `application/OrderApplicationService.java` | `application/usecases/place_order_usecase.dart` | Calls domain, calls repo interface |
| `infrastructure/persistence/JpaOrderRepository.java` | `data/repositories/order_repository_impl.dart` | Implements domain interface |
| `infrastructure/web/OrderController.java` | `presentation/bloc/order_bloc.dart` | Receives user actions, emits states |
| (HTML/JSON response) | `presentation/screens/cart_review_screen.dart` | Renders BLoC states |

### BLoC Pattern

```dart
// The BLoC is the Flutter equivalent of both the Controller and the Application Service
// It receives Events (user actions) and emits States (UI states)

// ✅ Correct
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final PlaceOrderUseCase _placeOrderUseCase;   // injected use case

  OrderBloc(this._placeOrderUseCase) : super(OrderInitial()) {
    on<PlaceOrderRequested>(_onPlaceOrderRequested);
  }

  Future<void> _onPlaceOrderRequested(
    PlaceOrderRequested event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());                         // ← always emit Loading first
    final result = await _placeOrderUseCase(      // ← calls use case, not repo
      PlaceOrderParams(cartId: event.cartId),
    );
    result.fold(
      (failure) => emit(OrderError(failure.message)),  // ← always handle failure
      (order)   => emit(OrderPlaced(order)),            // ← success case
    );
  }
}

// ❌ Wrong — BLoC calling repository directly
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _repo;   // ← wrong: should use use case, not repo
```

### Error Handling — Either<Failure, T>

```dart
// domain/entities/failures.dart
sealed class Failure {
  final String message;
  const Failure(this.message);
}
class ServerFailure extends Failure { const ServerFailure(super.message); }
class NetworkFailure extends Failure { const NetworkFailure(super.message); }
class ValidationFailure extends Failure { const ValidationFailure(super.message); }

// Every use case returns Either<Failure, T> — never throws
class PlaceOrderUseCase {
  final OrderRepository _repo;
  PlaceOrderUseCase(this._repo);

  Future<Either<Failure, Order>> call(PlaceOrderParams params) async {
    try {
      return Right(await _repo.placeOrder(params));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return Left(NetworkFailure('Check your connection'));
    }
  }
}
```

---

## 15. UX Design Workflow

### The Right Order

```
1. Persona definition      (who uses the app)
         ↓
2. Job Story mapping        (what they're trying to do + WHY)
         ↓
3. Domain event extraction  (what happens in the system)  ← feeds event-storm
         ↓
4. Screen Inventory         (every screen named before Figma opens)
         ↓
5. Navigation map           (how screens connect → drives state management choice)
         ↓
6. Wireframe specs          (text description reviewed by non-developer)
         ↓
7. Figma design             (designer works from wireframe spec)
         ↓
8. Design token extraction  (colors, typography, spacing → AppColors, AppTypography)
         ↓
9. Feature Cards            (each card links to specific screen IDs)
```

### Design Token Extraction

Before writing a single Flutter widget, extract design tokens from the approved
Figma design into Dart constants:

```dart
// core/theme/app_colors.dart — names MATCH Figma layer names exactly
abstract class AppColors {
  static const Color primary500 = Color(0xFF1565C0);  // "Primary/500" in Figma
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB00020);
  static const Color onPrimary = Color(0xFFFFFFFF);
}

// core/theme/app_spacing.dart
abstract class AppSpacing {
  static const double xs = 4.0;   // "Spacing/XS" in Figma
  static const double s  = 8.0;
  static const double m  = 16.0;
  static const double l  = 24.0;
  static const double xl = 32.0;
}

// Usage in widgets — ALWAYS tokens, NEVER magic values
Padding(
  padding: EdgeInsets.all(AppSpacing.m),   // ✅
  // padding: EdgeInsets.all(16),          // ❌
  child: Text(
    'Place Order',
    style: Theme.of(context).textTheme.headlineMedium,  // ✅
    // style: TextStyle(fontSize: 24),                   // ❌
  ),
)
```

### Widget Naming Mirrors Figma Component Naming

```
Figma component: "OrderSummaryCard"  →  Flutter widget: OrderSummaryCard
Figma component: "PrimaryButton"     →  Flutter widget: AppPrimaryButton
Figma component: "CartLineItem"      →  Flutter widget: CartLineItemWidget
```

This is non-negotiable. When a designer says "the OrderSummaryCard is wrong",
every developer on the team knows exactly which file to open.

---

## 16. Debugging with Rushee

```
/rushee:debug "<what failed>"
```

### Backend Failure Categories

| # | Category | Symptoms |
|---|----------|---------|
| A | Spring wiring | `BeanCreationException`, `NoSuchBeanDefinitionException`, context fail |
| B | JPA / Transactions | `LazyInitializationException`, `TransactionRequiredException` |
| C | Wrong value | `AssertionError: expected X but was Y` |
| D | Null pointer | `NullPointerException` — missing mock, missing validation |
| E | Cucumber | `Undefined step`, `PendingException` |
| F | HTTP test | Wrong status in `@WebMvcTest`, unexpected 401/403 |
| G | Test isolation | Passes alone, fails in suite |

### Flutter Failure Categories

| # | Category | Symptoms |
|---|----------|---------|
| H | Provider / BLoC wiring | `ProviderNotFoundException`, BLoC not found in widget tree |
| I | Async state | Widget renders before Future completes, `pump()` not awaited |
| J | Widget rendering | Golden test mismatch, layout overflow, missing widget |
| K | Golden drift | Golden file out of date after design change |
| L | Integration timing | Integration test fails intermittently — timing/race condition |

---

## 17. Parallel Features

### Mode 1 — Backend + Flutter in parallel (most common)

Once the API contract is approved and backend acceptance tests are RED:

```bash
# Two Claude Code sessions, same project
# Terminal 1
/rushee:tdd-cycle FDD-001      # Spring Boot implementation

# Terminal 2 (separate window)
/rushee:flutter-feature FDD-001  # Flutter implementation
```

Both work independently from the same spec. No file conflicts.
Sync point: both streams done → run `./mvnw test` and `flutter test` → `/rushee:status`.

### Mode 2 — Multiple features in a sprint

```bash
git worktree add ../project-FDD-004 -b feature/FDD-004-discount-codes
git worktree add ../project-FDD-005 -b feature/FDD-005-order-history
git worktree add ../project-FDD-006 -b feature/FDD-006-notifications

# Three separate terminal windows, each with its own Claude Code session
```

---

## 18. Extending Rushee

```
/rushee:extend skill <name>
/rushee:extend command <name>
/rushee:extend agent <name>
```

### Good candidates for new skills

- Your design system's specific component library (`your-app-design-system`)
- A framework you use: Riverpod instead of BLoC, GetX, etc. (`flutter-riverpod-patterns`)
- Flutter offline-first with Hive (`flutter-offline-first`)
- Resilience patterns for API calls (`resilience-patterns`)
- Push notifications and deep links (`flutter-notifications`)
- A bug pattern that escaped review and cost you time

### Project-specific skills (not for upstream)

Organisation-specific skills belong in `.claude/skills/`:

```
your-project/
└── .claude/
    └── skills/
        ├── company-design-system/
        │   └── SKILL.md
        └── internal-auth-sdk/
            └── SKILL.md
```

Claude Code discovers these alongside Rushee's skills. Project skills take
precedence when names conflict.

---

## 19. Technology Stack

### Backend

| Concern | Technology | Version |
|---------|-----------|---------|
| Language | Java | 17+ |
| Framework | Spring Boot | 3.x |
| Build | Maven | 3.8+ |
| BDD | Cucumber-JVM | 7.x |
| Unit tests | JUnit 5 + Mockito | 5.x |
| API tests | REST-assured | 5.x |
| API spec | OpenAPI | 3.1 |
| Schema migration | Flyway | 9.x+ |
| Coverage | JaCoCo | 0.8.x |
| Architecture tests | ArchUnit | 1.x |
| Security | Spring Security + OAuth2 | Boot 3.x |
| Observability | Micrometer + OpenTelemetry | Latest |
| Messaging | Apache Kafka / RabbitMQ | Latest |

### Flutter Mobile

| Concern | Technology |
|---------|-----------|
| Language | Dart 3.0+ |
| Framework | Flutter 3.7+ |
| State management | BLoC / flutter_bloc |
| Dependency injection | get_it |
| HTTP client | Dio |
| API client generation | openapi-generator dart-dio |
| Routing | go_router |
| Secure storage | flutter_secure_storage |
| Local cache | Hive |
| Unit testing | flutter_test + mocktail |
| BLoC testing | bloc_test |
| Integration testing | integration_test |
| Error handling | fpdart (Either<Failure, T>) |
| Code generation | freezed + json_serializable |

### UX Design

| Concern | Technology |
|---------|-----------|
| Design | Figma |
| Design tokens → Flutter | Manual extraction → AppColors/AppTypography |
| Figma → Flutter (optional) | Builder.io Visual Copilot / Dualite |

---

## 20. FAQ

**Q: Do I have to use BLoC for Flutter state management? What about Riverpod?**
A: Rushee's `flutter-clean-architecture` skill uses BLoC as the default because it
has the most explicit separation between events, states, and business logic — making
it the most testable. Riverpod is equally valid. Run `/rushee:extend skill flutter-riverpod-patterns`
to add Riverpod-specific patterns. The architecture layers (domain/data/presentation)
are identical regardless of which state management library you choose.

**Q: Can I use FlutterFlow or auto-generate Flutter code from Figma?**
A: Yes, for the presentation layer. Tools like Builder.io Visual Copilot or Dualite
generate Flutter widget code from Figma designs. The generated code should go in
`presentation/screens/` and `presentation/widgets/`. The domain, application, and
data layers must still be hand-crafted — no code generator handles business logic
or the OpenAPI contract integration correctly. Use code generation for widgets,
not for architecture.

**Q: The guard-domain-purity hook blocked my file. What do I do?**
A: You added `@Entity`, `@Service`, or a Spring annotation to a class in `domain/`.
Domain classes are pure Java. Move the class to `infrastructure/persistence/` (for
JPA entities) or remove the annotation. Same applies in Flutter — if you added a
`dio` import to a `domain/` Dart file, move the data access to the `data/` layer.

**Q: Both the backend and Flutter need to change for a single feature. Is that normal?**
A: Yes — that's the point of a full-stack discipline. A Feature Card represents
a user-visible behaviour. User-visible behaviours require a screen (Flutter) and
data from an API (Spring Boot). Both streams implement from the same OpenAPI spec,
so the work is parallel and independent, not sequential and blocking.

**Q: What if the Figma design isn't ready when I want to start the Flutter feature?**
A: The flutter-implementer will stop at the design token check and report which
design tokens are missing. This is correct behaviour. The domain and application
Dart layers (entities, use cases) can be built without the Figma design because
they contain no UI. Only the presentation layer (widgets and screens) requires
approved design tokens. Use that time to build and test the domain + application
layers first.

**Q: Can I skip the UX Discovery for a small, internal tool?**
A: You can, but even for internal tools, mapping the Screen Inventory takes 30 minutes
and saves hours of "we forgot the empty state" or "where does the error message go"
decisions during development. At minimum, write a Screen Inventory before opening Figma.

**Q: Can I use Gradle instead of Maven on the backend?**
A: Replace `./mvnw` with `./gradlew` in the relevant skill files and `regenerate-clients.sh`.
The plugin logic is identical — Gradle support is on the roadmap for v3.

**Q: How do I handle offline support in Flutter?**
A: The `data/datasources/order_local_datasource.dart` layer is where Hive (or Isar)
caching lives. The `OrderRepositoryImpl` decides whether to call remote or local based
on connectivity. The domain and presentation layers are completely unaware of this —
they always call the same `OrderRepository` interface. Run
`/rushee:extend skill flutter-offline-first` to add a dedicated offline-first skill.

**Q: Where do I ask questions or report bugs?**
A: Open an issue at `github.com/<your-username>/rushee/issues`.

---

## Contributing

1. Fork `github.com/<your-username>/rushee`
2. Branch: `git checkout -b skill/your-new-skill`
3. Follow the `extending-rushee` skill guide
4. Test in a real Flutter + Spring Boot project
5. Submit a PR with the skill, updated `plugin.json`, and a `CHANGELOG.md` entry

Replace `<your-github-username>` in `.claude-plugin/plugin.json` and
`.claude-plugin/marketplace.json` before publishing.

MIT License.
