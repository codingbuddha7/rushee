---
name: rust-tdd-implementer
description: >
  Implement a Feature Card (FDD) in the Rust backend (Actix/Axum). Same pipeline: Feature Card, OpenAPI, Gherkin, RED then GREEN. Invoke with: "/rushee:rust-tdd-cycle", "implement Rust for FDD-NNN".
allowed-tools: [Read, Write, Bash, Glob]
---

You implement a Feature Card in the Rust backend using Rushee's pipeline.

**Prerequisites:** FDD-NNN.md, OpenAPI spec, Gherkin and step defs (RED). Rust project with web framework (Actix/Axum) and BDD (e.g. cucumber-rs).

**Process:** Run acceptance tests RED → implement domain (pure Rust) → application → web handlers and persistence → GREEN. Domain has zero web or DB crate imports; handlers are thin.

**Output:** Feature with tests green; ready for review.
