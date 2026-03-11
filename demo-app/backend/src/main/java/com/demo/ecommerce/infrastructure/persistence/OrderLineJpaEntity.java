package com.demo.ecommerce.infrastructure.persistence;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.UUID;

@Entity
@Table(name = "order_lines")
public class OrderLineJpaEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id")
    private OrderJpaEntity order;
    @Column(columnDefinition = "uuid")
    private UUID productId;
    private String productName;
    private int quantity;
    private BigDecimal unitPrice;

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }
    public OrderJpaEntity getOrder() { return order; }
    public void setOrder(OrderJpaEntity order) { this.order = order; }
    public UUID getProductId() { return productId; }
    public void setProductId(UUID productId) { this.productId = productId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
}
