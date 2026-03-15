# Output of /rushee:bdd-spec FDD-001
# Validated by spec-guardian: no HTTP verbs, URLs, class names, or SQL
Feature: Place order from cart

  Background:
    Given the product catalogue contains:
      | name         | price |
      | Laptop Stand | 49.99 |
      | USB-C Hub    | 29.99 |

  Scenario: Shopper places a successful order
    Given Amara has added 1 "Laptop Stand" to her cart
    And Amara has added 2 "USB-C Hub" units to her cart
    When Amara places her order
    Then an order is created with status "PENDING"
    And the order total is 109.97
    And Amara sees an order confirmation with an order ID

  Scenario: Shopper cannot place an order with an empty cart
    Given Amara's cart is empty
    When Amara attempts to place an order
    Then the order is rejected
    And Amara sees the message "Your cart is empty"

  Scenario: Shopper sees all available products
    When Amara opens the product list
    Then she sees "Laptop Stand" priced at 49.99
    And she sees "USB-C Hub" priced at 29.99
