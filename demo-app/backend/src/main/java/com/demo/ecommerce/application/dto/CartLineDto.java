package com.demo.ecommerce.application.dto;

import java.math.BigDecimal;
import java.util.UUID;

public record CartLineDto(UUID productId, String productName, int quantity, BigDecimal unitPrice) {}
