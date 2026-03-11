import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_line.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this._repo) : super(CartInitial()) {
    on<CartRequested>(_onRequested);
    on<OrderPlaced>(_onOrderPlaced);
  }
  final CartRepository _repo;

  Future<void> _onRequested(CartRequested event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final lines = await _repo.getCart();
      emit(CartLoaded(lines));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onOrderPlaced(OrderPlaced event, Emitter<CartState> emit) async {
    emit(CartPlacingOrder());
    try {
      final order = await _repo.placeOrder();
      emit(OrderPlacedSuccess(order));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
