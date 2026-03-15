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

**Split-screen layout:** every scene has two panels side by side.
- **Left panel:** terminal running a Rushee command (typewriter effect)
- **Right panel:** the artifact the command produces (Feature Card, OpenAPI spec, Gherkin file, test output)

**Theme:**
| Property | Value |
|----------|-------|
| Dimensions | 900 × 500 px |
| Background | `#0d1117` (GitHub dark) |
| Font | `'SF Mono', 'Cascadia Code', 'Consolas', monospace` |
| Green (success) | `#3fb950` |
| Red (failure / block) | `#f85149` |
| Blue (commands) | `#58a6ff` |
| Yellow (warnings) | `#e3b341` |
| Purple (branding) | `#a78bfa` |
| Muted text | `#8b949e` |

**Animation mechanics:**
- Command text: typewriter at 30ms/char
- Output lines: appear instantly, staggered 200ms apart
- Scene transitions: 300ms crossfade
- Cursor: blinking block `▌`

---

## Scene Breakdown

### Short README loop (`rushee-readme.gif`) — ~7s, loops forever

| # | Scene | Duration | Left panel | Right panel |
|---|-------|----------|-----------|-------------|
| 1 | Session banner | 2s | `$ claude` → Rushee loads, repo scanned | Pipeline checklist — phases ticked off, current phase highlighted |
| 2 | Feature Card → OpenAPI | 2.5s | `/rushee:feature "Place order"` → FDD-001.md written · `/rushee:api-design FDD-001` → order-api.yaml written | FDD-001.md snippet (ID, Actor, Goal) → fades to `POST /api/v1/orders → 201` |
| 3 | RED → GREEN | 2.5s | `/rushee:atdd-run FDD-001` → tests RED · `/rushee:tdd-cycle FDD-001` → 12 tests GREEN | Counter animates: `● 3 failed` → `✔ 12 passed` · Coverage: 84% |
| — | Loop | — | Fades back to Scene 1 | |

### Long social post (`rushee-social.gif`) — ~16s, plays once

| # | Scene | Duration | Left panel | Right panel |
|---|-------|----------|-----------|-------------|
| 1 | Session banner | 3s | `$ claude` → Rushee loads, repo scanned | Full pipeline checklist with current phase highlighted |
| 2 | Feature Card → OpenAPI | 4s | `/rushee:feature "Place order"` → FDD-001.md · `/rushee:api-design FDD-001` → order-api.yaml | FDD-001.md → order-api.yaml revealed |
| 3 | BDD Gherkin | 4s | `/rushee:bdd-spec FDD-001` → feature file written, "No HTTP. No URLs. No SQL." | `FDD-001-place-order.feature` with full Given/When/Then scenario |
| 4 | RED → GREEN | 5s | `/rushee:atdd-run FDD-001` → RED · `/rushee:tdd-cycle FDD-001` → GREEN | `● 3 failed` animates to `✔ 12 passed`, Coverage 84% |
| 5 | End card | holds | — | Tagline: "Every phase guided. Shortcuts caught. Any stack supported." |

All content sourced from `demo/` artifacts (FDD-001.md, order-api.yaml, FDD-001-place-order.feature).

---

## Output Files

| File | Purpose |
|------|---------|
| `demo/rushee-readme.html` | Source animation for short loop — re-export any time |
| `demo/rushee-social.html` | Source animation for long version — re-export any time |
| `demo/rushee-readme.gif` | Final GIF for README `<img>` tag |
| `demo/rushee-social.gif` | Final GIF for launch post attachment |

---

## Export Process (Option B — automated)

1. Build both HTML animation files (`demo/rushee-readme.html`, `demo/rushee-social.html`)
2. Serve via local preview server
3. Open in Chrome, start GIF recorder
4. Let animation play to completion (short: 7s, long: 16s)
5. Stop recorder, export → downloads GIF
6. Move to `demo/` and commit

---

## README Integration

After export, add to `README.md` below the tagline:

```markdown
![Rushee in action](demo/rushee-readme.gif)
```
