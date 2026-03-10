---
name: spring-boot-patterns
description: >
  This skill should be used when making any architectural or structural decision in a Spring
  Boot project: creating a new class, choosing between @Service vs @Component, deciding on
  REST vs messaging, designing a DTO, choosing fetch strategy, or structuring a package.
  Also triggers on: "how should I structure", "best practice for", "Spring Boot pattern",
  "should I use @Transactional here", "how to test this Spring component".
version: 1.0.0
allowed-tools: [Read, Glob, Grep]
---

# Spring Boot Patterns Reference Skill

## Package Structure (Hexagonal / Ports & Adapters)
```
src/main/java/<base-package>/
├── <domain>/                      # One package per bounded context
│   ├── api/                       # Inbound adapters (Controllers, listeners)
│   │   ├── <Domain>Controller.java
│   │   └── dto/
│   │       ├── <Domain>Request.java   # Records (immutable)
│   │       └── <Domain>Response.java  # Records (immutable)
│   ├── application/               # Use case orchestration
│   │   ├── <Domain>Service.java       # Interface (port)
│   │   └── <Domain>ServiceImpl.java   # Implementation
│   ├── domain/                    # Pure domain model (no Spring annotations)
│   │   ├── <Entity>.java
│   │   └── <DomainException>.java
│   └── infrastructure/            # Outbound adapters (JPA, REST clients)
│       ├── <Domain>Repository.java    # Spring Data interface
│       └── <Domain>JpaEntity.java     # @Entity (separate from domain model)
```

## REST Controller Pattern
```java
@RestController
@RequestMapping("/api/<domain>")
@Validated
@RequiredArgsConstructor  // Lombok constructor injection
public class <Domain>Controller {

    private final <Domain>Service <domain>Service;  // Interface, not impl

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public <Domain>Response create(@Valid @RequestBody <Domain>Request request) {
        return <domain>Service.create(request);
    }

    @GetMapping("/{id}")
    public <Domain>Response findById(@PathVariable String id) {
        return <domain>Service.findById(id)
            .orElseThrow(() -> new <Domain>NotFoundException(id));
    }

    @ExceptionHandler(<Domain>NotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ProblemDetail handleNotFound(<Domain>NotFoundException ex) {
        return ProblemDetail.forStatusAndDetail(HttpStatus.NOT_FOUND, ex.getMessage());
    }
}
```

## Service Layer Pattern
```java
// Interface — define the port
public interface <Domain>Service {
    <Domain>Response create(<Domain>Request request);
    Optional<<Domain>Response> findById(String id);
}

// Implementation — @Transactional at method level, not class level
@Service
@RequiredArgsConstructor
public class <Domain>ServiceImpl implements <Domain>Service {

    private final <Domain>Repository repository;

    @Override
    @Transactional
    public <Domain>Response create(<Domain>Request request) {
        var entity = <Domain>Mapper.toEntity(request);
        var saved = repository.save(entity);
        return <Domain>Mapper.toResponse(saved);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<<Domain>Response> findById(String id) {
        return repository.findById(id).map(<Domain>Mapper::toResponse);
    }
}
```

## DTO Pattern (Java Records)
```java
// Request — validated at controller boundary
public record <Domain>Request(
    @NotBlank(message = "Name is required")
    @Size(max = 100)
    String name,

    @NotNull
    @Positive
    Integer quantity
) {}

// Response — never expose entity directly
public record <Domain>Response(
    String id,
    String name,
    Integer quantity,
    String status,
    Instant createdAt
) {}
```

## Domain Exception Pattern
```java
// Base class
public abstract class <Domain>Exception extends RuntimeException {
    protected <Domain>Exception(String message) { super(message); }
}

// Specific exceptions
public class <Domain>NotFoundException extends <Domain>Exception {
    public <Domain>NotFoundException(String id) {
        super("<Domain> not found: " + id);
    }
}

public class <Domain>BusinessRuleException extends <Domain>Exception {
    public <Domain>BusinessRuleException(String rule) {
        super("Business rule violation: " + rule);
    }
}
```

## @Transactional Rules
- **Service methods that write**: `@Transactional`
- **Service methods that read**: `@Transactional(readOnly = true)`
- **Never on controller methods**
- **Never on repository methods** (Spring Data handles this)
- **Propagation.REQUIRES_NEW**: only when you explicitly need a new transaction boundary

## Testing Technology Choices by Layer
| Layer | Test Type | Annotation | What to Mock |
|-------|-----------|------------|--------------|
| Controller | Slice | `@WebMvcTest` | Service with `@MockBean` |
| Service | Unit | None (plain) | Repos with `@Mock` / `@InjectMocks` |
| Repository | Slice | `@DataJpaTest` | Nothing — uses embedded DB |
| Integration | Full | `@SpringBootTest` | External services only |
| Acceptance | Full | `@SpringBootTest` + Cucumber | External HTTP APIs |

## Application Properties Structure
```
src/main/resources/
├── application.yml              # Shared config
├── application-dev.yml          # Dev overrides
├── application-test.yml         # Test overrides (auto-loaded by @SpringBootTest)
└── application-prod.yml         # Production (secrets via env vars)
```

## Common Mistakes — Reject These
| Pattern | Why it's wrong | Do this instead |
|---------|---------------|-----------------|
| `@Autowired` on fields | Hides dependencies, hard to test | Constructor injection |
| Entity directly in response | Exposes internals, causes lazy load issues | DTO / record |
| Logic in controller | Untestable without HTTP | Move to service |
| `@Transactional` on controller | Wrong layer | Service method |
| Spring bean in domain model | Couples domain to framework | Pure domain class |
| Repository injected in controller | Skips service layer | Via service only |
