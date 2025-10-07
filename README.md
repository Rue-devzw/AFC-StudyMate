# AFC StudyMate

AFC StudyMate is an offline-first Flutter application designed to support Apostolic Faith Church Sunday School learners across Beginners, Primary Pals, Answer, Search, Discovery, and Daybreak tracks. The app bundles curriculum content and Scripture locally, providing a gentle British English interface with accessible, large-tap experiences.

## Getting started

1. Install [Flutter](https://flutter.dev/docs/get-started/install) (latest stable) and Dart 3.x.
2. Run `flutter pub get`.
3. Copy curriculum assets into place (already provided in `assets/data/` and `assets/db/`).
4. Launch with `flutter run --dart-define=USE_FIREBASE=false` to disable Firebase during local development.

> **Platform shells**
>
> The `android/`, `ios/`, `windows/`, and other platform folders are not checked in to keep the repository lean. Before running
> the app on a specific platform, generate the platform scaffolding once per machine:
>
> ```sh
> flutter create . --platforms=windows,android,ios,macos,linux,web
> ```
>
> This command is idempotent—it will only create the missing platform directories and leave your Dart code untouched. After the
> scaffolding is in place, `flutter run` will detect the relevant devices (for example `-d windows`) and start the app normally.

## Firebase configuration

Firebase is optional in debug. Create `lib/firebase_options.dart` via `flutterfire configure` for production builds. The following services are expected:

- Authentication (anonymous, email/password, optional phone)
- Cloud Firestore
- Cloud Storage
- Cloud Messaging
- Analytics

Set platform configuration files (`google-services.json`, `GoogleService-Info.plist`) under the respective `android/` and `ios/` directories when ready.

## Testing

Run all automated checks:

```sh
flutter analyze
flutter test
```

Golden tests use `golden_toolkit` and render a single lesson screen snapshot; CI is configured to execute them headlessly.

## Offline data

The app ships with JSON lesson bundles and SQLite Bibles (KJV, Shona). On first run, the import pipeline seeds lessons into the local store. Bible lookups use read-only database assets.

## Directory structure

```
lib/
  app_router.dart
  data/
    drift/
    models/
    repositories/
    services/
  features/
    onboarding/
    today/
    sunday_school/
    discovery/
    daybreak/
    bible/
    profile/
    settings/
  theme/
  widgets/
```

## Continuous integration

A GitHub Actions workflow (see `.github/workflows/ci.yml`) runs analysis, unit/widget/golden tests, and produces Android/iOS build artefacts (unsigned). Adjust signing as required for release builds.

## Accessibility

- Material 3 with large tappable controls
- Dynamic type up to 200%
- VoiceOver/TalkBack friendly labels and copy
- Offline-first to reduce cognitive load from loading spinners

## Licence

Proprietary © Apostolic Faith Church. All rights reserved.
