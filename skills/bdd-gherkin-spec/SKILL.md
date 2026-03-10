---
name: bdd-gherkin-spec
description: >
  This skill should be used after a Feature Card exists and the developer is ready to write
  executable specifications. Triggers on: "write gherkin", "write feature file", "write scenarios",
  "BDD spec", "acceptance scenarios", or automatically after fdd-feature-design completes.
  Also triggers when a developer describes expected system behavior using words like
  "should", "when a user", "given that", "the system must".
version: 1.0.0
allowed-tools: [Read, Write, Glob, Grep]
---

# BDD — Gherkin Specification Skill

## Purpose
Transform the Feature Card's acceptance criteria into executable Gherkin `.feature` files
that can be run by Cucumber-JVM. These files ARE the requirements — not documentation.

## Mandatory Gate — STOP if violated
**Never write step definitions or ANY Java code in this skill.**
**Never reference Spring beans, REST endpoints, class names, or method names in Gherkin.**

Red Flags — STOP and rewrite the scenario:
- Scenario contains a class name, method name, URL path, HTTP verb, or DB column
- Scenario describes HOW the system does something (implementation)
- Scenario mixes multiple features in one `.feature` file
- Step definitions are written before ALL scenarios are confirmed
- "Given" step describes UI clicks or HTTP calls instead of system state

## Gherkin Language Rules for This Project
1. **Domain language only** — Use business terms, not technical terms
2. **One feature per file** — Each `.feature` file maps to exactly one Feature Card
3. **Scenarios are independent** — No scenario depends on another's state
4. **Background sparingly** — Only for truly universal preconditions in the file
5. **Scenario Outlines for data-driven** — Use Examples tables, not copy-pasted scenarios

## Step 1 — Read the Feature Card
Load `docs/features/<feature-id>.md` and extract:
- The Feature Statement (becomes the Feature: description)
- Each acceptance criterion (becomes one or more Scenarios)
- Out of Scope items (add as a comment at top of file)

## Step 2 — Write the Feature File
Save to `src/test/resources/features/<domain>/<feature-id>.feature`

```gherkin
# Feature: <FDD Feature Statement>
# FDD-ID: <feature-id>
# Out of Scope: <from Feature Card>

Feature: <Feature Statement in plain English>
  As a <Actor>
  I want to <action>
  So that <business value>

  Background: (only if truly universal)
    Given <universal precondition>

  Scenario: <happy path — descriptive name>
    Given <system is in this state>
    When <actor performs this action>
    Then <system should be in this new state>
    And <additional observable outcome>

  Scenario: <alternative path>
    Given <different starting state>
    When <same or different action>
    Then <different expected outcome>

  Scenario: <error/edge case>
    Given <precondition that leads to error>
    When <action that should fail gracefully>
    Then <system handles it correctly>

  Scenario Outline: <data-driven scenario name>
    Given a <item> with <field> of "<value>"
    When <action>
    Then <expected outcome with "<result>">

    Examples:
      | value    | result   |
      | valid    | accepted |
      | invalid  | rejected |
```

## Step 3 — Domain Language Glossary Check
Before confirming, verify every Step against the domain glossary.
If no glossary exists yet, create `docs/ubiquitous-language.md`:

```markdown
# Ubiquitous Language — <Domain>
| Term | Definition | NOT this |
|------|------------|----------|
| Order | A confirmed purchase request | Not "transaction", not "request" |
```

## Step 4 — Scenario Review Checklist
For each scenario ask:
- [ ] Can a non-technical stakeholder understand this completely?
- [ ] Does it describe WHAT not HOW?
- [ ] Does it have exactly one "When" action?
- [ ] Is the "Then" observable from outside the system?
- [ ] Would a bug in this feature cause this scenario to fail?

## Step 5 — Hand Off to ATDD
After all scenarios are confirmed:
- Save the `.feature` file
- Invoke the `atdd-acceptance-first` skill
- Say: "Gherkin specs confirmed. Now generating skeleton step definitions and running acceptance tests (they must fail first)."

## Spring Boot Specific Guidance
Feature files belong in `src/test/resources/features/` organized by domain package.
The Cucumber runner class will be at `src/test/java/<base-package>/CucumberIT.java`.
Step definition classes go in `src/test/java/<base-package>/steps/<Domain>Steps.java`.
