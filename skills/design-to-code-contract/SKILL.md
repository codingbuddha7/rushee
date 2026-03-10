---
name: design-to-code-contract
description: >
  This skill should be used when implementing any UI component from a Figma design,
  building a Flutter widget, setting up theming, or working with colours, typography,
  spacing, or visual design. Triggers on: "implement the design", "Figma", "match the design",
  "design tokens", "theme", "color", "colour", "typography", "spacing", "font size",
  "padding", "border radius", "component library", "design system", "widget naming",
  "dark mode", "Material 3", "ThemeData", "ColorScheme", "TextTheme", "AppBar styling",
  "match the mockup", "pixel perfect", "UI design", or when a Figma link is shared.
version: 1.0.0
allowed-tools: [Read, Write, Glob]
---

# Design to Code Contract Skill

## The Law
**Figma design tokens are the single source of truth for the Flutter theme.**
The OpenAPI spec is the contract for data. Figma is the contract for UI.
Neither is overridden by developer preference.

```
Figma Design Tokens          Flutter Code
──────────────────────────────────────────────────────
Colour palette        →      ColorScheme (AppColors)
Typography scale      →      TextTheme (AppTypography)
Spacing grid          →      AppSpacing constants
Border radius values  →      AppRadius constants
Elevation levels      →      AppElevation constants
Component names       →      Widget class names
```

**Never** hardcode `Color(0xFF...)`, `FontSize: 16`, `SizedBox(height: 24)` inline.
**Always** reference a named token.

---

## Phase 1 — Extract Design Tokens from Figma

Before writing any widget code, extract the design tokens from the Figma file.
Ask the designer to export them, or extract manually from Figma's design panel.

### Colours
```dart
// core/theme/app_colors.dart
// Token names MUST match Figma layer names exactly
// Designer names: "Primary/500" → code: primary500
abstract class AppColors {
  // Primary palette (from Figma Colours page)
  static const Color primary900 = Color(0xFF1A237E);
  static const Color primary700 = Color(0xFF303F9F);
  static const Color primary500 = Color(0xFF3F51B5);   // primary brand colour
  static const Color primary300 = Color(0xFF7986CB);
  static const Color primary100 = Color(0xFFC5CAE9);

  // Semantic colours (from Figma)
  static const Color success    = Color(0xFF4CAF50);
  static const Color warning    = Color(0xFFFFC107);
  static const Color error      = Color(0xFFF44336);
  static const Color info       = Color(0xFF2196F3);

  // Neutral palette
  static const Color grey900    = Color(0xFF212121);
  static const Color grey700    = Color(0xFF616161);
  static const Color grey400    = Color(0xFFBDBDBD);
  static const Color grey100    = Color(0xFFF5F5F5);
  static const Color white      = Color(0xFFFFFFFF);

  // Background tokens
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color surfaceDark  = Color(0xFF121212);
}
```

### Typography
```dart
// core/theme/app_typography.dart
// Font sizes MUST match Figma type scale exactly
abstract class AppTypography {
  static const String fontFamily = 'Inter';   // from Figma font

  // Display (Hero text — landing screens only)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily, fontSize: 57, fontWeight: FontWeight.w400, height: 1.12, letterSpacing: -0.25);
  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily, fontSize: 45, fontWeight: FontWeight.w400, height: 1.16);

  // Headline (screen titles)
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily, fontSize: 32, fontWeight: FontWeight.w400, height: 1.25);
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily, fontSize: 28, fontWeight: FontWeight.w400, height: 1.29);
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily, fontSize: 24, fontWeight: FontWeight.w400, height: 1.33);

  // Title (card titles, section headers)
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily, fontSize: 22, fontWeight: FontWeight.w500, height: 1.27);
  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w500, height: 1.50, letterSpacing: 0.15);
  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w500, height: 1.43, letterSpacing: 0.10);

  // Body (main content text)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w400, height: 1.50, letterSpacing: 0.50);
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w400, height: 1.43, letterSpacing: 0.25);
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.w400, height: 1.33, letterSpacing: 0.40);

  // Label (buttons, chips, inputs)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w500, height: 1.43, letterSpacing: 0.10);
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.w500, height: 1.33, letterSpacing: 0.50);
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily, fontSize: 11, fontWeight: FontWeight.w500, height: 1.45, letterSpacing: 0.50);
}
```

### Spacing
```dart
// core/theme/app_spacing.dart
// Spacing grid MUST match Figma spacing grid (usually 4pt or 8pt base)
abstract class AppSpacing {
  static const double xxs = 4.0;    // Figma: "Spacing/XXS"
  static const double xs  = 8.0;    // Figma: "Spacing/XS"
  static const double sm  = 12.0;   // Figma: "Spacing/SM"
  static const double md  = 16.0;   // Figma: "Spacing/MD" ← most common padding
  static const double lg  = 24.0;   // Figma: "Spacing/LG"
  static const double xl  = 32.0;   // Figma: "Spacing/XL"
  static const double xxl = 48.0;   // Figma: "Spacing/XXL"
  static const double xxxl = 64.0;  // Figma: "Spacing/XXXL"
}

abstract class AppRadius {
  static const double none    = 0.0;
  static const double xs      = 4.0;    // Figma: "Radius/XS"
  static const double sm      = 8.0;    // Figma: "Radius/SM"
  static const double md      = 12.0;   // Figma: "Radius/MD"
  static const double lg      = 16.0;   // Figma: "Radius/LG"
  static const double xl      = 24.0;   // Figma: "Radius/XL"
  static const double full    = 999.0;  // fully rounded (pills, chips)
}
```

---

## Phase 2 — Build ThemeData from Tokens

```dart
// core/theme/app_theme.dart
// ThemeData is assembled ONCE from tokens — never override inline
class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: AppTypography.fontFamily,
    colorScheme: const ColorScheme.light(
      primary:       AppColors.primary500,
      onPrimary:     AppColors.white,
      primaryContainer: AppColors.primary100,
      secondary:     AppColors.primary300,
      surface:       AppColors.surfaceLight,
      error:         AppColors.error,
    ),
    textTheme: const TextTheme(
      displayLarge:  AppTypography.displayLarge,
      displayMedium: AppTypography.displayMedium,
      headlineLarge: AppTypography.headlineLarge,
      headlineMedium:AppTypography.headlineMedium,
      headlineSmall: AppTypography.headlineSmall,
      titleLarge:    AppTypography.titleLarge,
      titleMedium:   AppTypography.titleMedium,
      titleSmall:    AppTypography.titleSmall,
      bodyLarge:     AppTypography.bodyLarge,
      bodyMedium:    AppTypography.bodyMedium,
      bodySmall:     AppTypography.bodySmall,
      labelLarge:    AppTypography.labelLarge,
      labelMedium:   AppTypography.labelMedium,
      labelSmall:    AppTypography.labelSmall,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),    // Figma button height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm)),
        textStyle: AppTypography.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md, vertical: AppSpacing.sm),
    ),
  );

  static ThemeData get dark => light.copyWith(
    colorScheme: const ColorScheme.dark(
      primary:    AppColors.primary300,
      onPrimary:  AppColors.primary900,
      surface:    AppColors.surfaceDark,
      error:      AppColors.error,
    ),
  );
}
```

---

## Phase 3 — Widget Naming Contract

Widget names in Dart must mirror Figma component names exactly.
This creates a navigable map between design and code.

```
Figma Component Name    →    Flutter Widget Class
────────────────────────────────────────────────────────
"OrderSummaryCard"      →    OrderSummaryCard
"PrimaryButton"         →    AppPrimaryButton
"OrderLineItem"         →    OrderLineItem
"PriceDisplay"          →    PriceDisplay
"StatusBadge"           →    StatusBadge
"EmptyStateView"        →    EmptyStateView
"LoadingSkeletonCard"   →    LoadingSkeletonCard
```

```dart
// Every widget that maps to a Figma component gets a named key for testing
class OrderSummaryCard extends StatelessWidget {
  final Order order;
  const OrderSummaryCard({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      key: const Key('order-summary-card'),   // testable by key
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),  // ← token, not magic number
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #${order.id.substring(0, 8)}',
              style: theme.textTheme.titleMedium,    // ← theme, not inline style
            ),
            const SizedBox(height: AppSpacing.xs),  // ← token, not SizedBox(height: 8)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusBadge(status: order.status),
                PriceDisplay(amount: order.total),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Phase 4 — Responsive Layout

```dart
// core/theme/app_breakpoints.dart
abstract class AppBreakpoints {
  static const double mobile  = 600;   // < 600 → mobile layout
  static const double tablet  = 900;   // 600-900 → tablet layout
  static const double desktop = 1200;  // > 900 → desktop layout
}

// Use in widgets
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;

  const ResponsiveLayout({required this.mobile, this.tablet, super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= AppBreakpoints.tablet && tablet != null) return tablet!;
    return mobile;
  }
}
```

---

## Anti-Patterns Table

| Anti-Pattern | Why It Breaks the Contract | Fix |
|--------------|---------------------------|-----|
| `Color(0xFF3F51B5)` inline | Magic number — breaks if brand colour changes | `AppColors.primary500` |
| `fontSize: 16` inline | Breaks type scale | `theme.textTheme.bodyLarge` |
| `SizedBox(height: 24)` inline | Magic spacing | `SizedBox(height: AppSpacing.lg)` |
| Widget named `MyCard` | Doesn't map to Figma | Match Figma: `OrderSummaryCard` |
| Overriding ThemeData inline | Bypasses design system | Update `app_theme.dart` |
| Different widget per screen for same component | Inconsistency | Extract to `widgets/` as shared component |
| Hardcoded `'Place Order'` string | Breaks l10n | `context.l10n.placeOrderButton` |

---

## Design Review Checklist — Before Merging

- [ ] All colours reference `AppColors.*` — zero `Color(0xFF...)` inline
- [ ] All typography references `theme.textTheme.*` — zero inline `fontSize`
- [ ] All spacing references `AppSpacing.*` or `AppRadius.*` — zero magic numbers
- [ ] Widget names match Figma component names exactly
- [ ] All shared components are in `core/widgets/` or `features/<x>/presentation/widgets/`
- [ ] All localised strings are in `l10n/*.arb` — zero hardcoded English strings
- [ ] Responsive layout implemented (mobile + tablet breakpoints)
- [ ] Dark mode tested (`ThemeMode.dark` renders correctly)
- [ ] Golden tests created/updated to capture the approved design
- [ ] Figma annotation on each Figma frame: "Implemented ✅" with PR link
