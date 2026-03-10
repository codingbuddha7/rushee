---
description: Write or review Gherkin specs for a Feature Card. Invokes gherkin-writer then spec-guardian.
argument-hint: <FDD-NNN or feature description>
allowed-tools: [Read, Write, Glob, Grep]
---

Invoke the `gherkin-writer` agent for feature: $ARGUMENTS

Then immediately invoke `spec-guardian` to validate the generated Gherkin for implementation leakage.
Do not proceed to step definitions until spec-guardian gives a clean report.
