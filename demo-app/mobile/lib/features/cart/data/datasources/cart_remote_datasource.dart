import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/cart_line.dart';
import '../../domain/entities/order.dart';

class CartRemoteDataSource {
  CartRemoteDataSource({required this.baseUrl});
  final String baseUrl;

  Future<List<CartLine>> fetchCart() async {
    final r = await http.get(Uri.parse('$baseUrl/api/v1/cart'));
    if (r.statusCode != 200) throw Exception('Failed to load cart');
    final j = jsonDecode(r.body) as Map<String, dynamic>;
    final list = j['lines'] as List? ?? [];
    return list.map((e) => _lineFromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> addItem(String productId, int quantity) async {
    final r = await http.post(
      Uri.parse('$baseUrl/api/v1/cart/items'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'productId': productId, 'quantity': quantity}),
    );
    if (r.statusCode != 200) throw Exception('Failed to add to cart');
  }

  Future<Order> placeOrder() async {
    final r = await http.post(Uri.parse('$baseUrl/api/v1/orders'));
    if (r.statusCode != 200) throw Exception('Failed to place order');
    final j = jsonDecode(r.body) as Map<String, dynamic>;
    return Order(
      id: j['id'] as String,
      total: (j['total'] as num).toDouble(),
      placedAt: DateTime.parse(j['placedAt'] as String),
    );
  }

  static CartLine _lineFromJson(Map<String, dynamic> j) {
    return CartLine(
      productId: j['productId'] as String,
      productName: j['productName'] as String,
      quantity: j['quantity'] as int,
      unitPrice: (j['unitPrice'] as num).toDouble(),
    );
  }
}
