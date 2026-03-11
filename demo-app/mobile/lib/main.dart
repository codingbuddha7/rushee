import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_colors.dart';
import 'features/catalog/data/datasources/product_remote_datasource.dart';
import 'features/catalog/data/repositories/product_repository_impl.dart';
import 'features/catalog/domain/repositories/product_repository.dart';
import 'features/catalog/presentation/bloc/product_list_bloc.dart';
import 'features/catalog/presentation/screens/product_list_screen.dart';
import 'features/cart/data/datasources/cart_remote_datasource.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/domain/entities/order.dart';
import 'features/cart/domain/repositories/cart_repository.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/cart/presentation/screens/cart_screen.dart';
import 'features/cart/presentation/screens/order_confirmation_screen.dart';

void main() {
  runApp(const EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    const baseUrl = 'http://localhost:8080';
    ProductRepository productRepo = ProductRepositoryImpl(
      ProductRemoteDataSource(baseUrl: baseUrl),
    );
    CartRepository cartRepo = CartRepositoryImpl(
      CartRemoteDataSource(baseUrl: baseUrl),
    );

    return MaterialApp(
      title: 'Ecommerce',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ProductListBloc(productRepo, cartRepo)
              ..add(ProductListRequested()),
          ),
          BlocProvider(
            create: (_) => CartBloc(cartRepo)..add(CartRequested()),
          ),
        ],
        child: const _AppShell(),
      ),
    );
  }
}

class _AppShell extends StatelessWidget {
  const _AppShell();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/cart') {
          return MaterialPageRoute<void>(
            builder: (_) => BlocProvider.value(
              value: context.read<CartBloc>()..add(CartRequested()),
              child: CartScreen(
                onOrderPlaced: (Order order) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => OrderConfirmationScreen(
                        order: order,
                        onDone: () {
                          Navigator.of(context).popUntil((r) => r.isFirst);
                          context.read<ProductListBloc>().add(ProductListRequested());
                          context.read<CartBloc>().add(CartRequested());
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
        if (settings.name == '/') {
          return MaterialPageRoute<void>(
            builder: (_) => ProductListScreen(
              onCartTap: () => Navigator.of(context).pushNamed('/cart'),
            ),
          );
        }
        return MaterialPageRoute<void>(
          builder: (_) => ProductListScreen(
            onCartTap: () => Navigator.of(context).pushNamed('/cart'),
          ),
        );
      },
    );
  }
}
