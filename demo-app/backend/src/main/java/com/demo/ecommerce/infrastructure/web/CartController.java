package com.demo.ecommerce.infrastructure.web;

import com.demo.ecommerce.application.EcommerceApplicationService;
import com.demo.ecommerce.application.dto.AddCartItemRequest;
import com.demo.ecommerce.application.dto.CartDto;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/cart")
public class CartController {

    private final EcommerceApplicationService service;

    public CartController(EcommerceApplicationService service) {
        this.service = service;
    }

    @GetMapping
    public ResponseEntity<CartDto> get(@RequestHeader(value = "X-Cart-Id", required = false) String cartId) {
        return ResponseEntity.ok(service.getCart(cartId));
    }

    @PostMapping("/items")
    public ResponseEntity<Void> addItem(
            @RequestHeader(value = "X-Cart-Id", required = false) String cartId,
            @RequestBody AddCartItemRequest request) {
        service.addToCart(cartId, request);
        return ResponseEntity.ok().build();
    }
}
