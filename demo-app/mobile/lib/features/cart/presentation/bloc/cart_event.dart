part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class CartRequested extends CartEvent {}
final class OrderPlaced extends CartEvent {}
