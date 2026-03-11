package com.demo.ecommerce.infrastructure.persistence;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "orders")
public class OrderJpaEntity {
    @Id
    @Column(columnDefinition = "uuid")
    private UUID id;
    private Instant placedAt;
    @OneToMany(cascade = CascadeType.ALL, orphanRemoval = true, mappedBy = "order")
    private List<OrderLineJpaEntity> lines = new ArrayList<>();

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }
    public Instant getPlacedAt() { return placedAt; }
    public void setPlacedAt(Instant placedAt) { this.placedAt = placedAt; }
    public List<OrderLineJpaEntity> getLines() { return lines; }
    public void setLines(List<OrderLineJpaEntity> lines) { this.lines = lines; }
}
