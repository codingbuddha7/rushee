package com.demo.ecommerce.domain.port.out;

import com.demo.ecommerce.domain.model.Order;
import com.demo.ecommerce.domain.model.OrderId;

import java.util.Optional;

public interface OrderRepository {
    Order save(Order order);
    Optional<Order> findById(OrderId id);
}
