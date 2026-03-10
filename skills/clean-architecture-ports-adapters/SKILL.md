---
name: clean-architecture-ports-adapters
description: >
  This skill should be used when creating any new class, deciding which package it belongs in,
  or reviewing any import statement. Triggers on: "which layer does this go in", "package structure",
  "hexagonal architecture", "ports and adapters", "clean architecture", "dependency rule",
  "can my domain use Spring", "should I put @Entity on my domain class", or any time an
  import in a domain class points to Spring, JPA, or infrastructure code.
version: 1.0.0
allowed-tools: [Read, Glob, Grep, Bash]
---

# Clean Architecture — Ports & Adapters Skill

## The Dependency Rule (Non-Negotiable)
```
Dependencies point INWARD only. NEVER outward.

        ┌─────────────────────────────────────┐
        │         Infrastructure              │  ← Spring, JPA, Kafka, REST clients
        │   ┌─────────────────────────────┐   │
        │   │       Application           │   │  ← Use cases, orchestration
        │   │   ┌─────────────────────┐   │   │
        │   │   │      Domain         │   │   │  ← Entities, VOs, Domain Services
        │   │   │   (pure Java)       │   │   │  ← NO framework imports
        │   │   └─────────────────────┘   │   │
        │   └─────────────────────────────┘   │
        └─────────────────────────────────────┘

Domain knows NOTHING about Application, Infrastructure, Spring, JPA, Kafka.
Application knows NOTHING about Infrastructure (only domain + ports).
Infrastructure knows everything (it wires things together).
```

---

## Package Structure per Bounded Context

```
src/main/java/<base>/<context>/
├── domain/                          ← PURE JAVA — zero framework dependencies
│   ├── model/
│   │   ├── Order.java               ← Entity (Aggregate Root)
│   │   ├── OrderLine.java           ← Child Entity
│   │   ├── OrderId.java             ← Value Object
│   │   ├── Money.java               ← Value Object
│   │   └── OrderStatus.java         ← Enum (domain concept)
│   ├── event/
│   │   ├── DomainEvent.java         ← Marker interface
│   │   ├── OrderPlaced.java         ← Domain Event (record)
│   │   └── OrderCancelled.java
│   ├── exception/
│   │   ├── OrderDomainException.java ← Base domain exception
│   │   └── OrderCannotBeCancelledException.java
│   └── port/
│       ├── out/
│       │   ├── OrderRepository.java  ← Output port (interface, no Spring)
│       │   └── PaymentGateway.java   ← Output port (interface)
│       └── in/
│           └── PlaceOrderUseCase.java ← Input port (interface — optional)
│
├── application/                     ← Orchestrates domain, depends on domain only
│   ├── OrderApplicationService.java  ← Implements use cases
│   └── dto/
│       ├── PlaceOrderCommand.java    ← Input DTO (record)
│       └── OrderDto.java            ← Output DTO (record)
│
└── infrastructure/                  ← Everything framework-specific
    ├── web/
    │   ├── OrderController.java      ← @RestController (inbound adapter)
    │   └── mapper/
    │       └── OrderWebMapper.java   ← Maps between web DTOs and application DTOs
    ├── persistence/
    │   ├── JpaOrderRepository.java   ← Implements OrderRepository port
    │   ├── OrderJpaEntity.java       ← @Entity (NOT the domain entity)
    │   ├── SpringDataOrderRepo.java  ← Spring Data interface
    │   └── mapper/
    │       └── OrderPersistenceMapper.java
    ├── messaging/
    │   ├── OrderEventPublisher.java  ← Publishes domain events to Kafka
    │   └── OrderEventListener.java  ← @KafkaListener (inbound adapter)
    └── client/
        └── PaymentGatewayClient.java ← Implements PaymentGateway port
```

---

## The Import Firewall — What Each Layer Can Import

### Domain Layer — ZERO framework imports
```java
// ALLOWED in domain
import java.util.*;
import java.time.*;
import java.math.*;

// FORBIDDEN in domain — delete these if found
import org.springframework.*;          // ❌
import jakarta.persistence.*;          // ❌
import com.fasterxml.jackson.*;        // ❌
import org.hibernate.*;               // ❌
```

Enforce with ArchUnit test:
```java
@AnalyzeClasses(packages = "com.myapp")
class ArchitectureTest {

    @ArchTest
    static final ArchRule domainMustNotDependOnSpring =
        noClasses().that().resideInAPackage("..domain..")
            .should().dependOnClassesThat()
            .resideInAnyPackage("org.springframework..", "jakarta.persistence..");

    @ArchTest
    static final ArchRule applicationMustNotDependOnInfrastructure =
        noClasses().that().resideInAPackage("..application..")
            .should().dependOnClassesThat()
            .resideInAPackage("..infrastructure..");

    @ArchTest
    static final ArchRule domainMustNotDependOnApplication =
        noClasses().that().resideInAPackage("..domain..")
            .should().dependOnClassesThat()
            .resideInAPackage("..application..");
}
```

Add ArchUnit to `pom.xml`:
```xml
<dependency>
    <groupId>com.tngtech.archunit</groupId>
    <artifactId>archunit-junit5</artifactId>
    <version>${archunit.version}</version>
    <scope>test</scope>
</dependency>
```

---

## The Two Entity Problem — Domain Entity vs JPA Entity

This is the most common violation. NEVER put `@Entity` on your domain class.

```java
// ✅ CORRECT — Domain Entity (pure Java, in domain/model/)
public class Order {
    private final OrderId id;
    private OrderStatus status;
    // behaviour methods
}

// ✅ CORRECT — JPA Entity (infrastructure/persistence/)
@Entity
@Table(name = "orders")
public class OrderJpaEntity {
    @Id private String id;
    @Enumerated(EnumType.STRING) private String status;
    // getters/setters only — no domain logic
}

// ✅ CORRECT — Mapper (infrastructure/persistence/mapper/)
@Component
public class OrderPersistenceMapper {
    public OrderJpaEntity toJpa(Order domain) { ... }
    public Order toDomain(OrderJpaEntity jpa) { ... }
}
```

**Why**: if `@Entity` is on your domain class, JPA's lazy loading, proxy generation, and
required no-arg constructors will pollute your domain model design.

---

## Port Definitions

### Output Port (driven port) — in domain/port/out/
```java
// Pure interface — domain tells infrastructure what it needs
public interface OrderRepository {
    void save(Order order);
    Optional<Order> findById(OrderId id);
    // Domain language methods, not CRUD
}
```

### Input Port (driving port) — in domain/port/in/ (optional but useful)
```java
// Defines a use case — application service implements this
public interface PlaceOrderUseCase {
    OrderDto placeOrder(PlaceOrderCommand command);
}
```

---

## Dependency Injection Wiring — Infrastructure only

```java
// Infrastructure layer — Spring configuration wires everything together
@Configuration
public class OrderModuleConfig {

    @Bean
    public OrderApplicationService orderApplicationService(
        OrderRepository orderRepository,         // Injected — Spring provides JpaOrderRepository
        PaymentGateway paymentGateway            // Injected — Spring provides PaymentGatewayClient
    ) {
        return new OrderApplicationService(orderRepository, paymentGateway);
        // ApplicationService doesn't know it's getting JPA or HTTP implementations
    }
}
```

---

## Architecture Violation Checklist
Run this scan on any Pull Request:

```bash
# Find Spring imports in domain layer
grep -r "import org.springframework" src/main/java/*/domain/ --include="*.java"

# Find JPA imports in domain layer
grep -r "import jakarta.persistence" src/main/java/*/domain/ --include="*.java"

# Find infrastructure imports in application layer
grep -r "import.*infrastructure" src/main/java/*/application/ --include="*.java"
```

Zero results required. Any violation blocks the PR.
