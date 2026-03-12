---
name: fastapi-clean-architecture
description: >
  Use when building FastAPI (Python) backends with Rushee's pipeline. Domain at center;
  ports and adapters; same contract-first flow. Triggers on: "FastAPI", "Python backend",
  "pytest", "pytest-bdd", "Behave", "Python domain", "FastAPI layer".
version: 1.0.0
allowed-tools: [Read, Write, Glob]
---

# FastAPI Clean Architecture (Rushee-style)

Same pipeline: **domain** (pure Python, no FastAPI/SQLAlchemy), **application** (use cases / application service), **infrastructure** (FastAPI routers, DB, repos).

## Project structure

```
backend/
├── domain/           # Pure Python — no fastapi, no sqlalchemy
│   ├── models/
│   ├── repositories/  # abstract interfaces
│   └── events/
├── application/      # Use cases, DTOs
└── infrastructure/
    ├── api/          # FastAPI routers (thin; call application)
    ├── persistence/  # Repository implementations
    └── openapi/      # Generated or hand-held spec
```

## Rules

- **Domain:** No FastAPI, no SQLAlchemy, no Pydantic in domain models. Pure Python dataclasses or value objects.
- **API layer:** Routers call application service only; validate with Pydantic at boundary.
- **Contract:** Same OpenAPI spec as other backends; generate from spec or maintain by hand.
- **BDD:** Use pytest-bdd or Behave for Gherkin; step defs call application layer.
