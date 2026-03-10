---
name: api-design-contract-first
description: >
  This skill should be used before implementing any REST endpoint, messaging contract,
  or external API. Triggers on: "new endpoint", "REST API", "API design", "OpenAPI",
  "Swagger", "messaging contract", "Kafka topic", "REST controller", "write an endpoint",
  or any time a developer is about to write a @RestController or @KafkaListener.
  Contract MUST be written and reviewed before any implementation.
version: 1.0.0
allowed-tools: [Read, Write, Bash, Glob]
---

# API Design — Contract First Skill

## Purpose
Write the API contract (OpenAPI spec or AsyncAPI) BEFORE writing a single line of
controller or listener code. The contract is the acceptance test for the API.

## The Rule
**Spec first. Code second. Always.**

If you write the controller before the spec: delete it and start with the spec.

---

## REST API — OpenAPI 3.1 Contract

### Step 1 — Create the spec file
Save to `src/main/resources/api/<bounded-context>-api.yaml`

```yaml
openapi: 3.1.0
info:
  title: Order Management API
  version: 1.0.0
  description: |
    Manages the order lifecycle within the Order bounded context.
    All amounts are in minor currency units (pence/cents).

servers:
  - url: /api/v1

tags:
  - name: Orders
    description: Order lifecycle operations

paths:
  /orders:
    post:
      tags: [Orders]
      operationId: placeOrder
      summary: Place a new order
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/PlaceOrderRequest'
            example:
              customerId: "CUST-123"
              lines:
                - productId: "PROD-456"
                  quantity: 2
      responses:
        '201':
          description: Order placed successfully
          headers:
            Location:
              description: URL of the created order
              schema:
                type: string
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderResponse'
        '400':
          $ref: '#/components/responses/ValidationError'
        '422':
          $ref: '#/components/responses/BusinessRuleViolation'

  /orders/{orderId}:
    get:
      tags: [Orders]
      operationId: getOrder
      summary: Retrieve an order by ID
      parameters:
        - name: orderId
          in: path
          required: true
          schema:
            type: string
            pattern: '^ORD-[0-9]+$'
      responses:
        '200':
          description: Order found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderResponse'
        '404':
          $ref: '#/components/responses/NotFound'

components:
  schemas:
    PlaceOrderRequest:
      type: object
      required: [customerId, lines]
      properties:
        customerId:
          type: string
          description: The customer placing the order
        lines:
          type: array
          minItems: 1
          items:
            $ref: '#/components/schemas/OrderLineRequest'

    OrderLineRequest:
      type: object
      required: [productId, quantity]
      properties:
        productId:
          type: string
        quantity:
          type: integer
          minimum: 1

    OrderResponse:
      type: object
      required: [orderId, status, customerId, lines, createdAt]
      properties:
        orderId:
          type: string
        status:
          type: string
          enum: [DRAFT, PLACED, CONFIRMED, FULFILLED, SHIPPED, DELIVERED, CANCELLED]
        customerId:
          type: string
        lines:
          type: array
          items:
            $ref: '#/components/schemas/OrderLineResponse'
        total:
          $ref: '#/components/schemas/MoneyResponse'
        createdAt:
          type: string
          format: date-time

    MoneyResponse:
      type: object
      required: [amount, currency]
      properties:
        amount:
          type: number
        currency:
          type: string
          pattern: '^[A-Z]{3}$'

    OrderLineResponse:
      type: object
      properties:
        productId:
          type: string
        quantity:
          type: integer
        unitPrice:
          $ref: '#/components/schemas/MoneyResponse'
        lineTotal:
          $ref: '#/components/schemas/MoneyResponse'

  responses:
    NotFound:
      description: Resource not found
      content:
        application/problem+json:
          schema:
            $ref: '#/components/schemas/ProblemDetail'
    ValidationError:
      description: Request validation failed
      content:
        application/problem+json:
          schema:
            $ref: '#/components/schemas/ProblemDetail'
    BusinessRuleViolation:
      description: Business rule prevented the operation
      content:
        application/problem+json:
          schema:
            $ref: '#/components/schemas/ProblemDetail'

    ProblemDetail:
      type: object
      properties:
        type:
          type: string
          format: uri
        title:
          type: string
        status:
          type: integer
        detail:
          type: string
        instance:
          type: string
          format: uri
```

### Step 2 — Generate server stubs from spec (Maven)
Add to `pom.xml`:
```xml
<plugin>
  <groupId>org.openapitools</groupId>
  <artifactId>openapi-generator-maven-plugin</artifactId>
  <version>${openapi-generator.version}</version>
  <executions>
    <execution>
      <goals><goal>generate</goal></goals>
      <configuration>
        <inputSpec>${project.basedir}/src/main/resources/api/order-api.yaml</inputSpec>
        <generatorName>spring</generatorName>
        <configOptions>
          <interfaceOnly>true</interfaceOnly>
          <useSpringBoot3>true</useSpringBoot3>
          <useTags>true</useTags>
          <dateLibrary>java8</dateLibrary>
          <useJakartaEe>true</useJakartaEe>
        </configOptions>
      </configuration>
    </execution>
  </executions>
</plugin>
```

### Step 3 — Implement the generated interface
```java
@RestController
@RequiredArgsConstructor
public class OrderController implements OrdersApi {  // Generated interface

    private final OrderApplicationService orderService;

    @Override
    public ResponseEntity<OrderResponse> placeOrder(PlaceOrderRequest request) {
        var result = orderService.placeOrder(request);
        return ResponseEntity
            .created(URI.create("/api/v1/orders/" + result.getOrderId()))
            .body(result);
    }
}
```

---

## Async API — Messaging Contract

For Kafka/RabbitMQ events, save to `docs/architecture/events/<EventName>.md`:

```markdown
# Event: OrderPlaced

**Topic/Exchange**: `order.events`
**Routing Key**: `order.placed`
**Version**: 1.0
**Producer**: Order Management Context
**Consumers**: Inventory Context, Notification Context, Analytics Context

## Schema
```json
{
  "eventType": "OrderPlaced",
  "eventId": "uuid",
  "occurredOn": "ISO-8601 datetime",
  "orderId": "string",
  "customerId": "string",
  "lines": [
    { "productId": "string", "quantity": "integer", "unitPrice": { "amount": "number", "currency": "string" } }
  ],
  "orderTotal": { "amount": "number", "currency": "string" }
}
```

## Compatibility
- Consumers MUST ignore unknown fields (forward compatibility)
- Producer MUST NOT remove or rename existing fields (backward compatibility)
- Breaking changes require a new event type: `OrderPlacedV2`
```

---

## API Design Checklist
Before writing any controller:
- [ ] OpenAPI spec exists and reviewed
- [ ] All request/response schemas defined with constraints
- [ ] All error responses use RFC 7807 Problem Detail format
- [ ] URL structure follows REST resource naming (nouns, not verbs)
- [ ] HTTP status codes semantically correct (201 for create, 404 for not found, 422 for business rule)
- [ ] Pagination defined for collection endpoints
- [ ] Breaking change policy documented
- [ ] Async events have published schema and versioning policy
