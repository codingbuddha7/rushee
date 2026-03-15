# Rushee

**Rushee** is a Claude Code plugin enforcing a complete engineering discipline for Angular + Spring Boot projects — from first feature sketch to production deployment. Every phase is guided, every shortcut is blocked, and your architecture stays clean.

**Default stack:** Angular (frontend) + Spring Boot (backend). Same pipeline for React, Svelte (web); FastAPI, NestJS, Go, Rust (backends).

## Install

```bash
cd /path/to/your-project
git clone https://github.com/codingbuddha7/rushee .claude/plugins/rushee
claude
```

## Quick Start

### New to this? (intern / junior)

Add to your project's `CLAUDE.md`:

```
level: junior
```

Then run:

```
/rushee:start
```

Rushee recommends `/rushee:feature-brief` — three questions, ~10 minutes, and you have a clear Feature Card to guide your implementation.

### Experienced? (mid / senior)

```
/rushee:start
```

Rushee scans your repo and tells you the next step — `/rushee:ux-discovery` for greenfield, or the right phase for brownfield.

## Hooks (always on)

| Hook | Behaviour |
|------|-----------|
| `guard-domain-purity` | **BLOCKS** Spring/JPA annotations in `domain/` layer |
| `guard-no-hardcoded-secrets` | **BLOCKS** passwords, tokens, API keys in source |
| `guard-no-code-before-feature-card` | **WARNS** production code written before Feature Card |
| `guard-openapi-contract-sync` | **WARNS** after spec change — regenerate both clients |
| `remind-migration-on-entity-change` | **WARNS** entity changed — create Flyway migration |
| `auto-run-tests-after-edit` | **WARNS** test file saved — run test suite |
| `session-start-discipline-reminder` | Displays pipeline banner at every session start |

---

→ Full command reference, rules, and phase gates: [docs/REFERENCE.md](docs/REFERENCE.md)
