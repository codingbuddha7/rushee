---
name: security-by-design
description: >
  This skill should be used when implementing any endpoint, authentication, authorisation,
  data handling, or configuration. Triggers on: "Spring Security", "authentication",
  "authorisation", "JWT", "OAuth2", "secure endpoint", "role", "permission", "CORS",
  "CSRF", "input validation", "password", "secret", "API key", "sensitive data",
  "security review", or before any feature touches user data or access control.
  Also fires automatically during spring-reviewer final review.
version: 1.0.0
allowed-tools: [Read, Glob, Grep, Bash]
---

# Security By Design Skill

## Core Principle
Security is designed in from the start, not bolted on at the end.
Every feature that touches users, data, or external systems needs a security review.

---

## Layer 1 — Spring Security Configuration

### OAuth2 Resource Server (JWT) — Standard Setup
```java
@Configuration
@EnableWebSecurity
@EnableMethodSecurity                         // enables @PreAuthorize
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http
            .csrf(AbstractHttpConfigurer::disable)          // disabled for stateless REST
            .sessionManagement(s -> s
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/actuator/health", "/actuator/info").permitAll()
                .requestMatchers("/api/public/**").permitAll()
                .anyRequest().authenticated())
            .oauth2ResourceServer(oauth2 -> oauth2
                .jwt(jwt -> jwt.jwtAuthenticationConverter(jwtAuthConverter())))
            .build();
    }

    @Bean
    public JwtAuthenticationConverter jwtAuthConverter() {
        var converter = new JwtGrantedAuthoritiesConverter();
        converter.setAuthoritiesClaimName("roles");
        converter.setAuthorityPrefix("ROLE_");
        var jwtConverter = new JwtAuthenticationConverter();
        jwtConverter.setJwtGrantedAuthoritiesConverter(converter);
        return jwtConverter;
    }
}
```

### Method-Level Security (use this, not URL patterns for business rules)
```java
@Service
public class OrderApplicationService {

    @PreAuthorize("hasRole('CUSTOMER') and #command.customerId == authentication.name")
    public OrderDto placeOrder(PlaceOrderCommand command) { ... }

    @PreAuthorize("hasRole('ADMIN') or (hasRole('CUSTOMER') and @orderSecurityService.isOwner(#orderId, authentication))")
    public OrderDto getOrder(String orderId) { ... }

    @PreAuthorize("hasRole('ADMIN')")
    public void cancelAnyOrder(String orderId) { ... }
}
```

---

## Layer 2 — Input Validation

### Every external input MUST be validated at the boundary
```java
public record PlaceOrderRequest(
    @NotBlank(message = "Customer ID is required")
    @Pattern(regexp = "^CUST-[0-9]+$", message = "Invalid customer ID format")
    String customerId,

    @NotEmpty(message = "Order must have at least one line")
    @Size(max = 100, message = "Order cannot exceed 100 lines")
    @Valid                                        // validate nested objects
    List<OrderLineRequest> lines
) {}

public record OrderLineRequest(
    @NotBlank
    @Pattern(regexp = "^PROD-[0-9]+$")
    String productId,

    @Min(value = 1, message = "Quantity must be at least 1")
    @Max(value = 1000, message = "Quantity cannot exceed 1000")
    Integer quantity
) {}

// Controller — always use @Valid
@PostMapping
public ResponseEntity<OrderResponse> placeOrder(@Valid @RequestBody PlaceOrderRequest request) { ... }

// Global exception handler for validation errors
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ProblemDetail handleValidation(MethodArgumentNotValidException ex) {
        var detail = ProblemDetail.forStatus(HttpStatus.BAD_REQUEST);
        detail.setTitle("Validation Failed");
        detail.setProperty("errors", ex.getBindingResult().getFieldErrors().stream()
            .map(e -> Map.of("field", e.getField(), "message", e.getDefaultMessage()))
            .toList());
        return detail;
    }
}
```

---

## Layer 3 — Secrets Management

### NEVER hardcode secrets — Zero Tolerance
```java
// ❌ NEVER DO THIS
@Value("${spring.datasource.password:mypassword123}")  // default value in code
private String dbPassword;

private static final String API_KEY = "sk-abc123";   // hardcode
```

```yaml
# ✅ Environment variables only in production
spring:
  datasource:
    url: ${DATABASE_URL}
    username: ${DATABASE_USERNAME}
    password: ${DATABASE_PASSWORD}     # injected at runtime from vault/env

jwt:
  secret: ${JWT_SECRET}               # never in application.yml
```

```bash
# Scan for secrets in code before every commit
grep -r "password\s*=\s*['\"][^$]" src/ --include="*.java" --include="*.yml"
grep -r "secret\s*=\s*['\"][^$]" src/ --include="*.java" --include="*.yml"
grep -r "api.key\s*=\s*['\"][^$]" src/ --include="*.java" --include="*.yml"
```

Use **Spring Cloud Vault** or **AWS Secrets Manager** for production secret management.

---

## Layer 4 — OWASP Top 10 Checklist for Spring Boot

### A01 — Broken Access Control
- [ ] Every endpoint has explicit authorisation (`@PreAuthorize` or `authorizeHttpRequests`)
- [ ] Object-level access control (can user A access resource owned by user B?)
- [ ] Admin endpoints restricted to ADMIN role
- [ ] No directory traversal possible in file operations

### A02 — Cryptographic Failures
- [ ] Passwords hashed with BCrypt (cost factor ≥ 12): `new BCryptPasswordEncoder(12)`
- [ ] Sensitive data encrypted at rest (PII, payment data)
- [ ] HTTPS enforced (no plain HTTP in production)
- [ ] JWT using RS256 or ES256 (not HS256 with weak secrets)

### A03 — Injection
- [ ] No `@Query` with string concatenation — use `@Query("... WHERE id = :id")`
- [ ] No `JdbcTemplate` with `String.format()` — use `?` placeholders
- [ ] Input validated and sanitised before use in queries

### A04 — Insecure Design
- [ ] Threat model reviewed for this feature
- [ ] Business logic limits enforced (max order value, rate limiting)

### A05 — Security Misconfiguration
- [ ] Actuator endpoints secured (only health/info public)
- [ ] Spring Security defaults overridden explicitly (never rely on defaults)
- [ ] Error messages don't leak stack traces or internal details
- [ ] CORS configured restrictively (not `allowedOrigins("*")`)

### A06 — Vulnerable Components
- [ ] `./mvnw dependency:check` — OWASP dependency check passes
- [ ] No critical CVEs in dependencies

### A07 — Authentication Failures
- [ ] No session fixation (stateless JWT — no sessions)
- [ ] JWT expiry enforced (access token ≤ 15 min, refresh token ≤ 24h)
- [ ] Refresh token rotation implemented

### A08 — Software Integrity
- [ ] Dependency checksums verified (Maven enforcer plugin)
- [ ] No unverified third-party scripts

### A09 — Logging & Monitoring Failures
- [ ] Security events logged: login attempts, access denials, privilege changes
- [ ] No PII in logs (mask credit card numbers, passwords, tokens)
- [ ] Structured logging with correlation IDs

### A10 — SSRF (Server-Side Request Forgery)
- [ ] External URLs validated against allowlist before fetching
- [ ] No user-controlled URLs passed to `RestTemplate` or `WebClient`

---

## Security Review Gate
Before any feature touching auth/data is merged:
```
SECURITY REVIEW — <feature>
════════════════════════════
Endpoints secured:         ✅/❌
Input validated:           ✅/❌
No hardcoded secrets:      ✅/❌
OWASP A01-A10 checked:     ✅/❌
Dependency scan clean:     ✅/❌
────────────────────────────
APPROVED / CHANGES REQUIRED
```
