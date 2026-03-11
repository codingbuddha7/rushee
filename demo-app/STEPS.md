# Rushee Demo App — Steps as a Junior Developer

I'm following the Rushee plugin pipeline to build a small **Quick Notes** app (Flutter + Spring Boot). This document records every step.

**App idea:** Users can create short notes (title + body) and see a list of their notes. Minimal scope for one bounded context.

---

## How I'm using Rushee

- **Entry point:** `/rushee:start` (then follow the recommended next command)
- **Pipeline order:** UX Discovery → Event Storm → DDD Model → Feature → API Design → BDD → ATDD → TDD (backend) → Flutter Feature
- **Golden rule:** UX → Domain → Contract → Code. Never write code before its acceptance test is RED.

---

## Phase 0 — UX Discovery

**Command I would run:** `/rushee:ux-discovery` (ux-analyst agent)

**What I'm producing (as if the agent guided me):**

1. **Personas** — who uses the app
2. **Job Stories** — what they do (When / I want / so I can)
3. **Domain events** — extracted from job stories (for event storm)
4. **Screen Inventory** — every screen with ID
5. **Navigation Map** — how screens connect
6. **Wireframe Specs** — text description per screen

Files created: `docs/ux/personas.md`, `job-stories.md`, `screen-inventory.md`, `navigation-map.md`, `wireframe-specs/NoteListScreen.md`, `CreateNoteScreen.md`.

**Next (Rushee would say):** Run `/rushee:event-storm` with the domain events: NoteCreated, NoteListViewed, NoteViewed.

---

## Phase 1 — Event Storming + DDD Model

**Commands:** `/rushee:event-storm` then `/rushee:ddd-model notes`

**What I'm producing:** Context map (one bounded context: Notes), then domain model (aggregate, entities, value objects, repository interface).

Files created: `docs/architecture/context-map.md`, `docs/domain/notes/domain-model.md`, and domain skeleton in `backend/src/main/java/com/demo/notes/domain/` (Note, NoteId, NoteCreated, NoteRepository).

**Next:** `/rushee:feature "Create and list notes"` then `/rushee:api-design FDD-001`.

---

## Phase 2 — Feature Card + OpenAPI Contract

**Commands:** `/rushee:feature "Create and list notes"` → `/rushee:api-design FDD-001`

**What I'm producing:** FDD-001 Feature Card with acceptance criteria and screen links; then OpenAPI 3.1 spec (the contract for both backend and Flutter).

Files created: `docs/features/FDD-001.md`, `backend/src/main/resources/api/notes-api.yaml`.

**Next:** `/rushee:bdd-spec FDD-001` then `/rushee:atdd-run FDD-001` to get RED acceptance tests.

---

## Phase 3 — BDD Gherkin + ATDD (RED)

**Commands:** `/rushee:bdd-spec FDD-001` → `/rushee:atdd-run FDD-001`

**What I'm producing:** Gherkin feature file in domain language (no HTTP/URLs); step definitions that throw `PendingException` so acceptance tests are RED.

Files created:
- `backend/src/test/resources/features/notes/FDD-001-create-and-list-notes.feature` (3 scenarios: create note, list newest first, empty title rejected)
- `backend/src/test/java/com/demo/notes/steps/NoteSteps.java` (wired to RestAssured and `@SpringBootTest(webEnvironment = RANDOM_PORT)`)

**Next:** `/rushee:tdd-cycle FDD-001` to implement backend until Cucumber is GREEN.

---

## Phase 4 — Backend TDD Implementation

**Command:** `/rushee:tdd-cycle FDD-001`

**What I did (outside-in):**
1. **Domain** — Already had `Note`, `NoteId`, `NoteCreated`, `NoteRepository` (pure Java).
2. **Application** — `NotesApplicationService` (create + list), `CreateNoteRequest`, `NoteDto`.
3. **Infrastructure** — `NoteController` (POST/GET), `NoteJpaEntity`, `SpringDataNoteRepository`, `JpaNoteRepository`.
4. **Cucumber steps** — Implemented with RestAssured; call real API and assert.

**Files created/updated:**
- `backend/src/main/java/.../application/` (dto, NotesApplicationService)
- `backend/src/main/java/.../infrastructure/web/NoteController.java`
- `backend/src/main/java/.../infrastructure/persistence/` (JpaNoteRepository, NoteJpaEntity, SpringDataNoteRepository)
- `backend/src/test/java/.../steps/NoteSteps.java` (full implementation)
- `backend/pom.xml` (Cucumber, RestAssured, JUnit Platform Suite)
- `backend/src/main/resources/application.yml`, `NotesApplication.java`

**Note:** Domain `Note` was given a `fromPersistence(...)` factory so the repository can reconstitute from DB without raising a domain event.

**Run acceptance tests:** From `demo-app/backend`, run `mvn test -Dtest=CucumberIT`. (If your environment has other Spring config, you may need to run from a clean directory or set `SPRING_CONFIG_ADDITIONAL_LOCATION` to empty.)

**Next:** `/rushee:flutter-feature FDD-001` to implement the Flutter app from the same OpenAPI contract.

---

## Phase 4f — Flutter Implementation

**Command:** `/rushee:flutter-feature FDD-001`

**What I'm producing:** Flutter feature following clean architecture: domain (entities, repository interface) → data (remote datasource, repository impl) → presentation (BLoC, screens). Design tokens in `core/theme`.

**Files created:**
- `mobile/pubspec.yaml` (flutter_bloc, equatable, http)
- `mobile/lib/core/theme/app_colors.dart` (design tokens stub)
- `mobile/lib/features/notes/domain/entities/note.dart`
- `mobile/lib/features/notes/domain/repositories/notes_repository.dart`
- `mobile/lib/features/notes/data/datasources/notes_remote_datasource.dart` (calls backend API)
- `mobile/lib/features/notes/data/repositories/notes_repository_impl.dart`
- `mobile/lib/features/notes/presentation/bloc/notes_list_bloc.dart`
- `mobile/lib/features/notes/presentation/screens/note_list_screen.dart` (S01)
- `mobile/lib/main.dart` (wires repo, BLoC, NoteListScreen)

**Create Note screen (S02)** is left as TODO (navigate from FAB) so the demo stays small. The list screen loads notes from the backend and shows them.

**Run Flutter:** From `demo-app/mobile`, run `flutter pub get` then `flutter run` (with backend running on port 8080).

---

## Summary: What a junior did with Rushee

| Phase | Rushee command / agent | Output |
|-------|------------------------|--------|
| 0 | `/rushee:ux-discovery` (ux-analyst) | Personas, job stories, screen inventory, navigation, wireframes |
| 1 | `/rushee:event-storm` → `/rushee:ddd-model notes` | Context map, domain model, domain skeleton (Note, NoteId, NoteCreated, NoteRepository) |
| 2 | `/rushee:feature "Create and list notes"` → `/rushee:api-design FDD-001` | FDD-001.md, notes-api.yaml |
| 3 | `/rushee:bdd-spec FDD-001` → `/rushee:atdd-run FDD-001` | FDD-001.feature, NoteSteps.java (RED) |
| 4 | `/rushee:tdd-cycle FDD-001` (tdd-implementer) | Controller, service, repository, JPA entity; steps implemented; Cucumber GREEN |
| 4f | `/rushee:flutter-feature FDD-001` (flutter-implementer) | Domain, data, BLoC, Note list screen (S01); Create screen (S02) stubbed |

**Golden rule followed:** UX → Domain → Contract → Code. No code before Feature Card; no controller before OpenAPI; no implementation before RED acceptance tests.

**How to run the demo:**
1. Start backend: `cd demo-app/backend && mvn spring-boot:run`
2. Start Flutter: `cd demo-app/mobile && flutter pub get && flutter run`
3. Open the app, tap FAB when Create screen is added; list loads from `GET /api/v1/notes`.
