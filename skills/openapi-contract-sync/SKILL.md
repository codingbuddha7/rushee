---
name: openapi-contract-sync
description: >
  This skill should be used whenever the OpenAPI spec changes, a new endpoint is added,
  a response field is modified, a new DTO is needed, or a Flutter model needs to be
  created for an API response. Triggers on: "add a field", "change the response",
  "API response", "JSON mapping", "fromJson", "toJson", "dto", "serialization",
  "openapi", "yaml spec", "api contract", "breaking change", "api versioning",
  "retrofit", "generate client", "regenerate", "model mismatch", or any edit to
  a file matching *-api.yaml or *.openapi.yaml.
  The spec is the law. Both codebases generate from it. Neither hand-writes DTOs.
version: 1.0.0
allowed-tools: [Read, Write, Bash, Glob]
---

# OpenAPI Contract Sync Skill

## The Law
**The OpenAPI spec is the single source of truth for both codebases.**

```
src/main/resources/api/order-api.yaml
          │
          ├── Spring Boot: openapi-generator-maven-plugin
          │     └── generates API interfaces → @RestController implements
          │
          └── Flutter: openapi-generator (dart-dio)
                └── generates models + API client → data layer uses
```

Neither side hand-writes DTOs. Neither side hand-writes JSON parsing.
If the spec changes, **both sides regenerate**. This is non-negotiable.

---

## Phase 1 — Spec Design Rules

### Field Naming Convention
```yaml
# Spring Boot (Jackson default) uses camelCase
# Flutter dart-dio generator produces camelCase Dart from camelCase YAML
# Therefore: ALWAYS use camelCase in the spec

# ✅ Correct
OrderResponse:
  properties:
    orderId:       { type: string, format: uuid }
    customerId:    { type: string }
    totalAmount:   { type: integer, description: "Amount in pence" }
    placedAt:      { type: string, format: date-time }

# ❌ Wrong — snake_case causes mismatch between Spring and Flutter
OrderResponse:
  properties:
    order_id:      { type: string }
    customer_id:   { type: string }
```

### Money Fields — Always Integer Pence, Never Decimal
```yaml
# ✅ Correct — integer avoids floating point rounding
totalAmount:
  type: integer
  format: int64
  description: "Total order amount in smallest currency unit (pence/cents)"
  example: 2499  # £24.99

# ❌ Wrong — floating point causes display bugs (£24.990000001)
totalAmount:
  type: number
  format: double
```

### Required vs Optional Fields
```yaml
OrderResponse:
  required:              # List ALL required fields here
    - orderId
    - customerId
    - status
    - totalAmount
    - placedAt
  properties:
    orderId:
      type: string
    cancelledAt:         # Optional — only present when status=CANCELLED
      type: string
      format: date-time
      nullable: true     # Explicit nullable for clarity
```

### Error Response — Standardise Once
```yaml
# Define once in components, reference everywhere
components:
  schemas:
    ErrorResponse:
      required: [timestamp, status, error, message, path]
      properties:
        timestamp:  { type: string, format: date-time }
        status:     { type: integer, example: 400 }
        error:      { type: string, example: "Bad Request" }
        message:    { type: string, example: "Cart cannot be empty" }
        path:       { type: string, example: "/api/v1/orders" }
        fieldErrors:
          type: array
          items:
            $ref: '#/components/schemas/FieldError'

    FieldError:
      required: [field, message]
      properties:
        field:   { type: string, example: "lines" }
        message: { type: string, example: "must not be empty" }
```

---

## Phase 2 — Spring Boot Code Generation

```xml
<!-- pom.xml — generate API interfaces from spec -->
<plugin>
  <groupId>org.openapitools</groupId>
  <artifactId>openapi-generator-maven-plugin</artifactId>
  <version>7.2.0</version>
  <executions>
    <execution>
      <id>generate-order-api</id>
      <goals><goal>generate</goal></goals>
      <configuration>
        <inputSpec>${project.basedir}/src/main/resources/api/order-api.yaml</inputSpec>
        <generatorName>spring</generatorName>
        <apiPackage>com.yourcompany.yourapp.order.infrastructure.web.generated</apiPackage>
        <modelPackage>com.yourcompany.yourapp.order.infrastructure.web.dto</modelPackage>
        <configOptions>
          <useSpringBoot3>true</useSpringBoot3>
          <interfaceOnly>true</interfaceOnly>     <!-- generate interfaces only -->
          <useTags>true</useTags>
          <dateLibrary>java8</dateLibrary>
          <useBeanValidation>true</useBeanValidation>
        </configOptions>
      </configuration>
    </execution>
  </executions>
</plugin>
```

```java
// OrderController IMPLEMENTS the generated interface
// Never write @RequestMapping manually — it comes from the spec
@RestController
@RequiredArgsConstructor
public class OrderController implements OrdersApi {  // ← generated interface

  private final OrderApplicationService orderService;

  @Override
  public ResponseEntity<OrderResponse> placeOrder(PlaceOrderRequest request) {
    var dto = orderService.placeOrder(mapper.toCommand(request));
    return ResponseEntity
        .created(URI.create("/api/v1/orders/" + dto.orderId()))
        .body(mapper.toResponse(dto));
  }
}
```

```bash
# Regenerate after any spec change
./mvnw generate-sources

# Verify no compilation errors
./mvnw compile -q
```

---

## Phase 3 — Flutter Code Generation

```bash
# Install openapi-generator (one-time)
npm install -g @openapitools/openapi-generator-cli

# Generate Dart/Flutter client from spec
openapi-generator-cli generate \
  -i ../backend/src/main/resources/api/order-api.yaml \
  -g dart-dio \
  -o lib/features/order/data/generated \
  --additional-properties=pubName=order_api,nullSafe=true,dateLibrary=core

# Regenerate Freezed/JSON models
flutter pub run build_runner build --delete-conflicting-outputs
```

### Use the Generated Client in the Data Source
```dart
// data/datasources/order_remote_datasource.dart
import '../generated/lib/api.dart';   // ← generated by openapi-generator

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final OrdersApi _api;   // ← generated API class

  const OrderRemoteDataSourceImpl({required OrdersApi api}) : _api = api;

  @override
  Future<OrderModel> placeOrder(PlaceOrderRequest request) async {
    try {
      final response = await _api.placeOrder(placeOrderRequest: request);
      if (response.data == null) throw ServerException(statusCode: 500, message: 'Empty response');
      return OrderModel.fromGenerated(response.data!);
    } on DioException catch (e) {
      final error = _parseError(e);
      throw ServerException(statusCode: error.status, message: error.message);
    }
  }

  ErrorResponse _parseError(DioException e) {
    try {
      return ErrorResponse.fromJson(e.response?.data as Map<String, dynamic>);
    } catch (_) {
      return ErrorResponse(
        timestamp: DateTime.now().toIso8601String(),
        status: e.response?.statusCode ?? 500,
        error: 'Unknown',
        message: 'An unexpected error occurred',
        path: e.requestOptions.path,
      );
    }
  }
}
```

---

## Phase 4 — Breaking Change Protocol

### Non-Breaking Changes (safe to deploy)
```yaml
# Adding a new optional field — backward compatible
# Backend deploys first, Flutter update follows
OrderResponse:
  properties:
    estimatedDelivery:   # NEW optional field
      type: string
      format: date-time
      nullable: true
```

### Breaking Changes (require versioning)
```
Removing a field        → BREAKING
Renaming a field        → BREAKING (treat as remove + add)
Changing a field type   → BREAKING (e.g. string → integer)
Making an optional field required → BREAKING
```

### Breaking Change Procedure
```
1. Add new endpoint version: POST /api/v2/orders
2. Keep v1 endpoint running with @Deprecated annotation
3. Add deprecation header to v1 responses:
   Deprecation: true
   Sunset: 2025-09-01T00:00:00Z
4. Update Flutter to use v2
5. After all clients have updated, remove v1 endpoint
   (minimum deprecation period: 1 sprint for internal, 3 months for external)
```

```java
// Spring Boot — deprecation header on old endpoint
@Override
@Deprecated
public ResponseEntity<OrderResponseV1> placeOrderV1(PlaceOrderRequestV1 request) {
  return ResponseEntity.status(200)
      .header("Deprecation", "true")
      .header("Sunset", "Mon, 01 Sep 2025 00:00:00 GMT")
      .header("Link", "</api/v2/orders>; rel=\"successor-version\"")
      .body(legacyMapper.toV1Response(orderService.placeOrder(mapper.toCommand(request))));
}
```

---

## Phase 5 — Contract Test (Both Sides Verify)

### Spring Boot — Spring Cloud Contract or REST-assured
```java
// ContractVerificationTest.java — backend proves it fulfils the spec
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class OrderApiContractTest {

  @Autowired TestRestTemplate restTemplate;

  @Test
  void placeOrder_returnsContractCompliantResponse() {
    var request = new PlaceOrderRequest()
        .customerId("cust-123")
        .lines(List.of(new OrderLineRequest().productId("prod-456").quantity(2)));

    var response = restTemplate.postForEntity("/api/v1/orders", request, Map.class);

    assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
    assertThat(response.getHeaders().getLocation()).isNotNull();

    var body = response.getBody();
    assertThat(body).containsKeys("orderId", "customerId", "status", "totalAmount", "placedAt");
    assertThat(body.get("status")).isEqualTo("PLACED");
    assertThat((Integer) body.get("totalAmount")).isGreaterThan(0);
  }
}
```

### Flutter — Contract Verification with Mock Server
```dart
// test/contract/order_api_contract_test.dart
void main() {
  late MockServer mockServer;    // WireMock or similar

  setUp(() async {
    mockServer = await MockServer.start();
    mockServer.stubFor(
      post(urlPathEqualTo('/api/v1/orders'))
          .willReturn(aResponse()
              .withStatus(201)
              .withHeader('Content-Type', 'application/json')
              .withBody(jsonEncode({
                'orderId': 'ord-789',
                'customerId': 'cust-123',
                'status': 'PLACED',
                'totalAmount': 2499,
                'placedAt': '2025-01-01T10:00:00Z',
              }))),
    );
  });

  test('placeOrder — parses contract-compliant response correctly', () async {
    final dataSource = OrderRemoteDataSourceImpl(api: buildApiClient(mockServer.baseUrl));
    final result = await dataSource.placeOrder(testRequest);

    expect(result.id, equals('ord-789'));
    expect(result.total.amountInPence, equals(2499));
    expect(result.status, equals(OrderStatus.placed));
  });
}
```

---

## The Regeneration Checklist

Run this after **every** change to any `*-api.yaml` file:

```bash
#!/bin/bash
# regenerate-clients.sh

echo "=== Regenerating API clients from spec ==="

# 1. Backend
cd backend
./mvnw generate-sources -q
./mvnw compile -q
if [ $? -ne 0 ]; then echo "❌ Backend compilation failed"; exit 1; fi
echo "✅ Backend generated and compiled"

# 2. Flutter
cd ../mobile
openapi-generator-cli generate \
  -i ../backend/src/main/resources/api/order-api.yaml \
  -g dart-dio \
  -o lib/features/order/data/generated \
  --additional-properties=nullSafe=true 2>/dev/null
flutter pub run build_runner build --delete-conflicting-outputs -q
if [ $? -ne 0 ]; then echo "❌ Flutter generation failed"; exit 1; fi
echo "✅ Flutter client generated"

# 3. Run contract tests on both
cd ../backend && ./mvnw test -Dtest="*ContractTest" -q
cd ../mobile && flutter test test/contract/ -q
echo "=== Both clients regenerated and contract tests pass ==="
```
