---
name: go-ports-adapters
description: >
  Use when building Go backends with Rushee's pipeline. Domain at center; ports and adapters;
  contract-first. Triggers on: "Go", "Golang", "Echo", "Gin", "Go backend", "Godog",
  "Go domain", "Go layer", "Go handler".
version: 1.0.0
allowed-tools: [Read, Write, Glob]
---

# Go Ports & Adapters (Rushee-style)

Same pipeline: **domain** (pure Go, no HTTP/DB), **application** (use cases), **infrastructure** (handlers, repos, DB).

## Project structure

```
cmd/api/
internal/
├── domain/           # Pure Go — no net/http, no sql
│   ├── entity/
│   ├── repository/    # interfaces
│   └── event/
├── application/       # Use cases, DTOs
└── infrastructure/
    ├── http/          # Handlers (thin)
    ├── persistence/   # Repository impls
    └── openapi/       # Spec, generated or hand-held
```

## Rules

- **Domain:** No net/http, no database/sql, no framework. Pure Go types and interfaces.
- **Handlers:** Call application service only; decode/encode at boundary.
- **Contract:** Same OpenAPI spec; use oapi-codegen or similar for types/handlers.
- **BDD:** Godog for Gherkin; steps call application layer.
