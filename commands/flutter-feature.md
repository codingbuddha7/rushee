---
name: flutter-feature
description: Implement a Feature Card (FDD) in the Flutter mobile app using clean architecture, BLoC state management, and the testing pyramid. The Flutter parallel stream to /rushee:tdd-cycle.
usage: /rushee:flutter-feature <FDD-NNN>
example: /rushee:flutter-feature FDD-001
---

**Skills needed for this phase:** Clean layers (domain/data/presentation), BLoC or Riverpod, design tokens, generated API client. Rushee skills: flutter-clean-architecture, flutter-testing-discipline, openapi-contract-sync.
**New to this?** Say: "Explain clean architecture on the frontend" or "How does BLoC work with use cases?" — then we'll run the flutter-implementer.

Invoke the **flutter-implementer** agent to implement a Feature Card in the Flutter client.

This command runs the Flutter implementation stream in parallel with `/rushee:tdd-cycle`
on the Spring Boot side. Both streams consume the same OpenAPI contract.

This command:
1. Verifies the OpenAPI spec exists and is approved for this feature
2. Regenerates the Dart API client from the spec (`openapi-generator-cli`)
3. Creates the clean architecture skeleton for this feature (domain/data/presentation)
4. Implements the domain layer: entities, value objects, repository interface, use cases
5. Implements the data layer: remote datasource, models (from generated code), repository impl
6. Implements the presentation layer: BLoC events/states, BLoC, screen, widgets
7. Writes tests at every layer (unit → widget → integration)
8. Runs golden tests against Figma-approved design
9. Runs `flutter analyze` and `flutter test --coverage`
10. Hands to **flutter-reviewer** for 5-gate quality review

**Prerequisites**:
- Feature Card exists: `docs/features/FDD-NNN.md`
- Screen exists in Screen Inventory: `docs/ux/screen-inventory.md`
- OpenAPI spec approved: `src/main/resources/api/*.yaml`
- Figma screens approved (status = ✅ in screen inventory)

**Rule enforced**: No BLoC calls repository directly — only use cases.
No API calls in widgets. All tokens in flutter_secure_storage.

**Output**: Feature fully implemented with tests. Run `/rushee:status` for final review.
