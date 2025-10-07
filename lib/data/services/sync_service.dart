import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/note.dart';
import '../models/progress.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(firestore: FirebaseFirestore.instance);
});

class SyncService {
  SyncService({required this.firestore});

  final FirebaseFirestore firestore;

  Future<void> syncProgress(String userId, List<Progress> progress) async {
    final batch = firestore.batch();
    final collection = firestore.collection('progress').doc(userId).collection('items');
    for (final item in progress) {
      batch.set(collection.doc(item.lessonId), item.toJson(), SetOptions(merge: true));
    }
    await batch.commit();
  }

  Future<void> syncNotes(String userId, List<Note> notes) async {
    final batch = firestore.batch();
    final collection = firestore.collection('notes').doc(userId).collection('items');
    for (final note in notes) {
      batch.set(collection.doc(note.id), note.toJson(), SetOptions(merge: true));
    }
    await batch.commit();
  }
}
