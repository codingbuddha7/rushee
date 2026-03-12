---
name: nest-ports-adapters
description: >
  Use when building NestJS (TypeScript) backends with Rushee's pipeline. Domain at center;
  ports and adapters; contract-first. Triggers on: "NestJS", "Nest", "TypeScript backend",
  "Nest domain", "Nest layer", "Nest controller", "Cucumber TypeScript".
version: 1.0.0
allowed-tools: [Read, Write, Glob]
---

# NestJS Ports & Adapters (Rushee-style)

Same pipeline: **domain** (pure TypeScript, no Nest), **application** (use cases), **infrastructure** (controllers, repos, DB).

## Project structure

```
src/
├── domain/           # Pure TS — no @nestjs, no typeorm
│   ├── entities/
│   ├── repositories/  # interfaces
│   └── events/
├── application/      # Use cases, DTOs
└── infrastructure/
    ├── web/          # Controllers (thin)
    ├── persistence/  # Repository impls (TypeORM/Prisma)
    └── api/          # OpenAPI spec
```

## Rules

- **Domain:** No NestJS, no TypeORM, no Express. Pure TypeScript.
- **Controllers:** Call application service only; validate at boundary.
- **Contract:** Same OpenAPI spec; generate DTOs or use openapi-typescript.
- **BDD:** Cucumber (e.g. cucumber-ts) or similar; steps call application.
