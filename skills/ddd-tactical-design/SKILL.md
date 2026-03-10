---
name: ddd-tactical-design
description: >
  This skill should be used when designing the domain model for a bounded context:
  deciding what is an entity vs value object, designing aggregates, raising domain events,
  or implementing business rules. Triggers on: "domain model", "aggregate design",
  "entity or value object", "where does this business rule go", "domain event",
  "should this be a service or a method", "rich domain model", "anemic model warning",
  or after ddd-strategic-design completes for a Core Domain.
version: 1.0.0
allowed-tools: [Read, Write, Glob, Grep]
---

# Tactical DDD Skill

## Purpose
Model the domain precisely inside a bounded context using DDD building blocks.
The goal: business rules live IN the domain model, not in service classes.

## The Anemic Domain Model Anti-Pattern — THE #1 Enemy
```java
// WRONG — anemic model (getter/setter bag, all logic in service)
public class Order {
    private String id;
    private String status;
    private List<OrderItem> items;
    // getters and setters only — no behaviour
}

// WRONG — god service holding all logic
public class OrderService {
    public void cancelOrder(Order order) {
        if (order.getStatus().equals("SHIPPED")) {
            throw new Exception("Can't cancel");
        }
        order.setStatus("CANCELLED"); // reaching into domain and changing state
    }
}
```

```java
// CORRECT — rich domain model
public class Order {
    private OrderId id;
    private OrderStatus status;
    private List<OrderLine> lines;

    public void cancel() {
        if (this.status == OrderStatus.SHIPPED) {
            throw new OrderCannotBeCancelledException(this.id);
        }
        this.status = OrderStatus.CANCELLED;
        registerEvent(new OrderCancelled(this.id));
    }
    // Business rule lives HERE, not in a service
}
```

---

## Building Block 1 — Entity

An object with a **unique identity** that persists through state changes.

```java
public class Order {                              // Entity
    private final OrderId id;                     // Identity (Value Object)
    private OrderStatus status;                   // Mutable state
    private final CustomerId customerId;          // Reference to another Aggregate by ID
    private final List<OrderLine> lines;          // Child entities/VOs

    // Identity equality — NOT field equality
    @Override
    public boolean equals(Object o) {
        if (!(o instanceof Order other)) return false;
        return this.id.equals(other.id);
    }

    // Behaviour methods — not setters
    public void addLine(ProductId productId, Quantity quantity, Money unitPrice) {
        // Enforce invariant: no duplicate products
        lines.stream()
            .filter(l -> l.productId().equals(productId))
            .findFirst()
            .ifPresent(l -> { throw new DuplicateOrderLineException(productId); });
        lines.add(new OrderLine(productId, quantity, unitPrice));
    }
}
```

**When to use Entity**: the concept has an identity that matters across time.
Order, Customer, Product, Invoice are entities. A price, a quantity, an address are not.

---

## Building Block 2 — Value Object

An object defined by its **attributes**, has no identity, is **immutable**.

```java
public record Money(BigDecimal amount, Currency currency) {

    // Validation in canonical constructor
    public Money {
        Objects.requireNonNull(amount, "Amount required");
        Objects.requireNonNull(currency, "Currency required");
        if (amount.compareTo(BigDecimal.ZERO) < 0)
            throw new NegativeMoneyException(amount);
    }

    // Behaviour — returns NEW value object (immutable)
    public Money add(Money other) {
        if (!this.currency.equals(other.currency))
            throw new CurrencyMismatchException(this.currency, other.currency);
        return new Money(this.amount.add(other.amount), this.currency);
    }

    public Money multiply(int factor) {
        return new Money(this.amount.multiply(BigDecimal.valueOf(factor)), this.currency);
    }
}

// Other common Value Objects:
public record OrderId(UUID value) { }
public record EmailAddress(String value) {
    public EmailAddress {
        if (!value.matches("^[^@]+@[^@]+\\.[^@]+$"))
            throw new InvalidEmailException(value);
    }
}
public record Quantity(int value) {
    public Quantity { if (value <= 0) throw new NonPositiveQuantityException(value); }
}
```

**When to use Value Object**: equality is by value, not identity. Address, Money, Quantity,
DateRange, EmailAddress, PhoneNumber, Percentage, Weight are all Value Objects.

**Rule**: If you're using a primitive (String, int, BigDecimal) for a domain concept — make it a Value Object.

---

## Building Block 3 — Aggregate

A **cluster of entities and value objects** treated as a single unit for data changes.
One entity is the **Aggregate Root** — the only entry point for external access.

### Aggregate Design Rules
1. **Reference other aggregates by ID only** — never hold a direct object reference
2. **Enforce all invariants within one transaction** — if you need two aggregates in one transaction, your boundaries are wrong
3. **Design aggregates small** — resist the urge to add "related" entities
4. **Only the root has a repository**

```java
// Aggregate Root
public class Order {                              // Aggregate Root
    private OrderId id;
    private CustomerId customerId;                // Reference by ID, not object
    private List<OrderLine> lines;                // Child entity (part of aggregate)
    private OrderStatus status;
    private final List<DomainEvent> events = new ArrayList<>();

    // All mutations go through the root
    public void place() {
        if (lines.isEmpty()) throw new EmptyOrderException(id);
        this.status = OrderStatus.PLACED;
        registerEvent(new OrderPlaced(id, customerId, lines));
    }

    protected void registerEvent(DomainEvent event) {
        this.events.add(event);
    }

    public List<DomainEvent> pullEvents() {
        var pending = List.copyOf(events);
        events.clear();
        return pending;
    }
}

// Child entity — only accessible through Order
public class OrderLine {                          // Child Entity (not a root)
    private OrderLineId id;
    private ProductId productId;                  // Reference by ID
    private Quantity quantity;
    private Money unitPrice;

    public Money lineTotal() {
        return unitPrice.multiply(quantity.value());
    }
}
```

---

## Building Block 4 — Domain Event

Something significant that **happened** in the domain. Past tense. Immutable.

```java
// Domain event — something that happened
public record OrderPlaced(
    OrderId orderId,
    CustomerId customerId,
    List<OrderLine> lines,
    Instant occurredOn
) implements DomainEvent {
    public OrderPlaced(OrderId orderId, CustomerId customerId, List<OrderLine> lines) {
        this(orderId, customerId, lines, Instant.now());
    }
}

// Base interface
public interface DomainEvent {
    Instant occurredOn();
}
```

**When to raise a domain event**: when something happens that other parts of the system (or other bounded contexts) need to know about.

**Domain Event vs Integration Event**:
- Domain Event: raised within an aggregate, published within the bounded context via Spring ApplicationEventPublisher
- Integration Event: published to a message broker (Kafka/RabbitMQ) for cross-context communication

---

## Building Block 5 — Domain Service

A **stateless operation** that doesn't naturally belong to any entity or value object.

```java
// Domain service — stateless, operates on domain objects
public interface ShippingCostCalculator {
    Money calculate(List<OrderLine> lines, Address destination);
}

// Wrong: putting this in Order (Order shouldn't know about shipping rates)
// Wrong: putting this in OrderService (that's an application service)
// Right: separate domain service
```

Use a Domain Service when: the operation involves multiple aggregates, or represents a domain concept that is inherently stateless (calculation, validation, transformation).

---

## Building Block 6 — Repository

A **collection abstraction** for persisting and retrieving aggregates.

```java
// Repository interface — in the domain layer (no Spring imports)
public interface OrderRepository {
    void save(Order order);
    Optional<Order> findById(OrderId id);
    List<Order> findByCustomerId(CustomerId customerId);
    void delete(OrderId id);
}

// Implementation — in infrastructure layer (Spring Data)
@Repository
public class JpaOrderRepository implements OrderRepository {
    private final SpringDataOrderRepository springRepo;
    private final OrderMapper mapper;

    @Override
    public void save(Order order) {
        var jpaEntity = mapper.toJpa(order);
        springRepo.save(jpaEntity);
        // Publish domain events after save
        order.pullEvents().forEach(applicationEventPublisher::publishEvent);
    }
}
```

**Rule**: The repository interface lives in the domain layer. The implementation lives in infrastructure.
The domain never imports Spring Data or JPA directly.

---

## Domain Model Quality Checklist
Before approving any domain class:
- [ ] Entities have identity-based equals/hashCode
- [ ] Value Objects are immutable records with validation
- [ ] No public setters on entities — all state changes via behaviour methods
- [ ] Business rules are in domain objects, not service classes
- [ ] Domain events raised for significant state changes
- [ ] No Spring annotations in domain layer classes
- [ ] Repository interface in domain layer, implementation in infrastructure
- [ ] Aggregates reference other aggregates by ID, not object reference
- [ ] Aggregate invariants enforced in the root
