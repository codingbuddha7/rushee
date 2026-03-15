---
name: skill-map
description: Show a visual skill tree and phase–skill mapping. Each node can be marked as "covered in this phase" or "prerequisite needed". Helps juniors see the full roadmap.
usage: /rushee:skill-map
example: /rushee:skill-map
allowed-tools: [Read, Glob]
---

Output the **Rushee skill map** as a visual tree and a phase–skill table.

1. **Print the dependency chain** as a clear ASCII or markdown diagram, for example:

```
    UX Discovery (personas, job stories)
        → Event Storming (bounded contexts, domain events)
            → DDD Strategic (context map)
                → DDD Tactical (aggregates, entities, value objects)
                    → Feature Design (Feature Card)
                        → API Design (OpenAPI contract)
                            → BDD / Gherkin (acceptance scenarios)
                                → ATDD (step defs, RED)
                                    → TDD (outside-in, backend)
                                        → Frontend (clean layers, state, contract client)
                                            → Security & Status
```

2. **Print the phase–skill table** so each phase shows:
   - Phase number and command (e.g. Phase 3: `/rushee:bdd-spec`)
   - Skills/concepts needed
   - Rushee skill(s) that cover it
   - "If new, ask" prompt

3. **Optional:** If the repo has been scanned (e.g. user ran `/rushee:start` or scan is available), mark the current "next phase" so the developer can see what they need for the immediate next step.

**Phase–skill table:**

| Phase | Command | Skills needed | If new, ask |
|-------|---------|---------------|-------------|
| 0 | ux-discovery | Personas, job stories, screen inventory | "Explain job stories vs user stories" |
| 1 | event-storm | Bounded contexts, domain events, context map | "What is event storming?" / "Explain bounded contexts" |
| 1b | ddd-model | Aggregates, entities, value objects | "Explain aggregates and value objects" / "Why no @Entity in domain?" |
| 2 | feature | Feature Card, acceptance criteria | "What goes in a Feature Card?" |
| 2b | api-design | REST, OpenAPI 3.1, contract-first | "Explain contract-first API design" |
| 3 | bdd-spec | BDD, Gherkin (Given/When/Then) | "Explain Gherkin and BDD" |
| 3b | atdd-run | Cucumber-JVM, step definitions, RED-first | "How do step definitions work?" |
| 4 | tdd-cycle | Outside-in TDD, ports & adapters | "Explain outside-in TDD" / "What are ports and adapters?" |
| 4f | angular-feature / flutter-feature | Clean layers, state, design tokens, API client | "Explain clean architecture on the frontend" |
| 5 | security-check | OWASP, auth, mobile security | "What should I check for security?" |

Do not invoke any other agent. Just output the map and table.
