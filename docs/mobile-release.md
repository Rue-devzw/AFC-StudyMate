# Mobile Release Setup

This project is currently prepared for Android and iPhone releases.

Core production identifiers:

- Android application id: `org.afmsear.studymate`
- iPhone bundle id: `org.afmsear.studymate`
- Privacy policy URL: `https://afc-studymate.web.app/privacy-policy.html`
- Version manifest URL: `https://afc-studymate.web.app/app-version.json`
- Release page URL: `https://afc-studymate.web.app/app-updates.html`

## Versioning

The first public StudyMate release is `Version 1`, represented in Flutter as:

- `version: 1.0.0+1`

For every future release:

1. Update `version` in `pubspec.yaml`
2. Update `public/app-version.json`
3. Update `public/app-updates.html`
4. Deploy Hosting so in-app update checks see the latest published version

Version meaning:

- `1.0.0` = user-facing app version
- `+1` = build number used for store and in-app update comparison

## Android

1. Copy `keystore.properties.example` to `keystore.properties` at the project root.
2. Replace the placeholder values with the real release keystore details.
3. Place the keystore file at the path referenced by `storeFile`.
4. Build a release artifact:

```sh
flutter build appbundle --release --dart-define=USE_FIREBASE=false
```

Notes:

- If `keystore.properties` is missing, the Gradle config falls back to debug signing so local release-style builds still work.
- Before Play Store submission, confirm the final package id remains `org.afmsear.studymate`.
- Confirm Google Sign-In works with the release SHA fingerprints registered in Google Cloud / Firebase.
- For the Play Console flow, see [android-play-release.md](android-play-release.md).

## iPhone

1. Open the iOS project in Xcode on macOS.
2. Confirm the bundle identifier is `org.afmsear.studymate`.
3. Set the correct Apple Developer team for the `Runner` target.
4. Confirm automatic signing is enabled and a valid provisioning profile is selected.
5. Verify Google Sign-In returns to the app correctly using the URL scheme already added in `Info.plist`.
4. Archive from Xcode or run:

```sh
flutter build ipa --dart-define=USE_FIREBASE=false
```

Notes:

- The local environment must have the required iOS platform runtime installed in Xcode.
- Optional cloud backup uses the signed-in user's Google Drive app data folder.
- For the TestFlight/App Store flow, see [ios-testflight-release.md](ios-testflight-release.md).

## Release Checklist

- `flutter analyze`
- `flutter test`
- Android debug build passes
- Android release build passes
- Google Drive sign-in and backup/restore verified on real devices
- Android release signing configured
- Xcode signing configured
- Privacy and license text reviewed
- Store metadata and screenshots prepared
- Accessibility pass completed
- Final preflight checklist completed in [production-checklist.md](production-checklist.md)
