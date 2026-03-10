---
name: flutter-clean-architecture
description: >
  This skill should be used when building any Flutter feature, creating any Dart class,
  deciding where a piece of logic belongs in Flutter, or structuring a Flutter project.
  Triggers on: "Flutter", "Dart", "widget", "screen", "BLoC", "Riverpod", "Provider",
  "state management", "flutter feature", "where does this go in Flutter", "Flutter layer",
  "flutter repository", "flutter use case", "flutter entity", "flutter data source",
  "flutter clean arch", "go_router", "dio", "retrofit", or any Flutter package name.
version: 1.0.0
allowed-tools: [Read, Write, Bash, Glob]
---

# Flutter Clean Architecture Skill

## The Mirror Principle

Flutter's clean architecture mirrors Spring Boot's hexagonal architecture.
If you understand Rushee's backend structure, you already understand the Flutter structure.

```
Spring Boot                Flutter
──────────────────────────────────────────────────────────────
domain/model/Order.java    domain/entities/order.dart
domain/port/out/           domain/repositories/
  OrderRepository.java       order_repository.dart        (abstract)
application/               application/usecases/
  OrderApplicationService    place_order_usecase.dart
  .java
infrastructure/            data/
  persistence/               datasources/
    JpaOrderRepository         order_remote_datasource.dart
    .java                    models/
  web/                         order_model.dart
    OrderController.java     repositories/
                               order_repository_impl.dart
@RestController            presentation/
  (HTTP in)                  screens/order_screen.dart
                             bloc/order_bloc.dart
                             widgets/order_summary_card.dart
```

---

## Project Structure

```
lib/
├── core/                           # Cross-cutting concerns
│   ├── error/
│   │   ├── failures.dart           # Sealed class: ServerFailure, CacheFailure, etc.
│   │   └── exceptions.dart         # ServerException, CacheException
│   ├── network/
│   │   ├── api_client.dart         # Dio instance + interceptors
│   │   └── api_constants.dart      # Base URLs, endpoints
│   ├── theme/
│   │   ├── app_theme.dart          # ThemeData built from design tokens
│   │   ├── app_colors.dart         # ColorScheme constants (from Figma)
│   │   ├── app_typography.dart     # TextTheme (from Figma)
│   │   └── app_spacing.dart        # Spacing constants (from Figma)
│   ├── router/
│   │   └── app_router.dart         # go_router configuration
│   └── di/
│       └── injection_container.dart # GetIt service locator setup
│
└── features/
    └── order/                      # ONE folder per bounded context
        ├── domain/                 # Pure Dart — ZERO Flutter imports
        │   ├── entities/
        │   │   └── order.dart      # Equatable, immutable
        │   ├── repositories/
        │   │   └── order_repository.dart  # abstract class
        │   └── usecases/
        │       ├── place_order_usecase.dart
        │       └── get_order_usecase.dart
        ├── data/                   # Implementation — Dio, Hive, etc.
        │   ├── datasources/
        │   │   ├── order_remote_datasource.dart
        │   │   └── order_local_datasource.dart  # offline cache
        │   ├── models/
        │   │   └── order_model.dart  # extends Order + fromJson/toJson
        │   └── repositories/
        │       └── order_repository_impl.dart
        └── presentation/           # Flutter widgets + BLoC
            ├── bloc/
            │   ├── order_bloc.dart
            │   ├── order_event.dart
            │   └── order_state.dart
            ├── screens/
            │   ├── order_screen.dart
            │   └── order_confirmation_screen.dart
            └── widgets/
                ├── order_summary_card.dart
                └── order_line_item.dart
```

---

## Domain Layer — Pure Dart, Zero Framework Imports

```dart
// domain/entities/order.dart
// RULE: No flutter/*, no dio, no json_annotation, no hive — pure Dart only
import 'package:equatable/equatable.dart';

enum OrderStatus { draft, placed, confirmed, shipped, delivered, cancelled }

class Order extends Equatable {
  final String id;
  final String customerId;
  final List<OrderLine> lines;
  final Money total;
  final OrderStatus status;
  final DateTime placedAt;

  const Order({
    required this.id,
    required this.customerId,
    required this.lines,
    required this.total,
    required this.status,
    required this.placedAt,
  });

  // Business rules live here — not in BLoC, not in the screen
  bool get canBeCancelled =>
      status == OrderStatus.placed || status == OrderStatus.confirmed;

  bool get isEmpty => lines.isEmpty;

  @override
  List<Object?> get props => [id, customerId, lines, total, status, placedAt];
}

// Value Object — same discipline as Spring Boot
class Money extends Equatable {
  final int amountInPence;   // never use double for money
  final String currency;

  const Money({required this.amountInPence, required this.currency});

  Money operator +(Money other) {
    assert(currency == other.currency, 'Cannot add different currencies');
    return Money(amountInPence: amountInPence + other.amountInPence, currency: currency);
  }

  String get formatted => '${currency}${(amountInPence / 100).toStringAsFixed(2)}';

  @override
  List<Object?> get props => [amountInPence, currency];
}
```

```dart
// domain/repositories/order_repository.dart
// Output port — abstract contract, no implementation details
import 'package:fpdart/fpdart.dart';
import '../entities/order.dart';
import '../../core/error/failures.dart';

abstract class OrderRepository {
  Future<Either<Failure, Order>> placeOrder(PlaceOrderParams params);
  Future<Either<Failure, Order>> getOrder(String orderId);
  Future<Either<Failure, List<Order>>> getOrderHistory(String customerId);
}
```

```dart
// domain/usecases/place_order_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';
import '../../core/error/failures.dart';

// Use cases are single-method classes — same as Spring Boot @UseCase
class PlaceOrderUseCase {
  final OrderRepository repository;
  const PlaceOrderUseCase(this.repository);

  Future<Either<Failure, Order>> call(PlaceOrderParams params) {
    if (params.lines.isEmpty) {
      return Future.value(Left(ValidationFailure('Cart cannot be empty')));
    }
    return repository.placeOrder(params);
  }
}

class PlaceOrderParams {
  final String customerId;
  final List<OrderLineParams> lines;
  const PlaceOrderParams({required this.customerId, required this.lines});
}
```

---

## Data Layer — Generated Models, Never Hand-Written

```dart
// data/models/order_model.dart
// GENERATED from OpenAPI spec — never hand-write JSON parsing
// Run: flutter pub run build_runner build
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/order.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.customerId,
    required super.lines,
    required super.total,
    required super.status,
    required super.placedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
```

```dart
// data/datasources/order_remote_datasource.dart
// RULE: This is the ONLY place Dio/http is used for orders
import 'package:dio/dio.dart';
import '../models/order_model.dart';
import '../../core/error/exceptions.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> placeOrder(Map<String, dynamic> request);
  Future<OrderModel> getOrder(String orderId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;
  const OrderRemoteDataSourceImpl({required this.dio});

  @override
  Future<OrderModel> placeOrder(Map<String, dynamic> request) async {
    try {
      final response = await dio.post('/api/v1/orders', data: request);
      return OrderModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['message'] ?? 'Unknown error',
      );
    }
  }

  @override
  Future<OrderModel> getOrder(String orderId) async {
    try {
      final response = await dio.get('/api/v1/orders/$orderId');
      return OrderModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(statusCode: e.response?.statusCode ?? 500,
          message: e.response?.data['message'] ?? 'Unknown error');
    }
  }
}
```

```dart
// data/repositories/order_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../datasources/order_remote_datasource.dart';
import '../datasources/order_local_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final OrderLocalDataSource localDataSource;

  const OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Order>> placeOrder(PlaceOrderParams params) async {
    try {
      final order = await remoteDataSource.placeOrder(params.toJson());
      await localDataSource.cacheOrder(order);   // offline resilience
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, Order>> getOrder(String orderId) async {
    try {
      final order = await remoteDataSource.getOrder(orderId);
      return Right(order);
    } on ServerException catch (e) {
      // Graceful degradation: serve from cache on network failure
      try {
        final cached = await localDataSource.getCachedOrder(orderId);
        return Right(cached);
      } catch (_) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      }
    }
  }
}
```

---

## Presentation Layer — BLoC

```dart
// presentation/bloc/order_event.dart
abstract class OrderEvent {}

class PlaceOrderRequested extends OrderEvent {
  final PlaceOrderParams params;
  PlaceOrderRequested(this.params);
}

class OrderDetailsRequested extends OrderEvent {
  final String orderId;
  OrderDetailsRequested(this.orderId);
}
```

```dart
// presentation/bloc/order_state.dart
abstract class OrderState {}

class OrderInitial extends OrderState {}
class OrderLoading extends OrderState {}

class OrderPlaced extends OrderState {
  final Order order;
  OrderPlaced(this.order);
}

class OrderLoaded extends OrderState {
  final Order order;
  OrderLoaded(this.order);
}

class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
}
```

```dart
// presentation/bloc/order_bloc.dart
// RULE: BLoC ONLY calls use cases — never repositories, never Dio
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/place_order_usecase.dart';
import '../../domain/usecases/get_order_usecase.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final PlaceOrderUseCase placeOrderUseCase;
  final GetOrderUseCase getOrderUseCase;

  OrderBloc({
    required this.placeOrderUseCase,
    required this.getOrderUseCase,
  }) : super(OrderInitial()) {
    on<PlaceOrderRequested>(_onPlaceOrderRequested);
    on<OrderDetailsRequested>(_onOrderDetailsRequested);
  }

  Future<void> _onPlaceOrderRequested(
      PlaceOrderRequested event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    final result = await placeOrderUseCase(event.params);
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (order) => emit(OrderPlaced(order)),
    );
  }

  Future<void> _onOrderDetailsRequested(
      OrderDetailsRequested event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    final result = await getOrderUseCase(event.orderId);
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (order) => emit(OrderLoaded(order)),
    );
  }
}
```

```dart
// presentation/screens/order_screen.dart
// RULE: Screens handle UI only — no business logic, no direct API calls
class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is OrderPlaced) {
          context.go('/orders/${state.order.id}/confirmation');
        }
      },
      builder: (context, state) {
        return switch (state) {
          OrderLoading() => const _OrderLoadingView(),
          OrderLoaded(:final order) => _OrderDetailView(order: order),
          OrderPlaced(:final order) => _OrderDetailView(order: order),
          _ => const _OrderInitialView(),
        };
      },
    );
  }
}
```

---

## Dependency Injection with GetIt

```dart
// core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs — factory so a new instance per screen
  sl.registerFactory(() => OrderBloc(
    placeOrderUseCase: sl(),
    getOrderUseCase: sl(),
  ));

  // Use cases
  sl.registerLazySingleton(() => PlaceOrderUseCase(sl()));
  sl.registerLazySingleton(() => GetOrderUseCase(sl()));

  // Repository
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(
    remoteDataSource: sl(),
    localDataSource: sl(),
  ));

  // Data sources
  sl.registerLazySingleton<OrderRemoteDataSource>(() =>
      OrderRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<OrderLocalDataSource>(() =>
      OrderLocalDataSourceImpl(hiveBox: sl()));

  // External
  sl.registerLazySingleton(() => Dio(BaseOptions(baseUrl: ApiConstants.baseUrl))
    ..interceptors.add(AuthInterceptor(sl())));
}
```

---

## Architecture Rules — Non-Negotiable

| Rule | Violation | Fix |
|------|-----------|-----|
| No `dart:io` or `package:dio` in `domain/` | `import 'package:dio/dio.dart'` in entity | Move to `data/` layer |
| No `package:flutter` in `domain/` | `import 'package:flutter/material.dart'` in use case | Domain is pure Dart |
| BLoC never imports repository directly | `OrderRepositoryImpl` in BLoC | BLoC only imports use cases |
| No `setState()` in screens with BLoC | `setState()` alongside `BlocBuilder` | All state in BLoC |
| No raw `Exception` — use `Either` | `throw Exception('failed')` in repo | Return `Left(Failure)` |
| No `print()` for debugging | `print(response.data)` | Use `logger` package |
| No hardcoded strings in widgets | `Text('Place Order')` inline | Use `l10n` or constants |

---

## pubspec.yaml — Required Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Architecture
  flutter_bloc: ^8.1.3       # State management
  get_it: ^7.6.0             # Dependency injection
  fpdart: ^1.1.0             # Either<Failure, T> for error handling
  equatable: ^2.0.5          # Value equality for entities

  # Networking
  dio: ^5.3.2                # HTTP client
  pretty_dio_logger: ^1.3.1  # Dev logging

  # Data
  json_annotation: ^4.8.1    # JSON serialisation
  hive_flutter: ^1.1.0       # Local cache

  # Security
  flutter_secure_storage: ^9.0.0  # Token storage — NEVER SharedPreferences
  local_auth: ^2.1.6              # Biometric authentication

  # Navigation
  go_router: ^12.1.1

  # Localisation
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.5          # BLoC unit testing
  mocktail: ^1.0.1           # Mocking
  json_serializable: ^6.7.1  # Code generation
  build_runner: ^2.4.6       # Code generation runner
  flutter_lints: ^3.0.1      # Linting
  golden_toolkit: ^0.15.0    # Golden (visual regression) tests
```
