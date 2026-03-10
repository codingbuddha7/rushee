---
name: database-migration-discipline
description: >
  This skill should be used whenever a JPA entity is created or modified, a database
  schema change is needed, or any persistence-related code is being written. Triggers on:
  "new entity", "add column", "change schema", "database migration", "Flyway", "Liquibase",
  "@Entity", "add field to entity", "rename column", "create table", or any JPA entity
  modification. Migration script MUST exist before any entity change is committed.
version: 1.0.0
allowed-tools: [Read, Write, Bash, Glob, Grep]
---

# Database Migration Discipline Skill

## The Rule
**Every schema change has a migration script. Scripts are immutable once merged. No exceptions.**

If you change a JPA entity without a migration script: the change WILL NOT WORK in staging or production.

---

## Flyway Setup (preferred for Spring Boot)

### Maven dependency
```xml
<dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-core</artifactId>
    <!-- version managed by Spring Boot BOM -->
</dependency>
<!-- For PostgreSQL -->
<dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-database-postgresql</artifactId>
</dependency>
```

### application.yml
```yaml
spring:
  flyway:
    enabled: true
    locations: classpath:db/migration
    baseline-on-migrate: false        # Never true in production
    out-of-order: false               # Never true in production
  jpa:
    hibernate:
      ddl-auto: validate              # NEVER create, update, or create-drop in production
```

### application-test.yml (for tests)
```yaml
spring:
  flyway:
    enabled: true                     # Always test with real migrations
  jpa:
    hibernate:
      ddl-auto: validate              # Validate against migrations — not generate
```

**NEVER use `ddl-auto: update` or `ddl-auto: create` outside of local throw-away development.**

---

## Migration File Naming Convention

```
src/main/resources/db/migration/
├── V1__create_orders_table.sql
├── V2__add_customer_table.sql
├── V3__add_status_to_orders.sql
├── V4__create_order_lines_table.sql
├── V5__add_index_orders_customer_id.sql
└── R__views.sql                       (repeatable migrations — use sparingly)
```

Format: `V<version>__<description>.sql`
- Version: integer, strictly sequential (`V1`, `V2`, `V3` — NOT `V1.1`, `V1.2`)
- Two underscores between version and description
- Description: snake_case, explains what changes
- **NEVER rename or modify a merged migration** — Flyway will fail on checksum mismatch

---

## Migration Script Patterns

### Create Table
```sql
-- V1__create_orders_table.sql
CREATE TABLE orders (
    id          VARCHAR(36)  NOT NULL,
    customer_id VARCHAR(36)  NOT NULL,
    status      VARCHAR(20)  NOT NULL,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    version     BIGINT       NOT NULL DEFAULT 0,  -- for optimistic locking
    CONSTRAINT pk_orders PRIMARY KEY (id),
    CONSTRAINT chk_orders_status CHECK (status IN ('DRAFT','PLACED','CONFIRMED','FULFILLED','SHIPPED','DELIVERED','CANCELLED'))
);

CREATE INDEX idx_orders_customer_id ON orders (customer_id);
CREATE INDEX idx_orders_status ON orders (status);
```

### Add Column (backward compatible — nullable first)
```sql
-- V5__add_shipping_address_to_orders.sql
-- Step 1: add nullable (backward compatible — old code still works)
ALTER TABLE orders ADD COLUMN shipping_address_line1 VARCHAR(200);
ALTER TABLE orders ADD COLUMN shipping_address_line2 VARCHAR(200);
ALTER TABLE orders ADD COLUMN shipping_address_city   VARCHAR(100);
ALTER TABLE orders ADD COLUMN shipping_address_country CHAR(2);

-- Step 2 (separate migration after all code is deployed): make NOT NULL
-- V6__make_shipping_address_required.sql
-- UPDATE orders SET shipping_address_line1 = 'UNKNOWN' WHERE shipping_address_line1 IS NULL;
-- ALTER TABLE orders ALTER COLUMN shipping_address_line1 SET NOT NULL;
```

### Rename Column (never break consumers)
```sql
-- V7__rename_total_to_total_amount.sql
-- SAFE: add new column, populate, deprecate old
ALTER TABLE orders ADD COLUMN total_amount DECIMAL(19,4);
UPDATE orders SET total_amount = total;
-- Old column stays until all consumers migrated
-- V8__drop_old_total_column.sql (only after all services updated)
-- ALTER TABLE orders DROP COLUMN total;
```

### Add Foreign Key
```sql
-- V4__create_order_lines_table.sql
CREATE TABLE order_lines (
    id          VARCHAR(36)   NOT NULL,
    order_id    VARCHAR(36)   NOT NULL,
    product_id  VARCHAR(36)   NOT NULL,
    quantity    INTEGER       NOT NULL,
    unit_price  DECIMAL(19,4) NOT NULL,
    currency    CHAR(3)       NOT NULL,
    CONSTRAINT pk_order_lines PRIMARY KEY (id),
    CONSTRAINT fk_order_lines_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT chk_order_lines_quantity CHECK (quantity > 0),
    CONSTRAINT chk_order_lines_price CHECK (unit_price >= 0)
);

CREATE INDEX idx_order_lines_order_id ON order_lines (order_id);
```

---

## JPA Entity — Mapping Rules

```java
@Entity
@Table(name = "orders",
    indexes = {
        @Index(name = "idx_orders_customer_id", columnList = "customer_id"),
        @Index(name = "idx_orders_status", columnList = "status")
    }
)
public class OrderJpaEntity {

    @Id
    @Column(name = "id", nullable = false, length = 36)
    private String id;

    @Column(name = "customer_id", nullable = false, length = 36)
    private String customerId;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private OrderStatusJpa status;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Version                                    // Optimistic locking
    @Column(name = "version", nullable = false)
    private Long version;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OrderLineJpaEntity> lines = new ArrayList<>();

    // No-arg constructor required by JPA
    protected OrderJpaEntity() {}
}
```

---

## Pre-Commit Checklist for Any Schema Change

- [ ] Migration script created in `src/main/resources/db/migration/`
- [ ] Script version is next sequential number
- [ ] `ddl-auto` is NOT `update` or `create` anywhere except local dev
- [ ] Migration tested: `./mvnw flyway:migrate` runs clean
- [ ] Migration is backward compatible (new columns nullable, old columns kept)
- [ ] Indexes added for all foreign keys and frequently queried columns
- [ ] `@Version` field present on entities that need optimistic locking
- [ ] `./mvnw test` passes with `ddl-auto: validate`
