import '../../domain/entities/cart_line.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(this._dataSource);
  final CartRemoteDataSource _dataSource;

  @override
  Future<List<CartLine>> getCart() => _dataSource.fetchCart();

  @override
  Future<void> addToCart(String productId, int quantity) =>
      _dataSource.addItem(productId, quantity);

  @override
  Future<Order> placeOrder() => _dataSource.placeOrder();
}
