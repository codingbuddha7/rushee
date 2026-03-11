package com.demo.ecommerce.infrastructure.web;

import com.demo.ecommerce.application.EcommerceApplicationService;
import com.demo.ecommerce.application.dto.OrderDto;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/orders")
public class OrderController {

    private final EcommerceApplicationService service;

    public OrderController(EcommerceApplicationService service) {
        this.service = service;
    }

    @PostMapping
    public ResponseEntity<OrderDto> placeOrder(@RequestHeader(value = "X-Cart-Id", required = false) String cartId) {
        return ResponseEntity.ok(service.placeOrder(cartId));
    }
}
