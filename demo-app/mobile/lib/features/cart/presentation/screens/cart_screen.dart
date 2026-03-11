import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/order.dart';
import '../bloc/cart_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({
    super.key,
    required this.onOrderPlaced,
  });
  final void Function(Order order) onOrderPlaced;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is OrderPlacedSuccess) {
            onOrderPlaced(state.order);
          }
        },
        builder: (context, state) {
          if (state is CartLoading || state is CartPlacingOrder) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CartError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is CartLoaded) {
            final lines = state.lines;
            if (lines.isEmpty) {
              return const Center(
                child: Text('Your cart is empty. Add products from the list.'),
              );
            }
            final total = lines.map((l) => l.lineTotal).reduce((a, b) => a + b);
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: lines.length,
                    itemBuilder: (context, i) {
                      final l = lines[i];
                      return ListTile(
                        title: Text(l.productName),
                        subtitle: Text('Qty: ${l.quantity} × \$${l.unitPrice.toStringAsFixed(2)}'),
                        trailing: Text('\$${l.lineTotal.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total: \$${total.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium),
                      FilledButton(
                        onPressed: () =>
                            context.read<CartBloc>().add(OrderPlaced()),
                        child: const Text('Place order'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('Loading cart...'));
        },
      ),
    );
  }
}
