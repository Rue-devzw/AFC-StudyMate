# Production Preflight Checklist

Use this checklist before submitting Android and iPhone builds.

## Product and policy

- Package id / bundle id confirmed as `org.afmsear.studymate`
- App name confirmed as `AFM SEAR StudyMate`
- Privacy policy page is live:
  `https://afc-studymate.web.app/privacy-policy.html`
- Acknowledgements, church contact details, and support details reviewed
- Licensing reviewed, including any commercial dependency obligations

## Real-device QA

- Android tested on at least one real phone
- iPhone tested on at least one real device
- Onboarding completes correctly
- Today screen loads correctly
- Sunday School lessons open correctly
- Discovery content opens and saves reflections correctly
- Bible notes, bookmarks, and verse tools work correctly
- Journal create, edit, and delete work correctly
- Reminder permissions and scheduling work correctly
- Appearance presets and per-screen backgrounds remain readable
- Large text and screen-reader pass completed

## Google account and backup

- Google Sign-In works on Android release config
- Google Sign-In works on iPhone release config
- Backup Now uploads to Google Drive app data folder
- Restore from Google Drive correctly restores app data
- Sign out returns the app to local-only mode without breaking the UI

## Build verification

- `flutter analyze`
- `flutter test`
- Android release APK built successfully
- Android release AAB built successfully
- iPhone archive built successfully in Xcode

## Store readiness

- Android signing keystore configured
- Apple signing/team configured
- Screenshots prepared for Android and iPhone
- Store descriptions and version notes prepared
- Target audience and rating answers completed
- App privacy / data safety answers match actual app behavior

## Final go/no-go

- No known crash in critical flows
- No unreadable text on customized themes
- No placeholder branding or package identifiers remain
- Pilot rollout approved before full public release
