# iPhone TestFlight Release

This document covers the iPhone-specific release path for `org.afmsear.studymate`.

## Before building

- Confirm the `Runner` target bundle id is `org.afmsear.studymate`
- Sign in to Xcode with the correct Apple Developer account
- Set the correct Apple Developer team on the `Runner` target
- Keep `CODE_SIGN_STYLE = Automatic`
- Confirm the app version in `pubspec.yaml`
- Confirm `public/app-version.json` matches the same release version and build
- Confirm `public/app-updates.html` reflects the same release notes
- Confirm the privacy policy URL is ready:
  `https://afc-studymate.web.app/privacy-policy.html`
- Confirm Google Sign-In works for the iOS client in Firebase / Google Cloud

## Capabilities and config checks

- `GoogleService-Info.plist` is present in `ios/Runner`
- `CFBundleURLTypes` contains the reversed Google client id in `ios/Runner/Info.plist`
- If push notifications are part of this release, add the required Apple capabilities and APNs setup in Xcode and Firebase

## Build commands

Debug verification:

```sh
flutter build ios --debug --no-codesign
```

Release-style local archive preparation:

```sh
flutter build ios --release --no-codesign
```

IPA build when signing is configured:

```sh
flutter build ipa --release --dart-define=USE_FIREBASE=false
```

## Xcode archive flow

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select the `Runner` scheme and a generic iPhone device.
3. Go to `Product` -> `Archive`.
4. In Organizer, validate the archive.
5. Upload to TestFlight.

## TestFlight checklist

- App icon and display name are correct
- Privacy policy URL added in App Store Connect
- App Privacy answers align with `PRIVACY.md`
- Test notes mention Google Drive backup behavior
- Hosting updated so in-app version checks point to the current release
- Internal TestFlight group created first
- Google sign-in and Drive backup tested on a real iPhone before external testing

## iPhone-specific notes

- This release is Android + iPhone only.
- User backup data is stored in the signed-in user's Google Drive app data folder.
- Realtime cloud sync is not part of this release.
