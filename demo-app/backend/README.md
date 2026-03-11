# Ecommerce demo backend

Spring Boot 3.2, H2 in-memory. Products, cart (in-memory), place order.

## Run

```bash
./mvnw spring-boot:run
# Or, if Maven wrapper is not present: mvn spring-boot:run
```

API base: `http://localhost:8080`

- `GET /api/v1/products` — list products
- `GET /api/v1/cart` — get cart (optional header `X-Cart-Id`)
- `POST /api/v1/cart/items` — body `{"productId":"<uuid>","quantity":1}`
- `POST /api/v1/orders` — place order from current cart

H2 console: http://localhost:8080/h2-console (JDBC URL: `jdbc:h2:mem:ecommerce`).
