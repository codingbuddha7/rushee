import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._dataSource);
  final ProductRemoteDataSource _dataSource;

  @override
  Future<List<Product>> listProducts() => _dataSource.fetchProducts();
}
