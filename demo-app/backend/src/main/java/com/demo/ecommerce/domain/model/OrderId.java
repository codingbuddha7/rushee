package com.demo.ecommerce.domain.model;

import java.util.UUID;

public record OrderId(UUID value) {
    public static OrderId of(UUID value) {
        return new OrderId(value);
    }
}
