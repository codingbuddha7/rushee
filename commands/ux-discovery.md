---
name: ux-discovery
description: Run a UX discovery session to define personas, job stories, screen inventory, and navigation map before any domain design or Feature Cards are created.
usage: /rushee:ux-discovery [app name | project description]
example: /rushee:ux-discovery "ecommerce mobile app — browse products, cart, place order"
example: /rushee:ux-discovery
---

**Skills needed for this phase:** Personas, job stories (When/situation I want/motivation so I can/outcome), screen inventory, navigation map, wireframe specs (text). Rushee skill: ux-discovery-first.
**New to this?** Say: "Explain job stories vs user stories" or "What is a screen inventory?" — then we'll run the session.

Invoke the **ux-analyst** agent to run a structured UX discovery session.

This command:
1. Defines 2–3 user personas with context, goals, and constraints
2. Writes Job Stories for each persona (not User Stories)
3. Extracts domain events revealed by each Job Story
4. Produces a Screen Inventory with every screen named and assigned
5. Draws a Navigation Map showing all screen-to-screen flows
6. Writes Wireframe Specs for all MVP-scope screens

**When to run**: At the very start of a new project or new major feature area.
BEFORE `/rushee:event-storm`. The domain events from Job Stories seed the storming session.

**Rule enforced**: No Feature Card can reference a screen that doesn't exist
in the Screen Inventory. Add the screen to inventory first.

**Output files**:
- `docs/ux/personas.md`
- `docs/ux/job-stories.md`
- `docs/ux/screen-inventory.md`
- `docs/ux/navigation-map.md`
- `docs/ux/wireframe-specs/<ScreenName>.md` (one per screen — **text specs**, not visual; designers use these to build in Figma)

**Visual tools (Figma, wireframes):** The plugin does not run Figma or other visual tools. Wireframe specs are text; you or a designer build visuals from them and update the screen inventory’s “Figma Status” when approved. Design tokens are then extracted into `frontend/src/` (Angular) or `mobile/lib/core/theme/` (Flutter) before frontend implementation. See README § Where visual verification happens and § How UX output is fed into subsequent phases.
