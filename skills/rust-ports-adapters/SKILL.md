---
name: rust-ports-adapters
description: >
  Use when building Rust backends (Actix, Axum) with Rushee's pipeline. Domain at center;
  ports and adapters; contract-first. Triggers on: "Rust", "Actix", "Axum", "Rust backend",
  "Rust domain", "Rust layer", "cucumber-rs", "Rust API".
version: 1.0.0
allowed-tools: [Read, Write, Glob]
---

# Rust Ports & Adapters (Rushee-style)

Same pipeline: **domain** (pure Rust, no actix/axum/sqlx), **application** (use cases), **infrastructure** (handlers, repos, DB).

## Project structure

```
src/
├── domain/           # Pure — no actix, no axum, no sqlx
│   ├── entity/
│   ├── repository/   # trait (port)
│   └── event/
├── application/      # Use cases, DTOs
└── infrastructure/
    ├── web/         # Handlers (thin)
    ├── persistence/ # Repository impls
    └── openapi/     # Spec
```

## Rules

- **Domain:** No actix, axum, sqlx, or HTTP/DB in domain crate or module. Pure Rust types and traits.
- **Handlers:** Call application service only; deserialize/serialize at boundary.
- **Contract:** Same OpenAPI spec; use openapi-generator or paperclip for types.
- **BDD:** cucumber-rs or similar; steps call application layer.
