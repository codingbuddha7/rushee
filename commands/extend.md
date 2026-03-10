---
name: extend
description: Add a new skill, command, or agent to Rushee. Guides through writing the SKILL.md, registering it in plugin.json, and testing the trigger phrases.
usage: /rushee:extend <skill | command | agent> <name>
example: /rushee:extend skill resilience-patterns
example: /rushee:extend command resilience-check
example: /rushee:extend agent resilience-reviewer
---

Invoke the **rushee-extender** agent to add new capabilities to this plugin.

This command:
1. Asks what problem the new skill/command/agent solves
2. Drafts the SKILL.md (or command/agent definition) following Rushee conventions
3. Writes precise trigger description to ensure auto-invocation works
4. Registers the new artifact in `plugin.json`
5. Tests the trigger by simulating relevant developer phrases

**When to use**:
- You've found a pattern that escaped review (add a skill to prevent it)
- Your project uses a framework Rushee doesn't cover yet
- You want to add an organisation-specific naming or architecture convention
- You want to contribute a new skill back to the Rushee community

**Output**: New file in `skills/<name>/SKILL.md` (or `commands/` or `agents/`),
updated `plugin.json`.
