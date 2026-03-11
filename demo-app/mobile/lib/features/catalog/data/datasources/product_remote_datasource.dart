import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/product.dart';

class ProductRemoteDataSource {
  ProductRemoteDataSource({required this.baseUrl});
  final String baseUrl;

  Future<List<Product>> fetchProducts() async {
    final r = await http.get(Uri.parse('$baseUrl/api/v1/products'));
    if (r.statusCode != 200) throw Exception('Failed to load products');
    final list = jsonDecode(r.body) as List;
    return list.map((e) => _fromJson(e as Map<String, dynamic>)).toList();
  }

  static Product _fromJson(Map<String, dynamic> j) {
    // Backend (Jackson) serializes UUID as string; ensure we always get a string
    final id = j['id'];
    return Product(
      id: id == null ? '' : id.toString(),
      name: j['name'] as String? ?? '',
      price: (j['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
