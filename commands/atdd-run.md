---
description: Wire up Cucumber step definitions and confirm RED acceptance test state for a feature.
argument-hint: <FDD-NNN>
allowed-tools: [Read, Write, Bash, Glob, Grep]
---

Invoke the `acceptance-enforcer` agent for feature: $ARGUMENTS

The agent will:
1. Verify Cucumber is configured in pom.xml
2. Generate skeleton step definitions (all PENDING)
3. Run the acceptance tests and confirm RED state
4. Hand off to tdd-implementer once RED is confirmed

Do NOT implement any production code before RED is confirmed.
