# Wireframe Spec — S03 Order Confirmation Screen

## Purpose
Confirm that the order was placed and show order ID (or summary).

## UI states
- Success: order ID, "Thank you" message, "Done" button
- Error: message + retry or back to Cart

## Content (reading order)
1. App bar: title "Order confirmed"
2. Message: "Your order has been placed."
3. Order ID (or summary)
4. "Done" button → back to Product List (S01)

## API calls this screen makes
- None (order already placed from Cart screen); optional GET /api/v1/orders/{id} to show details.
