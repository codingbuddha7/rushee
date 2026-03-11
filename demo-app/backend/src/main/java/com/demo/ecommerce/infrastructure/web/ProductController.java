package com.demo.ecommerce.infrastructure.web;

import com.demo.ecommerce.application.EcommerceApplicationService;
import com.demo.ecommerce.application.dto.ProductDto;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/products")
public class ProductController {

    private final EcommerceApplicationService service;

    public ProductController(EcommerceApplicationService service) {
        this.service = service;
    }

    @GetMapping
    public ResponseEntity<List<ProductDto>> list() {
        return ResponseEntity.ok(service.listProducts());
    }
}
