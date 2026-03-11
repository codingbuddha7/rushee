---
name: ddd-model-workshop
description: >
  Use this skill when a junior engineer needs to decide what type a concept is in DDD:
  entity, value object, aggregate, aggregate root, domain service, or domain event.
  Triggers on: "is this an entity or value object", "what is the aggregate root",
  "should this be an aggregate", "where does this business rule go",
  "how do I model this", "I don't know if this is an entity", "what type is X",
  or when domain-modeller agent is classifying concepts one by one.
version: 1.0.0
allowed-tools: [Read, Glob]
---

# DDD Model Workshop — Decision Trees for Juniors

This skill gives you a repeatable process for classifying any domain concept.
Run through the decision tree for each concept before writing any code.

---

## The Master Decision Tree

```
Is this a THING or an EVENT?
│
├── EVENT (something that happened, past tense)
│   └── → Domain Event  (e.g. OrderPlaced, PaymentFailed, UserRegistered)
│
└── THING (a noun in your domain)
    │
    Does this THING have an identity that matters over time?
    │
    ├── NO — it's defined purely by its values
    │   └── → Value Object  (e.g. Money, Address, Quantity, EmailAddress)
    │
    └── YES — you can track "this specific one" through changes
        │
        Is this THING the main entry point for a cluster of related things?
        │
        ├── NO — it belongs inside another thing
        │   └── → Entity (child of an aggregate)
        │
        └── YES — it owns and protects a group of related entities/VOs
            └── → Aggregate Root
                │
                Does it coordinate logic across multiple aggregates?
                └── That logic → Domain Service
```

---

## Decision Tree 1: Entity vs Value Object

Ask these three questions in order. Stop at the first YES.

**Q1: Does "the same X with different values" make sense?**
- "The same order with a different status" — YES → Entity
- "The same money with a different amount" — NO (that's a different money)
- "The same address with a different street" — NO (that's a different address)

**Q2: Do you need to track this X over time?**
- "I need to find this order next week" — YES → Entity
- "I just need to express this price right now" — NO → Value Object

**Q3: Is this X defined entirely by its attributes?**
- Two addresses with the same street/city/zip → they ARE the same address — Value Object
- Two orders with the same items → they are NOT the same order — Entity

**Results table:**

| Concept | Q1 | Q2 | Q3 | Type |
|---------|----|----|-----|------|
| Order | YES | YES | NO | Entity |
| Address | NO | NO | YES | Value Object |
| Money | NO | NO | YES | Value Object |
| Customer | YES | YES | NO | Entity |
| EmailAddress | NO | NO | YES | Value Object |
| Product | YES | YES | NO | Entity |
| Quantity | NO | NO | YES | Value Object |
| Invoice | YES | YES | NO | Entity |

**Common junior mistakes:**
- String id → should be `OrderId` Value Object (primitive obsession)
- Using `String` for `EmailAddress` → no validation, no type safety
- Making `Address` an Entity → but two identical addresses ARE the same address

---

## Decision Tree 2: Aggregate Boundaries

An aggregate is a cluster of entities and value objects that must always be
**consistent together**.

**Q1: Must X and Y always be consistent within a single transaction?**
- OrderLines must always belong to exactly one Order → same aggregate
- Customer and Order can be changed independently → separate aggregates

**Q2: Can X exist without Y?**
- OrderLine cannot exist without Order → OrderLine is inside the Order aggregate
- Customer can exist without any orders → separate aggregate

**Q3: Is the lifecycle of X tied to Y?**
- OrderLine is created when an order is created, deleted when order is deleted → same aggregate
- Product exists regardless of orders → separate aggregate

**Q4: Would putting X and Y in the same aggregate cause them to lock each other?**
- If Order and Customer were one aggregate, placing any order would lock the customer
  record → too broad

**The Small Aggregate Rule:**
When in doubt, make the aggregate smaller. You can always reference another aggregate
by its ID. It is far better to have two small aggregates that communicate via domain
events than one large aggregate that is hard to test and contended in production.

**Worked example — E-commerce:**

    Order aggregate:
      - Order (root)         ← entry point for all mutations
      - OrderLine (child)    ← cannot exist outside Order
      - OrderStatus (VO)     ← current state
      - Money totalAmount    ← derived VO

    Customer aggregate:       ← SEPARATE — independent lifecycle
      - Customer (root)
      - EmailAddress (VO)
      - PostalAddress (VO)

    Product aggregate:        ← SEPARATE — managed by catalogue team
      - Product (root)
      - Money price          ← VO
      - ProductId (VO)       ← Order references Product by ProductId only

---

## Decision Tree 3: Where Does a Business Rule Live?

**Rule**: Business rules belong in the innermost object that has all the data
needed to enforce them.

**Q1: Does the rule only need data from ONE entity?**
- "An order cannot be cancelled if it is already shipped"
  → needs only Order data → put it in `Order.cancel()`

**Q2: Does the rule need data from multiple entities across aggregate boundaries?**
- "Total order value must not exceed customer credit limit"
  → needs Order + Customer → this is a cross-aggregate rule

  Ask: **does a domain expert name this rule?** (e.g. "credit check", "eligibility")
  - YES, it is a named domain concept → **Domain Service** (lives in `domain/service/`,
    is an interface; implementation in `application/`)
  - NO, it is orchestration glue → **Application Service** (lives in `application/service/`)

  The distinction matters:
  - `CreditCheckService` (interface in domain) — a named domain rule involving two aggregates
  - `PlaceOrderUseCase` (application service) — orchestrates: load order, load customer,
    call CreditCheckService, call orderRepository.save()

**Q3: Does the rule involve reacting to something that happened in another aggregate?**
- "When an order is placed, reduce inventory"
  → prefer **Domain Events**: Order raises `OrderPlaced`, Inventory subscribes
  → avoids direct aggregate-to-aggregate calls, keeps aggregates decoupled

**Anti-patterns to avoid:**

```java
// WRONG — rule in service (anemic model)
orderService.cancel(orderId) {
    var order = repo.findById(orderId);
    if (order.getStatus().equals("SHIPPED")) throw ...  // reading internals
    order.setStatus("CANCELLED");                       // pushing state in from outside
}

// CORRECT — rule in entity
order.cancel() {
    if (this.status == SHIPPED) throw new OrderCannotBeCancelledException(id);
    this.status = CANCELLED;
    registerEvent(new OrderCancelled(id));
}
```

---

## Decision Tree 4: Should This Be a Domain Event?

**Q1: Did something significant just happen in the domain?**
- A user confirmed their order — YES → `OrderPlaced`
- A getter was called — NO (not a state change)

**Q2: Do other parts of the system need to react to this?**
- Inventory needs to know when an order is placed → YES → raise `OrderPlaced`
- A field was updated internally — maybe not

**Q3: Would a domain expert use past tense to describe this moment?**
- "The order was placed" → YES → `OrderPlaced`
- "The order is being processed" → NO (that's a state, not an event)

**Naming convention:** Always past tense.
`OrderPlaced`, `PaymentFailed`, `UserRegistered`, `InvoiceIssued`.

---

## Quick Reference Card

| Concept | Identity? | Mutable? | Equality | Java type |
|---------|-----------|----------|---------|-----------|
| Entity | YES | YES | by id field | `class` with `equals` on id |
| Value Object | NO | NO | by all fields | `record` |
| Aggregate Root | YES | YES | by id field | `class` — only externally accessible |
| Domain Event | NO | NO | by all fields | `record implements DomainEvent` |
| Domain Service | — | NO (stateless) | — | `interface` in domain, impl in application |

---

## Worked Example: Model the Booking Domain

**Concepts to classify:** Booking, Guest, Room, Money, DateRange, BookingStatus, RoomBooked

Walk through each:

| Concept | Decision | Reasoning |
|---------|----------|-----------|
| Booking | Entity → Aggregate Root | Has identity, entry point for booking mutations |
| Guest | Entity → Aggregate Root | Has identity, independent lifecycle, referenced by Booking via GuestId |
| Room | Entity → Aggregate Root | Has identity, managed by Room team, referenced by Booking via RoomId |
| Money | Value Object | Defined by amount + currency, no identity |
| DateRange | Value Object | Defined by start + end dates, no identity |
| BookingStatus | Value Object (enum) | No identity, immutable state label |
| RoomBooked | Domain Event | Something that happened, past tense, other contexts care |

**Result:**

    Booking aggregate (root: Booking):
      - Booking.confirm()       → raises RoomBooked
      - Booking.cancel()        → raises BookingCancelled
      - DateRange checkIn/Out   → Value Object
      - Money totalCost         → Value Object
      - GuestId                 → reference to Guest aggregate by ID
      - RoomId                  → reference to Room aggregate by ID
