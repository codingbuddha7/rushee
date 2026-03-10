---
description: Show the current FDD/BDD/ATDD/TDD status of all features in this project.
allowed-tools: [Read, Bash, Glob, Grep]
---

Scan the project and report status of all features:

1. Read all Feature Cards in `docs/features/`
2. For each feature, check:
   - Feature Card exists? (FDD ✅/❌)
   - Gherkin .feature file exists? (BDD ✅/❌)
   - Step definitions exist? (ATDD ✅/❌)
   - Acceptance tests passing? Run `./mvnw test -Dtest=CucumberIT` (ATDD GREEN ✅/❌)
   - Unit tests passing? Run `./mvnw test -Dtest="*Test"` (TDD GREEN ✅/❌)
   - Coverage ≥ 80%? (Coverage ✅/❌)
   - Final review passed? (Review ✅/❌)

Output a table:
```
Feature      | FDD | BDD | ATDD RED | ATDD GREEN | TDD | Coverage | Review
-------------|-----|-----|----------|------------|-----|----------|-------
FDD-001 ...  |  ✅ |  ✅ |    ✅    |     ✅     |  ✅ |   85%    |   ✅
FDD-002 ...  |  ✅ |  ✅ |    ✅    |     ❌     |  🔄 |   --     |   ❌
```

Legend: ✅ Done, ❌ Missing/Failing, 🔄 In Progress
