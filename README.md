# Rushee v2.2 — Full-Stack Angular + Spring Boot Engineering Discipline

> *"Start with the user. End with production. Never skip a step."*

**Rushee** is a [Claude Code](https://claude.ai/code) plugin that enforces a complete,
professional engineering discipline for full-stack projects — from first UX sketch to production deployment. **Default:** Angular + Spring Boot (with full Spring ecosystem: Spring AI, Integration, Cloud, Batch, Data, Security, etc., in infrastructure; domain stays pure). **Also supported:** React, Svelte (web); Flutter (mobile); FastAPI, NestJS, Go, Rust (backends); same pipeline and OpenAPI contract. Every stage is guided, every shortcut
is blocked, and both codebases stay in sync through a shared OpenAPI contract.

**First time here?** You only need to remember **one command**: run **`/rushee:start`** from your project root (the folder that contains `backend/`, `frontend/`, and `docs/`). It will look at your project and tell you **exactly what to do next**. No need to memorise the whole pipeline.

---

## Table of Contents

1. [Quick start & paths](#1-quick-start--paths) — **Start here**
2. [What is Rushee?](#2-what-is-rushee)
3. [Installation](#3-installation)
4. [The Full-Stack Pipeline](#4-the-full-stack-pipeline)
5. [Repository Structure](#5-repository-structure)
6. [Commands Reference](#6-commands-reference)
7. [Skills Reference](#7-skills-reference)
8. [Agents Reference](#8-agents-reference)
9. [Hooks Reference](#9-hooks-reference)
10. [Step-by-Step Full-Stack Walkthrough](#10-step-by-step-walkthrough)
11. [Non-Negotiable Rules](#11-non-negotiable-rules)
12. [Project Structure — Backend](#12-backend-project-structure)
13. [Project Structure — Flutter Mobile](#13-flutter-project-structure)
14. [The OpenAPI Contract Bridge](#14-the-openapi-contract-bridge)
15. [Flutter Architecture Deep Dive](#15-flutter-architecture)
16. [UX Design Workflow](#16-ux-design-workflow)
17. [Debugging with Rushee](#17-debugging-with-rushee)
18. [Running Features in Parallel](#18-parallel-features)
19. [Extending Rushee](#19-extending-rushee)
20. [Technology Stack](#20-technology-stack)
21. [FAQ](#21-faq)

---

## 1. Quick start & paths

**New to the team or straight out of college?** This section is for you. You don’t need to know the whole pipeline — just one command and your path below.

**Goal:** Get you from zero to “I know what to do next” in under a minute. No jargon — just one command and three simple paths.

### The one command you need

| Command | When to use it | What it does |
|--------|----------------|--------------|
| **`/rushee:start`** | Every time you open the project or finish a step | Looks at your repo (docs, backend, frontend) and tells you the **next step** in plain language. You don’t need to memorise the pipeline. |

**Rule:** Run `/rushee:start` from your **project root** (the folder that has `backend/`, `frontend/`, and `docs/`). If you’re not sure where that is, open the project in your editor and run it from the top-level folder.

**Stuck on *how* to do a step?** (e.g. “What’s an aggregate?” “How do I write a repository?”) Use a **deep-dive or companion skill** for that topic in the same session — Rushee tells you *when* to do each step; a deep-dive helps with the *how*. See [Using companion skills (e.g. deep-dive) with Rushee](#using-companion-skills-eg-deep-dive-with-rushee) for when to use what.

---

### Greenfield vs brownfield

Rushee works for **both**:

- **Greenfield (new project):** Run **`/rushee:start`**. It will see nothing (or only scaffolding) and tell you to start with `/rushee:ux-discovery`. Follow Path A, B, or C from there.
- **Brownfield (existing project):** Run **`/rushee:start`** anyway. It **scans** your repo (docs, OpenAPI, backend code, Flutter) and tells you the **next step** based on what already exists. If the project never used Rushee, run **`/rushee:bootstrap retrofit`** first — it maps your codebase to the pipeline and suggests where to join. Then you can **skip to a phase** with **`/rushee:bootstrap phase-N FDD-NNN`** (e.g. phase-3 for BDD, phase-4 for backend implementation). The bootstrapper helps create any missing docs or stubs. See [FAQ: Greenfield vs brownfield](#21-faq).

---

### Which path are you on?

Pick the one that matches your situation. Then follow the steps in order. Each path uses the same command: **`/rushee:start`** tells you what to do next.

---

#### Path A — I’m building a full app (backend + frontend) from scratch

**Who this is for:** New project, or you want both the API and the Flutter app done the “Rushee way.”

1. **Install** Rushee (see [Installation](#3-installation)). Create a project folder with `backend/`, `frontend/` (Angular), and `docs/` (or follow the layout Rushee suggests).
2. **Open** your project in Claude Code or Cursor. Make sure you’re in the **project root**.
3. Run **`/rushee:start`**. It will say something like: “Run `/rushee:ux-discovery` first.”
4. **Do that step** (e.g. run `/rushee:ux-discovery` and answer the questions).
5. When that step is done, run **`/rushee:start`** again. It will give you the **next** step (e.g. event-storm, then ddd-model, then feature, then api-design, then BDD, then backend code, then Angular).
6. **Repeat:** run `/rushee:start` → do what it says → run `/rushee:start` again. Keep going until the feature is done.

**Summary:** You only need to remember **`/rushee:start`**. It’s your guide. Do what it says, then ask it again.

---

#### Path B — I’m only building the backend (no Flutter yet)

**Who this is for:** You’re doing API-first. The mobile app will come later, or someone else will build it.

1. **Install** Rushee. Have a `backend/` folder (Spring Boot) and `docs/` at project root.
2. Run **`/rushee:start`**. It will guide you through: UX discovery (you can keep it minimal) → event-storm → ddd-model → feature → api-design → bdd-spec → atdd-run → tdd-cycle.
3. **Stop after** the backend is done (all tests green). You can ignore frontend commands. The OpenAPI spec and Feature Card are already there for when someone builds the app later.

**Summary:** Same as Path A, but you stop after the backend phase. `/rushee:start` still tells you the next step; when it suggests frontend (Angular), you’re done.

---

#### Path C — The API already exists; I’m building the Flutter app

**Who this is for:** Backend (or contract) is ready. You’re implementing the mobile UI.

1. **You need:** An **OpenAPI spec** (e.g. `backend/src/main/resources/api/*-api.yaml`) and a **Feature Card** (e.g. `docs/features/FDD-001.md`) for the feature you’re implementing. Ask your team if you don’t have them.
2. **You also need:** Design tokens (colors, typography, spacing) in `frontend/src/` (e.g. Angular theme or `styles/`). If you have Figma, extract them; otherwise use a stub.
3. Run **`/rushee:start`** to confirm Rushee sees the feature and the contract. Then run **`/rushee:angular-feature`** (or follow what `/rushee:start` suggests) to implement the Angular side for that feature.

**Summary:** Start from “API + Feature Card + design tokens exist.” Use `/rushee:start` to check; then use `/rushee:angular-feature` to build the screen(s).

---

### Cheat sheet: one command, three paths

| Your situation | What you do |
|----------------|-------------|
| New to Rushee / not sure | Run **`/rushee:start`** from project root. Do what it says. Repeat. |
| **New project (greenfield)** | Path A or B. Use `/rushee:start` as your loop from Phase 0. |
| **Existing project (brownfield)** | Run **`/rushee:start`** — it detects what exists and suggests the next step. Or run **`/rushee:bootstrap retrofit`** to scan and map; then **`/rushee:bootstrap phase-N FDD-NNN`** to jump to a phase. |
| Full app (backend + frontend) | Path A. Use `/rushee:start` as your loop. |
| Backend only | Path B. Use `/rushee:start` until backend is done; then stop. |
| Frontend only (API exists) | Path C. Get OpenAPI + Feature Card + design tokens, then `/rushee:start` and `/rushee:angular-feature`. |

---

## 2. What is Rushee?

Rushee is a Claude Code plugin — a collection of **33 skills**, **25 agents**,
**23 commands**, and **7 hooks** that enforce a structured engineering methodology
across full-stack projects. **Default stack:** Angular + Spring Boot (full Spring ecosystem in infrastructure; domain stays pure). **Also supported** (same pipeline, same contract): React, Svelte (web); Flutter (mobile); FastAPI (Python), NestJS (TypeScript), Go, Rust (backends). Start with **`/rushee:start`** for a guided entry point.

### The Problem Rushee Solves

Without discipline, full-stack AI-assisted development produces:
- UX designed **after** the backend model (UI becomes a form over a database)
- Flutter widgets that call APIs directly (no clean architecture)
- Hand-written DTOs on both sides that drift out of sync silently
- No tests on the Flutter side, or tests that never go RED first
- JWT tokens stored in `SharedPreferences` (a security vulnerability)
- Magic colour values and font sizes scattered across the Flutter codebase
- Spring Boot domain classes polluted with `@Entity` and `@Service` annotations

Rushee prevents all of this by making the right approach the only approach.

### The Three Codebases, One Discipline

```
┌──────────────────────────────────────────────────────────────────┐
│  UX LAYER          Figma design tokens, screen inventory,        │
│                    navigation maps, wireframe specs              │
│                    (Rushee phase: ux-discovery)                  │
├──────────────────────────────────────────────────────────────────┤
│  ANGULAR CLIENT    TypeScript · Clean Architecture · NgRx/signals │
│                    domain → application → data → presentation    │
│                    (Rushee phase: angular-feature)               │
│                              ↕ OpenAPI Contract (the bridge)     │
│  SPRING BOOT API   Java · DDD · Hexagonal Architecture           │
│                    domain → application → infrastructure         │
│                    (Rushee phase: tdd-cycle)                     │
└──────────────────────────────────────────────────────────────────┘
```

### Skills vs Commands vs Agents vs Hooks

| Artifact | What it is | When it fires |
|----------|-----------|---------------|
| **Skill** | A SKILL.md with patterns, rules, code examples | **Automatically** — Claude reads it when your conversation matches the trigger |
| **Command** | A named action you invoke explicitly | **Manually** — you type `/rushee:<command>` |
| **Agent** | A specialised AI persona for a complex task | **On demand** — invoked by commands or other agents |
| **Hook** | A shell script that fires on file system events | **Automatically** — fires on write, session start, etc. |

---

## 3. Installation

### Prerequisites

- **Claude Code**: `npm install -g @anthropic-ai/claude-code`
- **Java 17+** and **Maven 3.8+** for the Spring Boot project
- **Flutter 3.7+** and **Dart 3.0+** for the mobile app
- **Git** with a monorepo or two-repo setup
- **openapi-generator-cli** for contract code generation (optional but recommended)

**Platform support:** Rushee hooks and scripts are written for **macOS, Linux, and Windows**. On **Windows**, run hooks and `scripts/phase-gate.sh` from **Git Bash** or **WSL** so that the shell and Maven wrapper (`./mvnw`) work as in the docs. Paths in skills and agents use forward slashes; Git Bash and WSL accept these. On Windows CMD/PowerShell you can run Maven with `mvnw.cmd` (or `mvn`) directly when following command examples that show `./mvnw`.

Rushee can be installed in **Claude Code** (`.claude-plugin/`) or **Cursor** (`.cursor-plugin/`); the same repo works for both.

### Option A — Clone directly into your project (recommended)

```bash
# Navigate to your project root
cd /path/to/your-project

# Clone Rushee
git clone https://github.com/codingbuddha7/rushee .claude/plugins/rushee

# Start Claude Code
claude
```

**For Cursor:** Clone into the directory Cursor uses for plugins (see [Cursor Plugins](https://cursor.com/docs/plugins)) so the cloned folder contains `.cursor-plugin/plugin.json`. Commands and skills then appear in Cursor.

You should see the Rushee session banner immediately (Claude Code) or have Rushee commands available (Cursor):

```
╔══════════════════════════════════════════════════════════════════╗
║              🚀  RUSHEE  v2.2  — Full-Stack Mode 🚀             ║
║    Spring Boot Backend + Angular Frontend Engineering Discipline║
╠══════════════════════════════════════════════════════════════════╣
║  FULL PIPELINE (start here for new projects):                   ║
║  /rushee:ux-discovery   → User journeys, personas, screen map   ║
║  /rushee:event-storm    → Bounded contexts & domain events      ║
║  ...                                                            ║
```

If hooks do not run in Cursor, see [Cursor Hooks](https://cursor.com/docs/hooks) for event names and schema.

### Option B — Claude Code marketplace

```bash
/plugin marketplace add codingbuddha7/rushee-marketplace
/plugin install rushee@rushee-marketplace
```

Cursor users can install via Cursor’s marketplace or plugin flow when the plugin is published there.

### Monorepo Layout (recommended)

```
your-project/
├── backend/          ← Spring Boot project (Maven)
├── frontend/         ← Angular project
├── docs/             ← UX, domain, feature docs (shared)
│   ├── ux/
│   ├── architecture/
│   ├── domain/
│   └── features/
└── .claude/
    └── plugins/
        └── rushee/   ← this plugin
```

**Run from project root.** Always start Claude Code or Cursor from the directory that contains `backend/`, `frontend/`, and `docs/`. Rushee’s agents and hooks assume this layout: backend code under `backend/src/`, Angular under `frontend/src/`, shared docs under `docs/`. If your backend lives at project root (no `backend/` folder), use `src/` instead of `backend/src/` in any path the agent shows you. Run Maven (`./mvnw`) from the directory that contains `pom.xml` (usually `backend/`).

### First day / minimum setup

- **Phases 0–2 (UX, event-storm, feature, api-design):** You need Git, a text editor, and Claude Code or Cursor. No Java or Angular required yet.
- **Phases 3–4 (BDD, ATDD, TDD):** Add Java 17+, Maven 3.8+, and a backend project (e.g. `backend/` with `pom.xml`). Optional: `openapi-generator-cli` for generated API interfaces.
- **Phase 4f (Angular):** Add Node 18+, Angular 17+, and a `frontend/` project. Design tokens (e.g. `frontend/src/styles/ or theme`) are required for the presentation layer; Figma or a stub is needed. Run `/rushee:start` to see what’s missing for your current phase.

### Developer profile (optional)

In your **project root**, you can add a developer profile so Rushee tailors explanations to your level. Create or edit `CLAUDE.md` (or `.cursorrules`) and add:

```markdown
## DeveloperProfile
level: intern | junior | mid | senior
```

- **intern / junior:** Pipeline bootstrapper and phase agents include brief “What is X?” and “Why we do this” explanations when recommending or running a step. Run `/rushee:start` or `/rushee:skill-check` for a skill-gap probe and tailored path.
- **mid / senior:** Output stays terse: next command and phase gate reminder only.

The session-start hook does not change; agents read the profile when you run `/rushee:start` or a phase command. If no profile is present, behaviour defaults to mid/senior (terse). Create `.rushee-profile` (e.g. after running `/rushee:skill-check`) if you want the session-start hint to stop appearing.

---

## 4. The Full-Stack Pipeline

Every feature passes through every stage. No stage is optional.
No stage can start before its predecessor is complete.

```
╔══════════════════════════════════════════════════════════════════╗
║                    THE RUSHEE FULL-STACK PIPELINE               ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  PHASE 0 — UX DISCOVERY  (once per project, then per epic)      ║
║  ─────────────────────────────────────────────────────────────  ║
║  /rushee:ux-discovery                                           ║
║    → Personas (who uses this app?)                              ║
║    → Job Stories (what are they trying to accomplish?)          ║
║    → Domain events extracted from job stories                   ║
║    → Screen Inventory (every screen named before Figma opens)   ║
║    → Navigation map (how screens connect)                       ║
║    → Wireframe specs (text description before Figma design)     ║
║    Output: docs/ux/personas.md                                  ║
║            docs/ux/screen-inventory.md                          ║
║            docs/ux/navigation-map.md                            ║
║            docs/ux/wireframes/S{NN}-<screen-name>.md            ║
║                                                                  ║
║  PHASE 1 — DOMAIN DESIGN  (once per bounded context)            ║
║  ─────────────────────────────────────────────────────────────  ║
║  /rushee:event-storm                                            ║
║    → Context map: bounded contexts and relationships            ║
║    → Domain events: Core / Supporting / Generic classification  ║
║    Output: docs/architecture/context-map.md                     ║
║                                                                  ║
║  /rushee:ddd-model <context>                                    ║
║    → Aggregates, Entities, Value Objects, Domain Events         ║
║    → Repository interfaces (pure Java, no frameworks)           ║
║    → Ubiquitous language glossary                               ║
║    Output: domain skeleton classes                              ║
║            docs/domain/<context>/domain-model.md               ║
║                                                                  ║
║  PHASE 2 — FEATURE + CONTRACT  (once per Feature Card)          ║
║  ─────────────────────────────────────────────────────────────  ║
║  /rushee:feature <description>                                  ║
║    → Feature Card with acceptance criteria AND screen links     ║
║    Output: docs/features/FDD-NNN.md                             ║
║                                                                  ║
║  /rushee:api-design <FDD-NNN>                                   ║
║    → OpenAPI 3.1 spec — the law for BOTH codebases              ║
║    → Reviewed before any controller or frontend data source      ║
║    Output: backend/src/main/resources/api/<context>-api.yaml    ║
║                                                                  ║
║  PHASE 3 — BDD / ATDD  (backend)                                ║
║  ─────────────────────────────────────────────────────────────  ║
║  /rushee:bdd-spec <FDD-NNN>                                     ║
║    → Gherkin scenarios in pure domain language                  ║
║    → Validated: no HTTP verbs, URLs, class names, SQL           ║
║    Output: backend/src/test/resources/features/...              ║
║                                                                  ║
║  /rushee:atdd-run <FDD-NNN>                                     ║
║    → Step definitions wired — acceptance tests confirmed RED    ║
║    Output: step definitions with PendingException               ║
║                                                                  ║
║  PHASE 4 — PARALLEL IMPLEMENTATION  (backend + Angular)         ║
║  ─────────────────────────────────────────────────────────────  ║
║                                                                  ║
║  ┌─────────────────────────┐  ┌──────────────────────────────┐  ║
║  │ BACKEND STREAM          │  │ FRONTEND STREAM (Angular)    │  ║
║  │ /rushee:tdd-cycle       │  │ /rushee:angular-feature      │  ║
║  │                         │  │                              │  ║
║  │ Outside-in TDD:         │  │ Regenerate API client        │  ║
║  │  Controller tests       │  │ Domain entities (TS)         │  ║
║  │  Service tests          │  │ Use cases + unit tests       │  ║
║  │  Repository tests       │  │ NgRx/signals + unit tests    │  ║
║  │  Flyway migration       │  │ Component tests (mocked)     │  ║
║  │  Cucumber GREEN ✅      │  │ Screen integration test      │  ║
║  └─────────────────────────┘  └──────────────────────────────┘  ║
║                  ↕ both implement from same OpenAPI spec ↕       ║
║                                                                  ║
║  PHASE 5 — SECURITY + FINAL REVIEW                              ║
║  ─────────────────────────────────────────────────────────────  ║
║  /rushee:security-check <FDD-NNN>                               ║
║    → OWASP Top 10 (backend) + frontend security (Angular/Flutter)║
║                                                                  ║
║  /rushee:status                                                 ║
║    → spring-reviewer (8 gates) + angular/flutter-reviewer       ║
║    → APPROVED → merge                                           ║
╚══════════════════════════════════════════════════════════════════╝
```

### The Golden Rule: UX → Domain → Contract → Code

```
User journey reveals domain events.
Domain events shape the domain model.
Domain model shapes the OpenAPI contract.
OpenAPI contract generates code for both codebases.
```

Never reverse this order. Never start from the database schema. Never start from
the API spec. Always start from what the user is trying to accomplish.

### Phase gates and optional PR verification

**Platforms:** Phase gate checks run on **Windows (Git Bash or WSL), macOS, and Linux**. On Windows CMD/PowerShell, run Maven commands manually (e.g. `mvnw.cmd test ...`) or use the phase-gate script from Git Bash/WSL.

Rushee does **not** require a pull request after every phase. It recommends:

1. **Phase gates** — verify that each phase's outputs exist and pass minimal checks before starting the next phase.
2. **Optional, small PRs** — after Phase 2b, 3b, 4, and 4f, open a **small** PR (that phase's changes only) for review if you have a mentor; otherwise commit and continue.

The next phase is **blocked only on the phase gate**, not on "PR merged."

#### Small PRs, not one huge PR

Each recommended PR is **one phase's worth of work**:

| PR moment | What's in the PR | Review focus |
|-----------|------------------|--------------|
| After 2b (API design) | OpenAPI YAML + Feature Card update | Contract only — a few files, no code |
| After 3b (ATDD) | Feature file + step-def classes (RED, no app logic) | "Do the scenarios match the feature?" — no implementation yet |
| After 4 (backend) | Backend code for one feature | Backend tests green; one FDD |
| After 4f (Angular) | Angular feature + backend if same branch | Full-stack one feature |

If you skip PRs and only commit, the phase gate still gives you a checkpoint; artifacts (specs, domain model, Gherkin) remain **reviewable in the repo** even without a formal PR.

#### Phase gates (what to check before continuing)

**After Phase 0 — UX Discovery:** `docs/ux/personas.md` exists with at least one persona; `docs/ux/job-stories.md`, `docs/ux/screen-inventory.md`, `docs/ux/navigation-map.md` exist; wireframe specs under `docs/ux/wireframe-specs/` or `docs/ux/wireframes/`. No automated check. Optionally commit and open a PR for visibility.

**After Phase 1 / 1b:** `docs/architecture/context-map.md` exists; `docs/domain/<context>/domain-model.md` and domain skeleton classes exist. No automated check. Optional PR if someone can review the domain design.

**After Phase 2b — API design:** OpenAPI spec at `backend/src/main/resources/api/*-api.yaml`. **Phase gate:** Validate the spec. From project root: `bash path/to/rushee/scripts/phase-gate.sh 2b [backend]` or manually: `npx @openapitools/openapi-generator-cli validate -i backend/src/main/resources/api/<name>-api.yaml`. **Optional PR:** Strongly recommended for contract review.

**After Phase 3b — ATDD:** Feature file(s) under `backend/src/test/resources/features/`; step-def classes (every step throws `PendingException` or fails). **Phase gate:** Run Cucumber and confirm RED. Example: `bash path/to/rushee/scripts/phase-gate.sh 3b backend FDD-001` or `cd backend && ./mvnw test -Dtest=*Cucumber* -Dcucumber.filter.tags="@FDD-001"`. **Optional PR:** Recommended — small "step defs only, RED" PR.

**After Phase 4 — Backend:** All Cucumber tests GREEN; unit/integration tests pass. **Phase gate:** `./mvnw test`. **Optional PR:** Recommended before frontend or next feature.

**After Phase 4f — Angular:** Frontend app builds. **Phase gate:** No build errors; optional tests/lint. **Optional PR:** Recommended — full-stack feature ready for review.

| Phase | Phase gate focus | Open a PR? |
|-------|------------------|------------|
| 0 | Artifacts exist | Optional (visibility) |
| 1 / 1b | Context map, domain model | Optional |
| 2b | OpenAPI valid | **Recommended** — contract review |
| 3b | Cucumber RED | **Recommended** — step-defs only |
| 4 | Backend tests green | **Recommended** — code review + CI |
| 4f | Frontend builds (Angular) | **Recommended** — ready to ship |

**Reality check:** Many teams won't open a PR after every phase. Phase gates are quick local checks; artifacts stay reviewable in the repo. Running `spring-reviewer` / `angular-reviewer` (or `flutter-reviewer` for mobile) before merge still catches issues. If you don't have a reviewer, commit after the phase gate and continue.

---

## 5. Repository Structure

**Plugin version (for contributors):** When releasing, keep the version in sync in `.claude-plugin/plugin.json`, `.cursor-plugin/plugin.json`, and `.claude-plugin/marketplace.json`.

### Recommended Monorepo Layout

```
your-project/
│
├── backend/                       ← Spring Boot Maven project
│   ├── pom.xml
│   └── src/
│
├── frontend/                      ← Angular project (default)
│   ├── pubspec.yaml
│   └── lib/
│
├── docs/                          ← All documentation (shared, version-controlled)
│   ├── ux/
│   │   ├── personas.md            ← Who uses this app
│   │   ├── screen-inventory.md    ← Every screen tracked here
│   │   ├── navigation-map.md      ← How screens connect
│   │   └── wireframes/
│   │       ├── S01-splash.md
│   │       ├── S02-login.md
│   │       └── S13-cart-review.md
│   ├── architecture/
│   │   ├── context-map.md         ← Bounded context relationships
│   │   ├── event-timeline.md      ← Domain event flow
│   │   ├── subdomains.md          ← Core/Supporting/Generic
│   │   └── decisions/             ← Architecture Decision Records
│   ├── domain/
│   │   └── <context>/
│   │       └── domain-model.md    ← Aggregate design docs
│   ├── features/
│   │   ├── FDD-001.md             ← Feature Card: Place Order
│   │   ├── FDD-002.md             ← Feature Card: Cancel Order
│   │   └── FDD-003.md
│   └── reviews/
│       └── FDD-001-security.md    ← Security review record
│
├── regenerate-clients.sh          ← CRITICAL: regenerates both API clients
│
└── .claude/
    └── plugins/
        └── rushee/                ← This plugin
```

---

## 6. Commands Reference

### Phase 0 — UX Discovery

---

#### `/rushee:ux-discovery`

Start a new project or epic from the user's perspective.

**When to run**: At the very beginning of every project, and at the start of any
new epic or major feature set. Before Event Storming. Before writing any code.

**What happens**: The `ux-analyst` agent guides you through defining personas,
writing Job Stories, extracting domain events from those stories, building a
Screen Inventory, mapping navigation, and writing wireframe specs for every screen
in scope.

**Output**:
- `docs/ux/personas.md` — who uses the app, their context, goals, constraints
- `docs/ux/screen-inventory.md` — every screen named, assigned to a persona and job story
- `docs/ux/navigation-map.md` — how all screens connect
- `docs/ux/wireframes/S{NN}-<screen>.md` — text wireframe spec per screen

**Why this comes first**: User journeys reveal domain events. Those events are the
input to `/rushee:event-storm`. Every domain event that appears in your backend was
first discovered in a user's journey — or it shouldn't exist at all.

```
/rushee:ux-discovery
> "Tell me about the people who will use this app."
You: "Shoppers on mobile who want to browse products, add to cart, and place an order"
[Agent builds persona profiles, extracts job stories, discovers domain events,
 creates screen inventory and wireframe specs]
> "UX Discovery complete. Domain events ready for /rushee:event-storm"
```

---

### Phase 1 — Domain Design

---

#### `/rushee:event-storm`

Map bounded contexts and domain events.

**When to run**: After UX Discovery. Pass the domain events list from your job stories
as the starting point — the session will be dramatically faster.

**Output**: `docs/architecture/context-map.md`, `docs/architecture/subdomains.md`

```
/rushee:event-storm
[Agent imports domain events from UX discovery]
[Facilitates timeline building, context identification, relationship mapping]
> "Bounded context(s) identified (e.g. Notes). Next: /rushee:ddd-model <context>"
```

---

#### `/rushee:ddd-model <context-name>`

Design the tactical domain model for a bounded context.

**When to run**: After Event Storming, for each Core or Supporting subdomain.

**What happens**: The `domain-modeller` agent designs aggregates, entities, value
objects, domain events, and repository interfaces. Generates skeleton classes with
zero Spring/JPA annotations.

**Output**: `docs/domain/<context>/domain-model.md`, domain skeleton Java classes

```
/rushee:ddd-model notes
[Agent designs: Note (aggregate), NoteId (value object), NoteCreated (domain event),
 NoteRepository (output port interface)]
```

---

### Phase 2 — Feature & Contract

---

#### `/rushee:feature <description>`

Create a Feature Card for a new piece of functionality.

**When to run**: For every feature, before writing any code on either side.

**The v2.2 Feature Card** includes a Screens section linking each feature to its
Figma-approved screens in the Screen Inventory.

**Output**: `docs/features/FDD-NNN.md`

```markdown
## FDD-001: Place Order

### Screens
| Screen ID | Screen Name         | Figma Status   |
|-----------|---------------------|----------------|
| S13       | Cart Review Screen  | ✅ Approved    |
| S14       | Checkout Screen     | ✅ Approved    |
| S15       | Order Confirmation  | ✅ Approved    |

### Backend Endpoints
POST /api/v1/orders → 201 OrderDto

### Acceptance Criteria
1. A registered customer with a non-empty cart can place an order
2. An order with no items is rejected with a clear error
...
```

---

#### `/rushee:api-design <FDD-NNN>`

Design the OpenAPI contract before writing any controller or Flutter data source.

**When to run**: After Feature Card exists. Before any backend controller code.
Before any Flutter `RemoteDataSource` class.

**Critical**: The OpenAPI spec is the **only bridge** between the two codebases.
It generates the Spring Boot API interfaces via `openapi-generator-maven-plugin`
and the Flutter models + API client via `openapi-generator dart-dio`.
Neither side hand-writes DTOs.

**Output**: `backend/src/main/resources/api/<context>-api.yaml`

**Hook activated**: After saving the spec, `guard-openapi-contract-sync` hook
reminds you to run `./regenerate-clients.sh` to regenerate both clients.

---

### Phase 3 — BDD / ATDD (Backend)

---

#### `/rushee:bdd-spec <FDD-NNN>`

Write Gherkin scenarios in domain language.

**When to run**: After Feature Card + API contract approved.

**What happens**: `gherkin-writer` produces scenarios. `spec-guardian` validates
every step — rejecting HTTP verbs, URLs, class names, and SQL. Pure domain language only.

**Output**: `backend/src/test/resources/features/<domain>/FDD-NNN-<title>.feature`

---

#### `/rushee:atdd-run <FDD-NNN>`

Wire step definitions and confirm acceptance tests are RED.

**When to run**: After Gherkin is approved.

**Rule**: If tests are green at this point, the implementation already exists.
Something is wrong. Acceptance tests must fail before implementation begins.

**Output**: `*Steps.java` with `PendingException` bodies, confirmed failing

---

### Phase 4 — Implementation (Both Streams)

---

#### `/rushee:tdd-cycle <FDD-NNN>`

Implement the backend feature using outside-in TDD.

**When to run**: After acceptance tests are RED.

**What happens**: `tdd-implementer` works outside-in — controller → service →
repository. One failing test at a time. Checks Cucumber acceptance tests every
3-4 unit test cycles. Stops when all acceptance tests are GREEN.

**Never starts implementation** without seeing acceptance tests fail first.

---

#### `/rushee:angular-feature <FDD-NNN>` **(default frontend)**

Implement the Angular frontend feature for a Feature Card.

**When to run**: After Feature Card + OpenAPI contract + Figma screens are all approved.
Can run **in parallel** with `/rushee:tdd-cycle` since both implement from the same spec.

**What happens**:
1. Verifies prerequisites: Feature Card, Screen Inventory entry, OpenAPI spec, design tokens
2. Generates or uses API client from the OpenAPI spec (e.g. `openapi-generator-cli` typescript-* or project tooling)
3. Implements the domain layer in TypeScript (entities, repository interfaces — pure, no Angular/HttpClient)
4. Implements application layer (use cases / services) + unit tests
5. Implements data layer (repository implementations, API service)
6. Implements presentation (components, pages, state via NgRx or signals)
7. Runs tests and lint. Optionally hands to reviewer.

**Output**: Complete Angular feature implementation with clean layers and tests.

```
/rushee:angular-feature FDD-001
[Agent verifies prerequisites]
[Agent generates API client from OpenAPI spec]
[Domain → application → data → presentation, tests at each layer]
```

**Other frontends** (same pipeline): `/rushee:flutter-feature`, `/rushee:react-feature`, `/rushee:svelte-feature`.

#### Other frontends and backends (same pipeline, same contract)

| Command | Stack | Use when |
|--------|--------|----------|
| `/rushee:flutter-feature <FDD-NNN>` | Flutter (Dart) | Frontend is Flutter; same Feature Card + OpenAPI |
| `/rushee:react-feature <FDD-NNN>` | React (Vite, TypeScript) | Frontend is React; same Feature Card + OpenAPI |
| `/rushee:svelte-feature <FDD-NNN>` | Svelte / SvelteKit | Frontend is Svelte |
| `/rushee:fastapi-tdd-cycle <FDD-NNN>` | Python (FastAPI) | Backend is FastAPI; same Gherkin + OpenAPI |
| `/rushee:nest-tdd-cycle <FDD-NNN>` | TypeScript (NestJS) | Backend is NestJS |
| `/rushee:go-tdd-cycle <FDD-NNN>` | Go | Backend is Go (Echo/Gin, Godog) |
| `/rushee:rust-tdd-cycle <FDD-NNN>` | Rust (Actix/Axum) | Backend is Rust |

Same prerequisites: Feature Card, OpenAPI spec, (for frontend) screen inventory and design tokens; (for backend) Gherkin and step defs RED. Domain stays pure; contract-first.

---

### Quality Gates

---

#### `/rushee:debug <description>`

Systematically debug a failing test or exception on either backend or Flutter.

**When to run**: Any time any test fails. Do not guess. Classify first.

**Backend failure categories**: Spring wiring (A), JPA/Transactions (B),
Wrong value (C), NPE (D), Cucumber (E), HTTP test (F), Test isolation (G)

**Flutter failure categories**: Provider/BLoC wiring (H), async state (I),
widget rendering (J), golden test drift (K), integration test timing (L)

---

#### `/rushee:parallel <FDD-NNN>`

Dispatch parallel agents for independent implementation tasks.

**When to run**: When a feature has independent work units, or a sprint has
multiple independent Feature Cards.

**Most powerful use case for full-stack**: Dispatch backend stream (`tdd-implementer`)
and Flutter stream (`flutter-implementer`) simultaneously after the API contract is
approved and acceptance tests are RED.

```
/rushee:parallel FDD-001
[Dispatcher assigns:]
  Backend Agent  → Spring Boot controller → service → repository → Cucumber GREEN
  Flutter Agent  → Dart entities → use cases → BLoC → widgets → integration GREEN
[Both implement from the same OpenAPI spec — no conflicts by design]
```

---

#### `/rushee:security-check <FDD-NNN>`

Run OWASP security review on both the backend and the Flutter client.

**Backend** (OWASP Top 10): injection, broken auth, exposed data, XXE, misconfiguration,
XSS, insecure deserialization, outdated components, logging, SSRF.

**Flutter** (OWASP Mobile Top 10): token storage (`flutter_secure_storage` required),
certificate pinning, cleartext traffic, screenshot prevention on sensitive screens,
no PII in logs.

**Output**: APPROVED or CHANGES REQUIRED with severity (HIGH / MEDIUM / LOW)

---

#### `/rushee:extend <type> <name>`

Add new skills, commands, or agents to Rushee.

```
/rushee:extend skill resilience-patterns
/rushee:extend skill flutter-offline-first
/rushee:extend command contract-test
```

---

#### `/rushee:status`

Full pipeline status + 8-gate backend review + 5-gate Flutter review.

#### `/rushee:skill-check` [FDD-NNN]

Run a short self-assessment for the **next phase** in the pipeline. Scans the repo, asks up to 5 questions for that phase, and returns either **Ready — proceed** with the next command or a **prioritised list of skills to develop** with suggested prompts to ask in chat. Ideal for interns and juniors. Optionally creates `.rushee-profile` so the session-start first-time hint can stop showing.

#### `/rushee:skill-map`

Show a **visual skill tree** and phase–skill table: which concepts and Rushee skills apply to each phase, and what to ask if you're new. Gives juniors a roadmap they can point at.

---

## 7. Skills Reference

Skills fire **automatically** when your conversation matches their trigger phrases.

### UX Layer (NEW in v2.2)

| Skill | Triggers on... |
|-------|---------------|
| **ux-discovery-first** | "user journey", "persona", "wireframe", "UX design", "screen flow", "what does the app look like", "how does the user...", "job story", "screen inventory", "navigation", "onboarding" |
| **design-to-code-contract** | "implement the design", "Figma", "match the design", "design tokens", "theme", "color", "typography", "spacing", "padding", "border radius", "dark mode", "Material 3", "ThemeData", "pixel perfect" |

### Flutter Architecture Layer (NEW in v2.2)

| Skill | Triggers on... |
|-------|---------------|
| **flutter-clean-architecture** | "Flutter", "Dart", "widget", "screen", "BLoC", "Riverpod", "state management", "flutter layer", "flutter use case", "flutter repository", "go_router", "dio", "flutter clean arch" |
| **flutter-testing-discipline** | "flutter test", "widget test", "BLoC test", "golden test", "integration_test", "mocktail", "pump()", "flutter coverage", "bloc_test" |
| **mobile-security-by-design** | "store token", "JWT Flutter", "SharedPreferences", "flutter_secure_storage", "certificate pinning", "biometric", "OWASP Mobile", "keystore", "keychain", "screenshot prevention" |
| **openapi-contract-sync** | "add a field", "change the response", "fromJson", "toJson", "dto", "serialization", "api contract", "breaking change", "api versioning", "retrofit", "regenerate", "model mismatch", any edit to `*-api.yaml` |

### Other frontends (same clean-architecture pipeline)

| Skill | Triggers on... |
|-------|---------------|
| **react-clean-architecture** | "React", "Vite", "React Query", "Zustand", "react feature", "React layer" |
| **svelte-clean-architecture** | "Svelte", "SvelteKit", "svelte feature", "Svelte layer" |
| **angular-clean-architecture** | "Angular", "NgRx", "angular feature", "Angular layer" |

### Other backends (same ports & adapters pipeline)

| Skill | Triggers on... |
|-------|---------------|
| **fastapi-clean-architecture** | "FastAPI", "Python backend", "pytest-bdd", "Behave", "FastAPI layer" |
| **nest-ports-adapters** | "NestJS", "Nest", "TypeScript backend", "Nest domain" |
| **go-ports-adapters** | "Go", "Golang", "Echo", "Gin", "Godog", "Go backend" |
| **rust-ports-adapters** | "Rust", "Actix", "Axum", "Rust backend", "cucumber-rs" |

### Strategic Layer

| Skill | Triggers on... |
|-------|---------------|
| **ddd-strategic-design** | "new project", "new microservice", "bounded context", "event storming", "domain design", "context map" |
| **ddd-ubiquitous-language** | "what should I call this", "naming", "glossary", "the business calls it X but code says Y", naming inconsistency |
| **ddd-tactical-design** | "aggregate design", "entity or value object", "domain model", "rich domain model", "anemic model", "where does this business rule go" |

### Delivery Layer

| Skill | Triggers on... |
|-------|---------------|
| **api-design-contract-first** | "new endpoint", "REST API", "controller", "OpenAPI", "write an endpoint" |
| **fdd-feature-design** | "implement", "add feature", "new feature", "build" |
| **bdd-gherkin-spec** | "Gherkin", "scenarios", "BDD spec", "write scenarios", "feature file" |
| **atdd-acceptance-first** | "step definitions", "wire Cucumber", "ATDD", "acceptance tests" |
| **tdd-red-green-refactor** | Creating any production class, "unit test", "TDD", "write a test for" |

### Engineering Quality Layer

| Skill | Triggers on... |
|-------|---------------|
| **spring-git-workflow** | "create branch", "git worktree", "PR", "merge feature", "branch strategy" |
| **spring-parallel-agents** | "work in parallel", "dispatch agents", "multiple features at once" |
| **spring-systematic-debugging** | Any stack trace, "test fails", "exception", "bug", "debug", "why is this failing" |
| **clean-architecture-ports-adapters** | "which layer", "hexagonal", "ports and adapters", "@Entity on domain", "dependency rule" |
| **event-driven-architecture** | "domain event", "Kafka", "RabbitMQ", "Saga", "Outbox", "cross-context" |
| **solid-principles-enforcer** | "code review", "refactor", class over 150 lines, too many constructor params |
| **spring-boot-patterns** | Spring idioms, "@Autowired", "@Transactional", "layered architecture" |

### Quality Gates Layer

| Skill | Triggers on... |
|-------|---------------|
| **database-migration-discipline** | "@Entity", "add column", "Flyway", "schema change", "create table" |
| **security-by-design** | "Spring Security", "authentication", "JWT", "OAuth2", "OWASP", "password" |
| **observability-and-ops** | "logging", "metrics", "tracing", "Actuator", "Micrometer", "production ready" |

### Meta Layer

| Skill | Triggers on... |
|-------|---------------|
| **extending-rushee** | "add a skill", "Rushee doesn't cover", "customise Rushee", "how do I teach Rushee" |

---

## 8. Agents Reference

| Agent | Invoked by | Purpose |
|-------|-----------|---------|
| **ux-analyst** | `/rushee:ux-discovery` | Guides persona definition, job story mapping, screen inventory, navigation map, wireframe specs |
| **event-stormer** | `/rushee:event-storm` | Event Storming facilitation, context mapping, subdomain classification |
| **domain-modeller** | `/rushee:ddd-model` | Tactical DDD design — aggregates, entities, VOs, domain events. No Spring annotations in domain |
| **api-designer** | `/rushee:api-design` | Produces OpenAPI 3.1 spec. Blocks code until spec is reviewed and saved |
| **feature-analyst** | `/rushee:feature` | Interviews developer, writes Feature Card with acceptance criteria AND screen links |
| **gherkin-writer** | `/rushee:bdd-spec` | Writes Gherkin in domain language. Hands to spec-guardian |
| **spec-guardian** | After gherkin-writer | Rejects HTTP verbs, URLs, class names, SQL in Gherkin |
| **acceptance-enforcer** | `/rushee:atdd-run` | Checks Maven deps, generates PendingException skeletons, confirms RED |
| **tdd-implementer** | `/rushee:tdd-cycle` | Outside-in TDD: one test at a time. Backend only |
| **angular-implementer** | `/rushee:angular-feature` | Default frontend: domain → data → presentation (Angular). Tests at each layer |
| **flutter-implementer** | `/rushee:flutter-feature` | Flutter: use cases → BLoC → widgets → screens. Tests at every layer |
| **flutter-reviewer** | After flutter-implementer | Runs 5-gate Flutter quality review |
| **react-implementer** | `/rushee:react-feature` | Same pipeline for React (domain → data → presentation) |
| **svelte-implementer** | `/rushee:svelte-feature` | Same pipeline for Svelte |
| **fastapi-tdd-implementer** | `/rushee:fastapi-tdd-cycle` | Same BDD/TDD pipeline for FastAPI (Python) |
| **nest-tdd-implementer** | `/rushee:nest-tdd-cycle` | Same pipeline for NestJS (TypeScript) |
| **go-tdd-implementer** | `/rushee:go-tdd-cycle` | Same pipeline for Go |
| **rust-tdd-implementer** | `/rushee:rust-tdd-cycle` | Same pipeline for Rust (Actix/Axum) |
| **debugger** | `/rushee:debug` | Classifies failure (7 backend + 5 Flutter categories), forms hypothesis, applies minimal fix |
| **parallel-dispatcher** | `/rushee:parallel` | Defines file ownership, per-agent instructions, worktree setup |
| **security-reviewer** | `/rushee:security-check` | OWASP Top 10 (backend) + OWASP Mobile Top 10 (Flutter) |
| **ops-reviewer** | From spring-reviewer | Logging, metrics, tracing, health indicators, config review |
| **spring-reviewer** | `/rushee:status` | Chief backend reviewer — 8 gates. Calls flutter-reviewer for full-stack features |
| **rushee-extender** | `/rushee:extend` | Adds new skills/commands/agents following Rushee quality standards |

---

## 9. Hooks Reference

| Hook | Fires | Behaviour |
|------|-------|-----------|
| **session-start-discipline-reminder** | Every session start | Displays pipeline banner. Warns if no context map or screen inventory exists |
| **guard-no-code-before-feature-card** | Writing `*.java` in `src/main/java` | **WARNS** — production Java without a Feature Card |
| **guard-domain-purity** | Writing `*.java` in `**/domain/**` | **BLOCKS** — `@Entity`, `@Service`, Spring/JPA imports in domain layer |
| **guard-no-hardcoded-secrets** | Writing `*.java`, `*.yml`, `*.properties`, `*.dart` | **BLOCKS** — passwords, API keys, tokens in source files |
| **guard-openapi-contract-sync** | After writing `*-api.yaml` | **WARNS** — reminds to run `./regenerate-clients.sh` and run contract tests on both sides |
| **remind-migration-on-entity-change** | After writing `*Entity.java` | **WARNS** — create a Flyway migration |
| **auto-run-tests-after-edit** | After writing `*Test.java`, `*_test.dart` | **WARNS** — run the test suite |

### regenerate-clients.sh

Create this script at your project root. The `guard-openapi-contract-sync` hook
points to it every time you change a spec:

```bash
#!/bin/bash
# regenerate-clients.sh
# Run this every time any *-api.yaml file changes

set -e

SPEC_FILE="${1:-backend/src/main/resources/api/order-api.yaml}"
FLUTTER_OUTPUT="mobile/lib/features/order/data/generated"

echo "=== Regenerating API clients from: $SPEC_FILE ==="

echo "--- Backend (Spring Boot): generating interfaces ---"
cd backend && ./mvnw generate-sources -q && cd ..
echo "✅ Backend interfaces generated"

echo "--- Flutter: generating models + API client ---"
openapi-generator-cli generate \
  -i "$SPEC_FILE" \
  -g dart-dio \
  -o "$FLUTTER_OUTPUT" \
  --additional-properties=pubName=api_client,nullSafe=true
cd mobile && flutter pub run build_runner build --delete-conflicting-outputs -q && cd ..
echo "✅ Flutter client generated"

echo "=== Running contract tests ==="
echo "--- Backend contract tests ---"
cd backend && ./mvnw test -Dtest="*ContractTest" -q && cd ..
echo "✅ Backend contract tests pass"

echo "--- Flutter contract tests ---"
cd mobile && flutter test test/contract/ --no-pub && cd ..
echo "✅ Flutter contract tests pass"

echo ""
echo "=== Both clients regenerated and verified ==="
```

---

## 10. Step-by-Step Walkthrough

Here is a complete worked example building a **sample ecommerce mobile app** (browse products, cart, place order) from scratch. The same example, with step-by-step artifacts and code, is in **[demo-app/STEPS.md](demo-app/STEPS.md)** in this repository.

### Starting a New Project

```
claude   (from project root — Rushee banner appears)

> ⚠️ No UX discovery found. Consider running /rushee:ux-discovery first.
> ⚠️ No context map found.
```

### Step 0 — UX Discovery

```
/rushee:ux-discovery

> "Tell me about the people who will use this app."
You: "Shoppers on mobile who want to browse products, add to cart, and place an order"

> "For the Shopper persona — what's their situation when they open the app?"
You: "On their phone, commuting or at home, wants to order quickly"

[Agent writes Amara (Shopper) persona and job stories]

> "Now let's map the jobs. When do they open the app? What are they trying to do?"
You: "They open it to see products, add items to cart, and place an order"

> "Job Story JS-001: When I open the app, I want to see a list of products,
>  so I can choose what to buy.
>  Domain events found: ProductListViewed
>  Screens required: Product List Screen
>  
>  Job Story JS-002: When I tap a product, I want to add it to my cart, so I can buy it later.
>  Domain events found: ItemAddedToCart
>  ...
>  Job Story JS-003: When my cart has items, I want to place an order, so I can complete the purchase.
>  Domain events found: OrderPlaced
>  Screens required: Cart Screen, Checkout / Order Confirmation"

[Agent builds job stories, extracts domain events, screen inventory, wireframe specs]

> "UX Discovery complete:
>  ✅ Persona(s) defined
>  ✅ Job stories written
>  ✅ Domain events ready for event-storm
>  ✅ Screen inventory and wireframe specs
>  
>  Next: /rushee:event-storm (pass these domain events as input)"
```

### Step 1 — Event Storming

```
/rushee:event-storm

[Agent starts with the domain events from UX discovery]
[Builds timeline: ProductListViewed → ItemAddedToCart → OrderPlaced]
[Identifies bounded contexts: Catalog, Cart, Order]

> "Context(s) mapped. Next: /rushee:ddd-model order (or catalog, cart)"
```

### Step 2 — Domain Model

```
/rushee:ddd-model order

[Agent designs: Order (aggregate), OrderId (VO), OrderPlaced (domain event),
 OrderRepository (output port); Cart/Product as needed]
[Generates Java skeleton classes with ZERO Spring/JPA annotations]

> "Domain model approved. Next: /rushee:feature"
```

### Step 3 — Feature Card

```
/rushee:feature "Place order from cart (checkout)"

[Agent writes FDD-001 with acceptance criteria AND screen links]

> "FDD-001 created. Screens: Cart ✅, Checkout ✅
>  Next: /rushee:api-design FDD-001"
```

### Step 4 — API Contract

```
/rushee:api-design FDD-001

[api-designer drafts OpenAPI spec: GET /api/v1/products, POST /api/v1/cart/items, POST /api/v1/orders]
[Spec saved → guard-openapi-contract-sync hook fires]

> "⚡ Contract saved. Run: ./regenerate-clients.sh
>  This regenerates both the Spring Boot API interface and the Flutter Dart client."

./regenerate-clients.sh   (run in terminal, or on Windows: Git Bash/WSL)
> ✅ Backend interfaces generated
> ✅ Flutter client generated
> ✅ Contract tests pass

> "Both clients generated. Next: /rushee:bdd-spec FDD-001 (backend)
>              and simultaneously: /rushee:angular-feature FDD-001 (Angular)"
```

### Step 5 — BDD + ATDD (Backend)

```
/rushee:bdd-spec FDD-001

[gherkin-writer produces scenarios in domain language]
[spec-guardian validates: no HTTP/URL/class names in steps]
> "Scenarios saved. Next: /rushee:atdd-run FDD-001"

/rushee:atdd-run FDD-001

[acceptance-enforcer generates step definitions with PendingException]
[runs ./mvnw test -Dtest="CucumberIT" — or mvnw.cmd on Windows CMD]
> Tests run: N, PENDING ✅
> "Acceptance tests confirmed RED. Ready for implementation."
```

### Step 6 — Parallel Implementation

```
/rushee:parallel FDD-001

[parallel-dispatcher defines two independent streams]
[No shared files between streams — only the generated API client is shared,
 and it's read-only during implementation]

BACKEND stream owns:
  backend/src/main/java/.../infrastructure/web/OrderController.java, ProductController.java
  backend/src/main/java/.../application/OrderApplicationService.java
  backend/src/main/java/.../infrastructure/persistence/JpaOrderRepository.java
  All test files for the above

FLUTTER stream owns:
  mobile/lib/features/order/ (or catalog, cart) domain, data, presentation
  mobile/lib/features/.../presentation/screens/product_list_screen.dart, cart_screen.dart, checkout_screen.dart
  All test files for the above
```

Run two Claude Code sessions simultaneously:

```bash
# Terminal 1 — Backend
cd your-project && claude
/rushee:tdd-cycle FDD-001

# Terminal 2 — Flutter (same project root, different stream)
cd your-project && claude
/rushee:angular-feature FDD-001
```

Both sessions work independently. Neither blocks the other. Both implement
from the same OpenAPI spec.

### Step 7 — Backend TDD (in Terminal 1)

```
[tdd-implementer writes OrderControllerTest @WebMvcTest — RED]
[implements minimal OrderController — GREEN]
[writes OrderApplicationServiceTest — RED → implements — GREEN]
[writes OrderRepositoryTest @DataJpaTest — RED → implements — GREEN]
[creates V1__create_orders_table.sql Flyway migration]
[runs CucumberIT]
> CucumberIT: Tests run: 4, Failures: 0 ✅ ALL GREEN
> "Backend stream complete. Run /rushee:status when Flutter stream is also done."
```

### Step 8 — Flutter Implementation (in Terminal 2)

```
[flutter-implementer regenerates Dart client from spec]
[creates Order entity (Dart, Equatable)]
[writes PlaceOrderUseCase + unit test (mocktail) — RED → implements — GREEN]
[writes OrderBloc + bloc_test — RED → implements — GREEN]
[writes CartReviewScreen widget tests — RED → implements — GREEN]
[writes integration test against real backend (or WireMock)]
[runs flutter-reviewer]
> Gate F1 ✅  F2 ✅  F3 ✅  F4 ✅  F5 ✅
> FLUTTER REVIEW: APPROVED
> "Flutter stream complete."
```

### Step 9 — Security Check

```
/rushee:security-check FDD-001

BACKEND:
> ✅ @Valid on @RequestBody
> ✅ @PreAuthorize on endpoint
> ✅ No hardcoded secrets
> ✅ OWASP A01-A10: all pass

FLUTTER:
> ✅ JWT stored in flutter_secure_storage (not SharedPreferences)
> ✅ Certificate pinning configured
> ✅ No PII in logs
> ✅ Payment screen: screenshotPrevent = true
> VERDICT: APPROVED
```

### Step 10 — Final Review

```
/rushee:status

BACKEND — spring-reviewer (8 gates):
> Gate 1 DDD & Architecture    ✅
> Gate 2 SOLID Principles      ✅
> Gate 3 Spring Patterns       ✅
> Gate 4 Test Quality          ✅  (89% coverage)
> Gate 5 BDD/ATDD Quality      ✅
> Gate 6 Security              ✅  (APPROVED)
> Gate 7 Ops Readiness         ✅
> Gate 8 Database Migrations   ✅
> BACKEND: ✅ APPROVED

FLUTTER — flutter-reviewer (5 gates):
> Gate F1 Architecture Purity  ✅
> Gate F2 State Management     ✅
> Gate F3 Contract Compliance  ✅
> Gate F4 Test Coverage        ✅  (78% coverage)
> Gate F5 Mobile Security      ✅
> FLUTTER: ✅ APPROVED

OVERALL: ✅ APPROVED — Ready to merge FDD-001
```

---

## 11. Non-Negotiable Rules

### UX Rules
1. **No Feature Card before user journey is mapped** — screens in the Feature Card must exist in the Screen Inventory.
2. **No Figma design before wireframe spec** — text spec reviewed by a non-developer before Figma opens.
3. **UX discovery drives domain design** — domain events come from job stories, not database tables.

### Architecture Rules (Backend)
4. **No `@Entity` on domain model classes — ever.** JPA entities live in `infrastructure/persistence/`. *(Hook: BLOCKS)*
5. **No Spring annotations in `domain/` packages — ever.** *(Hook: BLOCKS)*
6. **No public setters on Aggregate Roots or Entities.** State changes through behaviour methods only.
7. **Dependencies only flow inward** — domain has no knowledge of application, infrastructure, or Flutter.

### Architecture Rules (Flutter)
8. **No API calls in widgets or BLoC — ever.** Only in `RemoteDataSource`.
9. **No Flutter imports in `domain/` Dart files — ever.** Pure Dart only.
10. **No `setState()` in screens that use BLoC.** All state in BLoC.
11. **No hardcoded `Color(0xFF...)`, font sizes, or spacing values.** Always use AppColors, AppTypography, AppSpacing tokens.

### Contract Rules
12. **No hand-written DTOs on either side.** Both codebases generate from the OpenAPI spec. *(Hook: WARNS on spec change)*
13. **No controller code before OpenAPI spec is saved.**
14. **No Flutter `RemoteDataSource` before OpenAPI spec is saved.**
15. **Breaking API change = new API version (`/v2/`)** + deprecation period on `/v1/`.

### Process Rules
16. **No production code before a Feature Card.** *(Hook: WARNS)*
17. **No implementation before acceptance tests are RED.**
18. **No technical language in Gherkin** — no HTTP, no URLs, no class names, no SQL.

### Security Rules
19. **No hardcoded secrets anywhere.** *(Hook: BLOCKS on `.java`, `.yml`, `.dart`)*
20. **JWT and tokens: `flutter_secure_storage` only** — never `SharedPreferences`.
21. **No merge without `security-reviewer` APPROVED.**

### Quality Rules
22. **No merge without `ops-reviewer` PRODUCTION READY.**
23. **Backend coverage ≥ 80% (JaCoCo).** Flutter domain + application ≥ 75%.
24. **`ddl-auto: validate`** in all non-local Spring profiles.
25. **Flyway migration required** for every `@Entity` change. *(Hook: REMINDS)*

---

## 12. Backend Project Structure

```
backend/src/
├── main/
│   ├── java/com/yourcompany/yourapp/
│   │   └── <context>/              ← one folder per bounded context
│   │       ├── domain/             ← PURE JAVA — zero framework imports
│   │       │   ├── model/
│   │       │   │   ├── Order.java              ← Aggregate Root
│   │       │   │   ├── OrderLine.java          ← Child Entity
│   │       │   │   ├── OrderId.java            ← Value Object (record)
│   │       │   │   ├── Money.java              ← Value Object (record)
│   │       │   │   └── OrderStatus.java        ← Enum
│   │       │   ├── event/
│   │       │   │   ├── OrderPlaced.java        ← Domain Event (record)
│   │       │   │   └── OrderCancelled.java
│   │       │   ├── exception/
│   │       │   │   └── OrderDomainException.java
│   │       │   └── port/
│   │       │       ├── in/PlaceOrderUseCase.java    ← Input port
│   │       │       └── out/OrderRepository.java     ← Output port (interface)
│   │       ├── application/        ← Use case orchestration
│   │       │   ├── OrderApplicationService.java
│   │       │   ├── command/PlaceOrderCommand.java   ← Input (record)
│   │       │   └── dto/OrderDto.java               ← Output (record)
│   │       └── infrastructure/     ← ALL framework code here
│   │           ├── web/
│   │           │   └── OrderController.java         ← @RestController
│   │           ├── persistence/
│   │           │   ├── JpaOrderRepository.java      ← implements OrderRepository
│   │           │   ├── OrderJpaEntity.java          ← @Entity (NOT domain)
│   │           │   └── mapper/OrderPersistenceMapper.java
│   │           ├── messaging/
│   │           │   └── OrderEventPublisher.java
│   │           └── config/OrderModuleConfig.java
│   └── resources/
│       ├── api/
│       │   └── order-api.yaml      ← OpenAPI 3.1 spec (source of truth)
│       ├── db/migration/
│       │   ├── V1__create_orders_table.sql
│       │   └── V2__create_order_lines_table.sql
│       └── application.yml
└── test/
    └── java/com/yourcompany/yourapp/<context>/
        ├── steps/PlaceOrderSteps.java      ← Cucumber steps
        ├── web/OrderControllerTest.java    ← @WebMvcTest
        ├── application/OrderServiceTest.java ← JUnit + Mockito
        └── persistence/OrderRepoTest.java  ← @DataJpaTest
```

---

## 13. Flutter Project Structure

```
mobile/lib/
├── core/                               ← Cross-cutting concerns
│   ├── error/
│   │   ├── failures.dart               ← Sealed class hierarchy
│   │   └── exceptions.dart
│   ├── network/
│   │   ├── api_client.dart             ← Dio + interceptors + cert pinning
│   │   └── api_constants.dart          ← Base URLs (from environment config)
│   ├── theme/
│   │   ├── app_theme.dart              ← ThemeData built from tokens
│   │   ├── app_colors.dart             ← ColorScheme (from Figma — NOT hardcoded)
│   │   ├── app_typography.dart         ← TextTheme (from Figma)
│   │   ├── app_spacing.dart            ← Spacing constants (from Figma)
│   │   └── app_radius.dart             ← Border radius constants
│   ├── router/
│   │   └── app_router.dart             ← go_router configuration
│   └── di/
│       └── injection_container.dart    ← GetIt service locator
│
└── features/
    └── order/                          ← ONE folder per bounded context
        ├── domain/                     ← PURE DART — zero Flutter imports
        │   ├── entities/
        │   │   └── order.dart          ← Equatable, immutable
        │   ├── repositories/
        │   │   └── order_repository.dart  ← abstract class
        │   └── usecases/
        │       ├── place_order_usecase.dart
        │       └── get_order_usecase.dart
        ├── data/                       ← Implementation — Dio, Hive, etc.
        │   ├── datasources/
        │   │   ├── order_remote_datasource.dart  ← uses generated API client
        │   │   └── order_local_datasource.dart   ← Hive offline cache
        │   ├── models/                           ← generated from OpenAPI spec
        │   │   └── [auto-generated by openapi-generator]
        │   └── repositories/
        │       └── order_repository_impl.dart    ← implements domain interface
        └── presentation/
            ├── bloc/
            │   ├── order_bloc.dart
            │   ├── order_event.dart    ← sealed class
            │   └── order_state.dart    ← sealed class
            ├── screens/
            │   ├── cart_review_screen.dart   ← S13
            │   ├── checkout_screen.dart      ← S14
            │   └── order_confirm_screen.dart ← S15
            └── widgets/
                ├── order_summary_card.dart   ← named to match Figma component
                └── cart_line_item.dart

test/
├── features/
│   └── order/
│       ├── domain/
│       │   └── usecases/place_order_usecase_test.dart  ← pure Dart, mocktail
│       ├── presentation/
│       │   ├── bloc/order_bloc_test.dart               ← bloc_test
│       │   └── screens/cart_review_screen_test.dart    ← widget test
│       └── contract/
│           └── order_api_contract_test.dart            ← validates JSON shapes
└── golden/                                             ← pixel regression
    └── cart_review_screen.png
```

---

## 14. The OpenAPI Contract Bridge

The OpenAPI spec at `backend/src/main/resources/api/<context>-api.yaml` is
**the single most important file in the entire project**. It is the contract
between the backend team and the Flutter team. Neither side owns it unilaterally.

### How it generates both codebases

```
order-api.yaml
     │
     ├── Spring Boot (openapi-generator-maven-plugin)
     │   └── generates OrdersApi interface
     │       └── OrderController implements OrdersApi
     │           └── if spec changes → compile error → forced fix
     │
     └── Flutter (openapi-generator dart-dio)
         └── generates OrderModel + OrdersApiClient
             └── OrderRemoteDataSource uses OrdersApiClient
                 └── if spec changes → regenerate → type errors → forced fix
```

### The Two Types of API Change

**Non-breaking (backward compatible):**
```yaml
# Adding a NEW optional field — safe
OrderResponse:
  properties:
    orderId:          { type: string }
    status:           { type: string }
    estimatedDelivery: { type: string, format: date }  ← NEW optional field
```
Action: Add to spec → regenerate both clients → add to any existing Flutter
model tests → deploy backend → Flutter works with and without the new field.

**Breaking (requires versioning):**
```yaml
# Removing or renaming a field — BREAKING
# Old: orderId  →  New: id   ← Flutter crashes if orderId disappears
```
Action: Add new `/api/v2/orders` endpoint with the new shape → keep `/api/v1/orders`
working → add `Sunset` header to v1 → update Flutter to v2 → deprecate v1 after
all clients are updated.

### The Contract Test

Write one contract test in Flutter that validates the JSON shape matches the spec:

```dart
// test/contract/order_api_contract_test.dart
void main() {
  group('Order API Contract', () {
    test('POST /api/v1/orders response matches OrderResponse schema', () async {
      final response = await orderApiClient.placeOrder(request);
      // If the spec changed and clients weren't regenerated, this throws
      expect(response.orderId, isNotNull);
      expect(response.status, isNotNull);
      expect(response.totalAmount, isNotNull);
    });
  });
}
```

---

## 15. Flutter Architecture

Flutter's clean architecture in Rushee is a direct mirror of Spring Boot's hexagonal architecture.

### Layer Mapping

| Spring Boot | Flutter | Rule |
|-------------|---------|------|
| `domain/model/Order.java` | `domain/entities/order.dart` | Pure language, no framework imports |
| `domain/port/out/OrderRepository.java` | `domain/repositories/order_repository.dart` | Abstract interface only |
| `application/OrderApplicationService.java` | `application/usecases/place_order_usecase.dart` | Calls domain, calls repo interface |
| `infrastructure/persistence/JpaOrderRepository.java` | `data/repositories/order_repository_impl.dart` | Implements domain interface |
| `infrastructure/web/OrderController.java` | `presentation/bloc/order_bloc.dart` | Receives user actions, emits states |
| (HTML/JSON response) | `presentation/screens/cart_review_screen.dart` | Renders BLoC states |

### BLoC Pattern

```dart
// The BLoC is the Flutter equivalent of both the Controller and the Application Service
// It receives Events (user actions) and emits States (UI states)

// ✅ Correct
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final PlaceOrderUseCase _placeOrderUseCase;   // injected use case

  OrderBloc(this._placeOrderUseCase) : super(OrderInitial()) {
    on<PlaceOrderRequested>(_onPlaceOrderRequested);
  }

  Future<void> _onPlaceOrderRequested(
    PlaceOrderRequested event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());                         // ← always emit Loading first
    final result = await _placeOrderUseCase(      // ← calls use case, not repo
      PlaceOrderParams(cartId: event.cartId),
    );
    result.fold(
      (failure) => emit(OrderError(failure.message)),  // ← always handle failure
      (order)   => emit(OrderPlaced(order)),            // ← success case
    );
  }
}

// ❌ Wrong — BLoC calling repository directly
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _repo;   // ← wrong: should use use case, not repo
```

### Error Handling — Either<Failure, T>

```dart
// domain/entities/failures.dart
sealed class Failure {
  final String message;
  const Failure(this.message);
}
class ServerFailure extends Failure { const ServerFailure(super.message); }
class NetworkFailure extends Failure { const NetworkFailure(super.message); }
class ValidationFailure extends Failure { const ValidationFailure(super.message); }

// Every use case returns Either<Failure, T> — never throws
class PlaceOrderUseCase {
  final OrderRepository _repo;
  PlaceOrderUseCase(this._repo);

  Future<Either<Failure, Order>> call(PlaceOrderParams params) async {
    try {
      return Right(await _repo.placeOrder(params));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return Left(NetworkFailure('Check your connection'));
    }
  }
}
```

---

## 16. UX Design Workflow

### The Right Order

```
1. Persona definition      (who uses the app)
         ↓
2. Job Story mapping        (what they're trying to do + WHY)
         ↓
3. Domain event extraction  (what happens in the system)  ← feeds event-storm
         ↓
4. Screen Inventory         (every screen named before Figma opens)
         ↓
5. Navigation map           (how screens connect → drives state management choice)
         ↓
6. Wireframe specs          (text description reviewed by non-developer)
         ↓
7. Figma design             (designer works from wireframe spec)
         ↓
8. Design token extraction  (colors, typography, spacing → AppColors, AppTypography)
         ↓
9. Feature Cards            (each card links to specific screen IDs)
```

### Where visual verification happens (Figma, wireframes)

The plugin **does not run** Figma, Miro, or other visual tools. Phase 0 produces **text** artifacts only: personas, job stories, screen inventory, navigation map, and **wireframe specs** (markdown descriptions of each screen). Designers use those specs to build in Figma; you then update the screen inventory’s “Figma Status” and extract design tokens into `frontend/src/` (Angular) or `mobile/lib/core/theme/` (Flutter) before frontend implementation. Golden tests (Flutter) compare to a stored baseline, not to Figma. So: **visual verification is in your process** (approve in Figma, update status, extract tokens), not inside the plugin. **How UX output feeds later phases:** event-stormer reads domain events from job stories; feature-analyst reads screen inventory and personas for Feature Cards; api-designer reads wireframe specs for “API calls this screen makes”; angular-implementer (or flutter-implementer) reads screen inventory (and Figma status) and design tokens. See below for UX outputs and how they feed later phases.

#### What the plugin produces in UX discovery (Phase 0)

| Output | Location | What it is |
|--------|----------|------------|
| Personas | `docs/ux/personas.md` | Who uses the app; context, goals, constraints |
| Job stories | `docs/ux/job-stories.md` | When/I want/so I can + **domain events** + screens required |
| Screen inventory | `docs/ux/screen-inventory.md` | Every screen (ID, name, persona, job story, status) |
| Navigation map | `docs/ux/navigation-map.md` | How screens connect (tabs, modals, wizards) |
| Wireframe **specs** | `docs/ux/wireframe-specs/<ScreenName>.md` | **Text** description: purpose, UI states, content order, interactions, **API calls** |

Wireframe specs are not visual — they are markdown. Designers use these specs to build in Figma; the plugin does not generate or open Figma files. **After** Phase 0, a designer builds Figma from the wireframe specs. Update the screen inventory's Figma Status when approved. Design tokens (colors, typography, spacing) are extracted into e.g. `frontend/src/styles/ or theme`; the plugin expects these before Flutter implementation and does not pull them from Figma automatically.

#### How UX output is fed into subsequent phases

| Phase | Command / agent | Reads from UX | How it uses UX output |
|-------|------------------|---------------|------------------------|
| Phase 1 | `/rushee:event-storm` | `job-stories.md`, `personas.md` | Domain events from job stories for Event Storming |
| Phase 1b | `/rushee:ddd-model` | context map, job stories, personas | Align aggregate/entity names with user journeys |
| Phase 2 | `/rushee:feature` | screen inventory, personas, job stories | Screens table from inventory; Actor from personas; criteria from job stories |
| Phase 2b | `/rushee:api-design` | FDD-NNN.md, domain-model, **wireframe-specs/*.md** | Wireframe specs' "API calls this screen makes" → endpoints and request/response shapes |
| Phase 3 | `/rushee:bdd-spec` | FDD-NNN.md, optionally wireframe-specs | Wireframe specs can suggest UI states (loading, empty, error) as scenarios |
| Phase 4f | `/rushee:angular-feature` | FDD-NNN.md, **screen-inventory** (Figma status), design tokens | Screen list + Figma status; theme tokens; component naming aligned with Figma |

**Quick reference:** `personas.md` → event-stormer, domain-modeller, feature-analyst (Actor). `job-stories.md` → event-stormer (domain events), domain-modeller, feature-analyst (criteria). `screen-inventory.md` → feature-analyst (Screens table), flutter-implementer (screen list + Figma status). `wireframe-specs/*.md` → api-designer (API calls per screen), gherkin-writer (optional UI states). Design tokens in `frontend/src/` (Angular) or `mobile/lib/core/theme/` (Flutter) are required by the frontend implementer before building screens.

### Design Token Extraction

Before writing a single Flutter widget, extract design tokens from the approved
Figma design into Dart constants:

```dart
// core/theme/app_colors.dart — names MATCH Figma layer names exactly
abstract class AppColors {
  static const Color primary500 = Color(0xFF1565C0);  // "Primary/500" in Figma
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB00020);
  static const Color onPrimary = Color(0xFFFFFFFF);
}

// core/theme/app_spacing.dart
abstract class AppSpacing {
  static const double xs = 4.0;   // "Spacing/XS" in Figma
  static const double s  = 8.0;
  static const double m  = 16.0;
  static const double l  = 24.0;
  static const double xl = 32.0;
}

// Usage in widgets — ALWAYS tokens, NEVER magic values
Padding(
  padding: EdgeInsets.all(AppSpacing.m),   // ✅
  // padding: EdgeInsets.all(16),          // ❌
  child: Text(
    'Place Order',
    style: Theme.of(context).textTheme.headlineMedium,  // ✅
    // style: TextStyle(fontSize: 24),                   // ❌
  ),
)
```

### Widget Naming Mirrors Figma Component Naming

```
Figma component: "OrderSummaryCard"  →  Flutter widget: OrderSummaryCard
Figma component: "PrimaryButton"     →  Flutter widget: AppPrimaryButton
Figma component: "CartLineItem"      →  Flutter widget: CartLineItemWidget
```

This is non-negotiable. When a designer says "the OrderSummaryCard is wrong",
every developer on the team knows exactly which file to open.

---

## 17. Debugging with Rushee

```
/rushee:debug "<what failed>"
```

### Backend Failure Categories

| # | Category | Symptoms |
|---|----------|---------|
| A | Spring wiring | `BeanCreationException`, `NoSuchBeanDefinitionException`, context fail |
| B | JPA / Transactions | `LazyInitializationException`, `TransactionRequiredException` |
| C | Wrong value | `AssertionError: expected X but was Y` |
| D | Null pointer | `NullPointerException` — missing mock, missing validation |
| E | Cucumber | `Undefined step`, `PendingException` |
| F | HTTP test | Wrong status in `@WebMvcTest`, unexpected 401/403 |
| G | Test isolation | Passes alone, fails in suite |

### Flutter Failure Categories

| # | Category | Symptoms |
|---|----------|---------|
| H | Provider / BLoC wiring | `ProviderNotFoundException`, BLoC not found in widget tree |
| I | Async state | Widget renders before Future completes, `pump()` not awaited |
| J | Widget rendering | Golden test mismatch, layout overflow, missing widget |
| K | Golden drift | Golden file out of date after design change |
| L | Integration timing | Integration test fails intermittently — timing/race condition |

---

## 18. Parallel Features

### Mode 1 — Backend + Flutter in parallel (most common)

Once the API contract is approved and backend acceptance tests are RED:

```bash
# Two Claude Code sessions, same project
# Terminal 1
/rushee:tdd-cycle FDD-001      # Spring Boot implementation

# Terminal 2 (separate window)
/rushee:angular-feature FDD-001  # Angular implementation
```

Both work independently from the same spec. No file conflicts.
Sync point: both streams done → run `./mvnw test` and `flutter test` → `/rushee:status`.

### Mode 2 — Multiple features in a sprint

```bash
git worktree add ../project-FDD-004 -b feature/FDD-004-discount-codes
git worktree add ../project-FDD-005 -b feature/FDD-005-order-history
git worktree add ../project-FDD-006 -b feature/FDD-006-notifications

# Three separate terminal windows, each with its own Claude Code session
```

---

## 19. Extending Rushee

```
/rushee:extend skill <name>
/rushee:extend command <name>
/rushee:extend agent <name>
```

### Good candidates for new skills

- Your design system's specific component library (`your-app-design-system`)
- A framework you use: Riverpod instead of BLoC, GetX, etc. (`flutter-riverpod-patterns`)
- Flutter offline-first with Hive (`flutter-offline-first`)
- Resilience patterns for API calls (`resilience-patterns`)
- Push notifications and deep links (`flutter-notifications`)
- A bug pattern that escaped review and cost you time

### Adding other frontend and backend stacks

You can add **other frontends** (e.g. React, Svelte, Angular) and **other backends** (e.g. Python, TypeScript, Go, Rust) and keep the **same full-stack flow** (UX → domain → contract → code) and **similar architecture styles** (clean/hexagonal, domain at center, contract-first).

**What stays the same (stack-agnostic):**

- **Phases 0–2b:** UX discovery, event storming, DDD model, Feature Card, **OpenAPI contract**. These are framework-agnostic. Personas, job stories, context map, domain-model.md, FDD-NNN.md, and the API spec work for any backend and any frontend.
- **Contract:** OpenAPI 3.1 remains the single source of truth. Any backend and any frontend can generate clients or server stubs from it.
- **Pipeline idea:** Never write code before the contract; never design the contract before the domain model; never design the domain before the user journey.

**What is stack-specific (what you add via extend):**

| Layer | Rushee today | How to add another stack |
|-------|----------------|---------------------------|
| **Backend (Phase 4)** | Spring Boot + Java: `tdd-implementer`, `spring-reviewer`, BDD (Cucumber-JVM), domain purity (no framework in domain). | Add a **skill** (e.g. `fastapi-clean-architecture`, `go-ports-adapters`) and an **agent** (e.g. `fastapi-tdd-implementer`, `go-reviewer`) that enforce the same rules: domain pure, ports & adapters, BDD/ATDD then TDD. Use the same OpenAPI spec and Feature Cards; only the implementation language and test runner change (e.g. pytest-bdd, Behave, Godog). |
| **Frontend (Phase 4f)** | Angular + TypeScript: `angular-implementer`, clean layers (domain/data/presentation), NgRx/signals, OpenAPI client. Also Flutter: `flutter-implementer`, `flutter-reviewer`. | Add a **skill** (e.g. `react-clean-architecture`, `svelte-ports-adapters`) and an **agent** (e.g. `react-feature-implementer`, `angular-reviewer`) that enforce: domain pure, no API calls in UI, design tokens, generated client from OpenAPI. Same docs (screen inventory, wireframe specs, Feature Card); only the framework and folder layout change (e.g. `src/domain`, `src/application`, `src/infrastructure`, `src/presentation`). |

**Example stacks you can add (same architecture style):**

- **Frontends:** React (Vite + React Query / Zustand), Svelte, Angular, Vue — each with domain/application/infrastructure/presentation (or equivalent), OpenAPI-generated client, and a reviewer agent.
- **Backends:** Python (FastAPI + domain layer + pytest-bdd), TypeScript (NestJS or Node + clean layers + Cucumber/Playwright), Go (standard lib or Echo/Gin + hexagon + Godog), Rust (Actix/Axum + domain crate + BDD) — each with domain purity, ports & adapters, and a reviewer agent.

**Steps to add a new stack:**

1. Use **`/rushee:extend skill <stack>-clean-architecture`** (or `<stack>-ports-adapters`) — document the layer rules, where domain/application/infrastructure live, and “no framework in domain.”
2. Use **`/rushee:extend agent <stack>-implementer`** (and optionally **`<stack>-reviewer`**) — same pipeline step (read Feature Card + OpenAPI, implement feature, run tests), but for your stack’s layout and test runner.
3. Optionally add a **command** (e.g. `/rushee:react-feature` or `/rushee:fastapi-tdd-cycle`) that invokes your implementer and points to the same upstream docs (FDD-NNN.md, OpenAPI, screen inventory).
4. Keep **Phase 0–2b and the contract unchanged.** Your new backend/frontend consumes the same `docs/` and `*-api.yaml`.

Rushee’s out-of-the-box flow is **Angular + Spring Boot**. Adding React, Svelte, Flutter, Python, Go, Rust, or TypeScript is done by **extending** with new skills and agents that follow the same architecture and pipeline; the shared pipeline and OpenAPI contract keep everything aligned.

### Project-specific skills (not for upstream)

Organisation-specific skills belong in `.claude/skills/`:

```
your-project/
└── .claude/
    └── skills/
        ├── company-design-system/
        │   └── SKILL.md
        └── internal-auth-sdk/
            └── SKILL.md
```

Claude Code discovers these alongside Rushee's skills. Project skills take
precedence when names conflict.

### Using companion skills (e.g. deep-dive) with Rushee

**Rushee tells you *what* to do and *when*.** A **deep-dive** (or other companion) skill or plugin tells you *how* in depth — patterns, internals, framework details. Juniors often don’t know when to switch to “go deep,” so use this as a guide.

**When to use a deep-dive (or similar) skill alongside Rushee**

| You’re in this phase / situation | Rushee says | When you’re stuck or unsure | Use a companion skill like… |
|----------------------------------|-------------|-----------------------------|------------------------------|
| Phase 0 (UX) | Run ux-discovery, write personas/job stories | “What’s a good job story?” “How do I run a workshop?” | UX / discovery / facilitation deep-dive (if installed) |
| Phase 1 / 1b (Domain) | Run event-storm, ddd-model | “What’s an aggregate vs entity?” “How do I model this?” | DDD / event storming / domain modelling deep-dive |
| Phase 2b (API) | Run api-design, write OpenAPI | “How do I design REST?” “What’s a good status code?” | API design / OpenAPI deep-dive |
| Phase 3 / 3b (BDD / ATDD) | Run bdd-spec, atdd-run | “How do I write good Gherkin?” “How do step defs work?” | BDD / Cucumber / ATDD deep-dive |
| Phase 4 (Backend) | Run tdd-cycle (or fastapi / nest / go / rust) | “I don’t understand repositories / ports and adapters.” | Spring Boot / FastAPI / Nest / Go / Rust deep-dive for your stack |
| Phase 4f (Frontend) | Run angular-feature (or react / svelte / flutter) | “I don’t understand clean layers / state / NgRx.” | Angular / React / Svelte / Flutter deep-dive for your stack |
| Security / Ops | Run security-check, status | “What’s OWASP?” “How do I add logging?” | Security / observability deep-dive |

**How to use them together**

1. **Keep Rushee as your loop:** Run `/rushee:start` and do the next step it suggests.
2. **When you don’t understand the *how*:** In the same session, ask explicitly, e.g. “Using the [deep-dive / X] skill, explain how to design this aggregate” or “I’m in Phase 4 (backend); give me a deep dive on Spring Boot repositories and then we’ll continue with Rushee.”
3. **What’s “available”:** Depends on your setup. In Claude Code or Cursor, any installed plugin or skill (e.g. from a marketplace or your org’s “deep dive” framework) is available in the same chat. Rushee doesn’t ship a specific deep-dive product; it just recommends *when* to reach for one so juniors don’t have to guess.

**Summary for juniors:** If Rushee says “do Phase X” and you’re not sure *how* to do it well, that’s the moment to ask for a deep-dive (or similar) on that topic — then continue with Rushee for the next step.

---

## 20. Technology Stack

### Backend (default: Spring Boot + Spring ecosystem)

| Concern | Technology | Version |
|---------|-----------|---------|
| Language | Java | 17+ |
| Framework | Spring Boot | 3.x |
| Build | Maven | 3.8+ |
| BDD | Cucumber-JVM | 7.x |
| Unit tests | JUnit 5 + Mockito | 5.x |
| API tests | REST-assured | 5.x |
| API spec | OpenAPI | 3.1 |
| Schema migration | Flyway | 9.x+ |
| Coverage | JaCoCo | 0.8.x |
| Architecture tests | ArchUnit | 1.x |
| Security | Spring Security + OAuth2 | Boot 3.x |
| Observability | Micrometer + OpenTelemetry | Latest |
| Messaging | Apache Kafka / RabbitMQ | Latest |

**Spring ecosystem (umbrella — all usable with Rushee; keep in infrastructure):**

| Project | Purpose |
|---------|---------|
| **Spring Boot** | Core, auto-config, **embedded server** (Tomcat/Jetty/Undertow) |
| **Spring AI** | AI/LLM (Chat, Embeddings, RAG, multi-provider: OpenAI, Anthropic, etc.) |
| **Spring Integration** | EIP, messaging adapters, channels, gateways |
| **Spring Cloud** | Config Server, Discovery, Gateway, OpenFeign, LoadBalancer, Circuit Breaker |
| **Spring Cloud Stream** | Binder abstraction (Kafka, Rabbit) |
| **Spring Batch** | Batch jobs, chunking, readers/writers, job repository |
| **Spring Data** | JPA, Redis, MongoDB, Elasticsearch, etc. |
| **Spring for Apache Kafka** | KafkaTemplate, @KafkaListener |
| **Spring AMQP** | RabbitMQ |
| **Spring Session** | Session storage (Redis, JDBC) |
| **Spring HATEOAS** | Hypermedia REST |
| **Spring Statemachine** | State machines |

All of these live in **infrastructure** (adapters); the **domain** layer stays pure (no Spring imports). Use the **spring-ecosystem** skill when adopting any of these. See [spring.io/projects](https://spring.io/projects) for the full portfolio.

### Flutter Mobile

| Concern | Technology |
|---------|-----------|
| Language | Dart 3.0+ |
| Framework | Flutter 3.7+ |
| State management | BLoC / flutter_bloc |
| Dependency injection | get_it |
| HTTP client | Dio |
| API client generation | openapi-generator dart-dio |
| Routing | go_router |
| Secure storage | flutter_secure_storage |
| Local cache | Hive |
| Unit testing | flutter_test + mocktail |
| BLoC testing | bloc_test |
| Integration testing | integration_test |
| Error handling | fpdart (Either<Failure, T>) |
| Code generation | freezed + json_serializable |

### UX Design

| Concern | Technology |
|---------|-----------|
| Design | Figma |
| Design tokens → Flutter | Manual extraction → AppColors/AppTypography |
| Figma → Flutter (optional) | Builder.io Visual Copilot / Dualite |

---

## 21. FAQ

**Q: Does Rushee work for greenfield and brownfield projects?**  
A: Yes. **Greenfield (new project):** Run `/rushee:start` from your project root. It will see no (or minimal) Rushee artifacts and tell you to start with `/rushee:ux-discovery`. Follow the pipeline from there. **Brownfield (existing project):** Run `/rushee:start` — it scans for existing docs (personas, context map, feature cards, OpenAPI, Gherkin, code) and recommends the **next step** based on what it finds. For a codebase that never used Rushee, run **`/rushee:bootstrap retrofit`** first: it scans the repo and infers where you are in the pipeline (e.g. "you have domain classes and an API spec; missing Feature Cards and Gherkin"). Then use **`/rushee:bootstrap phase-N FDD-NNN`** (e.g. `phase-3 FDD-001` to start at BDD, or `phase-4f FDD-001` for Flutter only) to jump to a phase. The bootstrapper will help create any missing stub files (e.g. a minimal Feature Card) so you can run that phase. You can skip phases when you already have the outputs (e.g. "we have an API spec, start at BDD"); you cannot skip **prerequisites** — the bootstrapper helps you add the minimum required files when you skip.

**Q: Can I use React, Svelte, Angular, or Python, Go, Rust, TypeScript instead of Flutter / Spring Boot?**  
A: Rushee default stack is **Angular + Spring Boot**. The **pipeline** (UX → domain → contract → code) and the **OpenAPI contract** are stack-agnostic. To use another frontend (React, Svelte, Angular, Vue) or backend (Python/FastAPI, TypeScript/Nest, Go, Rust), you **extend** Rushee: add a skill for that stack’s clean-architecture/ports-adapters rules and an agent (implementer + optional reviewer) that reads the same Feature Cards and OpenAPI spec and implements in your stack. See [Adding other frontend and backend stacks](#adding-other-frontend-and-backend-stacks) in § Extending Rushee. No change to Phase 0–2b or the contract; only the implementation phase (4 and 4f) is stack-specific.

**Q: Do I have to use BLoC for Flutter state management? What about Riverpod?**
A: Rushee's `flutter-clean-architecture` skill uses BLoC as the default because it
has the most explicit separation between events, states, and business logic — making
it the most testable. Riverpod is equally valid. Run `/rushee:extend skill flutter-riverpod-patterns`
to add Riverpod-specific patterns. The architecture layers (domain/data/presentation)
are identical regardless of which state management library you choose.

**Q: Can I use FlutterFlow or auto-generate Flutter code from Figma?**
A: Yes, for the presentation layer. Tools like Builder.io Visual Copilot or Dualite
generate Flutter widget code from Figma designs. The generated code should go in
`presentation/screens/` and `presentation/widgets/`. The domain, application, and
data layers must still be hand-crafted — no code generator handles business logic
or the OpenAPI contract integration correctly. Use code generation for widgets,
not for architecture.

**Q: The guard-domain-purity hook blocked my file. What do I do?**
A: You added `@Entity`, `@Service`, or a Spring annotation to a class in `domain/`.
Domain classes are pure Java. Move the class to `infrastructure/persistence/` (for
JPA entities) or remove the annotation. Same applies in Flutter — if you added a
`dio` import to a `domain/` Dart file, move the data access to the `data/` layer.

**Q: Both the backend and Flutter need to change for a single feature. Is that normal?**
A: Yes — that's the point of a full-stack discipline. A Feature Card represents
a user-visible behaviour. User-visible behaviours require a screen (Flutter) and
data from an API (Spring Boot). Both streams implement from the same OpenAPI spec,
so the work is parallel and independent, not sequential and blocking.

**Q: We only have a backend (no Flutter app). Can we still use Rushee?**
A: Yes. Run the pipeline through Phase 4: `/rushee:ux-discovery` → … → `/rushee:tdd-cycle FDD-NNN`. Then run `/rushee:security-check` and `/rushee:status`. Stop after backend approval. Use `/rushee:bootstrap phase-4 FDD-NNN` if you already have code and want to add discipline.

**Q: We only have a Flutter app; the API is external or in another repo. Can we use Rushee?**
A: Yes. You need an OpenAPI spec for the API (from the other team or a stub). Put shared docs in `docs/` (UX, screen inventory, feature cards). Run `/rushee:bootstrap phase-4f FDD-NNN` and ensure the OpenAPI spec path is correct (e.g. `backend/src/main/resources/api/<context>-api.yaml` or a path you provide). Flutter implementer will generate the client from that spec.

**Q: What if the Figma design isn't ready when I want to start the Flutter feature?**
A: The flutter-implementer will stop at the design token check and report which
design tokens are missing. This is correct behaviour. The domain and application
Dart layers (entities, use cases) can be built without the Figma design because
they contain no UI. Only the presentation layer (widgets and screens) requires
approved design tokens. Use that time to build and test the domain + application
layers first.

**Q: Can I skip the UX Discovery for a small, internal tool?**
A: You can, but even for internal tools, mapping the Screen Inventory takes 30 minutes
and saves hours of "we forgot the empty state" or "where does the error message go"
decisions during development. At minimum, write a Screen Inventory before opening Figma.

**Q: Can I use Gradle instead of Maven on the backend?**
A: Replace `./mvnw` with `./gradlew` in the relevant skill files and `regenerate-clients.sh`.
The plugin logic is identical — Gradle support is on the roadmap for v3.

**Q: How do I handle offline support in Flutter?**
A: The `data/datasources/order_local_datasource.dart` layer is where Hive (or Isar)
caching lives. The `OrderRepositoryImpl` decides whether to call remote or local based
on connectivity. The domain and presentation layers are completely unaware of this —
they always call the same `OrderRepository` interface. Run
`/rushee:extend skill flutter-offline-first` to add a dedicated offline-first skill.

**Q: Where do I ask questions or report bugs?**
A: Open an issue at `github.com/<your-username>/rushee/issues`.

---

## Contributing

1. Fork `github.com/<your-username>/rushee`
2. Branch: `git checkout -b skill/your-new-skill`
3. Follow the `extending-rushee` skill guide
4. Test in a real Angular + Spring Boot project
5. Submit a PR with the skill, updated `plugin.json`, and a `CHANGELOG.md` entry

Replace `<your-github-username>` in `.claude-plugin/plugin.json` and
`.claude-plugin/marketplace.json` before publishing.

MIT License.
