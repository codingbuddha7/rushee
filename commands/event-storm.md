---
name: event-storm
description: Run a lightweight Event Storming session to discover bounded contexts and produce a domain context map. Use at the start of any new project or major feature area.
usage: /rushee:event-storm [system description]
example: /rushee:event-storm "e-commerce platform handling orders, payments, and fulfilment"
---

Invoke the **event-stormer** agent to facilitate a domain discovery session.

This command:
1. Guides you through domain event discovery (what happens in your system?)
2. Groups events into bounded contexts
3. Classifies subdomains: Core / Supporting / Generic
4. Defines context relationships (Customer/Supplier, ACL, etc.)
5. Saves the context map to `docs/architecture/`

**When to use**: Before writing any Feature Card. Before designing any new service.
If a developer skips this and jumps to `/rushee:feature`, Rushee will ask them to run this first.

**Output**:
- `docs/architecture/event-timeline.md`
- `docs/architecture/context-map.md`
- `docs/architecture/subdomains.md`
