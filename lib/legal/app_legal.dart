const String appPrivacyPolicyUrl =
    'https://afc-studymate.web.app/privacy-policy.html';
const String appVersionManifestUrl =
    'https://afc-studymate.web.app/app-version.json';
const String appReleaseNotesUrl =
    'https://afc-studymate.web.app/app-updates.html';

const String appAcknowledgementsMarkdown = '''
# Developer Acknowledgement

AFM SEAR StudyMate was created and developed by **Strivemore R. Tapera** of **S-Tech Solutions** for the **AFM SEAR Media Team** and **Sunday School Team**.

## Developer

- Strivemore R. Tapera
- S-Tech Solutions
- Email: strivebernards@gmail.com
- Phone: +263718704505
- Website: www.s-techsolutions.org

## Official Church Contact

- Apostolic Faith Mission Southern and Eastern Africa
- Stand 10466, Lusaka, Highfields
- Harare, Zimbabwe
- Phone: +263 242 885 654
- Website: www.apostolicfaithsear.org

## Contributors and Support

This work was completed with the help of:

- Joseph Jaravani
- Caleb Bosha
- Tinevimbo S. Maidza
- S.B Chitanda
''';

const String appPrivacyMarkdown = '''
# Privacy & Data

StudyMate is designed to work offline first on Android and iPhone.

## What StudyMate stores on your device

- your profile and class preferences
- lesson progress and completion history
- journal entries, verse notes, bookmarks, and memory verse progress
- class roster and attendance records for teacher tools
- reminder preferences

## Notifications

StudyMate only requests notification permission when you enable reminders.

## Cloud features

This mobile release runs in local-first mode by default. Realtime cloud sync is not part of this release. If Google Drive backup is enabled in the app, your backup file is stored in your own Google Drive app data space after you sign in with Google.

## Analytics

In local-first builds, StudyMate does not send analytics events to remote services.

## Sharing

When you use share actions, the content you choose is passed to the app or service you select.

## Third-party libraries

StudyMate uses open source and commercial software components. Third-party license notices are available from the licenses screen inside Settings.

## Support

For questions about ministry content, data handling, or support, you may contact:

- Apostolic Faith Mission Southern and Eastern Africa
- Stand 10466, Lusaka, Highfields
- Harare, Zimbabwe
- Phone: +263 242 885 654
- Website: www.apostolicfaithsear.org

You may also contact the developer for technical assistance:

- Strivemore R. Tapera
- S-Tech Solutions
- Email: strivebernards@gmail.com
- Phone: +263718704505
''';

const String appReleaseScopeMarkdown = '''
# Mobile Release Scope

This release is prepared for Android and iPhone.

## Included in this release

- offline lesson content
- Sunday School tracks
- Discovery and Daybreak reading flows
- Bible reading, notes, bookmarks, and journal tools
- local reminder scheduling
- optional Google Drive backup to the signed-in user's Drive app data folder

## Not included in this release scope

- public web release
- realtime account-backed cloud sync
- store-ready desktop distribution

The production cloud path for this mobile release is user-owned Google Drive backup rather than Firestore or Firebase Storage.
''';
