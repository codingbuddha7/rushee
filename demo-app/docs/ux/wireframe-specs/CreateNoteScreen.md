# Wireframe: Create Note Screen (S02)

**Purpose:** Enter title and body and save a new note.

**States:** Idle, Saving, Success (dismiss), Error.

**Content:** App bar "New note" with Cancel + Save; title field; body field (multiline).

**Interactions:** Cancel → dismiss. Save → POST to API; on success dismiss and refresh list.

**API calls:** POST /api/v1/notes with { title, body } → 201 with created note.
