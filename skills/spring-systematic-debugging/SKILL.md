---
name: spring-systematic-debugging
description: >
  This skill should be used when any test fails, an exception is thrown, a Spring context
  fails to load, a Cucumber scenario fails, or unexpected behaviour occurs. Triggers on:
  "test fails", "error", "exception", "bug", "not working", "why is this failing",
  "debug", "broken", "context fails to load", "BeanCreationException", "NullPointerException",
  "LazyInitializationException", "TransactionRequiredException", or any stack trace.
  ALWAYS use this skill before asking Claude to guess at a fix.
version: 1.0.0
allowed-tools: [Read, Bash, Glob, Grep]
---

# Spring Systematic Debugging Skill

## The Rule
**Read the full stack trace before doing anything else.**
Never guess. Never change code without first forming a hypothesis.
The fix takes 2 minutes. Finding the right place to fix takes the other 28.

---

## Phase 1 — Classify the Failure

### Step 1: Run the failing test in isolation with full output
```bash
# Single test
./mvnw test -Dtest="OrderServiceTest#placeOrder_emptyLines_throwsException" -q

# Single class
./mvnw test -Dtest="OrderServiceTest"

# Cucumber scenario by tag
./mvnw test -Dtest="CucumberIT" -Dcucumber.filter.tags="@FDD-001"

# With debug logging
./mvnw test -Dtest="OrderServiceTest" -Dlogging.level.root=DEBUG
```

### Step 2: Identify the failure category

| Symptom | Category | Jump to |
|---------|----------|---------|
| `ApplicationContext failed to load` | Spring wiring | Section A |
| `BeanCreationException`, `NoSuchBeanDefinitionException` | Spring wiring | Section A |
| `LazyInitializationException` | JPA / transactions | Section B |
| `TransactionRequiredException` | JPA / transactions | Section B |
| `AssertionError` | Wrong value returned | Section C |
| `NullPointerException` | Missing dependency or null state | Section D |
| `UnsatisfiedDependencyException` | Missing bean / wrong qualifier | Section A |
| Cucumber step `undefined` | Missing step definition | Section E |
| Cucumber step `pending` | Step not implemented yet | Section E |
| Wrong HTTP status in `@WebMvcTest` | Controller / security | Section F |
| Test passes alone, fails in suite | Test isolation | Section G |

---

## Section A — Spring Context / Wiring Failures

### Diagnosis
```bash
# See full context failure reason
./mvnw test -Dtest="YourTest" -Dspring.test.context.failure.threshold=0

# Find all @Configuration classes
grep -rn "@Configuration\|@Bean" src/main/java --include="*.java" -l

# Find missing beans
grep -rn "NoSuchBeanDefinitionException" . 2>/dev/null
```

### Common Root Causes
| Error | Root Cause | Fix |
|-------|-----------|-----|
| `NoSuchBeanDefinitionException: OrderRepository` | Interface not scanned | Add `@Repository` on JPA impl or check `@ComponentScan` |
| `BeanCreationException: circular dependency` | A → B → A | Break cycle with `@Lazy` or redesign |
| `@WebMvcTest fails with missing service` | Service not mocked | Add `@MockBean OrderApplicationService` to test |
| `@DataJpaTest fails with missing entity` | Entity not in test slice | Check `@EntityScan` or package location |
| `UnsatisfiedDependencyException` on constructor | Dependency not available in test context | Use `@MockBean` or `@Import` the missing config |

### Fix Patterns
```java
// @WebMvcTest — always mock the service layer
@WebMvcTest(OrderController.class)
class OrderControllerTest {
    @MockBean                                     // ← required for WebMvcTest
    private OrderApplicationService orderService;
}

// @DataJpaTest — override Flyway if causing issues in test
@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.ANY)
class OrderRepositoryTest { }

// Full context test — use @SpringBootTest sparingly
@SpringBootTest
@AutoConfigureMockMvc
class OrderIntegrationTest { }
```

---

## Section B — JPA / Transaction Failures

### Diagnosis
```bash
# Enable SQL logging
./mvnw test -Dspring.jpa.show-sql=true -Dspring.jpa.properties.hibernate.format_sql=true

# Enable transaction logging
./mvnw test -Dlogging.level.org.springframework.transaction=TRACE
```

### Common Root Causes
| Error | Root Cause | Fix |
|-------|-----------|-----|
| `LazyInitializationException` | Accessing lazy collection outside session | Add `@Transactional` to service method, or use `JOIN FETCH` |
| `TransactionRequiredException` | Calling `save()` outside transaction | Add `@Transactional` to service or test |
| `StaleObjectStateException` | Optimistic lock conflict | Add retry logic or check `@Version` field |
| Wrong data after save | Missing `flush()` in test | Add `@Transactional` + `entityManager.flush()` |
| N+1 query problem | Missing `JOIN FETCH` | Check queries with `spring.jpa.show-sql=true` |

### Fix Patterns
```java
// Service method — always @Transactional at service level
@Service
public class OrderApplicationService {
    @Transactional                                // ← add this
    public OrderDto placeOrder(PlaceOrderCommand cmd) { ... }

    @Transactional(readOnly = true)               // ← for queries
    public OrderDto findOrder(String id) { ... }
}

// Avoid N+1 — use JOIN FETCH
@Query("SELECT o FROM OrderJpaEntity o JOIN FETCH o.lines WHERE o.id = :id")
Optional<OrderJpaEntity> findByIdWithLines(@Param("id") String id);

// Test: clear persistence context to force re-read
@DataJpaTest
class OrderRepositoryTest {
    @Autowired EntityManager em;

    @Test void save_andReload() {
        repo.save(entity);
        em.flush();
        em.clear();                               // ← force reload from DB
        var loaded = repo.findById(id);
        // now asserting against DB state, not cache
    }
}
```

---

## Section C — Wrong Value Returned (AssertionError)

### 4-Step Root Cause Process
```
1. WHAT is wrong?
   Read the assertion: expected <X> but was <Y>
   Write it down precisely.

2. WHERE does the value come from?
   Trace backwards: test → service → domain → repository → DB
   Add debug logging at each layer to find where it diverges.

3. WHY is it wrong at that layer?
   Inspect the object at the divergence point.
   Is it a mapping issue? A calculation issue? A missing step?

4. WHAT is the minimal fix?
   Change the smallest thing that makes the test pass.
   Do not refactor while fixing.
```

```java
// Add temporary debug — remove after fix
log.debug("DEBUG placeOrder — command: {}", cmd);
log.debug("DEBUG placeOrder — order before save: {}", order);
log.debug("DEBUG placeOrder — order after save: {}", savedOrder);
```

---

## Section D — NullPointerException

```bash
# Find the exact null — read the stack trace line by line
# The NPE line number points to the null dereference
# The line ABOVE in your code is where the null came from

# Common Spring NPE sources:
grep -rn "@Autowired\b" src/main/java --include="*.java"   # field injection — often null in tests
grep -rn "new.*Service\(\)" src/main/java --include="*.java"  # manual construction bypasses DI
```

| NPE Location | Root Cause | Fix |
|-------------|-----------|-----|
| In `@WebMvcTest` | Service not mocked with `@MockBean` | Add `@MockBean` |
| In service constructor | Null dependency passed in test | Use `@ExtendWith(MockitoExtension.class)` |
| In domain method | Value Object not validated | Add null check in VO constructor |
| After `repository.findById()` | Not handling `Optional.empty()` | Use `.orElseThrow()` |

---

## Section E — Cucumber Step Failures

```bash
# Run with verbose output
./mvnw test -Dtest="CucumberIT" -Dcucumber.plugin="pretty"

# See all undefined steps
./mvnw test -Dtest="CucumberIT" -Dcucumber.plugin="usage"
```

| Symptom | Fix |
|---------|-----|
| `Undefined step` | Create the step definition method |
| `Pending` (throws `PendingException`) | Implement the step body |
| `Ambiguous step` | Two step definitions match — make regex more specific |
| Step passes but wrong value | Add assertion to the step body |
| Scenario context lost between steps | Use a shared `ScenarioContext` object injected via Cucumber Guice/Spring |

---

## Section F — Wrong HTTP Status in @WebMvcTest

```java
// Debug: print MockMvc response
mockMvc.perform(post("/api/v1/orders").contentType(APPLICATION_JSON).content(body))
    .andDo(print())                               // ← prints full request/response
    .andExpect(status().isCreated());

// Common 401/403 in tests — disable security for unit tests
@WebMvcTest(OrderController.class)
@Import(TestSecurityConfig.class)                 // ← import permissive test config
class OrderControllerTest { }

@TestConfiguration
public class TestSecurityConfig {
    @Bean
    public SecurityFilterChain testFilterChain(HttpSecurity http) throws Exception {
        return http.authorizeHttpRequests(a -> a.anyRequest().permitAll()).build();
    }
}
```

---

## Section G — Test Isolation Failures (Pass Alone, Fail in Suite)

```bash
# Find the culprit test that contaminates state
./mvnw test -Dtest="TestA,TestB,TestC" --fail-fast

# Run in different order
./mvnw test -Dsurefire.runOrder=random
```

| Symptom | Root Cause | Fix |
|---------|-----------|-----|
| Static state shared | Static field modified by one test | Make field instance-scoped |
| DB state leaked | Missing `@Transactional` or `@Sql(executionPhase=AFTER_TEST)` | Add rollback or cleanup |
| Spring context cached with wrong config | Mixed `@MockBean` usage | Align context config across test classes |
| `ApplicationContext` recreated too often | Too many different context configs | Consolidate test config classes |

---

## Defense in Depth — Prevention Checklist

Add these to prevent the most common failures before they happen:

```java
// 1. Always assert the right thing — test the OUTCOME, not the mock call
// ❌ assertThat(orderRepo).called(1)  — tests the mock, not the behaviour
// ✅ assertThat(result.getOrderId()).isNotNull()  — tests the outcome

// 2. Make every test independent — no shared mutable state
@BeforeEach void setUp() { orderRepo = mock(OrderRepository.class); }

// 3. Validate at construction — fail fast
public record OrderId(UUID value) {
    public OrderId { Objects.requireNonNull(value, "OrderId cannot be null"); }
}

// 4. Use AssertJ for readable failures
assertThat(order.getStatus())
    .as("Order should be PLACED after placeOrder() is called")
    .isEqualTo(OrderStatus.PLACED);
```
