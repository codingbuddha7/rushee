---
name: event-driven-architecture
description: >
  This skill should be used when designing communication between bounded contexts,
  deciding between synchronous and asynchronous, implementing domain events, or
  working with Kafka/RabbitMQ. Triggers on: "domain event", "integration event",
  "Kafka", "RabbitMQ", "event publishing", "event listener", "eventual consistency",
  "Saga", "Outbox pattern", "cross-context communication", "async messaging",
  or "how should these two services communicate".
version: 1.0.0
allowed-tools: [Read, Write, Glob, Grep]
---

# Event-Driven Architecture Skill

## Event Taxonomy — Know Which Type You Have

```
Domain Event                    Integration Event
─────────────────               ──────────────────────────────
Within one bounded context      Crosses bounded context boundaries
Published via ApplicationEvent  Published via Kafka / RabbitMQ
Synchronous (same transaction)  Asynchronous (different transaction)
Fine-grained                    Coarser-grained
e.g. OrderPlaced (internal)     e.g. OrderConfirmed (for Inventory, Notifications)
```

**Getting this wrong is the #1 EDA mistake.** Publishing every internal domain event
to Kafka creates enormous coupling. Only publish integration events.

---

## Pattern 1 — Domain Events (Intra-Context)

Raised inside aggregates, published via Spring's `ApplicationEventPublisher`.
Consumed by other components in the same bounded context.

```java
// 1. Domain Event (in domain/event/) — pure record
public record OrderPlaced(OrderId orderId, CustomerId customerId, Instant occurredOn)
    implements DomainEvent {}

// 2. Aggregate raises the event
public class Order {
    private final List<DomainEvent> events = new ArrayList<>();

    public void place() {
        if (lines.isEmpty()) throw new EmptyOrderException(id);
        this.status = OrderStatus.PLACED;
        events.add(new OrderPlaced(id, customerId, Instant.now()));
    }

    public List<DomainEvent> pullEvents() {
        var pending = List.copyOf(events);
        events.clear();
        return pending;
    }
}

// 3. Repository publishes after save (infrastructure layer)
@Repository
public class JpaOrderRepository implements OrderRepository {
    private final ApplicationEventPublisher eventPublisher;

    @Override
    @Transactional
    public void save(Order order) {
        springRepo.save(mapper.toJpa(order));
        order.pullEvents().forEach(eventPublisher::publishEvent); // publish AFTER save
    }
}

// 4. Listener in same context (application layer)
@Component
public class OrderPlacedHandler {
    @EventListener
    @Async
    public void on(OrderPlaced event) {
        // e.g. send confirmation email within this context
    }
}
```

---

## Pattern 2 — Integration Events (Inter-Context via Kafka)

```java
// Integration Event — in infrastructure/messaging/event/
// Deliberately different from domain event — controls what we expose
public record OrderConfirmedIntegrationEvent(
    String orderId,           // String, not OrderId value object — don't leak domain types
    String customerId,
    BigDecimal totalAmount,
    String currency,
    Instant confirmedAt
) {}

// Publisher (infrastructure layer)
@Component
@RequiredArgsConstructor
public class OrderEventPublisher {
    private final KafkaTemplate<String, Object> kafka;

    @EventListener
    public void on(OrderPlaced domainEvent) {
        // Translate domain event → integration event (Anti-Corruption at the boundary)
        var integrationEvent = new OrderConfirmedIntegrationEvent(
            domainEvent.orderId().value().toString(),
            domainEvent.customerId().value(),
            // ... map fields
        );
        kafka.send("order.events", domainEvent.orderId().toString(), integrationEvent);
    }
}

// Consumer in another bounded context
@Component
@RequiredArgsConstructor
public class OrderEventListener {
    private final InventoryApplicationService inventoryService;

    @KafkaListener(topics = "order.events", groupId = "inventory-service")
    public void onOrderConfirmed(OrderConfirmedIntegrationEvent event) {
        inventoryService.reserveStock(event.orderId(), event.items());
    }
}
```

---

## Pattern 3 — Outbox Pattern (Guaranteed Delivery)

Problem: what if the service crashes between saving the order and publishing to Kafka?
Solution: save the event to the database in the same transaction, publish from there.

```java
// Outbox table
@Entity
@Table(name = "outbox_events")
public class OutboxEvent {
    @Id private UUID id;
    private String eventType;
    private String aggregateId;
    @Column(columnDefinition = "TEXT")
    private String payload;               // JSON serialised integration event
    private Instant createdAt;
    private boolean published;
}

// Save to outbox IN the same transaction as the domain change
@Service
@Transactional
public class OrderApplicationService {
    public void placeOrder(PlaceOrderCommand cmd) {
        var order = Order.place(cmd);
        orderRepository.save(order);

        // Outbox entry saved atomically with the order
        outboxRepository.save(new OutboxEvent(
            UUID.randomUUID(),
            "OrderPlaced",
            order.getId().toString(),
            objectMapper.writeValueAsString(new OrderPlacedIntegrationEvent(...))
        ));
        // If this crashes here, BOTH are rolled back — consistency guaranteed
    }
}

// Scheduler reads outbox and publishes (separate process/thread)
@Scheduled(fixedDelay = 1000)
@Transactional
public void publishOutboxEvents() {
    outboxRepo.findByPublishedFalse().forEach(event -> {
        kafka.send("order.events", event.getAggregateId(), event.getPayload());
        event.setPublished(true);
        outboxRepo.save(event);
    });
}
```

**Use Outbox Pattern when**: the operation must be reliably published. If publish fails, it will be retried.

---

## Pattern 4 — Saga (Distributed Transactions)

For business processes spanning multiple bounded contexts where all steps must succeed or all must roll back.

```
Choreography Saga (no central coordinator — events trigger next steps):

Order Context          Inventory Context         Payment Context
     │                       │                        │
  PlaceOrder                 │                        │
     │──OrderPlaced──────────►│                        │
     │                  ReserveStock                   │
     │                       │──StockReserved──────────►│
     │                       │                   ProcessPayment
     │                       │                        │──PaymentProcessed──►[Fulfil]
     │                       │                        │
     │◄──────────────────────────PaymentFailed─────────│
  CompensateOrder       ◄─────StockReleased────────────│
```

```java
// Each service listens for events and triggers compensating actions on failure
@KafkaListener(topics = "payment.events")
public void onPaymentFailed(PaymentFailedEvent event) {
    // Compensate: cancel the order
    orderService.cancelOrder(event.orderId(), CancellationReason.PAYMENT_FAILED);
}
```

**Choreography**: simple, decoupled, but hard to visualise the overall flow.
**Orchestration** (Saga Orchestrator): central coordinator tracks state — use Axon Framework or Temporal.

---

## Decision Matrix

| Communication need | Pattern | Technology |
|-------------------|---------|-----------|
| Within same context | Domain Event | Spring ApplicationEventPublisher |
| Cross-context, fire-and-forget | Integration Event | Kafka topic |
| Cross-context, need response | Request/Reply | REST or gRPC |
| Multi-step distributed transaction | Saga | Choreography (Kafka) or Orchestration (Axon/Temporal) |
| Guaranteed delivery | Outbox Pattern | DB + Kafka |
| Query across contexts | API Composition | REST aggregator |
| Read optimisation | CQRS | Separate read model |
