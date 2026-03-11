# Wireframe Spec — S02 Cart Screen

## Purpose
Show cart contents and allow placing an order.

## UI states
- Loading: spinner
- Empty: "Your cart is empty" + link to Product List
- Populated: list of line items (product name, quantity, price), subtotal, "Place order" button
- Error: message + retry

## Content (reading order)
1. App bar: title "Cart", back to Product List
2. List of cart lines: product name, quantity, unit price, line total
3. Subtotal
4. "Place order" button

## Interactions
- Tap "Place order" → POST order → navigate to Order Confirmation (S03)
- Change quantity or remove: PATCH/DELETE cart (optional for minimal demo)

## API calls this screen makes
- GET /api/v1/cart — list cart items
- POST /api/v1/orders — place order (from current cart)
