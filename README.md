# AFC StudyMate

AFC StudyMate is a Flutter application for distributing Bible lessons and
scripture resources for offline-first use in African faith communities.

## Getting started

1. Install the Flutter SDK (3.13 or newer recommended) and set up your local
   development environment following the [official installation guide](https://docs.flutter.dev/get-started/install).
2. Fetch dependencies:

   ```bash
   flutter pub get
   ```
3. (Optional) Run the analyzer and test suites:

   ```bash
   flutter analyze
   flutter test
   ```

4. Configure Firebase for cloud authentication and storage:

   - Create a Firebase project and add Android, iOS, and Web apps using the
     package/bundle identifiers `org.afc.studymate`.
   - Replace the placeholder values in `lib/firebase_options.dart` with the
     generated credentials or run `flutterfire configure` and copy the output.
   - Download the platform config files, rename them to `google-services.json`
     (Android) and `GoogleService-Info.plist` (iOS), and place them alongside
     the provided `.example` templates in `android/app/` and `ios/Runner/`.
   - Enable Email/Password, Google, and Apple providers in Firebase Auth and
     supply the corresponding OAuth client IDs for the web meta tags in
     `web/index.html`.

## Bundled Bible assets

The app expects bundled Bible translations (SQLite databases plus JSON manifests)
to be present under `assets/bibles/`. The JSON manifests are stored in Git, but
the `.db` bundles are binary files and therefore are not committed from this
Codex environment. Before running the app locally or building a release, add the
bundles manually:

1. Obtain the licensed SQLite bundles for the following translations:
   - `assets/bibles/kjv.db`
   - `assets/bibles/shona_bible.db`
   - `assets/bibles/amp.db`
   - `assets/bibles/ndebele.db`
   - `assets/bibles/por.db`
2. Place them alongside their corresponding `.json` manifests in
   `assets/bibles/`.
3. (Optional) Track the `.db` files with [Git LFS](https://git-lfs.com/) if you
   are committing from a local machine so that future updates do not bloat the
   repository (the files are ignored by default in this repo, so use `git add -f`
   when staging them):

   ```bash
   git lfs install
   git lfs track "assets/bibles/*.db"
   git add .gitattributes
   git add -f assets/bibles/*.db
   ```

4. Run `flutter pub get` (or just rebuild the app) after copying the bundles so
   Flutter regenerates its `AssetManifest.json` with the new assets.

These steps ensure that all bundled translations are available on first run
without requiring runtime downloads.

## Project structure highlights

- `lib/src/domain` – Domain entities and use cases.
- `lib/src/data` – Repository implementations backed by local storage.
- `lib/src/infrastructure` – Drift database definition and asset bundle loaders.
- `lib/src/presentation` – Flutter widgets and Riverpod providers.

For additional architectural notes, see [`blueprint.md`](blueprint.md).
