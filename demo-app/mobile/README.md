# Quick Notes (Flutter)

Flutter app for the Rushee demo. Connects to the notes backend at `http://localhost:8080`.

## "No supported devices connected" / "macOS or web not supported"

This project was set up manually and **does not have platform folders** (macos/, web/, ios/, android/) until you generate them. Run:

```bash
cd demo-app/mobile
flutter create . --platforms=macos,web
```

That adds support for **macOS** and **Chrome (web)**. Then:

```bash
flutter pub get
flutter run
```

Pick the device when prompted (e.g. `macos` or `chrome`).

To enable iOS/Android as well, run instead:

```bash
flutter create .
```

Then run on a simulator/emulator or a connected device.

## Run with backend

1. Start the backend: `cd ../backend && mvn spring-boot:run`
2. Run Flutter: `flutter run` (choose macos or chrome if you have no phone connected).
