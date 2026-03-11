package com.demo.ecommerce.application.dto;

import java.util.List;

public record CartDto(List<CartLineDto> lines) {}
