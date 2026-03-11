part of 'product_list_bloc.dart';

sealed class ProductListState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ProductListInitial extends ProductListState {}
final class ProductListLoading extends ProductListState {}
final class ProductListLoaded extends ProductListState {
  ProductListLoaded(this.products);
  final List<Product> products;
  @override
  List<Object?> get props => [products];
}
final class ProductListError extends ProductListState {
  ProductListError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

/// Emitted when add-to-cart fails; listener should show SnackBar then bloc clears by re-emitting loaded.
final class ProductListAddToCartFailed extends ProductListState {
  ProductListAddToCartFailed(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
