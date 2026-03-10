---
name: ddd-model
description: Design the tactical domain model for a bounded context — aggregates, entities, value objects, domain events, and repositories. Run after event-storm, before writing Feature Cards.
usage: /rushee:ddd-model <bounded-context-name>
example: /rushee:ddd-model order-management
---

Invoke the **domain-modeller** agent for the specified bounded context.

This command:
1. Reads the context map and ubiquitous language glossary
2. Identifies aggregates and their roots
3. Distinguishes entities from value objects
4. Defines domain events to raise on significant state changes
5. Specifies repository interfaces (domain layer, no Spring)
6. Generates skeleton domain classes with rich behaviour

**When to use**: After `/rushee:event-storm` for each Core or Supporting subdomain.
Before writing any Feature Card for that context.

**Output**:
- `docs/domain/<context>/domain-model.md`
- `docs/ubiquitous-language/<context>.md`
- Skeleton classes in `src/main/java/<base>/<context>/domain/`

**Rule enforced**: No `@Entity`, no Spring annotations, no public setters in domain classes.
