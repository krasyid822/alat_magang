import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/data/models.dart';
import '../../shared/data/local_storage.dart';
import '../../shared/data/firebase_service.dart';
import '../../dashboard/provider/dashboard_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'job_provider.g.dart';

@riverpod
class JobNotifier extends _$JobNotifier {
  @override
  List<JobDetail> build() {
    final nim = ref.watch(dashboardControllerProvider).nim;
    if (nim.isEmpty) return [];

    final local = ref.read(localStorageProvider);
    final localKey = 'jobs_$nim';
    final cached = local.read(localKey);
    
    if (cached != null) {
      try {
        final List decoded = jsonDecode(cached);
        final list = decoded.map((e) => JobDetail.fromJson(Map<String, dynamic>.from(e))).toList();
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
        ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.downloading, 'Mengecek tugas...');
        final cloudJobs = await ref.read(firebaseServiceProvider).getJobs(nim);
        
        final Map<String, JobDetail> merged = {};
        for (final item in state) {
          merged[item.id] = item;
        }
        for (final item in cloudJobs) {
          final localItem = merged[item.id];
          if (localItem == null || item.updatedAt > localItem.updatedAt) {
            merged[item.id] = item;
          }
        }
        
        final mergedList = merged.values.toList()..sort((a, b) => b.date.compareTo(a.date));
        
        bool needsUpload = false;
        bool needsLocalUpdate = false;
        
        for (final item in mergedList) {
          final localItem = state.firstWhere((e) => e.id == item.id, orElse: () => const JobDetail(id: '', title: '', description: '', date: ''));
          final cloudItem = cloudJobs.firstWhere((e) => e.id == item.id, orElse: () => const JobDetail(id: '', title: '', description: '', date: ''));
          
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
          ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.uploading, 'Mengunggah tugas...');
          for (final item in mergedList) {
            final cloudItem = cloudJobs.firstWhere((e) => e.id == item.id, orElse: () => const JobDetail(id: '', title: '', description: '', date: ''));
            if (cloudItem.id.isEmpty || item.updatedAt > cloudItem.updatedAt) {
              await ref.read(firebaseServiceProvider).saveJob(nim, item);
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
              await ref.read(firebaseServiceProvider).deleteJob(nim, item.id);
            }
            final purgedList = state.where((e) => !toPurge.any((p) => p.id == e.id)).toList();
            state = purgedList;
            _saveLocal(purgedList);
          }
        }
        
        ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Tugas sinkron');
      } catch (e) {
        ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.error, 'Gagal sinkron tugas');
      }
    });

    // 2. Real-time
    ref.listen(
      firebaseServiceProvider.select((s) => s.jobsStream(nim)),
      (previous, next) {
        next.listen(
          (cloudJobs) {
            final Map<String, JobDetail> merged = {};
            for (final item in state) {
              merged[item.id] = item;
            }
            bool changed = false;
            for (final item in cloudJobs) {
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
              ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Tugas sinkron');
            }
          },
        );
      },
      fireImmediately: true,
    );
  }

  void _saveLocal(List<JobDetail> jobs) {
    final nim = ref.read(dashboardControllerProvider).nim;
    if (nim.isEmpty) return;
    final local = ref.read(localStorageProvider);
    final localKey = 'jobs_$nim';
    local.write(localKey, jsonEncode(jobs.map((e) => e.toJson()).toList()));
  }

  Future<void> addJob(JobDetail job) async {
    final updatedJob = job.copyWith(
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    final updated = [...state, updatedJob]..sort((a, b) => b.date.compareTo(a.date));
    state = updated;
    _saveLocal(updated);
    
    final nim = ref.read(dashboardControllerProvider).nim;
    try {
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.uploading, 'Mengunggah tugas...');
      await ref.read(firebaseServiceProvider).saveJob(nim, updatedJob);
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Tugas terunggah');
    } catch (e) {
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.error, 'Gagal unggah tugas');
    }
  }

  Future<void> updateJob(JobDetail job) async {
    final updatedJob = job.copyWith(
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    final updated = state.map((e) => e.id == job.id ? updatedJob : e).toList()..sort((a, b) => b.date.compareTo(a.date));
    state = updated;
    _saveLocal(updated);
    
    final nim = ref.read(dashboardControllerProvider).nim;
    try {
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.uploading, 'Memperbarui tugas...');
      await ref.read(firebaseServiceProvider).saveJob(nim, updatedJob);
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Tugas diperbarui');
    } catch (e) {
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.error, 'Gagal update tugas');
    }
  }

  Future<void> deleteJob(String id) async {
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
    final deletedJob = updated.firstWhere((e) => e.id == id);
    try {
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.uploading, 'Menghapus tugas...');
      await ref.read(firebaseServiceProvider).saveJob(nim, deletedJob);
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Tugas terhapus');
    } catch (e) {
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.error, 'Gagal hapus tugas');
    }
  }

  Future<void> toggleJobCompletion(String id, bool isCompleted, String reason) async {
    final updated = state.map((e) {
      if (e.id == id) {
        return e.copyWith(
          isCompleted: isCompleted,
          reasonOfIncompletion: isCompleted ? '' : reason,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        );
      }
      return e;
    }).toList();
    state = updated;
    _saveLocal(updated);
    
    final nim = ref.read(dashboardControllerProvider).nim;
    final job = updated.firstWhere((e) => e.id == id);
    await ref.read(firebaseServiceProvider).saveJob(nim, job);
  }
}

@riverpod
Stream<List<JobDetail>> jobDetailsStream(Ref ref) {
  final jobs = ref.watch(jobProvider);
  return Stream.value(jobs.where((e) => !e.isDeleted).toList());
}

@riverpod
class JobController extends _$JobController {
  @override
  void build() {}

  /// Delegate methods to maintain compatibility with existing UI
  Future<void> addJob(JobDetail job) async {
    await ref.read(jobProvider.notifier).addJob(job);
  }

  Future<void> updateJob(JobDetail job) async {
    await ref.read(jobProvider.notifier).updateJob(job);
  }

  Future<void> deleteJob(String id) async {
    await ref.read(jobProvider.notifier).deleteJob(id);
  }

  Future<void> toggleJobCompletion(String id, bool isCompleted, String reason) async {
    await ref.read(jobProvider.notifier).toggleJobCompletion(id, isCompleted, reason);
  }
}
