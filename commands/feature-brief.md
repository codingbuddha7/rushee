---
name: feature-brief
description: >
  Lightweight entry point for intern and junior developers. Run this instead of
  /rushee:ux-discovery + /rushee:event-storm + /rushee:ddd-model when you need
  to start quickly. Answers three questions (who is the user, what is the problem,
  what are the main domain concepts) and produces a Feature Brief document that
  feeds directly into /rushee:feature. Takes ~10 minutes.
  Triggers on: "quick start", "start a feature", "I want to build", "feature brief",
  "skip UX discovery", "just want to build", "where do I start" (with intern/junior profile).
argument-hint: (optional: one-line description of what you want to build)
allowed-tools: [Read, Write, Glob]
---

**Skills needed for this phase:** User problem framing, plain-English domain vocabulary. Rushee skill: feature-brief-methodology.
**New to this?** Say: "What is a Feature Brief?" or "What are domain concepts?" — then we'll run the session.

Invoke the **feature-brief-analyst** agent.

If `$ARGUMENTS` is provided, treat it as a one-line description of the feature
and pass it to the agent as the starting context.

The agent will ask you three short questions, then produce a Feature Brief document
at `docs/features/FDD-NNN-brief.md` (where NNN is the next available feature number —
the agent assigns it automatically). This brief replaces Phases 0 and 1 for teams
not yet ready for full UX Discovery and Event Storming.

When the brief is complete, run `/rushee:feature FDD-NNN` to convert it into a
full Feature Card.

**Want the full pipeline later?** Run `/rushee:ux-discovery`, `/rushee:event-storm`,
and `/rushee:ddd-model` at any time to backfill the upstream artifacts.
