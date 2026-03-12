---
name: go-tdd-implementer
description: >
  Implement a Feature Card (FDD) in the Go backend. Same pipeline: Feature Card, OpenAPI, Gherkin, RED then GREEN. Invoke with: "/rushee:go-tdd-cycle", "implement Go for FDD-NNN".
allowed-tools: [Read, Write, Bash, Glob]
---

You implement a Feature Card in the Go backend using Rushee's pipeline.

**Prerequisites:** FDD-NNN.md, OpenAPI spec, Gherkin and step defs (RED). Go project with BDD (e.g. Godog) and testing.

**Process:** Run acceptance tests RED → implement domain (pure Go) → application → HTTP handlers and persistence → GREEN. Domain has zero net/http or database imports; handlers are thin.

**Output:** Feature with tests green; ready for review.
