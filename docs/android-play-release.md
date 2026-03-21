# Android Play Release

This document covers the Android-specific release path for `org.afmsear.studymate`.

## Before building

- Create `keystore.properties` from `keystore.properties.example`
- Place the release keystore at the configured path
- Or use `scripts/android_release.sh create-keystore` to generate one locally
- Confirm the Play Console app uses package id `org.afmsear.studymate`
- Confirm the app version in `pubspec.yaml`
- Confirm `public/app-version.json` matches the same release version and build
- Confirm `public/app-updates.html` reflects the same release notes
- Confirm the privacy policy URL is live:
  `https://afc-studymate.web.app/privacy-policy.html`
- Confirm Google Sign-In works with the Android release SHA fingerprints

## Build commands

Validate signing first:

```sh
scripts/android_release.sh validate
```

Debug verification:

```sh
flutter build apk --debug --dart-define=USE_FIREBASE=false
```

Release app bundle:

```sh
scripts/android_release.sh build-appbundle
```

Release APK for manual validation:

```sh
scripts/android_release.sh build-apk
```

## Output locations

- `build/app/outputs/bundle/release/app-release.aab`
- `build/app/outputs/apk/release/app-release.apk`

## Play Console checklist

- App signing configured
- Privacy policy URL added
- Target audience and content ratings completed
- Data safety answers aligned with `PRIVACY.md`
- Screenshots and store listing copy uploaded
- Version notes prepared
- Hosting updated so in-app version checks point to the current release
- Internal testing track created first
- Mention that backup uses the signed-in user's Google Drive app data folder

## Android-specific notes

- The manifest disables automatic device backup because the app stores personal study data locally.
- Cleartext traffic is disabled.
- Notifications require runtime permission on supported Android versions.
- User backup data is not stored in Firestore or Firebase Storage.
- Release signing falls back to debug only when no keystore is configured, which is acceptable for local validation but not for Play Store submission.
