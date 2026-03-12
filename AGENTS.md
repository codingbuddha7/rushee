# Rushee — Agent instructions

When working in this project with Rushee (Claude Code / Cursor plugin):

- **Run from project root.** Start Claude or Cursor from the directory that contains `backend/`, `mobile/`, and `docs/`. All commands and hooks assume this layout.
- **Follow the Rushee pipeline.** Use `/rushee:start` to see where you are and what to do next. Phases: UX Discovery → Event Storm → DDD Model → Feature Card → API Design → BDD → ATDD → TDD → Flutter → Security.
- **Phase gates.** After each phase, run the phase gate checks (see README § Phase gates and optional PR verification) (in this plugin repo). Consider opening a PR after Phase 2b, 3b, 4, or 4f if a reviewer is available.
- **Full reference.** See [README.md](README.md) for commands, skills, agents, and the full-stack walkthrough.
