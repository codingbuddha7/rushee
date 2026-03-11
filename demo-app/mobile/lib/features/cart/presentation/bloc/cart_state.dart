part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class CartInitial extends CartState {}
final class CartLoading extends CartState {}
final class CartLoaded extends CartState {
  CartLoaded(this.lines);
  final List<CartLine> lines;
  @override
  List<Object?> get props => [lines];
}
final class CartPlacingOrder extends CartState {}
final class OrderPlacedSuccess extends CartState {
  OrderPlacedSuccess(this.order);
  final Order order;
  @override
  List<Object?> get props => [order];
}
final class CartError extends CartState {
  CartError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
