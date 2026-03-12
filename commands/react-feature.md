---
name: react-feature
description: Implement a Feature Card (FDD) in the React frontend. Same pipeline as flutter-feature; consumes the same OpenAPI contract and Feature Card.
usage: /rushee:react-feature <FDD-NNN>
example: /rushee:react-feature FDD-001
---

Invoke the **react-implementer** agent to implement the feature in the React client.

**Prerequisites:** Feature Card (`docs/features/FDD-NNN.md`), OpenAPI spec, screen inventory. Frontend project (e.g. Vite + React + TypeScript) with OpenAPI client generation.

**Rule:** Same contract-first discipline as Flutter. Domain pure; no API calls in components. Use design tokens.

**Output:** Feature implemented with clean layers and tests. Run `/rushee:status` for full-stack review if backend is Spring Boot.
