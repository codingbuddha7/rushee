---
name: angular-feature
description: Implement a Feature Card (FDD) in the Angular frontend. Same contract and pipeline as other frontend commands.
usage: /rushee:angular-feature <FDD-NNN>
example: /rushee:angular-feature FDD-001
---

**Skills needed for this phase:** Clean layers (domain/data/presentation), NgRx or signals, design tokens, generated API client from OpenAPI. Rushee skills: angular-clean-architecture, openapi-contract-sync.
**New to this?** Say: "Explain clean architecture on the frontend" — then we'll run the angular-implementer.

Invoke the **angular-implementer** agent. Prerequisites: Feature Card, OpenAPI spec, screen inventory. Domain pure; no API in components. Output: feature with tests, ready for review.
