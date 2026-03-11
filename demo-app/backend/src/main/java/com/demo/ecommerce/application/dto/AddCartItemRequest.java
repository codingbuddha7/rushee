package com.demo.ecommerce.application.dto;

import java.util.UUID;

public record AddCartItemRequest(UUID productId, int quantity) {}
