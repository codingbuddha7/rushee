package com.demo.ecommerce.domain.model;

import java.util.UUID;

public record ProductId(UUID value) {
    public static ProductId of(UUID value) {
        return new ProductId(value);
    }
}
