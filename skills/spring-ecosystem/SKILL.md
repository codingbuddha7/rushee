---
name: spring-ecosystem
description: >
  Use when adopting or referencing any Spring portfolio project beyond core Boot:
  Spring AI, Spring Integration, Spring Cloud, Spring Batch, Spring Data, Spring Security,
  Spring for Apache Kafka, Spring AMQP, Spring Session, Spring HATEOAS, embedded servers, etc.
  Triggers on: "Spring AI", "Spring Integration", "Spring Cloud", "Spring Batch", "Spring Data",
  "Spring Kafka", "Spring AMQP", "Config Server", "Spring Gateway", "spring-ai", "spring-batch",
  "spring-cloud", "spring-integration", "embedded Tomcat", "when to use Spring X".
version: 1.0.0
allowed-tools: [Read, Glob, Grep]
---

# Spring Ecosystem (Rushee Default Backend)

The default Spring Boot backend in Rushee can use **any project under the Spring umbrella**. All of them belong in **infrastructure** (adapters); the **domain** layer stays pure (no Spring imports).

## Spring portfolio projects (relevant to Rushee)

| Project | Purpose | Where it lives in Rushee |
|---------|---------|---------------------------|
| **Spring Boot** | Core runtime, auto-config, embedded server (Tomcat/Jetty/Undertow) | `application/`, `infrastructure/` |
| **Spring AI** | AI/LLM integration (Chat, Embeddings, RAG, multi-provider) | `infrastructure/` (e.g. adapters calling AI APIs); domain never imports Spring AI |
| **Spring Integration** | EIP, messaging adapters, channels, gateways | `infrastructure/` (inbound/outbound adapters) |
| **Spring Cloud** | Config Server, Service Discovery, Gateway, OpenFeign, LoadBalancer, Circuit Breaker (Resilience4j) | `infrastructure/`; config/bootstrap only |
| **Spring Cloud Stream** | Binder abstraction (Kafka, Rabbit, etc.) | `infrastructure/` (listeners/senders) |
| **Spring Batch** | Batch jobs, chunking, readers/writers, job repository | `infrastructure/` (job definitions); domain logic in application or domain services |
| **Spring Data** | JPA, Redis, MongoDB, Elasticsearch, etc. | `infrastructure/persistence/` (repositories, entities) |
| **Spring Security** | AuthN/AuthZ, OAuth2, JWT | `infrastructure/web/` (filters, config); never in domain |
| **Spring for Apache Kafka** | KafkaTemplate, @KafkaListener | `infrastructure/` (listeners/producers) |
| **Spring AMQP** | RabbitMQ | `infrastructure/` |
| **Spring Session** | Session storage (Redis, JDBC) | Infrastructure / config |
| **Spring HATEOAS** | Hypermedia REST | `infrastructure/web/` (representation models) |
| **Spring Statemachine** | State machines | Application or infrastructure (not domain entities if you keep domain pure) |
| **Embedded server** | Tomcat, Jetty, Undertow (Boot default) | Runtime; no code in domain |

Reference: [Spring Projects](https://spring.io/projects) — all sub-projects follow the same principle: **domain has zero dependency on Spring**.

## Rushee rules for Spring ecosystem

1. **Domain layer:** No imports from any `org.springframework.*` or `org.springframework.*` project. No Spring AI, Spring Integration, Spring Cloud, or Spring Batch types in `domain/`.
2. **Application layer:** May use Spring for DI and `@Transactional` only; no framework-specific types (e.g. no `MessageChannel` or `ChatClient` in application if they leak abstraction). Prefer ports (interfaces) and implement in infrastructure.
3. **Infrastructure layer:** All Spring ecosystem libraries live here — REST controllers, Spring Data repositories, Spring AI clients, Spring Integration flows, Spring Cloud config clients, Spring Batch job definitions, Kafka/AMQP listeners, security filters.
4. **OpenAPI / contract:** REST APIs designed with api-designer remain the primary contract; Spring AI or messaging are implementation details behind the same domain-facing ports.

## When to use which (short guide)

- **Spring AI:** RAG, chat with docs, embeddings, multi-provider LLM — add as infrastructure adapter; application layer calls a port (e.g. `EmbeddingPort`, `ChatPort`).
- **Spring Integration:** File polling, FTP/SFTP, JMS, custom EIP flows — adapters in infrastructure; domain events can be published via a port.
- **Spring Cloud:** Microservices (config, discovery, gateway, load balancing, circuit breaker) — use when moving to multi-service; config and clients in infrastructure.
- **Spring Batch:** Bulk processing, scheduled jobs, chunked reads/writes — job configuration and item processors in infrastructure; business rules in application or domain.
- **Spring for Apache Kafka / Spring AMQP:** Event-driven features — listeners and producers in infrastructure; application layer publishes/consumes via domain events or ports.

## Adding a new Spring project to the stack

1. Add the dependency (e.g. `spring-ai-starter-open-ai`, `spring-cloud-starter-config`).
2. Create **ports** (interfaces) in domain or application that describe the capability (e.g. `VectorStorePort`, `ConfigClientPort`).
3. Implement in **infrastructure** using the Spring project's APIs.
4. Keep domain and application free of that project's types.
