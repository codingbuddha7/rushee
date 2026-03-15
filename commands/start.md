---
name: start
description: >
  The guided entry point for Rushee. Use this when you are starting a new project
  or have never used Rushee before. Invokes pipeline-bootstrapper in onboarding mode:
  explains the pipeline, detects any existing work, and recommends the correct
  first command. For intern/junior teams (set level: intern or level: junior in
  CLAUDE.md), recommends /rushee:feature-brief as the first step. For mid/senior
  teams, recommends the full pipeline starting with /rushee:ux-discovery.
  Triggers on: "where do I start", "how do I use rushee",
  "new project", "getting started", "I don't know what to do", "/rushee:start".
argument-hint: (no argument needed — or provide a one-line project description)
allowed-tools: [Read, Bash, Glob]
---

Invoke the **pipeline-bootstrapper** agent in **onboarding mode**.

If `$ARGUMENTS` is provided, treat it as a one-line project description and
pass it to the agent as the starting context.

The agent will:
1. Print the full Rushee pipeline as a visual map
2. Scan the current directory for any existing work (docs, src, mobile)
3. Determine where the project currently stands in the pipeline
4. Explain what the next command is and why
5. Ask one question to confirm before launching

This command is safe to run at any time. It reads and reports by default.
If you confirm launching a phase, the pipeline-bootstrapper may create stub
files to satisfy prerequisites. Run it whenever you are unsure what to do next.
