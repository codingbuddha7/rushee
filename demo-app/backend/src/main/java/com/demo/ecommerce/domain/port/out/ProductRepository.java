package com.demo.ecommerce.domain.port.out;

import com.demo.ecommerce.domain.model.Product;
import com.demo.ecommerce.domain.model.ProductId;

import java.util.List;
import java.util.Optional;

public interface ProductRepository {
    List<Product> findAll();
    Optional<Product> findById(ProductId id);
}
