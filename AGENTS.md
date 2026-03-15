# Rushee — Agent instructions

When working in this project with Rushee (Claude Code / Cursor plugin):

- **Run from project root.** Start Claude or Cursor from the directory that contains `backend/`, `frontend/` (or `mobile/`), and `docs/`. All commands and hooks assume this layout.
- **Follow the Rushee pipeline.** Use `/rushee:start` to see where you are and what to do next.
  - **Intern/junior path:** Feature Brief → Feature Card → API Design → TDD → Security. BDD (Gherkin) is optional — add it when the team is ready.
  - **Full pipeline:** UX Discovery → Event Storm → DDD Model → Feature Card → API Design → BDD → ATDD → TDD → Flutter → Security.
- **Juniors / first time.** Set `level: intern` or `level: junior` in the project’s `CLAUDE.md` — `/rushee:start` will recommend `/rushee:feature-brief` as the first step (three questions, ~10 min, no DDD knowledge needed). Run `/rushee:skill-check` for a phase readiness check, or `/rushee:skill-map` to see the full skill tree (see README § Developer profile).
- **Phase gates.** After each phase, run the phase gate checks (see README § Phase gates and optional PR verification) (in this plugin repo). Consider opening a PR after Phase 2b, 3b, 4, or 4f if a reviewer is available.
- **Full reference.** See [README.md](README.md) for commands, skills, agents, and the full-stack walkthrough.
