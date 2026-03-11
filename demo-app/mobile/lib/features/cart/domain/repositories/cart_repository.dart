import '../entities/cart_line.dart';
import '../entities/order.dart';

abstract class CartRepository {
  Future<List<CartLine>> getCart();
  Future<void> addToCart(String productId, int quantity);
  Future<Order> placeOrder();
}
