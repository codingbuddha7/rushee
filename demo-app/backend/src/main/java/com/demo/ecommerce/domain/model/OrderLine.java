package com.demo.ecommerce.domain.model;

import java.math.BigDecimal;

public record OrderLine(ProductId productId, String productName, int quantity, BigDecimal unitPrice) {}
