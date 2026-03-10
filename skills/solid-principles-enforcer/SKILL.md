---
name: solid-principles-enforcer
description: >
  This skill should be used during code review of any class, when a class is growing large,
  or when a method is getting complex. Triggers on: "code review", "refactor this",
  "this class is too big", "too many dependencies", "this method does too much",
  "SOLID", "single responsibility", "open closed", or automatically during
  tdd-red-green-refactor refactor phase on any class exceeding 150 lines.
version: 1.0.0
allowed-tools: [Read, Glob, Grep, Bash]
---

# SOLID Principles Enforcer Skill

## Quick Scan — Run This First
```bash
# Classes over 200 lines (SRP violation likely)
find src/main/java -name "*.java" | xargs wc -l | sort -rn | head -20

# Methods over 20 lines (SRP violation likely)
awk '/\{/{depth++} /\}/{depth--} depth==1 && /^\s+(public|private|protected)/{start=NR; method=$0} depth==0 && start{if(NR-start>20)print FILENAME":"start" — "method; start=0}' $(find src/main/java -name "*.java")

# Classes with too many dependencies (>5 constructor params = SRP violation)
grep -n "public.*@.*@.*@.*@.*@" src/main/java -r --include="*.java"
```

---

## S — Single Responsibility Principle

**One class = one reason to change.**

### Violation Detectors
```java
// ❌ VIOLATION: OrderService doing too much
public class OrderService {
    public Order placeOrder(...) { ... }
    public void sendConfirmationEmail(...) { ... }    // email sending?
    public BigDecimal calculateTax(...) { ... }       // tax calculation?
    public void updateInventory(...) { ... }          // inventory management?
    public byte[] generateInvoicePdf(...) { ... }     // PDF generation?
}
```

### Fix
```java
// ✅ Each class has one job
public class OrderService { placeOrder, confirmOrder, cancelOrder }
public class OrderNotificationService { sendConfirmation, sendCancellation }
public class TaxCalculator { calculateFor(Order) }
public class InventoryService { reserve, release }
public class InvoiceGenerator { generateFor(Order) }
```

### SRP Check Questions
- "If X changes, does this class need to change?" — more than one X = SRP violation
- "What is this class responsible for?" — if the answer has "and" in it = SRP violation

---

## O — Open/Closed Principle

**Open for extension, closed for modification.**
Add new behaviour without changing existing code.

### Violation Detector
```java
// ❌ VIOLATION: adding a new payment type requires editing this class
public class PaymentProcessor {
    public void process(Payment payment) {
        if (payment.getType().equals("CREDIT_CARD")) { ... }
        else if (payment.getType().equals("PAYPAL")) { ... }
        else if (payment.getType().equals("CRYPTO")) { ... }  // keep adding cases
    }
}
```

### Fix
```java
// ✅ New payment types via new classes, not modification
public interface PaymentStrategy {
    boolean supports(PaymentType type);
    PaymentResult process(Payment payment);
}

@Component public class CreditCardStrategy implements PaymentStrategy { ... }
@Component public class PaypalStrategy implements PaymentStrategy { ... }

@Service
public class PaymentProcessor {
    private final List<PaymentStrategy> strategies;

    public PaymentResult process(Payment payment) {
        return strategies.stream()
            .filter(s -> s.supports(payment.getType()))
            .findFirst()
            .orElseThrow(() -> new UnsupportedPaymentTypeException(payment.getType()))
            .process(payment);
    }
}
```

---

## L — Liskov Substitution Principle

**Subtypes must be substitutable for their base types without altering correctness.**

### Violation Detector
```java
// ❌ VIOLATION: subclass breaks parent contract
public class Rectangle {
    public void setWidth(int w) { this.width = w; }
    public void setHeight(int h) { this.height = h; }
}

public class Square extends Rectangle {
    @Override
    public void setWidth(int w) {
        this.width = w;
        this.height = w;  // breaks Rectangle's contract — caller is surprised
    }
}
```

### Fix — prefer composition or rethink hierarchy
```java
// ✅ Use interface segregation instead of inheritance
public interface Shape { int area(); }
public record Rectangle(int width, int height) implements Shape {
    public int area() { return width * height; }
}
public record Square(int side) implements Shape {
    public int area() { return side * side; }
}
```

### LSP Check Questions
- Does any overridden method throw exceptions the parent doesn't throw?
- Does any overridden method weaken preconditions or strengthen postconditions?
- Does any `instanceof` check in calling code suggest the hierarchy is wrong?

---

## I — Interface Segregation Principle

**Clients should not be forced to depend on methods they don't use.**

### Violation Detector
```java
// ❌ VIOLATION: fat interface forces implementations to provide unused methods
public interface OrderRepository {
    void save(Order order);
    Optional<Order> findById(OrderId id);
    List<Order> findAll();
    void delete(OrderId id);
    List<Order> findByCustomerId(CustomerId id);
    List<Order> findByStatus(OrderStatus status);
    void deleteAll();          // most callers never need this
    long count();              // most callers never need this
    List<Order> findExpired(); // only the cleanup job needs this
}
```

### Fix
```java
// ✅ Segregate by caller need
public interface OrderWriter { void save(Order order); }
public interface OrderReader {
    Optional<Order> findById(OrderId id);
    List<Order> findByCustomerId(CustomerId id);
}
public interface OrderCleaner {
    List<Order> findExpired();
    void delete(OrderId id);
}
// Implementation implements all three; callers depend only on what they need
```

---

## D — Dependency Inversion Principle

**High-level modules should not depend on low-level modules. Both should depend on abstractions.**

### Violation Detector
```java
// ❌ VIOLATION: application service depends on concrete JPA implementation
@Service
public class OrderApplicationService {
    private final JpaOrderRepository orderRepository;  // concrete — wrong layer
    private final SmtpEmailSender emailSender;         // concrete infrastructure
}
```

### Fix
```java
// ✅ Depend on abstractions (ports)
@Service
public class OrderApplicationService {
    private final OrderRepository orderRepository;     // interface (output port)
    private final NotificationPort notificationPort;   // interface (output port)
    // Spring injects concrete implementations — AppService doesn't know which
}
```

---

## SOLID Score Card (run during code review)
```
Class: <ClassName>
─────────────────────────────────────────────
S - Single Responsibility:  ✅ PASS / ❌ FAIL — <issue>
O - Open/Closed:            ✅ PASS / ❌ FAIL — <issue>
L - Liskov Substitution:    ✅ PASS / ❌ FAIL — <issue>
I - Interface Segregation:  ✅ PASS / ❌ FAIL — <issue>
D - Dependency Inversion:   ✅ PASS / ❌ FAIL — <issue>
─────────────────────────────────────────────
Lines: <N> (warn if >150, fail if >300)
Constructor params: <N> (warn if >4, fail if >6)
Public methods: <N> (warn if >10)
```

Any FAIL blocks merge. All WARNs must be addressed or documented with justification.
