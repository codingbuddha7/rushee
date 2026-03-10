---
name: extending-rushee
description: >
  This skill should be used when you want to add a new skill to Rushee, improve an
  existing skill, create a new command, add a new agent, or customise Rushee for your
  specific project or organisation. Triggers on: "add a skill", "create a skill",
  "improve Rushee", "add a command", "customise Rushee", "extend the plugin",
  "write a new skill", "Rushee doesn't cover", "add support for", or
  "how do I teach Rushee to".
version: 1.0.0
allowed-tools: [Read, Write, Bash, Glob]
---

# Extending Rushee Skill

## Philosophy
Rushee is designed to grow with your team. Every time you encounter a pattern that should
be enforced on every feature — a framework decision, an architectural rule, a team
convention — it belongs in a skill.

The best skills come from real pain: a bug that escaped, a pattern that got repeated
wrong three times, a decision that had to be remade from scratch every sprint.
Capture it once. Enforce it forever.

---

## Skill Anatomy

Every Rushee skill has one file: `skills/<skill-name>/SKILL.md`

```
skills/
└── my-new-skill/
    └── SKILL.md          ← the entire skill lives here
```

### SKILL.md Structure
```markdown
---
name: my-new-skill
description: >
  This skill should be used when... [describe the trigger conditions precisely]
  Triggers on: [list specific phrases/situations that should activate this skill]
version: 1.0.0
allowed-tools: [Read, Write, Bash, Glob, Grep]
---

# My New Skill Title

## Purpose
One paragraph: what problem does this skill solve?

## [Section 1 — The core pattern]
...

## [Section 2 — Code examples]
...

## Checklist
- [ ] Checkable item 1
- [ ] Checkable item 2
```

---

## Writing a Good Trigger Description

The `description` frontmatter is what causes Claude to auto-invoke the skill.
**It must be specific.** Vague triggers mean the skill never fires.

### Too vague (will not trigger reliably)
```yaml
description: >
  Use this skill for Spring Boot stuff.
```

### Too narrow (only triggers on exact phrase)
```yaml
description: >
  Use this when the developer types "use Resilience4j circuit breaker".
```

### Just right
```yaml
description: >
  This skill should be used when implementing any external HTTP call, database call,
  or third-party API integration that needs fault tolerance. Triggers on:
  "circuit breaker", "retry logic", "Resilience4j", "timeout", "fallback",
  "external service call", "fault tolerance", "rate limiter", or any
  @FeignClient or RestTemplate/WebClient usage that calls an external system.
```

---

## Skill Checklist — Before Publishing

### Content Quality
- [ ] Trigger description covers at least 6 distinct natural-language phrases
- [ ] Skill has a clear, single purpose (not "everything about X")
- [ ] At least one concrete Spring Boot Java code example
- [ ] Anti-patterns table showing what NOT to do
- [ ] Actionable checklist at the end
- [ ] No more than 300 lines (split into two skills if longer)

### Technical Quality
- [ ] Frontmatter is valid YAML
- [ ] `name` matches the folder name exactly
- [ ] `allowed-tools` only lists what the skill actually needs
- [ ] All code examples compile (mentally verify them)
- [ ] No hardcoded package names — use `<pkg>` placeholder

### Integration
- [ ] Skill added to `plugin.json` skills array
- [ ] Skill does not duplicate an existing skill's purpose
- [ ] If skill fires during a pipeline stage, it references the correct agent hand-off

---

## Example: Adding a "Resilience Patterns" Skill

### Step 1 — Create the file
```bash
mkdir -p skills/resilience-patterns
touch skills/resilience-patterns/SKILL.md
```

### Step 2 — Write the skill
```markdown
---
name: resilience-patterns
description: >
  This skill should be used when making any external HTTP call, database connection,
  or third-party service integration. Triggers on: "circuit breaker", "retry",
  "Resilience4j", "timeout", "fallback", "fault tolerance", "@FeignClient",
  "RestTemplate", "WebClient", "external service", or "what happens if X goes down".
version: 1.0.0
allowed-tools: [Read, Write, Glob]
---

# Resilience Patterns Skill

## Never Call External Services Naked

Every external call needs: timeout + retry + circuit breaker.
Without these, one slow downstream service takes your whole system down.

## Resilience4j Setup
[... Maven deps, config, code examples ...]

## Checklist
- [ ] All external HTTP calls have timeout configured
- [ ] Circuit breaker on every Feign client
- [ ] Fallback method defined
- [ ] Retry with exponential backoff
- [ ] Metrics exposed on circuit breaker state
```

### Step 3 — Register in plugin.json
```json
"skills": [
  "skills/resilience-patterns",
  // ... existing skills
]
```

### Step 4 — Test the trigger
Start a Claude Code session and say: "I need to call the payment gateway API."
The skill should auto-invoke.

---

## Adding a New Command

Commands live in `commands/<command-name>.md`:

```markdown
---
name: resilience-check
description: Review all external service calls for resilience patterns.
usage: /rushee:resilience-check [FDD-NNN | path]
example: /rushee:resilience-check FDD-007
---

Invoke the **resilience-reviewer** agent on all external service calls in the feature.

This command:
1. Scans for all @FeignClient, RestTemplate, WebClient usages
2. Checks for timeout configuration
3. Checks for circuit breaker annotation
4. Outputs APPROVED or CHANGES REQUIRED

**Output**: docs/reviews/<FDD-NNN>-resilience.md
```

Register in `plugin.json` commands array.

---

## Adding a New Agent

Agents live in `agents/<agent-name>.md`:

```markdown
---
name: resilience-reviewer
description: >
  Use this agent to review external service calls for circuit breakers, retries,
  and timeouts. Invoke with "/rushee:resilience-check" or from spring-reviewer
  when the feature makes external calls.
allowed-tools: [Read, Glob, Grep, Bash]
---

You are a Spring Boot resilience reviewer...

## Your Process
1. Scan for external calls
2. Verify each has the resilience triad: timeout + retry + circuit breaker
3. Output findings
```

Register in `plugin.json` agents array.

---

## Project-Specific Skills (Not for Upstream)

For skills that are specific to your organisation or project (company naming conventions,
internal framework patterns, proprietary API integrations), keep them in your project's
`.claude/skills/` folder — not in the Rushee plugin itself:

```
your-project/
├── .claude/
│   └── skills/
│       ├── company-naming-conventions/
│       │   └── SKILL.md
│       └── internal-auth-framework/
│           └── SKILL.md
└── .claude/plugins/rushee/   ← Rushee plugin (shared)
```

Claude Code will discover both. Project skills take precedence over plugin skills
when there is a naming conflict.

---

## Contributing Back to Rushee

If your skill is general enough to benefit all Spring Boot developers:

1. Fork: `github.com/<your-username>/rushee`
2. Add your skill following this guide
3. Test it in a real project
4. Submit a PR with:
   - The new `skills/<skill-name>/SKILL.md`
   - Updated `plugin.json`
   - A short description in `CHANGELOG.md` of what it covers and why

Skills that have been proven in production projects will be merged faster.
