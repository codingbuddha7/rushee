---
name: skill-check
description: Run a short self-assessment for the next phase in the pipeline. Returns "Ready — proceed" or a prioritised list of skills to develop first with suggested prompts. Ideal for interns and juniors.
usage: /rushee:skill-check [FDD-NNN or phase number]
example: /rushee:skill-check
example: /rushee:skill-check FDD-001
allowed-tools: [Read, Write, Bash, Glob]
---

Run in **skill-check mode** (do not run the full onboarding or bootstrap).

1. **Scan the repo** (same as pipeline-bootstrapper Step 0b) to determine the **next phase** the developer will hit. If the user provided an argument (e.g. FDD-001), use it to narrow the phase.

2. **Get the "Skills/concepts needed" and "Self-assessment questions"** for that phase from the table below.

3. **Ask up to 5 short self-assessment questions** for that phase. Use the questions from the phase–skill map (or from the table below). Accept yes/no or brief answers.

4. **Output one of:**
   - **Ready — proceed:** "You're ready for the next step. Run: `/rushee:<next-command>` (e.g. `/rushee:bdd-spec FDD-001`)."
   - **Develop first:** "Before proceeding, focus on: [prioritised list of 1–3 skills/concepts]. Suggested resources: ask in this chat — '[prompt 1]', '[prompt 2]'. Then run `/rushee:skill-check` again or go straight to `/rushee:<next-command>`."

5. **Optionally:** If this is the first time they've run skill-check and they answered the questions, write a minimal `.rushee-profile` file in the project root (e.g. `skill-check-run: true`) so the session-start hook can stop showing the first-time hint. Mention that they can run `/rushee:skill-map` to see the full skill tree.

**Phase → self-assessment questions:**

| Next phase | Questions to ask |
|------------|------------------|
| 0 | Have you written personas or job stories before? Do you know what a screen inventory is? |
| 1 | Have you run or participated in Event Storming? Do you know what a bounded context is? |
| 1b | Are you familiar with DDD aggregates and value objects? Do you know why domain classes should have no @Entity? |
| 2 | Have you written a Feature Card or acceptance criteria before? |
| 2b | Have you designed a REST API or written OpenAPI specs? |
| 3 | Have you written a Gherkin scenario (Given/When/Then)? |
| 3b | Have you written Cucumber step definitions? |
| 4 | Have you used TDD (red-green-refactor)? Do you know ports and adapters / hexagonal architecture? |
| 4f | Have you built a frontend with clean layers (domain/data/presentation) or used NgRx/BLoC/state management? |

Invoke the **pipeline-bootstrapper** with the instruction that it is running in **skill-check only** mode: perform the scan, determine next phase, run the self-assessment using the phase–skill map, and output Ready or Develop first. Do not print the full pipeline map or run pre-flight for another phase unless the user asks.
