# AFC Study Mate – Merged Blueprint (v1.0)

## 1) Purpose & Scope

AFC Study Mate is a production‑ready, offline‑first Flutter app enabling Sunday School and Bible study across ages (2 to adult). It supports offline Scripture reading, lessons, and progress tracking, with optional cloud sync, collaboration, moderated chat, and conferencing. This blueprint merges the existing AFC StudyMate plan with expanded requirements for a secure, performant, accessible, and age‑tailored experience.

---

## 2) Function Comparison & Merge (Completed vs Outstanding)

**Legend:** ✅ Completed (in existing app), 🟡 Partially, 🔴 Not yet.

| Capability                                                       | Existing Blueprint Status         | Requirement (This Spec)                                                    | Gap / Action                                                          | Target Milestone |
| ---------------------------------------------------------------- | --------------------------------- | -------------------------------------------------------------------------- | --------------------------------------------------------------------- | ---------------- |
| Bible reader (navigate by book/chapter; continue reading)        | ✅ Implemented                     | Keep                                                                       | None                                                                  | MVP              |
| Built‑in translations (KJV, AMP, Ndebele, Shona, Portuguese)     | 🔴 Only general “versions”        | Must ship 5 translations                                                   | Package and embed 5 bundles; verify licensing; size optimise          | MVP/v1           |
| Import additional translations (.zip of JSON/SQLite)             | 🔴                                | Must                                                                       | Implement import + validation + indexing                              | MVP              |
| Local full‑text search (FTS)                                     | 🔴                                | Must                                                                       | Drift FTS5 virtual tables; per‑translation indexes                    | MVP              |
| Parallel view (2+ translations)                                  | 🔴                                | Must                                                                       | Reader UI with side‑by‑side columns                                   | MVP              |
| Verse bookmarks/highlights/notes                                 | 🔴                                | Must                                                                       | Local storage + optional sync + version history (notes)               | MVP              |
| Offline audio playback (if audio provided)                       | 🔴                                | Optional                                                                   | Media cache + background audio                                        | v1               |
| Sunday School lessons (list, filter, detail, mark complete)      | 🟡 Basic list/detail & completion | Must include classes, offline caching, attachments, teacher notes, quizzes | Expand lesson model, renderer and cache                               | MVP/v1           |
| Lesson sources (preloaded + online URLs with offline cache)      | 🔴                                | Must                                                                       | Background fetcher + integrity checks                                 | MVP              |
| Progress tracking (status, score, time spent)                    | 🔴                                | Must                                                                       | Local metrics + sync                                                  | MVP              |
| Accounts: local‑only mode                                        | 🔴                                | Must                                                                       | Device‑scoped profile                                                 | MVP              |
| Cloud accounts (email/password + Google + Apple)                 | 🔴                                | Must                                                                       | Firebase/Supabase‑backed auth                                         | MVP              |
| Opt‑in sync (manual + auto) with queue and LWW conflicts         | 🔴                                | Must                                                                       | Durable queue, timestamps, last‑write‑wins; version history for notes | MVP              |                          
| Roles: Admin, Teacher, Moderator, Student, Parent                | 🔴                                | Must                                                                       | Role model + server‑side rules                                        | v1               |
| Teacher tools (create/edit lessons, schedule roundtables, forum) | 🔴                                | Should                                                                     | In‑app editor (quill), roundtable scheduling, discussion area         | v1               |
| Chatrooms per class with moderation (flag/remove/ban)            | 🔴                                | Must                                                                       | Realtime chat + moderation actions + reports                          | MVP              |
| Conferencing (Jitsi in‑app or external links; recordings)        | 🔴                                | Should                                                                     | Jitsi SDK wrapper + save recordings to Storage                        | v1               |
| Age‑specific themes & accessibility (screen readers, scaling)    | 🔴                                | Must                                                                       | Theming per cohort; a11y checks; dark mode                            | MVP/v1           |
| Gamification (badges, stars)                                     | 🔴                                | Later                                                                      | Lightweight rewards                                                   | Later            |
| Security & privacy (encrypted local, export/delete, rules)       | 🔴                                | Must                                                                       | SQLCipher/Hive‑enc; privacy controls; Firestore/Supabase rules        | MVP              |
| Internationalisation (i18n)                                      | 🔴                                | Must                                                                       | Flutter i18n + RTL ready                                              | MVP              |
| CI, tests (unit & integration), docs, sample data                | 🔴                                | Must                                                                       | GitHub Actions; test suites; sample packages                          | MVP              |

---

## 3) Architecture Overview

**Approach:** Clean architecture with presentation (Flutter/UI), domain (use‑cases), data (repositories), and infrastructure (local DB, network, storage). **Offline‑first** with Drift (SQLite + FTS) or Hive (encrypted) for local, plus Firebase *or* Supabase for cloud.

### 3.1 Layers

* **Presentation:** Flutter + Riverpod; feature modules (Bible, Lessons, Accounts, Chat, Settings).
* **Domain:** Entities (Verse, Translation, Lesson, Progress, Note, Message), repositories, use‑cases.
* **Data:** Repositories backed by Drift DAOs and cloud services.
* **Sync:** Durable queue that replays to cloud; conflict resolver (Last Write Wins except notes keep history).

### 3.2 Suggested Stack

* **Flutter:** Stable channel.
* **State:** Riverpod (hooks_riverpod if desired).
* **Local:** Drift (FTS5 for search, SQLCipher via sqlite_see for encryption) + Path Provider + flutter_archive for import.
* **Cloud Option A (default):** Firebase (Auth, Firestore, Storage, Functions, FCM).
* **Cloud Option B:** Supabase (Auth, Postgres + Realtime, Storage, Edge Functions). See migration notes §13.
* **Rich text:** flutter_quill (edit), flutter_html (render).
* **Video:** Jitsi SDK (jitsi_meet) or external deep links.

### 3.3 Repository Contracts (examples)

* `BibleRepository`: importTranslation(), listTranslations(), streamChapter(), search(), addBookmark(), addHighlight(), addNote().
* `LessonRepository`: getLessons(), cacheLesson(), updateProgress(), submitQuiz().
* `AccountRepository`: currentUser(), signInLocal(), signInCloud(), signOut().
* `SyncRepository`: enqueue(op), processQueue(), resolveConflicts().
* `ChatRepository`: streamMessages(classId), sendMessage(), flagMessage(), removeMessage(), banUser().

---

## 4) Data Model (Drift)

**Schema (abridged):**

'''sql
-- Translations
CREATE TABLE translations (
  id TEXT PRIMARY KEY,          -- e.g., "kjv"
  name TEXT NOT NULL,           -- King James Version
  language TEXT NOT NULL,       -- en, sn, nd, pt
  version TEXT NOT NULL,
  source TEXT,
  installedAt INTEGER NOT NULL
);

-- Verses (per translation)
CREATE TABLE verses (
  tId TEXT NOT NULL,            -- FK translations.id
  bookId INTEGER NOT NULL,      -- 1..66
  chapter INTEGER NOT NULL,
  verse INTEGER NOT NULL,
  text TEXT NOT NULL,
  PRIMARY KEY (tId, bookId, chapter, verse)
);

-- FTS index per translation (virtual tables created dynamically)
-- Example for KJV
CREATE VIRTUAL TABLE verses_kjv_fts USING fts5(text, content='verses', content_rowid='rowid');

-- Bookmarks / Highlights / Notes
CREATE TABLE bookmarks (
  id TEXT PRIMARY KEY,
  tId TEXT NOT NULL,
  bookId INTEGER NOT NULL,
  chapter INTEGER NOT NULL,
  verse INTEGER NOT NULL,
  createdAt INTEGER NOT NULL
);

CREATE TABLE highlights (
  id TEXT PRIMARY KEY,
  tId TEXT NOT NULL,
  bookId INTEGER NOT NULL,
  chapter INTEGER NOT NULL,
  verse INTEGER NOT NULL,
  colour TEXT NOT NULL,
  createdAt INTEGER NOT NULL
);

CREATE TABLE notes (
  id TEXT PRIMARY KEY,
  tId TEXT NOT NULL,
  bookId INTEGER NOT NULL,
  chapter INTEGER NOT NULL,
  verse INTEGER NOT NULL,
  text TEXT NOT NULL,
  version INTEGER NOT NULL DEFAULT 1,
  updatedAt INTEGER NOT NULL
);

-- Lessons
CREATE TABLE lessons (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  class TEXT NOT NULL,          -- Beginners, Primary Pals, Answer, Search, Discovery
  ageMin INTEGER,
  ageMax INTEGER,
  objectives TEXT,              -- JSON array
  scriptures TEXT,              -- JSON array with {ref, tId}
  contentHtml TEXT,
  teacherNotes TEXT,
  attachments TEXT,             -- JSON array
  quizzes TEXT,                 -- JSON array
  sourceUrl TEXT,
  lastFetchedAt INTEGER
);

-- Progress
CREATE TABLE progress (
  id TEXT PRIMARY KEY,          -- userId + lessonId
  userId TEXT NOT NULL,
  lessonId TEXT NOT NULL,
  status TEXT NOT NULL,         -- not_started / in_progress / completed
  quizScore REAL,
  timeSpentSeconds INTEGER NOT NULL DEFAULT 0,
  updatedAt INTEGER NOT NULL
);

-- Users (local profile)
CREATE TABLE local_users (
  id TEXT PRIMARY KEY,
  displayName TEXT,
  avatarUrl TEXT
);

-- Sync Queue
CREATE TABLE sync_queue (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  opType TEXT NOT NULL,         -- upsert_note / upsert_progress / delete_message / ban_user / etc
  payload TEXT NOT NULL,        -- JSON
  createdAt INTEGER NOT NULL,
  lastTriedAt INTEGER,
  attempts INTEGER NOT NULL DEFAULT 0
);

-- Chat messages (local cache)
CREATE TABLE messages (
  id TEXT PRIMARY KEY,
  classId TEXT NOT NULL,
  userId TEXT NOT NULL,
  body TEXT NOT NULL,
  createdAt INTEGER NOT NULL,
  deleted INTEGER NOT NULL DEFAULT 0,
  flagged INTEGER NOT NULL DEFAULT 0
);
'''

---

## 5) JSON Schemas (Deliverable)

### 5.1 Bible Package Manifest (JSON Schema)

'''json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "BiblePackageManifest",
  "type": "object",
  "required": ["id", "language", "name", "version", "fileFormat", "checksum"],
  "properties": {
    "id": {"type": "string", "pattern": "^[a-z0-9_-]+$"},
    "language": {"type": "string"},
    "name": {"type": "string"},
    "version": {"type": "string"},
    "source": {"type": "string"},
    "fileFormat": {"type": "string", "enum": ["jsonl", "sqlite"]},
    "checksum": {"type": "string"},
    "files": {"type": "array", "items": {"type": "string"}}
  }
}
'''

### 5.2 Verse Record

'''json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "VerseRecord",
  "type": "object",
  "required": ["bookId", "chapter", "verse", "text"],
  "properties": {
    "bookId": {"type": "integer", "minimum": 1, "maximum": 66},
    "chapter": {"type": "integer", "minimum": 1},
    "verse": {"type": "integer", "minimum": 1},
    "text": {"type": "string"}
  }
}
'''

### 5.3 Lesson JSON

'''json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Lesson",
  "type": "object",
  "required": ["id", "title", "class", "ageRange", "objectives", "scriptures", "contentHtml"],
  "properties": {
    "id": {"type": "string"},
    "title": {"type": "string"},
    "class": {"type": "string", "enum": ["Beginners", "Primary Pals", "Answer", "Search", "Discovery"]},
    "ageRange": {"type": "object", "required": ["min", "max"], "properties": {"min": {"type": "integer"}, "max": {"type": "integer"}}},
    "objectives": {"type": "array", "items": {"type": "string"}},
    "scriptures": {"type": "array", "items": {"type": "object", "required": ["ref", "tId"], "properties": {"ref": {"type": "string"}, "tId": {"type": "string"}}}},
    "contentHtml": {"type": "string"},
    "teacherNotes": {"type": "string"},
    "attachments": {"type": "array", "items": {"type": "object", "properties": {"type": {"type": "string", "enum": ["image", "audio", "pdf", "video"]}, "url": {"type": "string"}, "title": {"type": "string"}}}},
    "quizzes": {"type": "array", "items": {"type": "object", "required": ["id", "type", "prompt"], "properties": {"id": {"type": "string"}, "type": {"type": "string", "enum": ["mcq", "true_false", "short_answer"]}, "prompt": {"type": "string"}, "options": {"type": "array", "items": {"type": "string"}}, "answer": {"type": ["string", "array"]}}}}
  }
}
'''

### 5.4 Progress Object

'''json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Progress",
  "type": "object",
  "required": ["userId", "lessonId", "status", "updatedAt"],
  "properties": {
    "userId": {"type": "string"},
    "lessonId": {"type": "string"},
    "status": {"type": "string", "enum": ["not_started", "in_progress", "completed"]},
    "quizScore": {"type": ["number", "null"]},
    "timeSpentSeconds": {"type": "integer", "minimum": 0},
    "updatedAt": {"type": "integer"}
  }
}
'''

---

## 6) Critical Flow – Code Examples (abridged)

### 6.1 Bible Import (.zip → DB + FTS)

'''dart
final bibleImporterProvider = Provider((ref) => BibleImporter(ref.read));

class BibleImporter {
  BibleImporter(this._read);
  final Reader _read;

  Future<void> importZip(File zipFile) async {
    final tempDir = await getTemporaryDirectory();
    final outDir = Directory('${tempDir.path}/bible_import_${DateTime.now().millisecondsSinceEpoch}');
    await outDir.create(recursive: true);

    await ZipFile.extractToDirectory(zipFile: zipFile, destinationDir: outDir);
    final manifestFile = File(path.join(outDir.path, 'manifest.json'));
    final manifest = jsonDecode(await manifestFile.readAsString()) as Map<String, dynamic>;
    final tId = manifest['id'] as String;

    final db = _read(appDatabaseProvider);
    await db.transaction(() async {
      await db.translationsDao.upsert(Translation(
        id: tId,
        name: manifest['name'],
        language: manifest['language'],
        version: manifest['version'],
        source: manifest['source'],
        installedAt: DateTime.now().millisecondsSinceEpoch,
      ));

      if (manifest['fileFormat'] == 'jsonl') {
        final versesFile = File(path.join(outDir.path, 'verses.jsonl'));
        final lines = versesFile.openRead().transform(utf8.decoder).transform(const LineSplitter());
        await for (final line in lines) {
          final v = jsonDecode(line) as Map<String, dynamic>;
          await db.versesDao.insertVerse(Verse(
            tId: tId,
            bookId: v['bookId'],
            chapter: v['chapter'],
            verse: v['verse'],
            text: v['text'],
          ));
        }
      } else if (manifest['fileFormat'] == 'sqlite') {
        // Copy prebuilt sqlite into app space and attach as a read-only database.
      }

      await db.versesDao.buildFtsIndexFor(tId); // creates FTS5 virtual table and populates it
    });
  }
}
'''

### 6.2 Bible Reader with Parallel View & Annotations

'''dart
class ParallelReaderPage extends ConsumerWidget {
  const ParallelReaderPage({super.key, required this.bookId, required this.chapter});
  final int bookId; final int chapter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leftTid = ref.watch(readerStateProvider.select((s) => s.leftTid));
    final rightTid = ref.watch(readerStateProvider.select((s) => s.rightTid));
    final left = ref.watch(versesStreamProvider((leftTid, bookId, chapter)));
    final right = ref.watch(versesStreamProvider((rightTid, bookId, chapter)));

    return Scaffold(
      appBar: AppBar(title: const Text('Parallel View')),
      body: Row(
        children: [
          Expanded(child: _VerseColumn(stream: left, tId: leftTid)),
          const VerticalDivider(width: 1),
          Expanded(child: _VerseColumn(stream: right, tId: rightTid)),
        ],
      ),
    );
  }
}

class _VerseColumn extends StatelessWidget {
  const _VerseColumn({required this.stream, required this.tId});
  final AsyncValue<List<Verse>> stream; final String tId;

  @override
  Widget build(BuildContext context) {
    return stream.when(
      data: (verses) => ListView.builder(
        itemCount: verses.length,
        itemBuilder: (c, i) {
          final v = verses[i];
          return ListTile(
            title: Text('${v.verse}. ${v.text}')
          ).onLongPress(() => _showAnnotateSheet(context, v));
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
'''

### 6.3 Lesson Caching (online URL → offline)

'''dart
class LessonCacher {
  LessonCacher(this._db, this._client);
  final AppDatabase _db; final http.Client _client;

  Future<void> cacheFromUrl(Uri url) async {
    final resp = await _client.get(url);
    if (resp.statusCode != 200) throw Exception('Failed to fetch lesson');
    final map = jsonDecode(resp.body) as Map<String, dynamic>;
    final lesson = Lesson.fromJson(map);
    await _db.lessonsDao.upsert(lesson);

    // Attachments
    for (final a in lesson.attachments) {
      final fileResp = await _client.get(Uri.parse(a.url));
      final dir = await getApplicationDocumentsDirectory();
      final file = File(path.join(dir.path, 'attachments', path.basename(a.url)));
      await file.create(recursive: true);
      await file.writeAsBytes(fileResp.bodyBytes);
    }
  }
}
'''

### 6.4 Offline → Cloud Sync (queue + LWW conflicts)

'''dart
class SyncService {
  SyncService(this._db, this._cloud);
  final AppDatabase _db; final CloudApi _cloud; // CloudApi abstracts Firebase/Supabase

  Future<void> enqueue(String userId, String opType, Map<String, dynamic> payload) async {
    await _db.syncDao.enqueue(SyncOp(
      id: const Uuid().v4(), userId: userId, opType: opType,
      payload: jsonEncode(payload), createdAt: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  Future<void> processQueue() async {
    final ops = await _db.syncDao.pendingOps();
    for (final op in ops) {
      try {
        await _cloud.apply(op);
        await _db.syncDao.delete(op.id);
      } catch (e) {
        await _db.syncDao.bumpAttempts(op.id);
      }
    }
  }
}
'''

**Conflict rule (LWW except Notes keep history):**

* Compare `updatedAt` (client) vs `lastUpdated` (cloud). If client is newer, overwrite; otherwise keep cloud version.
* For Notes, append a new version (increment `version`), preserving the prior text for manual merge.

### 6.5 Basic Chat with Moderation (Firestore example)

**Client structure:** `/classes/{classId}/messages/{messageId}` with fields `{userId, body, createdAt, deleted, flagged}` and `/classes/{classId}/bans/{userId}`.

'''dart
class ChatRepo {
  ChatRepo(this._db, this._firestore);
  final AppDatabase _db; final FirebaseFirestore _firestore;

  Stream<List<Message>> streamMessages(String classId) {
    return _firestore.collection('classes/$classId/messages')
      .orderBy('createdAt', descending: false)
      .snapshots()
      .map((s) => s.docs.map((d) => Message.fromMap(d.data())).toList());
  }

  Future<void> send(String classId, String body) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _firestore.collection('classes/$classId/messages').add({
      'userId': uid, 'body': body, 'createdAt': FieldValue.serverTimestamp(), 'deleted': false, 'flagged': false,
    });
  }

  Future<void> flag(String classId, String messageId) async {
    await _firestore.doc('classes/$classId/messages/$messageId').update({'flagged': true});
  }

  Future<void> removeMessage(String classId, String messageId) async {
    await _firestore.doc('classes/$classId/messages/$messageId').update({'deleted': true});
  }

  Future<void> banUser(String classId, String userId) async {
    await _firestore.doc('classes/$classId/bans/$userId').set({'bannedAt': FieldValue.serverTimestamp()});
  }
}
'''

**Firestore rules (excerpt):**

'''js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function hasRole(role) {
      return exists(/databases/$(database)/documents/users/$(request.auth.uid)) &&
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.roles[role] == true;
    }

    match /classes/{classId}/messages/{messageId} {
      allow read: if request.auth != null; // class membership check elided
      allow create: if request.auth != null && !exists(/databases/$(database)/documents/classes/$(classId)/bans/$(request.auth.uid));
      allow update: if hasRole('Teacher') || hasRole('Moderator') || (request.auth.uid == resource.data.userId && !('deleted' in request.resource.data.keys()));
    }

    match /classes/{classId}/bans/{userId} {
      allow write: if hasRole('Teacher') || hasRole('Admin');
      allow read: if request.auth != null;
    }
  }
}
'''

**Supabase equivalent (policies):**

* Table `messages` with RLS: `select` to class members; `insert` only if user not in `bans`; `update` where `auth.uid() = user_id OR role IN ('teacher','moderator')`.

### 6.6 Jitsi Integration (in‑app)

'''dart
await JitsiMeet.join(
  JitsiMeetingOptions(room: 'afc-roundtable-${classId}')
    ..subject = 'AFC Roundtable'
    ..userDisplayName = currentUser.displayName
    ..audioMuted = false
    ..videoMuted = true,
);
'''

---

## 7) UX & UI

* **Age‑specific themes:**

  * *Beginners (2–5):* Larger tap targets, vivid colours, gentle animations.
  * *Primary Pals (6–9):* Friendly icons, progress stars.
  * *Answer (10–13):* Brighter palette, simple badges.
  * *Search / Discovery (teens–adults):* Calmer palette, denser information, reduced motion.
* **Accessibility:** Screen readers, semantic labels, text scaling, high‑contrast mode, dark mode.
* **Layouts:** Responsive master‑detail on tablets; parallel view in landscape.

**Wireframe bundle:** Home → Bible → Book → Chapter → Parallel View; Lessons → Detail → Quiz; Teacher Panel → Roundtables → Chat Moderation.

---

## 8) Security & Privacy

* **Local encryption:** SQLCipher/SEE for Drift or encrypted Hive boxes.
* **Secrets & tokens:** Secure storage (flutter_secure_storage).
* **Privacy controls:** Data export (JSON) and delete account flows.
* **Rules:** Firestore rules / Supabase RLS as above; Storage rules restrict by owner/role.
* **Telemetry:** Opt‑in only; anonymised.

---

## 9) Non‑Functional Requirements Mapping

* **Offline‑first:** All Bible & cached lessons fully usable offline; queue for writes.
* **Lightweight:** Bible packages compressed (JSONL gz or SQLite w/ WAL disabled for ship); lazy install of extra translations.
* **Performance:** <300ms initial chapter render (precompute verse layout; isolate‑based parsing; memoised providers).
* **i18n:** Flutter localisation; additional languages via ARB; left‑to‑right and right‑to‑left support prepared.
* **Test coverage:** Unit tests (models, FTS queries, sync logic); integration tests (offline → online sync). See §12.

---

## 10) Delivery – Repository & Scaffold

**Proposed folder structure:**

'''
lib/
  app.dart
  core/
    env/
    errors/
    router/
    theme/
    util/
  features/
    bible/
      data/ (daos, repos)
      domain/ (entities, usecases)
      presentation/ (pages, widgets, providers)
    lessons/
    accounts/
    chat/
    teacher/
    settings/
  services/
    db/ (drift database)
    sync/
    cloud/ (firebase|supabase adapters)
  l10n/
assets/
  bible_packages/ (KJV, Shona samples)
  lessons/ (5 sample lessons)
'''

**Sample data:** Ship KJV and Shona packages; include 5 lessons across classes.

---

## 11) CI/CD & Quality

**GitHub Actions (excerpt):**

'''yaml
name: CI
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: {channel: 'stable'}
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage
      - run: flutter build apk --debug
'''

---

## 12) Test Plan & QA Scenarios

* **Offline Bible search & parallel view:** Disable network; import KJV; search “faith”; open parallel with Shona; verify results and scrolling sync.
* **Import damaged/partial package:** Corrupt checksum; show friendly error; no partial install.
* **Concurrent note edits (two devices):** Make two edits; verify LWW and note version history retained; manual merge possible.
* **Teacher removes student message:** Remove while offline; check local soft delete; after reconnection, change propagates.
* **Sync queue replay (100+ ops):** Simulate long offline period; ensure backoff and eventual consistency.
* **Accessibility:** VoiceOver/TalkBack labels; dynamic type scaling; contrast.

---

## 13) Firebase ↔ Supabase Migration Notes

* **Auth:** Email/password + Google + Apple available in both; map UID ↔ auth.uid().
* **Data:** Firestore collections vs Postgres tables; create views & RLS policies equivalent to Firestore rules.
* **Realtime:** Firestore snapshots ↔ Supabase Realtime channels.
* **Functions:** Cloud Functions ↔ Edge Functions; move moderation logs and ban enforcement logic accordingly.
* **Storage:** Map paths (`/recordings/{classId}/...`) to buckets with RLS.
* **Client adapters:** Keep `CloudApi` interface; provide `FirebaseApi` and `SupabaseApi` implementations; DI selects one via env.

---

## 14) Acceptance Criteria (Definition of Done)

* User can read included Bible translations offline, search, highlight, and add notes.
* Client‑provided lessons load offline and from online URLs; progress persists locally.
* User can create a cloud account and opt‑in to sync progress; synced progress visible in cloud DB.
* Teachers can create a roundtable and moderate a chatroom (flag & remove a message).
* Importing a new Bible package (zip) adds a translation and it becomes searchable offline.
* Basic tests pass in CI; docs explain how to add Bible packages and lessons.

---

## 15) Priority Backlog

**MVP:**

* Bible reader (KJV + Shona), import, FTS search, bookmarks/highlights/notes
* Local lessons for one class, progress tracking, local account
* Cloud auth + opt‑in progress sync
* One class chatroom with moderation

**v1:**

* All built‑in translations; lesson editor; teacher roundtables; Jitsi; richer moderation; audio playback (if assets)

**Later:**

* Analytics; gamification leaderboard; web admin for content; multi‑tenant (multiple churches); transcripts & audio narration

---

## 16) Documentation Set (to ship with repo)

* **README:** Setup, build, environment config, platform notes (Android/iOS), Firebase/Supabase setup.
* **Schema Docs:** Lesson JSON spec & Bible package spec (this document §5).
* **API Docs:** If custom backend used (otherwise link Firebase/Supabase).
* **Security & Privacy Policy Template:** Data categories, retention, user rights (export/delete), contact.

---

## 17) Implementation Plan & Timeline (Gantt‑style, 10 weeks)

* **W1–W2 (MVP Core):** Drift schema; Bible import & FTS; parallel reader; annotations.
* **W3–W4:** Lessons model + caching; progress tracking; local profiles; i18n.
* **W5–W6:** Auth (email/password + Google/Apple); sync queue; LWW; tests (unit).
* **W7:** Chat + moderation; rules/policies; integration tests (offline→online).
* **W8:** Teacher panel basics; roundtable scheduling; Jitsi linking.
* **W9:** Accessibility pass; age themes; performance tuning; docs.
* **W10:** CI workflow; sample data; acceptance sign‑off.

---

## 18) Risks & Mitigations

* **Package size (5 translations):** Compress; lazy install; defer audio.
* **Conflict complexity:** LWW for most; versioned notes; expose manual merge UI.
* **Moderation abuse:** Audit log; rate limiting; teacher approval for first‑time posters (optional rule).
* **Low‑end devices:** Avoid heavy animations; cache aggressively; isolate workers for parsing.

---

## 19) Hand‑off Assets

* Wireframes (per cohort), typography & colour tokens, icon set.
* Teacher onboarding flow and moderation SOP.
* Sample Bible packages (KJV, Shona) and 5 lessons.

---

**End of Blueprint**
