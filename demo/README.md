# What Rushee Produces

Run through the Rushee pipeline for a single feature — **Place Order** — and these are the artifacts you get. Each file is the output of one command. No code yet — just the specs that drive it.

| Step | Command | Output |
|------|---------|--------|
| 1 | `/rushee:ddd-model order` | [domain-model.md](domain-model.md) — aggregates, value objects, domain events |
| 2 | `/rushee:feature "place order from cart"` | [FDD-001.md](FDD-001.md) — Feature Card with acceptance criteria |
| 3 | `/rushee:api-design FDD-001` | [order-api.yaml](order-api.yaml) — OpenAPI 3.1 contract |
| 4 | `/rushee:bdd-spec FDD-001` | [FDD-001-place-order.feature](FDD-001-place-order.feature) — Gherkin scenarios |

After step 4 the acceptance tests are wired RED, and `/rushee:tdd-cycle FDD-001` (backend) runs in parallel with `/rushee:angular-feature FDD-001` (frontend) — both implementing from the same OpenAPI contract.

The full step-by-step walkthrough with code is in [demo-app/STEPS.md](../demo-app/STEPS.md).
