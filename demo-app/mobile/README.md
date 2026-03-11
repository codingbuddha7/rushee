# Ecommerce demo mobile

Flutter app: product list, cart, place order. Uses `http://localhost:8080` by default.

## Run

1. Start the backend: `cd ../backend && ./mvnw spring-boot:run`
2. Create platforms if needed: `flutter create . --platforms=web,macos` (or `ios`, `android`)
3. Run: `flutter run -d chrome` or `flutter run -d macos`

## CORS

Backend is configured to allow `http://localhost:*` for `/api/**`. For web, use Chrome or ensure backend CORS matches your origin.
