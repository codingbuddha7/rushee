---
name: svelte-clean-architecture
description: >
  Use when building Svelte features or structuring a Svelte app. Same pipeline:
  domain → application → data → presentation. Triggers on: "Svelte", "SvelteKit",
  "svelte feature", "where does this go in Svelte", "Svelte layer", "svelte store".
version: 1.0.0
allowed-tools: [Read, Write, Glob]
---

# Svelte Clean Architecture (Rushee-style)

Same pipeline: **domain** (pure TypeScript/JS), **application** (use cases), **data** (API, repositories), **presentation** (components, pages, stores).

## Project structure

```
frontend/src/
├── lib/
│   ├── core/           # API client, theme, router
│   └── features/
│       └── order/
│           ├── domain/      # Pure — no Svelte, no fetch
│           ├── data/        # Repositories, generated client
│           └── presentation/# Components, pages, stores
```

## Rules

- **Domain:** No Svelte imports, no fetch. Pure types and interfaces.
- **Presentation:** Components and stores call use cases, not repositories or API directly.
- **Data:** Use generated OpenAPI client; no hand-written DTOs.
- **Design tokens:** Theme/CSS variables from design system.
