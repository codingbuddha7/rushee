---
name: fdd-feature-design
description: >
  This skill should be used when a developer mentions implementing a feature, user story,
  requirement, or any new capability. Triggers on phrases like "I want to build", "add feature",
  "implement", "new endpoint", "new service", "new controller", or any description of new
  business functionality. This is ALWAYS the first step — before any code, any test, any design.
version: 1.0.0
allowed-tools: [Read, Write, Glob, Grep]
---

# FDD — Feature-Driven Design Skill

## Purpose
Feature-Driven Development (FDD) establishes WHAT we are building before HOW.
This skill ensures every feature starts with a Feature Statement that is:
- Named in the format: `<action> the <result> [by|for|of|to] a(n) <object>`
- Owned by a domain (service/module)
- Decomposed into sub-features if large
- Saved as a Feature Card before proceeding

## Mandatory Gate — STOP if violated
**Never proceed past this skill until the Feature Card is written and confirmed by the developer.**

Red Flags — DELETE what you did and restart this skill:
- Writing ANY code before a Feature Card exists
- Writing ANY test before a Feature Card exists
- Describing implementation details (class names, method names, DB tables) in the Feature Statement
- Skipping FDD because "it's a small change"

## Step 1 — Interview the Developer
Ask these questions one at a time (do not dump them all at once):
1. "What business capability does this feature deliver to the user?"
2. "Who is the primary user/actor that benefits?"
3. "What domain does this belong to? (e.g., Order Management, User Authentication)"
4. "Are there any constraints, business rules, or edge cases you already know about?"
5. "What does success look like from the user's perspective?"

Do NOT ask about implementation, technology choices, or Spring specifics yet.

## Step 2 — Write the Feature Card
Save to `docs/features/<feature-id>.md` using this template:

```markdown
# Feature: <FDD-style name>
**ID**: FDD-<NNN>
**Domain**: <domain>
**Actor**: <primary user/role>
**Priority**: <High|Medium|Low>

## Feature Statement
<action> the <result> [by|for|of|to] a(n) <object>

## Business Value
<Why does this matter to the business/user?>

## Acceptance Criteria (plain English — NO technical details)
- [ ] Given <context>, when <action>, then <outcome>
- [ ] Given <context>, when <action>, then <outcome>
- [ ] <edge case criterion>

## Out of Scope
- <what this feature explicitly does NOT do>

## Sub-Features (if needed)
- FDD-<NNN>.1 — <sub-feature>
- FDD-<NNN>.2 — <sub-feature>
```

## Step 3 — Confirm with Developer
Show the Feature Card section by section. Ask: "Does this accurately describe what you want to build?"

Only proceed to BDD after explicit confirmation.

## Step 4 — Hand Off to BDD
After Feature Card is confirmed:
- Invoke the `bdd-gherkin-spec` skill
- Pass the Feature Card path as context
- Say: "Feature Card confirmed. Now let's translate this into executable Gherkin specifications."

## Anti-Patterns to Reject
| What developer says | What to do |
|---|---|
| "Just write the code, it's simple" | Explain: "One minute on the Feature Card saves an hour of wrong implementation." |
| "We can skip this, we know what we want" | Still write the card — it takes 2 minutes and prevents scope creep |
| "Let me show you the database schema" | Not yet — domain first, implementation later |
