part of 'product_list_bloc.dart';

sealed class ProductListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ProductListRequested extends ProductListEvent {}

final class ProductAddedToCart extends ProductListEvent {
  ProductAddedToCart(this.productId, this.quantity);
  final String productId;
  final int quantity;
  @override
  List<Object?> get props => [productId, quantity];
}
