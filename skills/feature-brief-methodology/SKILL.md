---
name: feature-brief-methodology
description: >
  Explains the Feature Brief approach for junior and intern developers: what it is,
  when to use it instead of the full Phase 0-1 pipeline, and how to graduate to full
  UX Discovery and Event Storming as the team matures. Use when someone asks
  "why feature brief instead of UX discovery?", "when do I use the full pipeline?",
  "what is a feature brief?", or "should I skip UX discovery?".
version: 1.0.0
allowed-tools: [Read, Glob]
---

# Feature Brief Methodology

## What Is a Feature Brief?

A Feature Brief is the minimum viable context document for a feature. It answers three questions in plain English — no DDD, BDD, or UX methodology required.

**The three questions:**
1. **Who is the user?** — one sentence: their role and their goal
2. **What problem does it solve?** — one sentence: current pain + desired outcome
3. **What are the main domain concepts?** — 2–3 plain-English nouns

**Example:**
```markdown
**User:** A customer who wants to track their order status after purchase.
**Problem:** Customers have no visibility after checkout, causing support tickets.
**Domain concepts:** Order, Shipment, Customer
```

**Time to complete:** ~10 minutes.
**Output:** `docs/features/FDD-NNN-brief.md`
**Next step:** Feeds directly into `/rushee:feature` (Feature Card creation).

---

## When to Use Feature Brief vs. Full Pipeline

| Situation | Recommended approach |
|-----------|----------------------|
| New team, first feature, interns/juniors | `/rushee:feature-brief` |
| Team unfamiliar with DDD and event storming | `/rushee:feature-brief` |
| Fast-moving startup, tight deadline | `/rushee:feature-brief` |
| Team experienced with DDD, complex domain | Full pipeline (Phases 0–1) |
| Multiple bounded contexts, large system | Full pipeline (Phases 0–1) |
| Existing Figma designs already done | `/rushee:bootstrap phase-2` (skips UX/domain phases — design already exists) |

**Rule of thumb:** If your team cannot explain what an aggregate is, use Feature Brief. If they can, use the full pipeline.

---

## What the Brief Skips (and Why That Is OK)

The Feature Brief intentionally omits:
- **Persona depth** — one sentence replaces a full persona document
- **Domain events** — concepts are named but not yet mapped as events
- **Bounded contexts** — no context map; the domain may need refactoring later
- **Aggregate classification** — nouns are listed but not yet classified as entity vs value object

**This is intentional.** The brief gets you to Phase 2 (Feature Card) quickly. These gaps become visible after 2–3 features, at which point the team is ready to backfill the upstream artifacts.

---

## How to Graduate to the Full Pipeline

After shipping 2–3 features using Feature Briefs, the team will encounter:
- Naming inconsistencies between features (→ ubiquitous language gap)
- Confusion about which context owns which concept (→ bounded context gap)
- Difficulty classifying new concepts (→ domain model gap)

That is the signal to graduate. Run in order:

1. `/rushee:event-storm` — map events that have already happened in the system retroactively
2. `/rushee:ddd-model <context>` — classify the concepts from existing briefs into the formal domain model
3. Update existing Feature Cards to use formal domain terminology

The guards (`guard-domain-purity`, `guard-no-hardcoded-secrets`) and all clean architecture skills remain active regardless of which path was taken.

---

## How the Brief Feeds into the Feature Analyst

When you run `/rushee:feature FDD-NNN` after a Feature Brief:
1. The `feature-analyst` reads `docs/features/FDD-NNN-brief.md` in its Step 0
2. It maps: Brief User → Feature Card Actor; Brief Problem → Business Value; Brief Concepts → Domain field
3. The interview is shorter — the first three questions are pre-answered
4. Output is a full Feature Card at `docs/features/FDD-NNN.md`

The brief file is kept after the Feature Card is created as a lightweight record of the original intent.
