---
name: tdd-red-green-refactor
description: >
  This skill should be used when implementing any class, method, service, controller,
  or repository in a Spring Boot project. Triggers on: "implement the service", "write the
  controller", "create the repository", "add the logic", "implement this method", or
  automatically after atdd-acceptance-first completes. Also triggers when someone writes
  production code before mentioning tests.
version: 1.0.0
allowed-tools: [Read, Write, Bash, Glob, Grep]
---

# TDD — Red-Green-Refactor Inner Cycle Skill

## Purpose
Drive implementation of every Spring Boot class through strict Red → Green → Refactor.
This is the INNER test loop. The outer Cucumber acceptance tests are already RED.
The inner JUnit tests guide the step-by-step implementation until both streams go GREEN.

## The Discipline — No Exceptions
```
RED   → Write ONE failing test. Run it. Confirm it fails for the RIGHT reason.
GREEN → Write THE MINIMUM code to make it pass. No more.
CLEAN → Refactor. Run tests. They must still pass.
REPEAT
```

## Mandatory Gate — STOP if violated
**Write ONE test. Run it. See it fail. THEN write code.**
Not two tests. Not a whole test class. ONE test.

Red Flags — DELETE the code and start over:
- Production code written before a failing test exists
- Test written AFTER the code it tests
- Multiple tests written at once before any are GREEN
- "I'll add the test at the end"
- "This logic is too simple to test"
- "I already know this works"
- Writing code to pass a test that was already passing

## Spring Boot TDD Patterns

### Layer Order — Always work outside-in:
```
Controller Test → Controller → Service Interface
Service Test → Service Implementation → Repository Interface  
Repository Test → Repository Implementation
```

### Pattern 1: Controller Slice Test (MockMvc)
```java
@WebMvcTest(OrderController.class)
class OrderControllerTest {

    @Autowired MockMvc mockMvc;
    @MockBean OrderService orderService;  // Mock the dependency

    @Test
    void placeOrder_validRequest_returns201() throws Exception {
        // RED: Write this first, run, confirm FAIL (method doesn't exist yet)
        var request = new PlaceOrderRequest("PROD-1", 2);
        given(orderService.placeOrder(any())).willReturn(new OrderResult("ORD-123", "CONFIRMED"));

        mockMvc.perform(post("/api/orders")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.orderId").value("ORD-123"))
            .andExpect(jsonPath("$.status").value("CONFIRMED"));
    }
}
```

### Pattern 2: Service Unit Test (Plain JUnit + Mockito)
```java
class OrderServiceTest {

    @Mock OrderRepository orderRepository;
    @Mock InventoryClient inventoryClient;
    @InjectMocks OrderServiceImpl orderService;  // Concrete impl under test

    @BeforeEach void setUp() { MockitoAnnotations.openMocks(this); }

    @Test
    void placeOrder_sufficientInventory_createsOrder() {
        // Arrange
        given(inventoryClient.checkAvailability("PROD-1", 2)).willReturn(true);
        given(orderRepository.save(any())).willAnswer(inv -> inv.getArgument(0));

        // Act
        var result = orderService.placeOrder(new PlaceOrderRequest("PROD-1", 2));

        // Assert
        assertThat(result.status()).isEqualTo("CONFIRMED");
        verify(orderRepository).save(any(Order.class));
    }

    @Test
    void placeOrder_insufficientInventory_throwsDomainException() {
        // RED first — this test drives the error handling code
        given(inventoryClient.checkAvailability("PROD-1", 2)).willReturn(false);

        assertThatThrownBy(() -> orderService.placeOrder(new PlaceOrderRequest("PROD-1", 2)))
            .isInstanceOf(InsufficientInventoryException.class)
            .hasMessageContaining("PROD-1");
    }
}
```

### Pattern 3: Repository Slice Test (DataJpaTest)
```java
@DataJpaTest
class OrderRepositoryTest {

    @Autowired OrderRepository orderRepository;
    @Autowired TestEntityManager entityManager;

    @Test
    void findByCustomerId_existingCustomer_returnsOrders() {
        // Setup
        var customer = entityManager.persist(new Customer("CUST-1"));
        entityManager.persist(new Order(customer, "CONFIRMED"));
        entityManager.flush();

        // Act & Assert
        var orders = orderRepository.findByCustomerId("CUST-1");
        assertThat(orders).hasSize(1);
        assertThat(orders.get(0).getStatus()).isEqualTo("CONFIRMED");
    }
}
```

### Pattern 4: Integration Slice (@SpringBootTest with TestContainers)
For tests that need a real database:
```java
@SpringBootTest
@Testcontainers
class OrderIntegrationTest {

    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:15");

    @DynamicPropertySource
    static void configureProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
    }
    // ...
}
```

## Step-by-Step TDD Cycle per Feature

### 1. Start with the outermost layer — Controller
```bash
# Write ONE test in OrderControllerTest
# Run: ./mvnw test -Dtest=OrderControllerTest
# Confirm: COMPILATION ERROR or TEST FAILURE (correct RED)
```

### 2. Write minimum controller code to pass
- Just enough to compile and satisfy the one test
- No service logic in the controller
- No repository access from the controller

### 3. Move to Service layer
```bash
# Write ONE test in OrderServiceTest  
# Run: ./mvnw test -Dtest=OrderServiceTest
# Confirm: RED
```

### 4. Write minimum service implementation
- Define the service interface first
- Implement just enough logic for the one test
- Mock all dependencies

### 5. Move to Repository layer if needed
```bash
# Write ONE test in OrderRepositoryTest
# Run: ./mvnw test -Dtest=OrderRepositoryTest  
# Confirm: RED
```

### 6. Check the outer acceptance loop
```bash
# Run: ./mvnw test -Dtest=CucumberIT
# Are acceptance scenarios turning GREEN? Keep going until all GREEN.
```

## Refactor Phase Rules
Only refactor when ALL tests are GREEN. Refactoring rules:
- Extract method if a method exceeds 20 lines
- Extract class if a class has more than one reason to change (SRP)
- Replace magic numbers with named constants
- Remove duplication (DRY)
- Improve naming — class/method names should reveal intent

After every refactor: `./mvnw test` — ALL tests must pass.

## DONE Criteria — Both Streams GREEN
Feature is complete ONLY when:
- [ ] All Cucumber acceptance scenarios: PASS
- [ ] All unit tests (Controller, Service, Repository): PASS  
- [ ] Test coverage ≥ 80% for new code: `./mvnw jacoco:report`
- [ ] No Sonar/Spotbugs critical issues: `./mvnw verify`
- [ ] The Feature Card is updated with status: DONE

Then invoke `spring-reviewer` agent for final code review.
