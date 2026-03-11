package com.demo.ecommerce.infrastructure.persistence;

import com.demo.ecommerce.domain.model.*;
import com.demo.ecommerce.domain.port.out.OrderRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public class JpaOrderRepository implements OrderRepository {

    private final SpringDataOrderRepository spring;

    public JpaOrderRepository(SpringDataOrderRepository spring) {
        this.spring = spring;
    }

    @Override
    public Order save(Order order) {
        OrderJpaEntity e = new OrderJpaEntity();
        e.setId(order.id().value());
        e.setPlacedAt(order.placedAt());
        for (OrderLine line : order.lines()) {
            OrderLineJpaEntity le = new OrderLineJpaEntity();
            le.setOrder(e);
            le.setProductId(line.productId().value());
            le.setProductName(line.productName());
            le.setQuantity(line.quantity());
            le.setUnitPrice(line.unitPrice());
            e.getLines().add(le);
        }
        spring.save(e);
        return order;
    }

    @Override
    public Optional<Order> findById(OrderId id) {
        return spring.findById(id.value()).map(this::toDomain);
    }

    private Order toDomain(OrderJpaEntity e) {
        List<OrderLine> lines = e.getLines().stream()
                .map(l -> new OrderLine(ProductId.of(l.getProductId()), l.getProductName(), l.getQuantity(), l.getUnitPrice()))
                .toList();
        return new Order(OrderId.of(e.getId()), lines, e.getPlacedAt());
    }
}
