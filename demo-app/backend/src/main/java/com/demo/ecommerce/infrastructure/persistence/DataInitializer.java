package com.demo.ecommerce.infrastructure.persistence;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.math.BigDecimal;
import java.util.UUID;

@Configuration
public class DataInitializer {

    @Bean
    public CommandLineRunner initProducts(SpringDataProductRepository repo) {
        return args -> {
            if (repo.count() > 0) return;
            save(repo, "Widget A", "9.99");
            save(repo, "Widget B", "14.99");
            save(repo, "Gadget X", "29.99");
        };
    }

    private void save(SpringDataProductRepository repo, String name, String price) {
        ProductJpaEntity e = new ProductJpaEntity();
        e.setId(UUID.randomUUID());
        e.setName(name);
        e.setPrice(new BigDecimal(price));
        repo.save(e);
    }
}
