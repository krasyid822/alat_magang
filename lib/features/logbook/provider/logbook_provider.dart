import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/data/models.dart';
import '../../shared/data/local_storage.dart';
import '../../shared/data/firebase_service.dart';
import '../../dashboard/provider/dashboard_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'logbook_provider.g.dart';

@riverpod
class LogbookNotifier extends _$LogbookNotifier {
  @override
  List<InternshipLog> build() {
    final nim = ref.watch(dashboardControllerProvider).nim;
    if (nim.isEmpty) return [];

    final local = ref.read(localStorageProvider);
    final localKey = 'logs_$nim';
    final cached = local.read(localKey);
    
    if (cached != null) {
      try {
        final List decoded = jsonDecode(cached);
        final list = decoded.map((e) => InternshipLog.fromJson(Map<String, dynamic>.from(e))).toList();
        list.sort((a, b) => b.date.compareTo(a.date));
        _initCloudSync(nim);
        return list;
      } catch (_) {}
    }
    
    _initCloudSync(nim);
    return [];
  }

  void _initCloudSync(String nim) {
    // 1. Rekonsiliasi awal
    Future.microtask(() async {
      try {
        ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.downloading, 'Mengecek logbook...');
        final cloudLogs = await ref.read(firebaseServiceProvider).getLogs(nim);
        
        final Map<String, InternshipLog> merged = {};
        for (final item in state) {
          merged[item.id] = item;
        }
        for (final item in cloudLogs) {
          final localItem = merged[item.id];
          if (localItem == null || item.updatedAt > localItem.updatedAt) {
            merged[item.id] = item;
          }
        }
        
        final mergedList = merged.values.toList()..sort((a, b) => b.date.compareTo(a.date));
        
        bool needsUpload = false;
        bool needsLocalUpdate = false;
        
        for (final item in mergedList) {
          final localItem = state.firstWhere((e) => e.id == item.id, orElse: () => const InternshipLog(id: '', date: '', activity: '', startTime: '', endTime: '', weekNumber: 0));
          final cloudItem = cloudLogs.firstWhere((e) => e.id == item.id, orElse: () => const InternshipLog(id: '', date: '', activity: '', startTime: '', endTime: '', weekNumber: 0));
          
          if (localItem.id.isEmpty || item.updatedAt > localItem.updatedAt) {
            needsLocalUpdate = true;
          }
          if (cloudItem.id.isEmpty || item.updatedAt > cloudItem.updatedAt) {
            needsUpload = true;
          }
        }
        
        if (needsLocalUpdate) {
          state = mergedList;
          _saveLocal(mergedList);
        }
        
        if (needsUpload) {
          ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.uploading, 'Mengunggah logbook...');
          for (final item in mergedList) {
            final cloudItem = cloudLogs.firstWhere((e) => e.id == item.id, orElse: () => const InternshipLog(id: '', date: '', activity: '', startTime: '', endTime: '', weekNumber: 0));
            if (cloudItem.id.isEmpty || item.updatedAt > cloudItem.updatedAt) {
              await ref.read(firebaseServiceProvider).saveLog(nim, item);
            }
          }
        }

        // 1. Declare sync time for this session
        final deviceId = ref.read(localStorageProvider).getDeviceId();
        await ref.read(firebaseServiceProvider).updateSessionSyncTime(nim, deviceId);
        
        // 2. Fetch all active sessions
        final sessions = await ref.read(firebaseServiceProvider).getSessions(nim);
        
        // 3. Find the oldest lastSyncedAt among all devices
        int minSyncTime = DateTime.now().millisecondsSinceEpoch;
        if (sessions.isNotEmpty) {
          for (final session in sessions) {
            final lastSynced = session['lastSyncedAt'] as int? ?? 0;
            if (lastSynced < minSyncTime) {
              minSyncTime = lastSynced;
            }
          }
        }
        
        // 4. Purge tombstones that have been synced by all devices
        if (minSyncTime > 0) {
          final toPurge = mergedList.where((e) => e.isDeleted && e.updatedAt < minSyncTime).toList();
          if (toPurge.isNotEmpty) {
            for (final item in toPurge) {
              await ref.read(firebaseServiceProvider).deleteLog(nim, item.id);
            }
            final purgedList = state.where((e) => !toPurge.any((p) => p.id == e.id)).toList();
            state = purgedList;
            _saveLocal(purgedList);
          }
        }
        
        ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Logbook sinkron');
      } catch (e) {
        ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.error, 'Gagal sinkron logbook');
      }
    });

    // 2. Real-time listener
    ref.listen(
      firebaseServiceProvider.select((s) => s.logsStream(nim)),
      (previous, next) {
        next.listen(
          (cloudLogs) {
            final Map<String, InternshipLog> merged = {};
            for (final item in state) {
              merged[item.id] = item;
            }
            bool changed = false;
            for (final item in cloudLogs) {
              final localItem = merged[item.id];
              if (localItem == null || item.updatedAt > localItem.updatedAt) {
                merged[item.id] = item;
                changed = true;
              }
            }
            if (changed) {
              final mergedList = merged.values.toList()..sort((a, b) => b.date.compareTo(a.date));
              state = mergedList;
              _saveLocal(mergedList);
              ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Logbook sinkron');
            }
          },
        );
      },
      fireImmediately: true,
    );
  }

  void _saveLocal(List<InternshipLog> logs) {
    final nim = ref.read(dashboardControllerProvider).nim;
    if (nim.isEmpty) return;
    final local = ref.read(localStorageProvider);
    final localKey = 'logs_$nim';
    local.write(localKey, jsonEncode(logs.map((e) => e.toJson()).toList()));
  }

  Future<void> addLog(InternshipLog log) async {
    final updatedLog = log.copyWith(
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    final updated = [...state, updatedLog]..sort((a, b) => b.date.compareTo(a.date));
    state = updated;
    _saveLocal(updated);
    
    final nim = ref.read(dashboardControllerProvider).nim;
    try {
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.uploading, 'Mengunggah log...');
      await ref.read(firebaseServiceProvider).saveLog(nim, updatedLog);
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Log terunggah');
    } catch (e) {
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.error, 'Gagal unggah log');
    }
  }

  Future<void> updateLog(InternshipLog log) async {
    final updatedLog = log.copyWith(
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    final updated = state.map((e) => e.id == log.id ? updatedLog : e).toList()..sort((a, b) => b.date.compareTo(a.date));
    state = updated;
    _saveLocal(updated);
    
    final nim = ref.read(dashboardControllerProvider).nim;
    try {
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.uploading, 'Memperbarui log...');
      await ref.read(firebaseServiceProvider).saveLog(nim, updatedLog);
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Log diperbarui');
    } catch (e) {
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.error, 'Gagal update log');
    }
  }

  Future<void> deleteLog(String id) async {
    final updated = state.map((e) {
      if (e.id == id) {
        return e.copyWith(
          isDeleted: true,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        );
      }
      return e;
    }).toList();
    state = updated;
    _saveLocal(updated);
    
    final nim = ref.read(dashboardControllerProvider).nim;
    final deletedLog = updated.firstWhere((e) => e.id == id);
    try {
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.uploading, 'Menghapus log...');
      await ref.read(firebaseServiceProvider).saveLog(nim, deletedLog);
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Log terhapus');
    } catch (e) {
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.error, 'Gagal hapus log');
    }
  }

  Future<void> toggleSign(String id, bool isSigned) async {
    final updated = state.map((e) => e.id == id ? e.copyWith(
      isSigned: isSigned,
      signatureData: isSigned ? e.signatureData : '',
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    ) : e).toList();
    state = updated;
    _saveLocal(updated);
    
    final nim = ref.read(dashboardControllerProvider).nim;
    final log = updated.firstWhere((e) => e.id == id);
    await ref.read(firebaseServiceProvider).saveLog(nim, log);
  }

  Future<void> saveSignature(String id, String signatureData) async {
    final updated = state.map((e) => e.id == id ? e.copyWith(
      isSigned: signatureData.isNotEmpty,
      signatureData: signatureData,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    ) : e).toList();
    state = updated;
    _saveLocal(updated);
    
    final nim = ref.read(dashboardControllerProvider).nim;
    final log = updated.firstWhere((e) => e.id == id);
    await ref.read(firebaseServiceProvider).saveLog(nim, log);
  }
}

@riverpod
Stream<List<InternshipLog>> logbookStream(Ref ref) {
  final logs = ref.watch(logbookProvider);
  return Stream.value(logs.where((e) => !e.isDeleted).toList());
}

@riverpod
class LogbookController extends _$LogbookController {
  @override
  void build() {}

  /// Delegate methods to maintain compatibility with existing UI
  Future<void> addLog(InternshipLog log) async {
    await ref.read(logbookProvider.notifier).addLog(log);
  }

  Future<void> updateLog(InternshipLog log) async {
    await ref.read(logbookProvider.notifier).updateLog(log);
  }

  Future<void> deleteLog(String id) async {
    await ref.read(logbookProvider.notifier).deleteLog(id);
  }

  Future<void> toggleSign(String id, bool isSigned) async {
    await ref.read(logbookProvider.notifier).toggleSign(id, isSigned);
  }

  Future<void> saveSignature(String id, String signatureData) async {
    await ref.read(logbookProvider.notifier).saveSignature(id, signatureData);
  }
}
