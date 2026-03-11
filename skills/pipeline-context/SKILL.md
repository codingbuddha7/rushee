---
name: pipeline-context
description: >
  This skill should be used when someone wants to skip one or more pipeline phases,
  join the pipeline at a specific phase, or when the project already has existing
  artifacts (designs, domain models, API specs) that predate Rushee. Triggers on:
  "skip phase", "start from phase", "I already have", "existing design",
  "existing API spec", "existing domain model", "I don't need UX discovery",
  "jump to", "begin at", "skip to", "bypass", "we already did the design",
  "existing codebase", "retrofit Rushee", "we have a Figma already",
  "we have an OpenAPI spec already", "start at feature", "start at implementation",
  "skip event storming", "skip UX", "skip BDD", or any request to begin
  mid-pipeline. Also fires automatically at session start when Rushee detects
  existing artifacts that indicate a specific pipeline stage has been reached.
version: 1.0.0
allowed-tools: [Read, Write, Bash, Glob]
---

# Pipeline Context Skill

## The Rule
**Every phase has prerequisites. You can skip a phase only if you provide its
outputs.** Rushee does not care how the outputs were produced — by a previous
Rushee session, by your team, by an existing design agency, or by hand.
What it cares about is that the files exist and are complete enough for the
downstream phase to consume.

---

## Phase Dependency Map

```
Phase 0: UX Discovery
  Outputs: docs/ux/personas.md
           docs/ux/job-stories.md        ← contains domain event list
           docs/ux/screen-inventory.md
           docs/ux/navigation-map.md
           docs/ux/wireframe-specs/*.md
  Skip condition: Provide these files (or a subset) manually
  Minimum to skip to Phase 1: docs/ux/job-stories.md with domain events listed

Phase 1a: Event Storming
  Reads:   docs/ux/job-stories.md (if exists)
  Outputs: docs/architecture/context-map.md
           docs/architecture/event-timeline.md
           docs/architecture/subdomains.md
  Skip condition: Provide docs/architecture/context-map.md

Phase 1b: DDD Model
  Reads:   docs/architecture/context-map.md        ← REQUIRED
           docs/ux/job-stories.md                  ← if exists
  Outputs: docs/domain/<context>/domain-model.md
           backend/src/main/java/.../domain/ skeleton (or src/... if backend at root)
  Skip condition: Provide docs/domain/<context>/domain-model.md

Phase 2a: Feature Card
  Reads:   docs/ux/screen-inventory.md             ← if exists
           docs/domain/<context>/domain-model.md   ← if exists
           docs/architecture/context-map.md        ← if exists
  Outputs: docs/features/FDD-NNN.md
  Skip condition: Provide docs/features/FDD-NNN.md

Phase 2b: API Contract
  Reads:   docs/features/FDD-NNN.md                ← REQUIRED
           docs/domain/<context>/domain-model.md   ← if exists
  Outputs: backend/src/main/resources/api/<context>-api.yaml (or src/... if backend at root)
  Skip condition: Provide the OpenAPI spec file

Phase 3a: BDD Gherkin
  Reads:   docs/features/FDD-NNN.md                ← REQUIRED
  Outputs: backend/src/test/resources/features/.../*.feature (or src/... if backend at root)
  Skip condition: Provide the .feature file(s)

Phase 3b: ATDD Wire
  Reads:   backend/src/test/resources/features/.../*.feature (or src/...)  ← REQUIRED
  Outputs: backend/src/test/java/.../steps/*Steps.java (RED) (or src/... if backend at root)
  Skip condition: Provide step definitions in RED state

Phase 4: Implementation
  Reads:   *Steps.java (RED)                        ← REQUIRED (backend)
           docs/features/FDD-NNN.md                 ← REQUIRED (Flutter)
           docs/ux/screen-inventory.md              ← REQUIRED (Flutter)
           api/<context>-api.yaml                   ← REQUIRED (Flutter)
  No skip condition — this phase must be implemented
```

---

## How to Skip Phases

### Option A — Declare existing artifacts at session start

Tell Claude what you already have:

```
"We already have:
  - Figma designs approved (skipping UX Discovery — I'll provide screen inventory)
  - Domain model documented (skipping Event Storming and DDD Model)
  - OpenAPI spec at backend/src/main/resources/api/order-api.yaml
  We want to start from Phase 3 — BDD Gherkin for FDD-001."
```

Claude will:
1. Check which required files exist on disk
2. Create stub files for any required-but-missing upstream outputs
3. Confirm what CAN be derived from existing artifacts
4. Start the requested phase

### Option B — Use the bootstrap command

```
/rushee:bootstrap <phase> <FDD-NNN>
```

Examples:
```
/rushee:bootstrap phase-1 order-management    ← skip UX, start at event-storm
/rushee:bootstrap phase-2 FDD-001             ← skip domain design, start at feature card
/rushee:bootstrap phase-3 FDD-001             ← skip feature+contract, start at BDD
/rushee:bootstrap phase-4 FDD-001             ← skip BDD, start at implementation
```

The bootstrap command (defined in commands/bootstrap.md) runs the pre-flight
check for the target phase, creates any missing stub files, and launches the
appropriate agent.

### Option C — Provide artifacts manually then run the normal command

Create the files the next phase requires, then run the command as normal.
Every agent checks for its required inputs first and reads them if present.

---

## Stub File Templates

All paths below assume you run from **project root**. Backend paths use `backend/` when your backend lives in a `backend/` folder; if backend is at project root, use `src/` instead of `backend/src/`.

### Minimum stub for skipping UX Discovery (to Phase 1)

Create `docs/ux/job-stories.md`:
```markdown
# Job Stories — <AppName>
<!-- Minimum required: at least 3 job stories with domain events -->

## JS-001
When <situation>,
I want to <motivation>,
so I can <outcome>.

→ Domain events revealed: <EventName1>, <EventName2>
→ Screens required: <Screen Name>

## JS-002
[...]
```

### Minimum stub for skipping Event Storming (to Phase 1b DDD)

Create `docs/architecture/context-map.md`:
```markdown
# Context Map — <AppName>

## Bounded Contexts

### <ContextName> (Core Domain)
Responsibility: <one sentence>
Key events: <EventName1>, <EventName2>
Relationships: <upstream/downstream context>

### <ContextName2> (Supporting Domain)
[...]

## Context Relationships
<ContextA> → <ContextB>: Customer/Supplier
[...]
```

### Minimum stub for skipping DDD Model (to Phase 2a Feature)

Create `docs/domain/<context>/domain-model.md`:
```markdown
# Domain Model — <ContextName>

## Aggregates
### <AggregateName> (Aggregate Root)
Properties: <field: type>, <field: type>
Invariants: <business rule>
Raises: <EventName> on <action>

## Value Objects
### <ValueObjectName>
Properties: <field: type>

## Repository
<AggregateName>Repository: find by id, save, findByX
```

### Minimum stub for skipping Feature Card (to Phase 2b API)

Create `docs/features/FDD-NNN.md`:
```markdown
# Feature: <Title>
**ID**: FDD-NNN
**Domain**: <context>
**Actor**: <role>
**Status**: DRAFT

## Feature Statement
<verb> the <result> for a(n) <object>

## Acceptance Criteria
- [ ] Given <context>, when <action>, then <outcome>

## Screens
| Screen ID | Screen Name | Figma Status |
|-----------|------------|--------------|
| S01       | <name>     | ✅ Approved  |
```

### Minimum stub for skipping API Contract (to Phase 3 BDD)

The actual OpenAPI YAML file must exist. No stub is sufficient —
if you're skipping contract design, the spec must be real and complete:
```
backend/src/main/resources/api/<context>-api.yaml
```
If you have an existing spec in a different location, copy it there.

---

## What Each Agent Does With Skipped-Phase Outputs

When an upstream phase was skipped and its outputs were provided manually,
each downstream agent reads those outputs and explicitly acknowledges them:

**event-stormer** (if UX was skipped):
```
"I can see docs/ux/job-stories.md exists with [N] job stories and [N] domain
events already extracted. I'll use these as the starting point rather than
running the full discovery conversation. Proceeding with event timeline..."
```

**domain-modeller** (if event-storm was skipped):
```
"docs/architecture/context-map.md found. Reading [N] contexts.
Proceeding directly to tactical model design for <ContextName>..."
```

**feature-analyst** (if domain model was skipped):
```
"No domain-model.md found for this context. I'll proceed without it,
but be aware that Feature Card terminology may not align with a formal
domain model. Consider running /rushee:ddd-model <context> at any time
to formalise the domain design."
```

**gherkin-writer** (if feature card was provided manually):
```
"Reading FDD-NNN.md. [N] acceptance criteria found.
Writing Gherkin scenarios from the existing Feature Card..."
```

---

## Tradeoffs When Skipping

| Phase skipped | Risk | Mitigation |
|--------------|------|-----------|
| UX Discovery | Screen inventory missing → flutter-implementer blocked | Create docs/ux/screen-inventory.md stub |
| Event Storming | Domain events not mapped → context map may be wrong | Provide context-map.md manually |
| DDD Model | Feature Card may use anemic language | Provide domain-model.md stub or accept the risk |
| Feature Card | No acceptance criteria for BDD | Must provide FDD-NNN.md — no workaround |
| API Contract | Both codebases will hand-write DTOs | Must provide api.yaml — no workaround |
| BDD/ATDD | No executable acceptance tests | Guard: tdd-implementer warns, requires explicit override |

---

## Retrofitting Rushee onto an Existing Codebase

If you have an existing Spring Boot + Flutter codebase that didn't use Rushee:

```
Step 1: Run /rushee:event-storm
  Tell the agent: "We have an existing system. Let's map what we have."
  This produces a context map from existing code, not greenfield discovery.

Step 2: Run /rushee:ddd-model <context>
  Tell the agent: "Here are the existing domain classes: [list them]"
  This produces a domain model doc from existing code.

Step 3: For new features, run the full pipeline from /rushee:feature
  Existing code is not retroactively forced through the pipeline.
  New code must follow the full discipline.

Step 4: Hooks apply to new files only
  guard-domain-purity: fires only on new writes to domain/ — won't block
  existing files. But you'll be warned if you touch an existing domain class
  that has Spring annotations.
```
