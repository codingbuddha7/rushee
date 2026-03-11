# Demo app — Ecommerce (Rushee pipeline)

This demo app was created by following the Rushee plugin pipeline: UX Discovery → Event Storm → DDD Model → Feature Card → API Contract → BDD/ATDD (optional in this repo) → Backend + Flutter.

## Flow

- **S01 Product List**: Browse products, add to cart.
- **S02 Cart**: View cart, place order.
- **S03 Order Confirmation**: See order ID and total.

## Pipeline steps applied

| Phase | Command / action | Output |
|-------|------------------|--------|
| 0 | UX Discovery (personas, job stories, screen inventory, wireframes) | `docs/ux/personas.md`, `job-stories.md`, `screen-inventory.md`, `navigation-map.md`, `wireframe-specs/*.md` |
| 1 | Event storm + context map | `docs/architecture/context-map.md` |
| 1b | DDD model (Order, Catalog) | `docs/domain/order/domain-model.md`, domain classes in backend |
| 2 | Feature Card FDD-001 | `docs/features/FDD-001.md` |
| 2b | API contract (REST) | Backend controllers: GET /products, GET/POST /cart, POST /orders |
| 4 | Backend implementation | Spring Boot: Product, Order, Cart (in-memory), JPA for products/orders |
| 4f | Flutter implementation | Product list, Cart, Order confirmation screens; BLoC; repositories calling backend |

## Run

1. **Backend**: `cd demo-app/backend && ./mvnw spring-boot:run`
2. **Flutter**: `cd demo-app/mobile && flutter create . --platforms=web,macos` (if needed), then `flutter run -d chrome`

Base URL for the app: `http://localhost:8080`. CORS is enabled for localhost.
