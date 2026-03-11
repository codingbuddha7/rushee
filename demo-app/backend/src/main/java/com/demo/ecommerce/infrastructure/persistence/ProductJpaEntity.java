package com.demo.ecommerce.infrastructure.persistence;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.UUID;

@Entity
@Table(name = "products")
public class ProductJpaEntity {
    @Id
    @Column(columnDefinition = "uuid")
    private UUID id;
    private String name;
    private BigDecimal price;

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
}
