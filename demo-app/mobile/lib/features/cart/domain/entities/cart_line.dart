import 'package:equatable/equatable.dart';

class CartLine extends Equatable {
  const CartLine({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  double get lineTotal => quantity * unitPrice;

  @override
  List<Object?> get props => [productId, productName, quantity, unitPrice];
}
