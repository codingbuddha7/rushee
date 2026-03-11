# Domain Model — Notes (bounded context)

## Aggregate: Note

**Aggregate root:** Note

- **Note** (entity): identity = NoteId (UUID). Attributes: title (String), body (String), createdAt (Instant). No public setters; factory method `create(title, body)` raises domain event NoteCreated.
- **NoteId** (value object): UUID wrapper.
- **NoteCreated** (domain event): noteId, title, body, createdAt.

## Repository (output port)

- **NoteRepository** (interface, in domain): `save(Note)`, `findAllOrderByCreatedAtDesc()`, `findById(NoteId)`. Pure Java; no Spring/JPA.

## Skeleton location

- Domain classes: `backend/src/main/java/.../notes/domain/` (no `@Entity`, no Spring).
- JPA entity and mapper live in infrastructure.
