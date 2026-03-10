---
name: flutter-testing-discipline
description: >
  This skill should be used when writing any test in Flutter, deciding what type of
  Flutter test to write, or when a Flutter test fails. Triggers on: "flutter test",
  "widget test", "integration test", "bloc test", "golden test", "pump", "mocktail",
  "flutter_test", "testWidgets", "pumpWidget", "BlocTest", "test coverage flutter",
  "flutter unit test", "test a screen", "test a widget", "test a BLoC",
  "test a use case", or any reference to testing in the Flutter/Dart context.
version: 1.0.0
allowed-tools: [Read, Write, Bash, Glob]
---

# Flutter Testing Discipline Skill

## The Flutter Test Pyramid

```
                    ┌────────────────────────────┐
                    │   Integration Tests (E2E)  │  ← Slowest, fewest
                    │   integration_test pkg      │     Full app on device
                    │   ~10% of test suite        │
                   ┌┴────────────────────────────┴┐
                  │       Widget Tests              │  ← Medium speed
                  │       flutter_test pump()       │     Isolated screens
                  │       ~30% of test suite        │
                 ┌┴────────────────────────────────┴┐
                │         Unit Tests                  │  ← Fastest, most
                │    Pure Dart — no Flutter           │     Domain + BLoC + Repos
                │         ~60% of test suite         │
               └────────────────────────────────────┘
```

**Mirror with Spring Boot:**
| Flutter | Spring Boot |
|---------|------------|
| Unit test (mocktail) | JUnit + Mockito |
| Widget test (pumpWidget) | @WebMvcTest |
| Integration test (integration_test) | @SpringBootTest + CucumberIT |
| Golden test (matchesGoldenFile) | No direct equivalent — visual regression |

---

## Layer 1 — Unit Tests (60% of your tests)

### Use Case Tests
```dart
// test/features/order/domain/usecases/place_order_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  late PlaceOrderUseCase useCase;
  late MockOrderRepository mockRepository;

  setUp(() {
    mockRepository = MockOrderRepository();
    useCase = PlaceOrderUseCase(mockRepository);
  });

  group('PlaceOrderUseCase', () {
    final tParams = PlaceOrderParams(
      customerId: 'cust-123',
      lines: [OrderLineParams(productId: 'prod-456', quantity: 2)],
    );

    final tOrder = Order(
      id: 'ord-789',
      customerId: 'cust-123',
      lines: [OrderLine(productId: 'prod-456', quantity: 2, unitPrice: Money(amountInPence: 1250, currency: 'GBP'))],
      total: Money(amountInPence: 2500, currency: 'GBP'),
      status: OrderStatus.placed,
      placedAt: DateTime(2025, 1, 1),
    );

    test('calls repository when cart is not empty', () async {
      // Arrange
      when(() => mockRepository.placeOrder(tParams))
          .thenAnswer((_) async => Right(tOrder));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, Right(tOrder));
      verify(() => mockRepository.placeOrder(tParams)).called(1);
    });

    test('returns ValidationFailure when cart is empty', () async {
      // Arrange
      final emptyParams = PlaceOrderParams(customerId: 'cust-123', lines: []);

      // Act
      final result = await useCase(emptyParams);

      // Assert
      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Should not succeed'),
      );
      verifyNever(() => mockRepository.placeOrder(any()));
    });
  });
}
```

### BLoC Tests
```dart
// test/features/order/presentation/bloc/order_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

class MockPlaceOrderUseCase extends Mock implements PlaceOrderUseCase {}
class MockGetOrderUseCase extends Mock implements GetOrderUseCase {}

void main() {
  late OrderBloc bloc;
  late MockPlaceOrderUseCase mockPlaceOrder;
  late MockGetOrderUseCase mockGetOrder;

  setUp(() {
    mockPlaceOrder = MockPlaceOrderUseCase();
    mockGetOrder = MockGetOrderUseCase();
    bloc = OrderBloc(
      placeOrderUseCase: mockPlaceOrder,
      getOrderUseCase: mockGetOrder,
    );
    // Register fallback values for any() matcher
    registerFallbackValue(PlaceOrderParams(customerId: '', lines: []));
  });

  tearDown(() => bloc.close());

  group('PlaceOrderRequested', () {
    blocTest<OrderBloc, OrderState>(
      'emits [OrderLoading, OrderPlaced] when placeOrder succeeds',
      build: () {
        when(() => mockPlaceOrder(any()))
            .thenAnswer((_) async => Right(tOrder));
        return bloc;
      },
      act: (b) => b.add(PlaceOrderRequested(tParams)),
      expect: () => [isA<OrderLoading>(), isA<OrderPlaced>()],
      verify: (_) => verify(() => mockPlaceOrder(tParams)).called(1),
    );

    blocTest<OrderBloc, OrderState>(
      'emits [OrderLoading, OrderError] when placeOrder fails',
      build: () {
        when(() => mockPlaceOrder(any()))
            .thenAnswer((_) async => Left(ServerFailure('Network error', statusCode: 503)));
        return bloc;
      },
      act: (b) => b.add(PlaceOrderRequested(tParams)),
      expect: () => [
        isA<OrderLoading>(),
        isA<OrderError>().having((s) => s.message, 'message', 'Network error'),
      ],
    );
  });
}
```

### Repository Implementation Tests
```dart
// test/features/order/data/repositories/order_repository_impl_test.dart
class MockOrderRemoteDataSource extends Mock implements OrderRemoteDataSource {}
class MockOrderLocalDataSource extends Mock implements OrderLocalDataSource {}

void main() {
  late OrderRepositoryImpl repository;
  late MockOrderRemoteDataSource mockRemote;
  late MockOrderLocalDataSource mockLocal;

  setUp(() {
    mockRemote = MockOrderRemoteDataSource();
    mockLocal = MockOrderLocalDataSource();
    repository = OrderRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  test('returns order and caches it when remote call succeeds', () async {
    when(() => mockRemote.placeOrder(any())).thenAnswer((_) async => tOrderModel);
    when(() => mockLocal.cacheOrder(any())).thenAnswer((_) async => {});

    final result = await repository.placeOrder(tParams);

    expect(result, Right(tOrderModel));
    verify(() => mockLocal.cacheOrder(tOrderModel)).called(1);
  });

  test('returns cached order when remote fails with ServerException', () async {
    when(() => mockRemote.placeOrder(any())).thenThrow(
        ServerException(statusCode: 503, message: 'Service unavailable'));
    when(() => mockLocal.getCachedOrder(any())).thenAnswer((_) async => tOrderModel);

    // On network failure, repository should serve from cache
    // (This tests graceful degradation — offline resilience)
    final result = await repository.getOrder('ord-789');

    expect(result, Right(tOrderModel));
    verify(() => mockLocal.getCachedOrder('ord-789')).called(1);
  });
}
```

---

## Layer 2 — Widget Tests (30% of your tests)

```dart
// test/features/order/presentation/screens/order_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOrderBloc extends MockBloc<OrderEvent, OrderState> implements OrderBloc {}

void main() {
  late MockOrderBloc mockBloc;

  setUp(() => mockBloc = MockOrderBloc());

  // Helper: wraps widget in required providers and MaterialApp
  Widget buildTestableWidget() => MaterialApp(
    home: BlocProvider<OrderBloc>.value(
      value: mockBloc,
      child: const OrderScreen(),
    ),
  );

  group('OrderScreen', () {
    testWidgets('shows loading indicator when state is OrderLoading', (tester) async {
      when(() => mockBloc.state).thenReturn(OrderLoading());

      await tester.pumpWidget(buildTestableWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(OrderSummaryCard), findsNothing);
    });

    testWidgets('shows order summary when state is OrderLoaded', (tester) async {
      when(() => mockBloc.state).thenReturn(OrderLoaded(tOrder));

      await tester.pumpWidget(buildTestableWidget());

      expect(find.byType(OrderSummaryCard), findsOneWidget);
      expect(find.text('£24.99'), findsOneWidget);
      expect(find.text('PLACED'), findsOneWidget);
    });

    testWidgets('shows snackbar when state is OrderError', (tester) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([OrderLoading(), OrderError('Network error')]),
        initialState: OrderLoading(),
      );

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();   // trigger listener

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Network error'), findsOneWidget);
    });

    testWidgets('dispatches PlaceOrderRequested when CTA tapped', (tester) async {
      when(() => mockBloc.state).thenReturn(OrderInitial());

      await tester.pumpWidget(buildTestableWidget());
      await tester.tap(find.byKey(const Key('place-order-cta')));

      verify(() => mockBloc.add(isA<PlaceOrderRequested>())).called(1);
    });
  });
}
```

---

## Layer 3 — Golden Tests (visual regression)

Run once to create baseline PNG, then on every change to catch regressions:

```dart
// test/features/order/presentation/widgets/order_summary_card_golden_test.dart
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  group('OrderSummaryCard golden tests', () {
    testGoldens('renders correctly with placed order', (tester) async {
      await loadAppFonts();   // load custom fonts for accurate rendering

      final widget = MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: OrderSummaryCard(order: tOrder),
        ),
      );

      await tester.pumpWidgetBuilder(widget);
      await screenMatchesGolden(tester, 'order_summary_card_placed');
    });

    testGoldens('renders correctly in dark mode', (tester) async {
      await loadAppFonts();
      final widget = MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(body: OrderSummaryCard(order: tOrder)),
      );

      await tester.pumpWidgetBuilder(widget);
      await screenMatchesGolden(tester, 'order_summary_card_dark');
    });
  });
}
```

```bash
# Create baseline goldens (run once after design is approved)
flutter test --update-goldens test/features/order/presentation/widgets/

# Verify against baseline (run on every PR)
flutter test test/features/order/presentation/widgets/
```

---

## Layer 4 — Integration Tests (10% of your tests)

```dart
// integration_test/order_flow_test.dart
// Runs on a real device/emulator against a real or mocked backend
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Place Order Integration Flow — FDD-001', () {
    testWidgets('user can place an order end-to-end', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to cart
      await tester.tap(find.byKey(const Key('nav-cart')));
      await tester.pumpAndSettle();

      // Verify cart is populated (from previous test setup / seed data)
      expect(find.byType(OrderLineItem), findsWidgets);

      // Tap checkout
      await tester.tap(find.byKey(const Key('checkout-cta')));
      await tester.pumpAndSettle();

      // Fill payment details
      await tester.enterText(find.byKey(const Key('card-number')), '4242424242424242');
      await tester.pumpAndSettle();

      // Confirm order
      await tester.tap(find.byKey(const Key('confirm-order-cta')));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify confirmation screen
      expect(find.byType(OrderConfirmationScreen), findsOneWidget);
      expect(find.textContaining('Order confirmed'), findsOneWidget);
    });
  });
}
```

```bash
# Run integration tests on emulator
flutter test integration_test/ -d emulator-5554

# Run on CI (headless)
flutter test integration_test/ --dart-define=API_BASE_URL=http://localhost:8080
```

---

## Coverage — Minimum Thresholds

```yaml
# analysis_options.yaml — enforce coverage in CI
# Run: flutter test --coverage && genhtml coverage/lcov.info -o coverage/html

# Target coverage by layer:
# domain/         → 90% (pure Dart — easy to test, no excuse)
# application/    → 85% (use cases + mappers)
# data/           → 75% (repositories + data sources)
# presentation/   → 70% (BLoC + key widget states)
```

```bash
# CI coverage check
flutter test --coverage
COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | grep -oP '\d+\.\d+')
if (( $(echo "$COVERAGE < 75.0" | bc -l) )); then
  echo "❌ Coverage $COVERAGE% is below 75% threshold"
  exit 1
fi
echo "✅ Coverage: $COVERAGE%"
```

---

## Checklist — Before Submitting Flutter Feature

- [ ] Use case has unit tests (happy path + all failure paths)
- [ ] BLoC has unit tests for all events (Loading/Success/Error states)
- [ ] Repository impl tests cover remote success + remote failure + cache fallback
- [ ] All screens have widget tests for all BLoC states
- [ ] All screens have widget test proving correct event is dispatched on CTA tap
- [ ] Design system widgets have golden tests (baseline created, matches current Figma)
- [ ] Integration test covers the main happy path flow
- [ ] `flutter test --coverage` shows ≥ 75% overall
- [ ] `flutter analyze` shows zero warnings or errors
- [ ] Golden tests updated if UI changed (`--update-goldens`)
