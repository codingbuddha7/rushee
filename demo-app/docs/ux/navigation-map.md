# Navigation Map — Quick Notes

- **Entry:** Note List Screen (S01) — default route.
- **S01 → S02:** FAB or "New note" button opens Create Note Screen (modal or push).
- **S02 → S01:** On save, dismiss (modal) or pop (push); list refreshes.

**State:** List screen has persistent list state (BLoC). Create screen is scoped (BLoC for form); on success, emit event so list refreshes.
