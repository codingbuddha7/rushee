---
name: mobile-security-by-design
description: >
  This skill should be used when implementing any authentication, token storage,
  API call, user data handling, or sensitive screen in Flutter. Triggers on:
  "store token", "JWT", "SharedPreferences", "secure storage", "login screen",
  "biometric", "certificate pinning", "ssl pinning", "offline", "keychain",
  "keystore", "OWASP Mobile", "auth token", "refresh token", "logout",
  "sensitive data", "payment screen", "screenshot", "background app",
  "deeplink", "firebase", "crashlytics", "analytics", "privacy",
  or any Flutter screen that handles personal or financial data.
version: 1.0.0
allowed-tools: [Read, Write, Glob]
---

# Mobile Security by Design Skill

## OWASP Mobile Top 10 — Flutter Checklist

This skill covers M1-M10 of the OWASP Mobile Application Security Verification Standard.
It complements `security-by-design` (which covers the Spring Boot backend).

---

## M1 — Improper Credential Usage

### Never SharedPreferences for Tokens
```dart
// ❌ CRITICAL VULNERABILITY — SharedPreferences is plain text on disk
final prefs = await SharedPreferences.getInstance();
prefs.setString('access_token', token);     // readable by any app with root access

// ✅ CORRECT — flutter_secure_storage uses Keychain (iOS) / Keystore (Android)
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
  );

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  static Future<String?> getAccessToken() =>
      _storage.read(key: 'access_token');

  static Future<void> clearAll() => _storage.deleteAll();  // on logout
}
```

### Token Refresh Interceptor
```dart
// core/network/auth_interceptor.dart
class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio _dio;
  bool _isRefreshing = false;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final newToken = await _refreshToken();
        await _tokenStorage.saveTokens(accessToken: newToken.accessToken,
            refreshToken: newToken.refreshToken);
        // Retry original request with new token
        err.requestOptions.headers['Authorization'] = 'Bearer ${newToken.accessToken}';
        final response = await _dio.fetch(err.requestOptions);
        handler.resolve(response);
      } catch (e) {
        await _tokenStorage.clearAll();
        // Navigate to login — emit auth failure event
        handler.reject(err);
      } finally {
        _isRefreshing = false;
      }
    } else {
      handler.next(err);
    }
  }
}
```

---

## M2 — Inadequate Supply Chain Security

```yaml
# pubspec.yaml — lock dependency versions exactly
# Never use ^ for security-critical packages
dependencies:
  flutter_secure_storage: 9.0.0      # exact version, not ^9.0.0
  local_auth: 2.1.8
  dio: 5.3.2

# Audit dependencies regularly
# Run: flutter pub outdated
# Run: dart pub audit (checks for known vulnerabilities)
```

---

## M3 — Insecure Authentication

### Biometric Re-authentication for Sensitive Actions
```dart
// Require biometric before showing payment, profile, or sensitive data
import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticateForSensitiveAction(String reason) async {
    final canAuthenticate = await _auth.canCheckBiometrics ||
        await _auth.isDeviceSupported();

    if (!canAuthenticate) return false;   // fall back to PIN/password

    return await _auth.authenticate(
      localizedReason: reason,
      options: const AuthenticationOptions(
        biometricOnly: false,             // allow PIN as fallback
        stickyAuth: true,
        useErrorDialogs: true,
      ),
    );
  }
}

// Use before showing sensitive screen
class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: BiometricAuthService().authenticateForSensitiveAction(
          'Confirm your identity to view payment details'),
      builder: (context, snapshot) {
        if (snapshot.data == true) return const _PaymentContent();
        if (snapshot.data == false) return const _AuthFailedView();
        return const _LoadingView();
      },
    );
  }
}
```

---

## M4 — Insufficient Input/Output Validation

```dart
// Validate on the Flutter side too — defence in depth
// Backend validates, but mobile validation provides faster feedback

class PlaceOrderValidator {
  static ValidationResult validate(PlaceOrderParams params) {
    final errors = <String>[];

    if (params.customerId.isEmpty) {
      errors.add('Customer ID is required');
    }
    if (params.lines.isEmpty) {
      errors.add('Cart cannot be empty');
    }
    if (params.lines.any((l) => l.quantity <= 0)) {
      errors.add('All quantities must be greater than zero');
    }

    return errors.isEmpty
        ? ValidationResult.valid()
        : ValidationResult.invalid(errors);
  }
}

// In BLoC — validate before calling use case
Future<void> _onPlaceOrderRequested(
    PlaceOrderRequested event, Emitter<OrderState> emit) async {
  final validation = PlaceOrderValidator.validate(event.params);
  if (!validation.isValid) {
    emit(OrderValidationError(validation.errors));
    return;
  }
  // proceed with use case call
}
```

---

## M5 — Insecure Communication

### Certificate Pinning
```dart
// core/network/api_client.dart — certificate pinning for production
import 'dart:io';
import 'package:dio/dio.dart';

Dio buildSecureDio(String baseUrl, {bool enablePinning = true}) {
  final dio = Dio(BaseOptions(baseUrl: baseUrl));

  if (enablePinning && !kDebugMode) {
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => false; // reject bad certs

      // Pin to specific certificate fingerprint
      // Get fingerprint: openssl s_client -connect api.yourapp.com:443 | openssl x509 -fingerprint -sha256
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        const pinnedFingerprint = 'AA:BB:CC:DD:...';  // from your cert
        final certFingerprint = cert.der.map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join(':').toUpperCase();
        return certFingerprint != pinnedFingerprint;   // reject if not matching
      };
      return client;
    };
  }

  return dio;
}
```

### Network Security Config (Android)
```xml
<!-- android/app/src/main/res/xml/network_security_config.xml -->
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
  <!-- Disallow cleartext (HTTP) in production -->
  <base-config cleartextTrafficPermitted="false">
    <trust-anchors>
      <certificates src="system" />
    </trust-anchors>
  </base-config>

  <!-- Allow cleartext only in debug for local dev -->
  <debug-overrides>
    <trust-anchors>
      <certificates src="system" />
      <certificates src="user" />
    </trust-anchors>
  </debug-overrides>
</network-security-config>
```

---

## M6 — Inadequate Privacy Controls

### Prevent Screenshots on Sensitive Screens
```dart
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class PaymentScreen extends StatefulWidget {
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    // Disable screenshots when entering sensitive screen
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void dispose() {
    // Re-enable when leaving
    FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    super.dispose();
  }
}
```

### Hide Content in App Switcher
```dart
// In AppLifecycleObserver — hide sensitive content when app goes to background
class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      // Show blur overlay to hide content in app switcher
      _overlayController.show();
    } else if (state == AppLifecycleState.resumed) {
      _overlayController.hide();
    }
  }
}
```

### No PII in Logs or Crash Reports
```dart
// ❌ NEVER log PII
debugPrint('User logged in: ${user.email} password: ${user.password}');

// ❌ NEVER send PII to Crashlytics
FirebaseCrashlytics.instance.setUserIdentifier(user.email);  // PII

// ✅ Use opaque identifiers
FirebaseCrashlytics.instance.setUserIdentifier(user.id);     // not PII

// ✅ Filter sensitive fields from error reports
class SanitisedLogger {
  static void logError(Object error, StackTrace stack, {Map<String, dynamic>? context}) {
    final sanitised = context?.map((k, v) =>
        MapEntry(k, _sensitiveKeys.contains(k) ? '[REDACTED]' : v));
    FirebaseCrashlytics.instance.recordError(error, stack, information: [sanitised]);
  }

  static const _sensitiveKeys = {'email', 'password', 'phone', 'cardNumber', 'token'};
}
```

---

## M7 — Insufficient Binary Protections

```yaml
# android/app/build.gradle — enable ProGuard/R8 in release
android {
  buildTypes {
    release {
      minifyEnabled true          # code shrinking
      shrinkResources true        # resource shrinking
      proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'),
                   'proguard-rules.pro'
    }
  }
}
```

---

## M8 — Security Misconfiguration

```dart
// Never commit api keys or base URLs — use --dart-define or .env
// ❌ Wrong
const apiBaseUrl = 'https://api.prod.yourapp.com';
const stripeKey = 'sk_live_XXXXXXXXXX';

// ✅ Correct — injected at build time
const apiBaseUrl = String.fromEnvironment('API_BASE_URL',
    defaultValue: 'http://localhost:8080');
const stripePublishableKey = String.fromEnvironment('STRIPE_KEY', defaultValue: '');

// Build command:
// flutter build apk --dart-define=API_BASE_URL=https://api.prod.yourapp.com
//                   --dart-define=STRIPE_KEY=pk_live_XXXXX
```

---

## Mobile Security Checklist — Pre-Merge Gate

### Authentication & Storage
- [ ] All tokens stored in `flutter_secure_storage` — zero use of `SharedPreferences` for tokens
- [ ] Token refresh interceptor implemented
- [ ] Logout clears ALL stored credentials (`_storage.deleteAll()`)
- [ ] Biometric auth required for: payment screens, profile edit, account deletion

### Communication
- [ ] Certificate pinning enabled in production build
- [ ] HTTP cleartext disabled in `network_security_config.xml` (Android)
- [ ] `NSAppTransportSecurity` configured (iOS `Info.plist`)
- [ ] All API calls use HTTPS — no HTTP in production

### Privacy & Data
- [ ] Payment, profile, and PII screens have `FLAG_SECURE` (no screenshots)
- [ ] App switcher overlay implemented (hides sensitive content)
- [ ] No PII in logs, Crashlytics, or analytics events
- [ ] User ID in crash reports is opaque (not email/phone)

### Build
- [ ] ProGuard/R8 enabled in release build (Android)
- [ ] No API keys or base URLs hardcoded — all from `--dart-define`
- [ ] `flutter build` with `--obfuscate --split-debug-info` for release

### Dependencies
- [ ] `flutter pub audit` shows zero high/critical vulnerabilities
- [ ] Security-critical package versions are pinned exactly (no `^`)
