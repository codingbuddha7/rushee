# UX discovery: outputs, visual tools, and downstream flow

This document clarifies (1) where **visual verification** (Figma, wireframes, etc.) fits in the plugin, and (2) **how UX discovery output is fed into subsequent phases**.

---

## 1. What the plugin produces in UX discovery (Phase 0)

The **ux-analyst** agent (invoked by `/rushee:ux-discovery`) produces **text-only** artifacts:

| Output | Location | What it is |
|--------|----------|------------|
| Personas | `docs/ux/personas.md` | Who uses the app; context, goals, constraints |
| Job stories | `docs/ux/job-stories.md` | When/I want/so I can + **domain events** + screens required |
| Screen inventory | `docs/ux/screen-inventory.md` | Every screen (ID, name, persona, job story, status) |
| Navigation map | `docs/ux/navigation-map.md` | How screens connect (tabs, modals, wizards) |
| Wireframe **specs** | `docs/ux/wireframe-specs/<ScreenName>.md` | **Text** description: purpose, UI states, content order, interactions, **API calls** |

**Wireframe specs are not visual.** They are markdown documents that describe each screen in reading order, all states (loading, empty, error), and which API calls the screen needs. The idea: **designers use these specs to build in Figma** (or another tool). The plugin does not generate or open Figma files.

---

## 2. Where visual verification happens (and where it doesn’t)

- **Inside the plugin (automated):**  
  - **None.** The plugin does not run Figma, Miro, Balsamiq, or any visual design tool. It does not call Figma’s API or validate screens against a design file.

- **In your process (manual / tool of your choice):**  
  - **After** Phase 0, a designer (or you) builds **Figma** (or wireframes in another tool) **from the wireframe specs**.  
  - **Screen inventory** has a **Figma Status** column (e.g. ☐ Not started | 🔲 Wireframe | ✅ Figma approved). That status is updated **by you** when the design is approved.  
  - **Design tokens** (colors, typography, spacing) are extracted from the approved Figma (or a stub) into e.g. `mobile/lib/core/theme/app_colors.dart`. The plugin expects these files to exist before Flutter implementation; it does not pull them from Figma automatically.

- **In Flutter (optional, later):**  
  - **Golden tests** (`matchesGoldenFile`) capture widget output and compare it to a stored image. They guard against visual regression once a baseline exists. They do **not** talk to Figma; they compare to the last approved golden image.  
  - So: “visual verification” in the plugin’s world means: (1) human approval of Figma, (2) design tokens in code, (3) optional golden tests against a baseline.

**Summary:** Visual verification is **outside** the plugin. The plugin defines the **sequence**: text wireframe spec → (you/designer) build in Figma → approve → update screen inventory status → extract design tokens → then Flutter implementation can start.

---

## 3. How UX output is fed into subsequent phases

Each downstream phase **reads** specific UX artifacts. The following is what agents and skills expect.

| Phase | Command / agent | Reads from UX (and others) | How it uses UX output |
|-------|------------------|----------------------------|------------------------|
| **Phase 1** | `/rushee:event-storm` (event-stormer) | `docs/ux/job-stories.md`, `docs/ux/personas.md` | Takes **domain events** from job stories (“→ Domain events revealed: …”) as the starting point for Event Storming; does not re-ask what’s already in personas/job stories. |
| **Phase 1b** | `/rushee:ddd-model` (domain-modeller) | `docs/architecture/context-map.md`, `docs/ux/job-stories.md`, `docs/ux/personas.md` | Uses job stories and personas to align aggregate/entity names and language with user journeys. |
| **Phase 2** | `/rushee:feature` (feature-analyst) | `docs/ux/screen-inventory.md`, `docs/ux/personas.md`, `docs/ux/job-stories.md` | **Screens** section of the Feature Card uses **screen IDs and names from the inventory**; **Actor** uses **persona names**; acceptance criteria can be derived from job story outcomes. |
| **Phase 2b** | `/rushee:api-design` (api-designer) | `docs/features/FDD-NNN.md`, `docs/domain/…/domain-model.md`, **`docs/ux/wireframe-specs/*.md`** | Uses wireframe specs’ **“API calls this screen makes”** (or equivalent) to design endpoints and request/response shapes. |
| **Phase 3** | `/rushee:bdd-spec` (gherkin-writer) | `docs/features/FDD-NNN.md`, optionally `docs/ux/wireframe-specs/*.md` | Wireframe specs can suggest **UI states** (loading, empty, error) as additional scenarios. |
| **Phase 4f** | `/rushee:flutter-feature` (flutter-implementer) | `docs/features/FDD-NNN.md`, **`docs/ux/screen-inventory.md`** (Figma status), design tokens in `mobile/lib/core/theme/` | Checks that the feature’s screens exist in the inventory and that **design tokens** exist; implements widgets using **theme tokens and naming aligned with Figma** (when available). |

So: **personas and job stories** feed event-storm and domain model; **screen inventory** feeds Feature Cards and Flutter; **wireframe specs** feed API design (and optionally BDD). **Figma status** in the inventory is the gate for “approved to implement” on the Flutter side; the plugin does not perform the approval itself.

---

## 4. Quick reference: UX → downstream

```
docs/ux/personas.md          → event-stormer, domain-modeller, feature-analyst (Actor)
docs/ux/job-stories.md       → event-stormer (domain events), domain-modeller, feature-analyst (criteria)
docs/ux/screen-inventory.md  → feature-analyst (Screens table), flutter-implementer (screen list + Figma status)
docs/ux/navigation-map.md    → (reference for navigation structure; not read by agents today)
docs/ux/wireframe-specs/*.md → api-designer (API calls per screen), gherkin-writer (optional UI states)
```

Design tokens (from Figma or stub) live in `mobile/lib/core/theme/` and are required by the flutter-implementer before building screens; they are not produced by UX discovery.
