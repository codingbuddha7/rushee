import 'package:equatable/equatable.dart';

class Order extends Equatable {
  const Order({
    required this.id,
    required this.total,
    required this.placedAt,
  });
  final String id;
  final double total;
  final DateTime placedAt;

  @override
  List<Object?> get props => [id, total, placedAt];
}
