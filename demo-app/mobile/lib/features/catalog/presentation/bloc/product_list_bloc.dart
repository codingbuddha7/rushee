import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../../cart/domain/repositories/cart_repository.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListBloc(this._productRepo, this._cartRepo) : super(ProductListInitial()) {
    on<ProductListRequested>(_onRequested);
    on<ProductAddedToCart>(_onAddedToCart);
  }
  final ProductRepository _productRepo;
  final CartRepository _cartRepo;

  Future<void> _onRequested(ProductListRequested event, Emitter<ProductListState> emit) async {
    emit(ProductListLoading());
    try {
      final products = await _productRepo.listProducts();
      emit(ProductListLoaded(products));
    } catch (e) {
      emit(ProductListError(e.toString()));
    }
  }

  Future<void> _onAddedToCart(ProductAddedToCart event, Emitter<ProductListState> emit) async {
    try {
      await _cartRepo.addToCart(event.productId, event.quantity);
      if (state is ProductListLoaded) {
        emit(ProductListLoaded((state as ProductListLoaded).products));
      }
    } catch (_) {}
  }
}
