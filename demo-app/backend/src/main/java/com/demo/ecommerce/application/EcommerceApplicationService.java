package com.demo.ecommerce.application;

import com.demo.ecommerce.application.dto.*;
import com.demo.ecommerce.domain.model.*;
import com.demo.ecommerce.domain.port.out.OrderRepository;
import com.demo.ecommerce.domain.port.out.ProductRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class EcommerceApplicationService {

    private final ProductRepository productRepository;
    private final OrderRepository orderRepository;
    private final Map<String, List<CartLine>> carts = new ConcurrentHashMap<>();
    private static final String DEFAULT_CART_ID = "default";

    public EcommerceApplicationService(ProductRepository productRepository, OrderRepository orderRepository) {
        this.productRepository = productRepository;
        this.orderRepository = orderRepository;
    }

    public List<ProductDto> listProducts() {
        return productRepository.findAll().stream()
                .map(p -> new ProductDto(p.id().value(), p.name(), p.price()))
                .toList();
    }

    public CartDto getCart(String cartId) {
        String key = cartId != null ? cartId : DEFAULT_CART_ID;
        List<CartLine> lines = carts.getOrDefault(key, List.of());
        List<CartLineDto> dtos = lines.stream()
                .map(l -> new CartLineDto(l.productId().value(), l.productName(), l.quantity(), l.unitPrice()))
                .toList();
        return new CartDto(dtos);
    }

    public void addToCart(String cartId, AddCartItemRequest request) {
        String key = cartId != null ? cartId : DEFAULT_CART_ID;
        Product product = productRepository.findById(ProductId.of(request.productId()))
                .orElseThrow(() -> new IllegalArgumentException("Product not found: " + request.productId()));
        List<CartLine> lines = new ArrayList<>(carts.getOrDefault(key, List.of()));
        boolean found = false;
        for (int i = 0; i < lines.size(); i++) {
            if (lines.get(i).productId().value().equals(request.productId())) {
                lines.set(i, new CartLine(product.id(), product.name(), lines.get(i).quantity() + request.quantity(), product.price()));
                found = true;
                break;
            }
        }
        if (!found) {
            lines.add(new CartLine(product.id(), product.name(), request.quantity(), product.price()));
        }
        carts.put(key, lines);
    }

    public OrderDto placeOrder(String cartId) {
        String key = cartId != null ? cartId : DEFAULT_CART_ID;
        List<CartLine> lines = carts.remove(key);
        if (lines == null || lines.isEmpty()) {
            throw new IllegalStateException("Cart is empty");
        }
        OrderId orderId = OrderId.of(UUID.randomUUID());
        List<OrderLine> orderLines = lines.stream()
                .map(l -> new OrderLine(l.productId(), l.productName(), l.quantity(), l.unitPrice()))
                .toList();
        Order order = new Order(orderId, orderLines, Instant.now());
        orderRepository.save(order);
        carts.put(key, new ArrayList<>());
        return new OrderDto(
                order.id().value(),
                order.lines().stream()
                        .map(l -> new OrderLineDto(l.productId().value(), l.productName(), l.quantity(), l.unitPrice()))
                        .toList(),
                order.total(),
                order.placedAt()
        );
    }

    private record CartLine(ProductId productId, String productName, int quantity, BigDecimal unitPrice) {}
}
