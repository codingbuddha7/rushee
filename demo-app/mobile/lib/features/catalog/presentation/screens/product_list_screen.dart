import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_list_bloc.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({
    super.key,
    required this.onCartTap,
  });
  final VoidCallback onCartTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: onCartTap,
          ),
        ],
      ),
      body: BlocBuilder<ProductListBloc, ProductListState>(
        builder: (context, state) {
          if (state is ProductListLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProductListError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is ProductListLoaded) {
            final products = state.products;
            if (products.isEmpty) {
              return const Center(child: Text('No products yet.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, i) {
                final p = products[i];
                return _ProductTile(
                  product: p,
                  onAddToCart: () => context.read<ProductListBloc>().add(
                        ProductAddedToCart(p.id, 1),
                      ),
                );
              },
            );
          }
          return const Center(child: Text('Pull to load products.'));
        },
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({
    required this.product,
    required this.onAddToCart,
  });
  final Product product;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(product.name),
        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
        trailing: TextButton(
          onPressed: onAddToCart,
          child: const Text('Add to cart'),
        ),
      ),
    );
  }
}
