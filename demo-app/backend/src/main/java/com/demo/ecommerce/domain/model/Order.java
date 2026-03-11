package com.demo.ecommerce.domain.model;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

public record Order(OrderId id, List<OrderLine> lines, Instant placedAt) {
    public BigDecimal total() {
        return lines.stream()
                .map(l -> l.unitPrice().multiply(BigDecimal.valueOf(l.quantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}
