# Domain Model — Order Context

Output of `/rushee:ddd-model order`

---

## Aggregate Root: Order

| Element | Type | Notes |
|---------|------|-------|
| `OrderId` | Value Object | UUID wrapper, generated on creation |
| `customerId` | Value Object | UUID wrapper |
| `lines` | List\<OrderLine\> | Child entities, min 1 |
| `status` | Enum | PENDING → CONFIRMED → SHIPPED → CANCELLED |
| `placedAt` | Instant | Set at creation, immutable |

**Behaviour methods** (state changes through methods only — no public setters):
- `Order.place(cart: Cart): Order` — creates from cart, validates non-empty, emits `OrderPlaced`
- `order.confirm()` — PENDING → CONFIRMED, emits `OrderConfirmed`
- `order.cancel(reason)` — PENDING/CONFIRMED → CANCELLED, emits `OrderCancelled`

**Invariant:** An Order must have at least one OrderLine. Total is calculated — never stored.

---

## Child Entity: OrderLine

| Element | Type | Notes |
|---------|------|-------|
| `product` | Value Object (ProductSnapshot) | Name + price at order time — not a live reference |
| `quantity` | Value Object (Quantity) | Positive integer, min 1 |
| `lineTotal()` | Money | Derived: quantity × unitPrice |

---

## Value Objects

| Name | Fields | Notes |
|------|--------|-------|
| `OrderId` | UUID | Immutable wrapper |
| `CustomerId` | UUID | Immutable wrapper |
| `Money` | amount (BigDecimal) + currency | Supports add, multiply |
| `Quantity` | positive integer | Validates > 0 on construction |
| `ProductSnapshot` | productId + name + price | Snapshot at time of order |

---

## Domain Events

| Event | Payload |
|-------|---------|
| `OrderPlaced` | orderId, customerId, lines, total, placedAt |
| `OrderConfirmed` | orderId, confirmedAt |
| `OrderCancelled` | orderId, reason, cancelledAt |

---

## Repository Interface (output port — pure Java, no framework imports)

```java
public interface OrderRepository {
    void save(Order order);
    Optional<Order> findById(OrderId id);
    List<Order> findByCustomerId(CustomerId customerId);
}
```

`OrderJpaEntity` lives in `infrastructure/persistence/` — never in `domain/`.
