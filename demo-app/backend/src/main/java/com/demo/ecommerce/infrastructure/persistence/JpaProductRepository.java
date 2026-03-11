package com.demo.ecommerce.infrastructure.persistence;

import com.demo.ecommerce.domain.model.Product;
import com.demo.ecommerce.domain.model.ProductId;
import com.demo.ecommerce.domain.port.out.ProductRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public class JpaProductRepository implements ProductRepository {

    private final SpringDataProductRepository spring;

    public JpaProductRepository(SpringDataProductRepository spring) {
        this.spring = spring;
    }

    @Override
    public List<Product> findAll() {
        return spring.findAll().stream().map(this::toDomain).toList();
    }

    @Override
    public Optional<Product> findById(ProductId id) {
        return spring.findById(id.value()).map(this::toDomain);
    }

    private Product toDomain(ProductJpaEntity e) {
        return new Product(ProductId.of(e.getId()), e.getName(), e.getPrice());
    }
}
