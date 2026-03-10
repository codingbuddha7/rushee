---
name: api-design
description: Design a REST API or async messaging contract using OpenAPI 3.1 before any controller or listener code is written. Contract-first enforced.
usage: /rushee:api-design <FDD-NNN | feature description>
example: /rushee:api-design FDD-003
example: /rushee:api-design "order placement and tracking endpoints"
---

Invoke the **api-designer** agent to produce a reviewed API contract.

This command:
1. Reads the Feature Card and domain model for context
2. Identifies all required operations and their consumers
3. Drafts a complete OpenAPI 3.1 spec (or AsyncAPI for events)
4. Asks for your review before saving
5. Saves the spec to `src/main/resources/api/`
6. Documents async event schemas to `docs/architecture/events/`

**When to use**: After the Feature Card exists (`/rushee:feature`), before writing any controller.

**Output**:
- `src/main/resources/api/<context>-api.yaml`
- `docs/architecture/events/<EventName>.md` (for each published event)

**Rule enforced**: No controller code until the spec is reviewed and saved.
All errors use RFC 7807 Problem Detail. All collections have pagination.
