---
name: react-clean-architecture
description: >
  Use when building React features, structuring a React app, or deciding where logic
  belongs. Same pipeline as Rushee: domain → application → data → presentation.
  Triggers on: "React", "Vite", "React Query", "Zustand", "TanStack", "react feature",
  "where does this go in React", "React layer", "react repository", "react use case".
version: 1.0.0
allowed-tools: [Read, Write, Glob]
---

# React Clean Architecture (Rushee-style)

Same pipeline as Flutter/Spring: **domain** (pure TypeScript), **application** (use cases), **data** (API client, repositories), **presentation** (components, pages, state).

## Project structure (per feature / bounded context)

```
frontend/src/
├── core/                    # Theme, router, API client, DI
│   ├── theme/
│   ├── api/                 # Generated OpenAPI client or axios/fetch wrapper
│   └── router/
└── features/
    └── order/
        ├── domain/          # Pure TS — no React, no fetch
        │   ├── entities/
        │   ├── repositories/  # interfaces
        │   └── usecases/
        ├── data/
        │   ├── api/         # implementation using generated client
        │   └── repositories/
        └── presentation/
            ├── components/
            ├── pages/
            └── hooks/       # or Zustand/React Query for state
```

## Rules

- **Domain:** No `react`, no `fetch`, no `axios`. Pure TypeScript types and interfaces.
- **Presentation:** Components and pages call **use cases** (or hooks that wrap use cases), never repositories or API directly.
- **Data:** Repository implementations use the **generated OpenAPI client**; no hand-written DTOs.
- **Design tokens:** Use a theme (CSS variables or theme object) from design tokens; no magic values in components.

## OpenAPI contract

Generate client from the same spec as backend: `openapi-generator-cli generate -g typescript-fetch -i ...` (or similar). Keep frontend in sync with contract.
