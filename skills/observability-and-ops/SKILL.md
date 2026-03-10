---
name: observability-and-ops
description: >
  This skill should be used when implementing any service, endpoint, or background job that
  will run in production. Triggers on: "logging", "metrics", "tracing", "Actuator",
  "health check", "Micrometer", "Prometheus", "structured logging", "correlation ID",
  "distributed tracing", "Zipkin", "alerting", "monitoring", "observability", or
  automatically during the final review phase of any feature. Production code without
  observability is incomplete.
version: 1.0.0
allowed-tools: [Read, Write, Glob, Grep]
---

# Observability & Ops Skill

## The Three Pillars of Observability
```
Logs    → What happened (events, errors, state changes)
Metrics → How the system is performing (counters, gauges, histograms)
Traces  → Where time was spent (distributed request flow across services)
```

A feature is not production-ready until all three pillars are in place.

---

## Pillar 1 — Structured Logging

### Dependencies
```xml
<!-- Spring Boot includes Logback by default -->
<!-- Add structured logging -->
<dependency>
    <groupId>net.logstash.logback</groupId>
    <artifactId>logstash-logback-encoder</artifactId>
    <version>${logstash-encoder.version}</version>
</dependency>
```

### Logback configuration (src/main/resources/logback-spring.xml)
```xml
<configuration>
    <springProfile name="!local">
        <!-- JSON for production (parsed by log aggregators) -->
        <appender name="JSON" class="ch.qos.logback.core.ConsoleAppender">
            <encoder class="net.logstash.logback.encoder.LogstashEncoder">
                <includeMdcKeyName>traceId</includeMdcKeyName>
                <includeMdcKeyName>spanId</includeMdcKeyName>
                <includeMdcKeyName>correlationId</includeMdcKeyName>
                <includeMdcKeyName>userId</includeMdcKeyName>
            </encoder>
        </appender>
        <root level="INFO"><appender-ref ref="JSON"/></root>
    </springProfile>

    <springProfile name="local">
        <!-- Human-readable for local development -->
        <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
            <encoder>
                <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} [%X{traceId}] - %msg%n</pattern>
            </encoder>
        </appender>
        <root level="DEBUG"><appender-ref ref="CONSOLE"/></root>
    </springProfile>
</configuration>
```

### Logging Patterns — What to Log and How
```java
@Service
@RequiredArgsConstructor
@Slf4j
public class OrderApplicationService {

    public OrderDto placeOrder(PlaceOrderCommand cmd) {
        // Log at entry — include all business context, NO PII
        log.info("Placing order. customerId={} lineCount={}", cmd.customerId(), cmd.lines().size());

        try {
            var order = Order.place(cmd);
            orderRepository.save(order);

            // Log successful outcome — include the result ID
            log.info("Order placed successfully. orderId={} customerId={} total={}",
                order.getId(), cmd.customerId(), order.getTotal());

            return mapper.toDto(order);

        } catch (InsufficientInventoryException e) {
            // Business exception — WARN, not ERROR (expected scenario)
            log.warn("Order placement failed — insufficient inventory. customerId={} productId={}",
                cmd.customerId(), e.getProductId());
            throw e;

        } catch (Exception e) {
            // Unexpected exception — ERROR with full context
            log.error("Unexpected error placing order. customerId={}", cmd.customerId(), e);
            throw e;
        }
    }
}
```

### What NEVER to log
```java
// ❌ NEVER log these
log.info("User password: {}", password);              // credentials
log.info("Card number: {}", cardNumber);              // payment data
log.info("JWT token: {}", token);                     // authentication tokens
log.info("SSN: {}", socialSecurityNumber);            // PII
log.debug("Request body: {}", rawRequestBody);        // may contain secrets
```

### Correlation ID Filter
```java
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class CorrelationIdFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
        throws IOException, ServletException {

        var request = (HttpServletRequest) req;
        var correlationId = Optional.ofNullable(request.getHeader("X-Correlation-ID"))
            .orElse(UUID.randomUUID().toString());

        MDC.put("correlationId", correlationId);
        ((HttpServletResponse) res).setHeader("X-Correlation-ID", correlationId);

        try {
            chain.doFilter(req, res);
        } finally {
            MDC.clear();
        }
    }
}
```

---

## Pillar 2 — Metrics (Micrometer + Prometheus)

### Dependencies
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-registry-prometheus</artifactId>
</dependency>
```

### application.yml
```yaml
management:
  endpoints:
    web:
      exposure:
        include: health, info, prometheus, metrics
  endpoint:
    health:
      show-details: when-authorized
  metrics:
    tags:
      application: ${spring.application.name}
      environment: ${spring.profiles.active}
```

### Custom Business Metrics
```java
@Service
@RequiredArgsConstructor
public class OrderApplicationService {

    private final MeterRegistry meterRegistry;

    public OrderDto placeOrder(PlaceOrderCommand cmd) {
        var timer = Timer.start(meterRegistry);
        try {
            var result = doPlaceOrder(cmd);

            // Count successful orders by status
            meterRegistry.counter("orders.placed",
                "status", "success",
                "customer_tier", resolveTier(cmd.customerId())
            ).increment();

            timer.stop(Timer.builder("orders.place.duration")
                .tag("outcome", "success")
                .register(meterRegistry));

            return result;

        } catch (BusinessException e) {
            meterRegistry.counter("orders.placed",
                "status", "rejected",
                "reason", e.getClass().getSimpleName()
            ).increment();
            timer.stop(Timer.builder("orders.place.duration")
                .tag("outcome", "rejected")
                .register(meterRegistry));
            throw e;
        }
    }
}
```

### @Observed Annotation (AOP-based — simpler)
```java
@Configuration
@EnableAspectJAutoProxy
public class ObservabilityConfig {
    @Bean
    public ObservedAspect observedAspect(ObservationRegistry registry) {
        return new ObservedAspect(registry);
    }
}

// Then annotate service methods
@Observed(name = "orders.place", contextualName = "place-order")
public OrderDto placeOrder(PlaceOrderCommand cmd) { ... }
```

---

## Pillar 3 — Distributed Tracing

### Dependencies
```xml
<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-tracing-bridge-otel</artifactId>
</dependency>
<dependency>
    <groupId>io.opentelemetry</groupId>
    <artifactId>opentelemetry-exporter-zipkin</artifactId>
</dependency>
```

### application.yml
```yaml
management:
  tracing:
    sampling:
      probability: 1.0   # 100% in dev, reduce to 0.1 in high-traffic prod
  zipkin:
    tracing:
      endpoint: ${ZIPKIN_ENDPOINT:http://localhost:9411/api/v2/spans}

logging:
  pattern:
    correlation: "[${spring.application.name},%X{traceId:-},%X{spanId:-}]"
```

Trace IDs are automatically added to logs. Cross-service calls propagate trace context via HTTP headers.

---

## Health Checks — Custom Indicators
```java
@Component
public class DatabaseHealthIndicator implements HealthIndicator {

    private final DataSource dataSource;

    @Override
    public Health health() {
        try (var conn = dataSource.getConnection();
             var stmt = conn.prepareStatement("SELECT 1")) {
            stmt.execute();
            return Health.up()
                .withDetail("database", "PostgreSQL")
                .withDetail("status", "Connected")
                .build();
        } catch (SQLException e) {
            return Health.down()
                .withDetail("error", e.getMessage())
                .build();
        }
    }
}
```

---

## Observability Checklist (per feature)
- [ ] Service methods log entry (INFO), success (INFO), business failures (WARN), errors (ERROR)
- [ ] No PII or secrets in any log line
- [ ] Correlation ID propagated across all layers
- [ ] Business metrics instrumented: counters for key outcomes, timers for latency
- [ ] `@Observed` or manual timer on externally-called service methods
- [ ] Distributed tracing configured and trace IDs appear in logs
- [ ] Custom health indicator if feature depends on external resource
- [ ] Actuator `/health` and `/prometheus` endpoints accessible to monitoring
- [ ] Log levels correct: DEBUG for detail, INFO for business events, WARN for recoverable, ERROR for unexpected
