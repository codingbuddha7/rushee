---
name: ddd-strategic-design
description: >
  This skill should be used at the very start of any new project, module, microservice,
  or major feature area. Triggers on: "new project", "new microservice", "new module",
  "how should I structure this", "what bounded context", "domain design", "event storming",
  "where does this feature belong", or any discussion about system decomposition.
  ALWAYS fires before fdd-feature-design when the domain structure is unclear.
version: 1.0.0
allowed-tools: [Read, Write, Glob]
---

# Strategic DDD Skill

## Purpose
Establish the domain landscape BEFORE any feature work begins.
Strategic DDD answers: What are we building? Where does it live? How does it relate to everything else?

## Mandatory Gate
**No Feature Cards until bounded contexts are mapped.**
If a developer jumps straight to features without a context map, invoke this skill first.

---

## Phase 1 — Event Storming (Lightweight)

Run a lightweight Event Storming session by asking the developer these questions.
Work through them conversationally — do not dump them all at once.

### Step 1: Discover Domain Events
Ask: "Walk me through what happens in your system from a business perspective.
What are the key things that *happen*? (e.g. 'Order placed', 'Payment confirmed', 'User registered')"

Write every event in past tense on a timeline. Format:
```
TIMELINE OF DOMAIN EVENTS
─────────────────────────────────────────────────────────
[OrderPlaced] → [PaymentProcessed] → [OrderFulfilled] → [OrderShipped]
                                   ↘ [PaymentFailed]   → [OrderCancelled]
```

### Step 2: Find Commands (what triggers events)
Ask: "For each event, what user action or system command caused it?"

```
Command           → Event
PlaceOrder        → OrderPlaced
ProcessPayment    → PaymentProcessed / PaymentFailed
FulfilOrder       → OrderFulfilled
ShipOrder         → OrderShipped
```

### Step 3: Group into Aggregates
Ask: "Which events naturally cluster together? Which share the same 'thing' changing state?"

### Step 4: Draw Bounded Context Boundaries
Group aggregates + their commands/events into bounded contexts.
Ask: "Does the word 'Order' mean the same thing to your sales team as to your warehouse team?"
Different meanings = different bounded contexts.

---

## Phase 2 — Subdomain Classification

For each bounded context, classify it:

| Type | Definition | Investment Level |
|------|-----------|-----------------|
| **Core Domain** | Your competitive advantage — what makes you unique | Maximum: DDD, ATDD, full discipline |
| **Supporting Subdomain** | Necessary but not competitive | Moderate: clean code, tested |
| **Generic Subdomain** | Commodity functionality | Minimal: buy or use open source |

Example:
```
E-Commerce Platform
├── Order Management    → CORE DOMAIN (competitive differentiator)
├── Inventory           → SUPPORTING (necessary, but not unique)
├── Email Notifications → GENERIC (use SendGrid, don't build)
└── Authentication      → GENERIC (use Keycloak/Auth0, don't build)
```

**Rushee only applies full discipline (FDD→BDD→ATDD→TDD) to Core and Supporting subdomains.**

---

## Phase 3 — Context Mapping

Define how bounded contexts relate. Save to `docs/architecture/context-map.md`.

```
CONTEXT MAP
═══════════════════════════════════════════════════════════

[Order Context] ──────Customer/Supplier──────► [Inventory Context]
     │                                                │
     │ Published Language (REST API)                  │
     ▼                                                │
[Payment Context] ◄──────ACL──────────────────────────┘
     │
     │ Event (OrderPaid)
     ▼
[Notification Context]  (Generic — use 3rd party)
```

### Context Mapping Relationships
| Pattern | When to use |
|---------|------------|
| **Partnership** | Two contexts evolve together, teams coordinate closely |
| **Customer/Supplier** | Upstream supplies API, downstream consumes it |
| **Conformist** | Downstream conforms entirely to upstream model (no power to change it) |
| **Anti-Corruption Layer (ACL)** | Downstream translates upstream model to protect its own domain |
| **Open Host Service** | Upstream publishes a formal protocol for all consumers |
| **Published Language** | Shared formal model (e.g. OpenAPI schema, Protobuf) |
| **Shared Kernel** | Two contexts share a small subset of model (use sparingly) |
| **Separate Ways** | No integration — contexts are completely independent |

---

## Phase 4 — Output Artifacts

### `docs/architecture/context-map.md`
```markdown
# Context Map — <System Name>
Generated: <date>

## Bounded Contexts
| Context | Type | Team | Description |
|---------|------|------|-------------|
| Order Management | Core Domain | Order Team | ... |

## Relationships
| Upstream | Downstream | Pattern | Interface |
|----------|-----------|---------|-----------|
| Order | Payment | Customer/Supplier | REST API |

## Event Flows
<timeline diagram>

## Out of Scope (Generic — use 3rd party)
- Authentication: Keycloak
- Email: SendGrid
- SMS: Twilio
```

### `docs/architecture/subdomains.md`
```markdown
# Subdomain Registry
| Subdomain | Type | Bounded Context | Discipline Level |
|-----------|------|----------------|-----------------|
| ...       | ...  | ...             | Full / Moderate / Buy |
```

---

## Anti-Patterns to Reject

| What developer does | Problem | Correct approach |
|---------------------|---------|-----------------|
| One giant `Order` class shared across all contexts | Semantic coupling | Separate Order in each context |
| `OrderService` with 20 methods | God service, no boundaries | Split by aggregate |
| Calling another context's repository directly | Context coupling | Use published events or APIs |
| Building authentication from scratch | Generic subdomain | Use Keycloak/Spring Security OAuth2 |

---

## Hand Off
After context map is agreed:
- For each Core/Supporting context: proceed to `ddd-ubiquitous-language` skill
- For Generic contexts: document the 3rd party tool choice, no further DDD needed
