# Wireframe: Note List Screen (S01)

**Purpose:** Show all notes in a list, newest first; allow opening create flow.

**States:** Loading, Empty (no notes), Populated (list), Error.

**Content (reading order):** App bar "My Notes", FAB "+", list of rows (title, body snippet, date).

**Interactions:** Tap FAB → open Create Note Screen. Tap row → (MVP: no detail; later open detail).

**API calls:** GET /api/v1/notes → list of notes.
