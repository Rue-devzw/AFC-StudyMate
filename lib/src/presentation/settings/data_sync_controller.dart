import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/sync/entities.dart';
import '../../domain/sync/repositories.dart';
import '../../infrastructure/sync/sync_orchestrator.dart';

class DataSyncState {
  const DataSyncState({
    this.isSyncing = false,
    this.pendingOperations = 0,
    this.lastSyncedAt,
    this.lastError,
    this.conflictCount = 0,
  });

  final bool isSyncing;
  final int pendingOperations;
  final DateTime? lastSyncedAt;
  final String? lastError;
  final int conflictCount;

  DataSyncState copyWith({
    bool? isSyncing,
    int? pendingOperations,
    DateTime? lastSyncedAt,
    bool clearLastSyncedAt = false,
    String? lastError,
    bool clearLastError = false,
    int? conflictCount,
  }) {
    return DataSyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      pendingOperations: pendingOperations ?? this.pendingOperations,
      lastSyncedAt:
          clearLastSyncedAt ? null : (lastSyncedAt ?? this.lastSyncedAt),
      lastError: clearLastError ? null : (lastError ?? this.lastError),
      conflictCount: conflictCount ?? this.conflictCount,
    );
  }
}

class DataSyncController extends StateNotifier<DataSyncState> {
  DataSyncController(
    this._orchestrator,
    SyncRepository repository,
  ) : super(const DataSyncState()) {
    _statusSub = _orchestrator.statusStream.listen(_handleStatus);
    _conflictSub = repository.watchConflicts().listen((conflicts) {
      state = state.copyWith(conflictCount: conflicts.length);
    });
  }

  final SyncOrchestrator _orchestrator;
  StreamSubscription<SyncStatus>? _statusSub;
  StreamSubscription<List<SyncConflict>>? _conflictSub;

  Future<void> syncNow() async {
    try {
      await _orchestrator.syncNow(manual: true);
    } catch (_) {
      // Orchestrator already records the error in its status stream.
    }
  }

  void _handleStatus(SyncStatus status) {
    state = state.copyWith(
      isSyncing: status.isSyncing,
      pendingOperations: status.pendingOperations,
      lastSyncedAt: status.lastSyncedAt,
      clearLastSyncedAt: status.lastSyncedAt == null,
      lastError: status.lastError,
      clearLastError: status.lastError == null,
    );
  }

  @override
  void dispose() {
    _statusSub?.cancel();
    _conflictSub?.cancel();
    super.dispose();
  }
}
