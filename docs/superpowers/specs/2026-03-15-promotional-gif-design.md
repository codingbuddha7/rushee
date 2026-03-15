# Rushee Promotional GIF — Design Spec

**Date:** 2026-03-15
**Status:** Approved

---

## Overview

Two animated GIFs that show what Rushee does at a glance:

- **`demo/rushee-readme.gif`** — short loop (~7s) for the GitHub README header
- **`demo/rushee-social.gif`** — longer demo (~16s, plays once) for launch posts on Twitter/X, LinkedIn, Reddit

---

## Visual Style

**Split-screen layout:** every scene (except the end card) has two panels side by side.
- **Left panel:** terminal running a Rushee command (typewriter effect)
- **Right panel:** the artifact the command produces

**Theme:**

| Property | Value |
|----------|-------|
| Dimensions | 900 × 500 px |
| Background | `#0d1117` (GitHub dark) |
| Font | `'SF Mono', 'Cascadia Code', 'Consolas', monospace` |
| Green (success) | `#3fb950` |
| Red (failure / block) | `#f85149` |
| Blue (commands) | `#58a6ff` |
| Yellow (warnings / labels) | `#e3b341` |
| Purple (branding / section labels) | `#a78bfa` |
| Muted text | `#8b949e` |
| Panel divider | `#30363d` |

**Animation mechanics:**
- Command text: typewriter at 30ms per character
- Output lines: appear instantly, staggered 200ms apart
- Scene transitions: 300ms crossfade — **the 300ms is the final 300ms of each scene's stated duration** (inclusive; no extra time is added between scenes)
- Cursor: blinking block `▌` shown while command is typing, disappears once output appears

---

## Scene Breakdown

### Short README loop (`rushee-readme.gif`) — ~7s, loops forever

| # | Scene | Duration | Left panel | Right panel |
|---|-------|----------|-----------|-------------|
| 1 | Session banner | 2s (incl. 300ms fade to Scene 2) | `$ claude` → `✔ Rushee loaded` → `Scanning repo…` → `▸ Next step: /rushee:feature` | Pipeline checklist — phases 0–1b shown as `✔`, Phase 2 shown as `▶ Feature Card ← you are here` in white, phases 2b–5 shown as `○` in `#8b949e` |
| 2 | Feature Card → OpenAPI | 2.5s (incl. 300ms fade to Scene 3) | `/rushee:feature "Place order"` types in → `✔ FDD-001.md written` → then `/rushee:api-design FDD-001` types in → `✔ order-api.yaml written` | Panel switches mid-scene: FDD-001.md snippet fades to order-api.yaml snippet (see exact content below) |
| 3 | RED → GREEN | 2.5s (incl. 300ms fade back to Scene 1) | `/rushee:atdd-run FDD-001` types in → `● 3 scenarios FAILED` in `#f85149` → `✔ Tests confirmed RED` in `#8b949e` → `/rushee:tdd-cycle FDD-001` types in → `✔ 3 scenarios PASSED` in `#3fb950` | Animated counter: large `● 3 failed` in `#f85149` transitions to `✔ 3 passed` in `#3fb950` |
| — | Loop | — | Crossfades back to Scene 1 | |

### Long social post (`rushee-social.gif`) — ~16s, plays once

| # | Scene | Duration | Left panel | Right panel |
|---|-------|----------|-----------|-------------|
| 1 | Session banner | 3s (incl. 300ms fade) | Same as README Scene 1 | Same as README Scene 1 |
| 2 | Feature Card → OpenAPI | 4s (incl. 300ms fade) | Same as README Scene 2 (slower typing pace to fill 4s) | Same as README Scene 2 |
| 3 | BDD Gherkin | 4s (incl. 300ms fade) | `/rushee:bdd-spec FDD-001` types in → `No HTTP. No URLs. No SQL.` (hardcoded copy, not from a demo file) → `✔ FDD-001-place-order.feature written` | Static display of `Background:` block + first scenario only (see exact content below). No scrolling. |
| 4 | RED → GREEN | 5s (incl. 300ms fade) | Same as README Scene 3 (slower pace to fill 5s) | Same as README Scene 3 |
| 5 | End card | **2s hold, then GIF ends** | Full-width (no split-screen) — centred layout, see end card spec below | (same element — full-width card) |

---

## Exact Content for Each Right Panel

### Scene 1 — Pipeline checklist (both GIFs)

```
RUSHEE PIPELINE          ← #a78bfa, small-caps label

✔  UX Discovery          ← #3fb950
✔  Event Storm           ← #3fb950
✔  DDD Model             ← #3fb950
▶  Feature Card          ← #ffffff  "← you are here"  in #8b949e
○  API Design            ← #484f58
○  BDD · ATDD · TDD      ← #484f58
○  Frontend · Security   ← #484f58
```

### Scene 2 — FDD-001.md snippet (shown first, then fades)

Exact field values from `demo/FDD-001.md`:

```
ID:                FDD-001
Actor:             Amara (Shopper)
Feature Statement: Place an order from the current
                   cart so the shopper can complete
                   their purchase.
```

Label at top of panel: `FDD-001.md` in `#e3b341`.

### Scene 2 — order-api.yaml snippet (shown after FDD fades)

Show only the orders endpoint. A truncation comment signals that more endpoints exist:

```yaml
# order-api.yaml  (2 more endpoints omitted)

POST /api/v1/orders
  → 201  OrderConfirmed
  → 422  Unprocessable
```

Label at top of panel: `order-api.yaml` in `#e3b341`.
`POST` keyword in `#79c0ff`, status codes in `#3fb950` / `#f85149`.

### Scene 3 (Social only) — BDD feature file

Display `Background:` block and the first scenario only. Exact text from `demo/FDD-001-place-order.feature`:

```gherkin
Background:
  Given the product catalogue contains:
    | name         | price |
    | Laptop Stand | 49.99 |
    | USB-C Hub    | 29.99 |

Scenario: Shopper places a successful order
  Given Amara has added 1 "Laptop Stand" to her cart
  And Amara has added 2 "USB-C Hub" units to her cart
  When Amara places her order
  Then an order is created with status "PENDING"
  And the order total is 109.97
  # … (1 more step omitted for display)
```

Label at top: `FDD-001-place-order.feature` in `#e3b341`.
`Background:` / `Scenario:` keywords in `#a78bfa`.
`Given` / `And` / `When` / `Then` in `#8b949e`.
String literals (`"PENDING"`, `109.97`) in `#3fb950`.

### Scene 3 / 4 — RED → GREEN counter (right panel, both GIFs)

Large centred counter animation:

```
● 3 failed      ← #f85149, ~28px, shown for first half of scene
     ↓          ← #8b949e arrow, appears after 1s pause
✔ 3 passed      ← #3fb950, ~28px, replaces failed count
```

No coverage percentage.

### Scene 5 (Social only) — End card

Full-width card, no split-screen. Centred vertically and horizontally on `#0d1117` background:

```
RUSHEE
──────────────────────
Every phase guided.
Shortcuts caught.
Any stack supported.
```

- `RUSHEE`: `#a78bfa`, monospace, ~22px, letter-spacing 4px
- Horizontal rule: 1px solid `#30363d`, width 200px
- Tagline lines: `#e6edf3`, ~14px, line-height 1.8
- Holds for 2s then GIF file ends

---

## Output Files

| File | Purpose |
|------|---------|
| `demo/rushee-readme.html` | Source animation for short loop — re-export any time |
| `demo/rushee-social.html` | Source animation for long version — re-export any time |
| `demo/rushee-readme.gif` | Final GIF — used in README `<img>` tag |
| `demo/rushee-social.gif` | Final GIF — attached to launch posts |

---

## Export Process

1. Build `demo/rushee-readme.html` and `demo/rushee-social.html`
2. Serve each via a local preview server
3. Open in Chrome, start the built-in GIF recorder
4. Let the animation play to completion (short: full 7s loop, long: 16s to end card)
5. Stop the recorder and export — file downloads automatically
6. Move exported GIFs to `demo/` and commit

---

## README Integration

After export, add to `README.md` immediately below the tagline line:

```markdown
![Rushee in action](demo/rushee-readme.gif)
```
