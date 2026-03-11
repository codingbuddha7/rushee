package com.demo.ecommerce.domain.model;

import java.math.BigDecimal;

public record Product(ProductId id, String name, BigDecimal price) {}
