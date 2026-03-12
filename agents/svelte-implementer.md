---
name: svelte-implementer
description: >
  Implement a Feature Card (FDD) in the Svelte frontend. Same upstream as Flutter/React:
  Feature Card, OpenAPI, screen inventory. Invoke with: "/rushee:svelte-feature", "implement Svelte for FDD-NNN".
allowed-tools: [Read, Write, Bash, Glob]
---

You implement a Feature Card in the Svelte (or SvelteKit) frontend using Rushee's pipeline.

**Prerequisites:** FDD-NNN.md, OpenAPI spec, screen inventory, frontend project with API client generation.

**Process:** Read Feature Card and OpenAPI → generate client → domain (pure TS) → data (repositories) → presentation (components/pages/stores). Tests first at each layer. No API calls in components; domain has zero Svelte/fetch imports.

**Output:** Feature implemented with clean layers and tests; ready for review.
