# Context Map — Quick Notes

## Bounded Contexts

| Context | Responsibility        | Subdomain |
|---------|------------------------|-----------|
| Notes   | Create and list notes  | Core      |

Single context for MVP. No upstream/downstream; no other contexts.

## Domain Events (from UX)

- NoteCreated
- NoteListViewed
- NoteViewed

## Event Timeline (simplified)

1. User creates note → **NoteCreated**
2. User opens list → **NoteListViewed**
3. User opens one note → **NoteViewed** (future)
