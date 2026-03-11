# Wireframe Spec — S01 Product List Screen

## Purpose
Show a list of products so the shopper can browse and add items to cart.

## UI states
- Loading: spinner or skeletons
- Empty: "No products" message
- Populated: list of product cards (name, price, optional image)
- Error: message + retry

## Content (reading order)
1. App bar: title "Products", cart icon with badge (count)
2. List of product rows: name, price, quantity selector, "Add to cart" button

## Interactions
- Tap "Add to cart" → item (productId + quantity) added to cart; badge updates
- Tap cart icon → navigate to Cart screen (S02)

## API calls this screen makes
- GET /api/v1/products — list products
- POST /api/v1/cart/items — add line (productId, quantity)
- GET /api/v1/cart — cart summary for badge (optional)
