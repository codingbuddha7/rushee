# Quick Notes Backend

Spring Boot API for the Rushee demo app. Uses **H2 in-memory** by default (no install needed).

## Run

```bash
mvn spring-boot:run
```

API: http://localhost:8080/api/v1/notes

## If you see `ClassNotFoundException: org.postgresql.Driver`

Spring is trying to use PostgreSQL because something is overriding the datasource config (e.g. `SPRING_DATASOURCE_URL` or an `application.yml` in a parent directory).

- **Use H2 (default):** Unset `SPRING_DATASOURCE_URL` and `SPRING_DATASOURCE_DRIVER_CLASS_NAME`, and run from this directory so no parent `application.yml` is loaded.
- **Use PostgreSQL:** The project includes the PostgreSQL driver. Set `spring.datasource.url`, `username`, and `password` (or env vars) to your Postgres instance.

## Tests

```bash
mvn test -Dtest=CucumberIT
```
