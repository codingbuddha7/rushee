package com.demo.ecommerce.application.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

public record OrderDto(UUID id, List<OrderLineDto> lines, BigDecimal total, Instant placedAt) {}
