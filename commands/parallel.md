---
name: parallel
description: Dispatch parallel agents to implement independent layers of a feature simultaneously, or set up parallel worktrees for multiple features in a sprint.
usage: /rushee:parallel <FDD-NNN | sprint>
example: /rushee:parallel FDD-004
example: /rushee:parallel sprint-3
---

Invoke the **parallel-dispatcher** agent to plan and dispatch parallel implementation work.

This command:
1. Analyses the feature (or sprint) for independent work units
2. Defines file ownership for each agent (no conflicts)
3. Produces per-agent dispatch instructions
4. Sets up git worktrees if running multiple features
5. Defines sync points where agents must wait for each other

**When to use**:
- A single feature has 3+ independent layers ready to implement simultaneously
- A sprint has multiple independent feature cards
- You want to maximise implementation speed after domain model is approved

**Prerequisites**: Domain model must be APPROVED before parallelising implementation.
OpenAPI contract must exist. Acceptance tests must be RED.

**Rule enforced**: Each agent owns specific files. No two agents touch the same file.
Domain model is read-only during parallel implementation.
