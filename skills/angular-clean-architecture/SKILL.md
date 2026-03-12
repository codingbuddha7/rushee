---
name: angular-clean-architecture
description: >
  Use when building Angular features or structuring an Angular app. Same pipeline:
  domain → application → data → presentation. Triggers on: "Angular", "NgRx",
  "angular feature", "Angular layer", "angular service", "angular component".
version: 1.0.0
allowed-tools: [Read, Write, Glob]
---

# Angular Clean Architecture (Rushee-style)

Same pipeline: **domain** (pure TS models/interfaces), **application** (use cases / application services), **data** (repositories, API), **presentation** (components, NgRx or signals).

## Project structure (feature module)

```
src/app/features/order/
├── domain/           # Models, repository interfaces (pure)
├── data/             # Repositories, API service (generated client)
└── presentation/     # Components, containers, state (NgRx/signals)
```

## Rules

- **Domain:** No Angular, no HttpClient. Pure TypeScript.
- **Presentation:** Components dispatch to use cases / facades; no direct API or repository calls.
- **Data:** Use generated OpenAPI client; inject via Angular DI.
- **Design tokens:** Use theme/design system (e.g. CSS vars or Angular material theme).
