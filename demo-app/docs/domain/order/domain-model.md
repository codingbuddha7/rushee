# Domain Model — Order (bounded context)

## Aggregate: Order

- **Order** (aggregate root): id (OrderId), customerId (optional for demo), line items, status, placedAt.
- **OrderLine** (entity): productId, productName, quantity, unitPrice (snapshot at order time).
- **OrderId** (value object): UUID.
- **OrderStatus** (enum): PENDING, PLACED, CONFIRMED.

## Domain events

- **OrderPlaced**: orderId, lineItems, placedAt.

## Ports

- **OrderRepository** (out): save(Order), findById(OrderId).  
- Cart can be in-memory or same aggregate; for minimal demo, Cart is a separate concept: Cart (session) with CartLine (productId, quantity), then PlaceOrder command creates Order from Cart.

## Simplified for demo

- **Cart**: id (CartId), lines (productId, quantity). Repository: CartRepository.
- **Order**: created from Cart at place-order; OrderRepository.save(Order).
