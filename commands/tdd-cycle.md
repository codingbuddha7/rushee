---
description: Run the TDD inner Red-Green-Refactor cycle to implement a feature layer by layer.
argument-hint: <FDD-NNN> [layer: controller|service|repository]
allowed-tools: [Read, Write, Bash, Glob, Grep]
---

**Skills needed for this phase:** Outside-in TDD, ports & adapters, domain purity (no framework in domain). Rushee skills: tdd-red-green-refactor, clean-architecture-ports-adapters, spring-boot-patterns.
**New to this?** Say: "Explain outside-in TDD" or "What are ports and adapters?" — then we'll run the tdd-implementer.

Invoke the `tdd-implementer` agent for: $ARGUMENTS

The agent will:
1. Work outside-in: Controller → Service → Repository
2. Write ONE failing test per step
3. Implement minimum code to pass
4. Refactor
5. Check acceptance tests after every 3-4 unit tests
6. Report DONE when both streams are GREEN

Remember: ONE test at a time. No skipping.
