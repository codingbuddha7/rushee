---
name: bootstrap
description: >
  Join the Rushee pipeline at any phase, skipping earlier phases when their
  outputs already exist or when you choose to provide them manually.
  Use this when starting mid-pipeline, retrofitting Rushee onto an existing
  project, or when a team already has designs, domain models, or API specs
  that predate Rushee.
usage: /rushee:bootstrap <phase> [FDD-NNN | context-name]
example: /rushee:bootstrap phase-0        → run UX discovery (default start)
example: /rushee:bootstrap phase-1        → skip UX, start at event-storm
example: /rushee:bootstrap phase-1b order → skip event-storm, model a context
example: /rushee:bootstrap phase-2 FDD-001 → skip domain design, write feature card
example: /rushee:bootstrap phase-3 FDD-001 → skip feature+contract, start at BDD
example: /rushee:bootstrap phase-4 FDD-001 → skip BDD, go straight to implementation
example: /rushee:bootstrap phase-4f FDD-001 → Flutter implementation only
example: /rushee:bootstrap retrofit        → join existing codebase mid-project
---

Invoke the **pipeline-bootstrapper** agent to run a pre-flight check for
the target phase, identify any missing required files, help create stub files
for skipped phases, and then launch the correct agent.

This command:
1. Checks which files the target phase requires
2. Reports what exists vs what is missing
3. For each missing file: offers to create a stub interactively OR
   explains the minimum content required to create it manually
4. Once all prerequisites are met, launches the target phase's agent

**Phase reference:**
| Phase | Command | Requires |
|-------|---------|----------|
| phase-0 | ux-discovery | nothing |
| phase-1 | event-storm | docs/ux/job-stories.md (optional) |
| phase-1b | ddd-model | docs/architecture/context-map.md |
| phase-2 | feature | docs/domain/*/domain-model.md (optional) |
| phase-3 | bdd-spec | docs/features/FDD-NNN.md + api.yaml |
| phase-4 | tdd-cycle | feature file + step defs (RED) |
| phase-4f | angular-feature (default) or flutter-feature / react-feature / svelte-feature | feature card + screen inventory + api.yaml |
| retrofit | — | scans existing codebase, maps to pipeline state |

**Skipping phases is valid. Skipping prerequisites is not.**
The bootstrapper helps you satisfy prerequisites quickly when you skip.
