---
name: ddd-ubiquitous-language
description: >
  This skill should be used when naming anything in a bounded context: classes, methods,
  variables, REST endpoints, events, database tables, Gherkin steps. Triggers on:
  "what should I call this", "naming", "glossary", "ubiquitous language", "domain terms",
  "the business calls it X but the code says Y", or any detected naming inconsistency
  between business language and code. Also fires when Gherkin scenarios contain
  technical terms not in the domain glossary.
version: 1.0.0
allowed-tools: [Read, Write, Glob, Grep]
---

# Ubiquitous Language Skill

## Purpose
Ensure that every term used in code, tests, Gherkin, APIs, and documentation
means exactly one thing — and that it is the same term the business uses.
The ubiquitous language is the single source of truth for naming in a bounded context.

## The Core Rule
**If the business calls it an "Order", the code calls it `Order`. Not `Transaction`. Not `Request`. Not `PurchaseRecord`.**

When the same concept has different names in code vs business: the code is wrong.
When the same word means different things in two bounded contexts: that is correct — document it explicitly.

---

## Step 1 — Discover the Language

Ask the developer:
1. "What do domain experts (business analysts, product owners) call this concept?"
2. "Is there a glossary, data dictionary, or requirements doc I should read?"
3. "Are there any terms that mean different things to different teams?"

Scan existing code for naming drift:
```bash
# Find technical terms masquerading as domain terms
grep -r "Manager\|Handler\|Processor\|Helper\|Util\|Data\|Info\|DTO" src/main/java --include="*.java" -l
```

Each of those suffixes is a red flag — they suggest technical thinking, not domain thinking.

---

## Step 2 — Build the Glossary

Maintain `docs/ubiquitous-language/<context-name>.md` for each bounded context:

```markdown
# Ubiquitous Language — <Bounded Context Name>
Last updated: <date>
Owner: <team>

## Core Terms

### Order
**Definition**: A confirmed customer intent to purchase one or more products.
**Lifecycle**: Draft → Placed → Confirmed → Fulfilled → Shipped → Delivered | Cancelled
**NOT**: Transaction, Purchase, Request, Cart (Cart becomes an Order when placed)
**In code**: `Order` entity, `OrderRepository`, `PlaceOrderCommand`
**In Gherkin**: "the customer places an order", "the order is confirmed"
**Different in**: Warehouse context (called "Fulfilment Job"), Finance context (called "Invoice")

### Customer
**Definition**: A registered account holder who has placed at least one order.
**NOT**: User (User is pre-registration), Account, Client
**In code**: `Customer` entity, `CustomerId` value object
**Different in**: Marketing context (called "Prospect" before first order)

### ...
```

---

## Step 3 — Enforce in Code

### Naming Rules
| Code Artifact | Naming Rule | Example |
|--------------|-------------|---------|
| Entity | Exact domain noun | `Order`, `Customer`, `Product` |
| Value Object | Domain concept, often compound | `Money`, `OrderId`, `EmailAddress` |
| Aggregate Root | Same as primary Entity | `Order` (not `OrderAggregate`) |
| Repository | `<Entity>Repository` | `OrderRepository` |
| Domain Service | Verb phrase if stateless operation | `PricingService`, `ShippingCalculator` |
| Command | Imperative verb + noun | `PlaceOrderCommand`, `CancelOrderCommand` |
| Domain Event | Past tense | `OrderPlaced`, `PaymentFailed` |
| Application Service | `<Context>Service` or use case name | `OrderApplicationService` |
| REST Controller | `<Entity>Controller` | `OrderController` |

### Anti-Patterns — Rename These on Sight
| Bad name | Problem | Better name |
|----------|---------|-------------|
| `OrderManager` | "Manager" is meaningless — manages what? | `OrderService` or split by behaviour |
| `OrderDTO` | DTO is technical, not domain | `PlaceOrderRequest`, `OrderSummary` |
| `OrderData` | "Data" adds nothing | `Order` or `OrderDetails` |
| `processOrder()` | "Process" is vague | `placeOrder()`, `confirmOrder()`, `fulfillOrder()` |
| `getOrder()` in service | "get" is CRUD thinking | `findOrder()`, `lookUpOrder()` |
| `isValid()` on entity | Reveals nothing about *what* is valid | `isReadyToShip()`, `canBeCancelled()` |

---

## Step 4 — Gherkin Language Check

Before any Gherkin scenario is accepted, verify every term against the glossary:
- Every noun in a Gherkin step must be in the glossary
- Every verb must reflect a real domain action (not CRUD: no "create", "update", "delete")
- Technical terms → domain terms: "POST /api/orders" → "places an order"

---

## Step 5 — Drift Detection (run periodically)

```bash
# Find code names not in the glossary
grep -r "class \|interface \|enum " src/main/java --include="*.java" | \
  grep -v "test\|Test" | \
  awk '{print $2}' | sort -u > /tmp/code-names.txt

echo "Review these against docs/ubiquitous-language/<context>.md for drift"
cat /tmp/code-names.txt
```

When drift is found: update the glossary OR rename the code. Never leave them out of sync.
