# Demo app — Ecommerce (Rushee pipeline)

Sample ecommerce mobile app: **product list** → **cart** → **place order** → **order confirmation**. Built following the Rushee plugin pipeline (UX Discovery → Event Storm → DDD → Feature Card → API → Backend + Flutter).

---

## How to run

### 1. Start the backend

From this directory (`demo-app/`):

```bash
cd backend && ./mvnw spring-boot:run
```

Or with system Maven: `mvn spring-boot:run`.

- API: **http://localhost:8080**
- Endpoints: `GET /api/v1/products`, `GET/POST /api/v1/cart`, `POST /api/v1/orders`
- More detail: [backend/README.md](backend/README.md)

### 2. Run the Flutter app

In a **second terminal**, from `demo-app/`:

```bash
cd mobile
flutter pub get
# If platforms are missing (e.g. first clone):
flutter create . --platforms=web,macos
# Run (pick one):
flutter run -d chrome
# or: flutter run -d macos
```

The app talks to **http://localhost:8080**. CORS is enabled for localhost.

- More detail: [mobile/README.md](mobile/README.md)

### 3. Quick check

1. Backend running → open http://localhost:8080/api/v1/products (you should see JSON).
2. Flutter app running → you should see the product list; add to cart, open cart, place order.

---

## What’s in this repo

| Path | Description |
|------|-------------|
| [docs/](docs/) | UX (personas, job stories, screen inventory, wireframes), architecture (context map), domain model, feature card FDD-001 |
| [backend/](backend/) | Spring Boot 3.2, H2, products + cart + orders |
| [mobile/](mobile/) | Flutter app (BLoC, product list / cart / order confirmation) |
| [STEPS.md](STEPS.md) | Pipeline phases applied to build this demo |
