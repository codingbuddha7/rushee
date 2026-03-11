# Context Map — Sample Ecommerce App

## Bounded contexts

- **Catalog** (Core): Products available for sale. Provides product list.
- **Order** (Core): Cart and orders. Consumes product info to create order lines; places order.

## Relationships

- **Order** → **Catalog**: Order lines reference product ID and snapshot (name, price). No runtime call during place order if snapshot is stored.
- For minimal demo: single deployment; Catalog and Order can be same process with clear package boundaries.

## Domain events (from UX)

- ProductListViewed  
- ItemAddedToCart  
- CartViewed  
- OrderPlaced  
