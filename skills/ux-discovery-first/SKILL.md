---
name: ux-discovery-first
description: >
  This skill should be used at the very beginning of any feature or project that has
  a user-facing interface. Triggers on: "user journey", "persona", "wireframe",
  "UX design", "screen flow", "what does the app look like", "how does the user",
  "job story", "user story mapping", "user experience", "mobile screen", "onboarding",
  "navigation", "app flow", "what screens do we need", "design the UI", or any
  request to design, sketch, or plan a screen before writing code.
  UX discovery ALWAYS happens before Event Storming, not after.
version: 1.0.0
allowed-tools: [Read, Write, Glob]
---

# UX Discovery First Skill

## The Law
**User journeys drive domain events. Domain events never drive user journeys.**

The biggest architectural mistake in full-stack development is designing the backend
domain model first and then building a UI that fits it. Users do not think in aggregates.
They think in tasks. Discover the tasks first — the domain model will emerge naturally.

```
WRONG ORDER:
  Domain Model → OpenAPI Spec → Flutter Screen
  (the UI becomes a form over a database)

RIGHT ORDER:
  User Journey → Job Story → Screen Inventory → Domain Events → Domain Model
  (the domain reflects what users actually do)
```

---

## Phase 1 — Persona Definition

Before mapping journeys, define who is using the app. Keep it concrete — one paragraph
per persona, not a marketing profile.

```markdown
## Personas — <AppName>

### Persona 1: The [Role]
**Name**: [Real-feeling name]
**Context**: [One sentence: what is their situation when using the app]
**Primary goal**: [What are they trying to accomplish]
**Biggest frustration**: [What currently goes wrong for them]
**Technical comfort**: [Low / Medium / High]
**Key constraint**: [Time pressure / connectivity / device type / accessibility need]

Example:
### Persona 1: The Returning Shopper
Name: Amara
Context: Ordering groceries on her phone while commuting, often poor connectivity
Primary goal: Reorder her usual weekly groceries in under 2 minutes
Biggest frustration: Having to search for the same 20 items every week
Technical comfort: Medium — uses apps daily but dislikes learning new interfaces
Key constraint: One-handed use on a moving train, intermittent 4G
```

**Rule**: Every screen in the app must serve at least one persona's primary goal.
Screens that exist for "the system's convenience" (admin-only error logs, developer
debug panels) are not user-facing screens — they belong in a separate backoffice tool.

---

## Phase 2 — Job Story Mapping

For each persona, write Job Stories — not User Stories.

**Why Job Stories, not User Stories?**
User Stories ("As a user I want X so that Y") focus on features.
Job Stories ("When [situation], I want to [motivation], so I can [outcome]")
focus on context and intent. Context is what produces good domain events.

```markdown
## Job Stories — <Persona Name>

### JS-001
When I open the app after a week away,
I want to see my previous order ready to repeat,
So I can reorder without searching for each item again.

→ Domain events revealed: OrderHistoryViewed, ReorderRequested
→ Screens required: Order History Screen, Reorder Confirmation Screen

### JS-002
When a product I ordered last time is out of stock,
I want to be offered the closest alternative immediately,
So I don't have to abandon the reorder flow and search manually.

→ Domain events revealed: SubstitutionOffered, SubstitutionAccepted/Rejected
→ Screens required: Substitution Suggestion Modal (overlay on Cart Screen)
```

**Critical insight**: The domain events in the right column of each Job Story are
the inputs to `/rushee:event-storm`. This is why UX comes first.

---

## Phase 3 — Screen Inventory

List every screen in the app before designing any of them.
This prevents scope creep during design and reveals missing screens early.

```markdown
## Screen Inventory — <AppName> v1.0

### Authentication Flow
| ID  | Screen Name          | Primary Persona | Job Stories | Status |
|-----|---------------------|----------------|-------------|--------|
| S01 | Splash / Onboarding | All            | -           | ☐ |
| S02 | Login               | All            | JS-005      | ☐ |
| S03 | Registration        | New User       | JS-006      | ☐ |
| S04 | Forgot Password     | All            | JS-007      | ☐ |

### Order Flow
| ID  | Screen Name              | Primary Persona    | Job Stories   | Status |
|-----|-------------------------|--------------------|---------------|--------|
| S10 | Home / Product Listing  | Returning Shopper  | JS-001        | ☐ |
| S11 | Product Search          | New Shopper        | JS-003        | ☐ |
| S12 | Product Detail          | Both               | JS-004        | ☐ |
| S13 | Cart Review             | Both               | JS-001, JS-002| ☐ |
| S14 | Checkout                | Both               | JS-008        | ☐ |
| S15 | Order Confirmation      | Both               | JS-008        | ☐ |
| S16 | Order History           | Returning Shopper  | JS-001        | ☐ |

Status: ☐ Not started | 🔲 Wireframe | ✅ Figma approved | 🔗 Feature Card exists
```

**Rule**: No Feature Card can be created for a screen that doesn't appear in the
Screen Inventory. Add it to the inventory first.

---

## Phase 4 — Navigation Map

Define how screens connect before designing them individually.
Navigation decisions affect state management architecture — a bottom navigation
bar means persistent state across tabs, a linear checkout means disposable state.

```markdown
## Navigation Map — <AppName>

### Top-Level Navigation (Bottom Bar)
Home Tab → S10 Home
Orders Tab → S16 Order History
Profile Tab → S20 Profile

### Modal Flows (push over current screen, back = dismiss)
S13 Cart → S14 Checkout → S15 Order Confirmation [Modal Stack — dispose on confirm]
S12 Product Detail → [can be pushed from S10 or S11]

### Navigation Architecture Decision
State management choice driven by navigation:
- Bottom bar tabs: use persistent Riverpod providers (survives tab switch)
- Checkout flow: use scoped BLoC (disposed when flow completes)
- Modals: ephemeral local state (StatefulWidget acceptable)
```

---

## Phase 5 — Wireframe Specification (per screen)

Before Figma, write a wireframe spec for each screen. This is a text description
of what appears on screen, in reading order. Designers use this to build Figma
frames — not the other way around.

```markdown
## Wireframe Spec — S13 Cart Review Screen

### Purpose
Allow the user to review selected items, quantities, and total cost before
proceeding to checkout. Handle out-of-stock substitutions inline.

### States
1. LOADING — skeleton placeholders for each cart line
2. EMPTY — illustration + "Your cart is empty" + "Continue Shopping" CTA
3. POPULATED — list of cart lines + order summary + "Proceed to Checkout" CTA
4. SUBSTITUTION_PENDING — cart line shows substitution offer with Accept/Reject

### Content (reading order, top to bottom)
1. App bar: "My Cart" title + item count badge
2. Cart line list (repeating):
   - Product image (48×48)
   - Product name (primary text)
   - Quantity stepper (−, count, +)
   - Line total (right-aligned)
   - [If substitution]: yellow banner "Out of stock → [Alternative]" [Accept] [Reject]
3. Order summary card:
   - Subtotal
   - Delivery fee (or "FREE" if threshold met)
   - Total (bold)
4. Primary CTA button: "Proceed to Checkout — £XX.XX"

### Interactions
- Tap − on quantity = 1: shows "Remove item?" confirmation dialog
- Tap product image: navigates to S12 Product Detail (back returns to cart)
- Accept substitution: replaces cart line, shows green confirmation toast
- Reject substitution: removes cart line, shows undo snackbar (3s)

### API calls this screen makes
GET /api/v1/cart/{cartId}           (on load)
PUT /api/v1/cart/{cartId}/items/{id} (quantity change)
POST /api/v1/cart/{cartId}/substitutions/{id}/accept
POST /api/v1/cart/{cartId}/substitutions/{id}/reject
```

---

## Handoff Checklist — UX Discovery Complete

Before starting Event Storming (`/rushee:event-storm`):

- [ ] All personas defined (at least 2)
- [ ] All job stories written (at least 3 per persona)
- [ ] Domain events extracted from each job story
- [ ] Screen Inventory complete (every screen named and assigned a persona + job story)
- [ ] Navigation map drawn (all flows documented)
- [ ] Wireframe spec written for every screen in the MVP scope
- [ ] Wireframe specs reviewed by a non-developer (product owner, designer, or end user)
- [ ] Screen Inventory status column updated to "🔲 Wireframe"

**Only then run `/rushee:event-storm`** — pass the extracted domain events list
as the starting point. You'll find the storming session goes twice as fast.
