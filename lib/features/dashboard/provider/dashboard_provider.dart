import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/data/local_storage.dart';
import '../../shared/data/models.dart';
import '../../shared/data/firebase_service.dart';

part 'dashboard_provider.g.dart';

@riverpod
class DashboardController extends _$DashboardController {
  @override
  StudentProfile build() {
    final local = ref.read(localStorageProvider);
    final savedNim = local.getNim();
    
    if (savedNim != null && savedNim.isNotEmpty) {
      // Load from local first
      final cached = local.read('profile_$savedNim');
      if (cached != null) {
        try {
          final profile = StudentProfile.fromJson(jsonDecode(cached));
          _initCloudSync(savedNim);
          return profile;
        } catch (_) {}
      }
      _initCloudSync(savedNim);
      return StudentProfile(nim: savedNim);
    }
    return const StudentProfile(nim: '');
  }

  void _initCloudSync(String nim) {
    final local = ref.read(localStorageProvider);
    final deviceId = local.getDeviceId();
    
    // Register this device
    ref.read(firebaseServiceProvider).registerDevice(nim, deviceId);

    // 1. Cek data di cloud terlebih dahulu untuk rekonsiliasi awal
    Future.microtask(() async {
      try {
        if (!ref.mounted) return;
        ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.downloading, 'Mengecek cloud...');
        final cloudProfile = await ref.read(firebaseServiceProvider).getProfile(nim);
        if (!ref.mounted) return;
        
        if (cloudProfile != null) {
          // Check for global logout
          final lastLogout = cloudProfile.lastLogoutAllTimestamp ?? 0;
          final loginTs = local.getLoginTimestamp();
          if (lastLogout > loginTs) {
            if (cloudProfile.logoutAllForce) {
              await logout();
            } else {
              if (!ref.mounted) return;
              ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.uploading, 'Menyinkronkan data sebelum logout...');
              await _syncAllLocalDataToCloud(nim, lastLogout);
              if (!ref.mounted) return;
              await logout();
            }
            return;
          }

          // LWW Conflict Resolution
          if (cloudProfile.updatedAt >= state.updatedAt) {
            state = cloudProfile;
            local.write('profile_$nim', jsonEncode(cloudProfile.toJson()));
            if (!ref.mounted) return;
            ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Data dimuat dari cloud');
          } else {
            // Local is newer, upload to cloud
            if (!ref.mounted) return;
            ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.uploading, 'Mengunggah profil terbaru...');
            await ref.read(firebaseServiceProvider).saveProfile(state);
            if (!ref.mounted) return;
            ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Profil terunggah');
          }
        } else if (state.name.isNotEmpty || state.companyName.isNotEmpty) {
          // Cloud kosong tapi lokal punya data (device lama), migrasikan ke cloud
          if (!ref.mounted) return;
          ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.uploading, 'Migrasi ke cloud...');
          await ref.read(firebaseServiceProvider).saveProfile(state);
          if (!ref.mounted) return;
          ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Data termigrasi ke cloud');
        } else {
          if (!ref.mounted) return;
          ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Data dimuat dari cloud');
        }
      } catch (e) {
        if (!ref.mounted) return;
        ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.error, 'Gagal sinkron awal');
      }
    });

    // 2. Listen to cloud changes and update local state/cache (Real-time)
    final subscription = ref.read(firebaseServiceProvider).profileStream(nim).listen(
      (cloudProfile) {
        if (!ref.mounted) return;
        if (cloudProfile != null) {
          // Check for global logout in real-time
          final lastLogout = cloudProfile.lastLogoutAllTimestamp ?? 0;
          final loginTs = local.getLoginTimestamp();
          if (lastLogout > loginTs) {
            if (cloudProfile.logoutAllForce) {
              logout();
            } else {
              Future.microtask(() async {
                if (!ref.mounted) return;
                ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.uploading, 'Menyinkronkan data sebelum logout...');
                await _syncAllLocalDataToCloud(nim, lastLogout);
                if (!ref.mounted) return;
                await logout();
              });
            }
            return;
          }

          if (cloudProfile != state && cloudProfile.updatedAt > state.updatedAt) {
            state = cloudProfile;
            local.write('profile_$nim', jsonEncode(cloudProfile.toJson()));
            if (!ref.mounted) return;
            ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Sinkron');
          }
        }
      },
    );

    ref.onDispose(() {
      subscription.cancel();
    });
  }

  /// Memperbarui NIM aktif dan menyimpannya secara lokal
  void setNim(String nim) {
    if (nim.trim().isEmpty) return;
    final trimmed = nim.trim();
    final local = ref.read(localStorageProvider);
    local.saveNim(trimmed);
    local.saveLoginTimestamp(); // Track when this login session started

    // Cari profil lokal yang tersimpan untuk NIM ini
    final cached = local.read('profile_$trimmed');
    if (cached != null) {
      try {
        state = StudentProfile.fromJson(jsonDecode(cached));
        _initCloudSync(trimmed);
        return;
      } catch (_) {}
    }
    state = StudentProfile(nim: trimmed);
    _initCloudSync(trimmed);
  }

  /// Memperbarui informasi profil mahasiswa ke lokal dan cloud
  Future<void> updateProfile({
    required String name,
    required String className,
    required String major,
    required String companyName,
    int? internshipDurationWeeks,
    String? whatsappNumber,
  }) async {
    final updated = state.copyWith(
      name: name,
      className: className,
      major: major,
      companyName: companyName,
      internshipDurationWeeks: internshipDurationWeeks ?? state.internshipDurationWeeks,
      whatsappNumber: whatsappNumber ?? state.whatsappNumber,
      lastDeviceId: ref.read(localStorageProvider).getDeviceId(),
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    state = updated;
    
    // Save locally
    final local = ref.read(localStorageProvider);
    local.write('profile_${state.nim}', jsonEncode(updated.toJson()));

    // Save to cloud
    try {
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.uploading, 'Menyimpan profil...');
      await ref.read(firebaseServiceProvider).saveProfile(updated);
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Profil tersimpan');
    } catch (e) {
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.error, 'Gagal upload profil');
    }
  }

  Future<void> _syncAllLocalDataToCloud(String nim, int lastLogout) async {
    final local = ref.read(localStorageProvider);
    final firebase = ref.read(firebaseServiceProvider);

    // 1. Profil
    try {
      final cloudProfile = await firebase.getProfile(nim);
      if (cloudProfile != null) {
        if (state.updatedAt > cloudProfile.updatedAt) {
          await firebase.saveProfile(state);
        }
      }
    } catch (_) {}

    // 2. Logbook
    try {
      final cached = local.read('logs_$nim');
      if (cached != null) {
        final List decoded = jsonDecode(cached);
        final localLogs = decoded.map((e) => InternshipLog.fromJson(Map<String, dynamic>.from(e))).toList();
        final cloudLogs = await firebase.getLogs(nim);
        for (final item in localLogs) {
          final cloudItem = cloudLogs.firstWhere(
            (e) => e.id == item.id,
            orElse: () => const InternshipLog(id: '', date: '', activity: '', startTime: '', endTime: '', weekNumber: 0),
          );
          if (cloudItem.id.isEmpty) {
            // Jika data tidak ada di cloud, dan updatedAt lokal lebih lama dari lastLogout,
            // itu berarti data ini telah dihapus oleh device lain dan tombstone-nya sudah di-purge.
            // Jangan unggah kembali untuk menghindari kebangkitan data (resurrection).
            if (item.updatedAt < lastLogout) continue;
            await firebase.saveLog(nim, item);
          } else if (item.updatedAt > cloudItem.updatedAt) {
            await firebase.saveLog(nim, item);
          }
        }
      }
    } catch (_) {}

    // 3. Pekerjaan (Jobs)
    try {
      final cached = local.read('jobs_$nim');
      if (cached != null) {
        final List decoded = jsonDecode(cached);
        final localJobs = decoded.map((e) => JobDetail.fromJson(Map<String, dynamic>.from(e))).toList();
        final cloudJobs = await firebase.getJobs(nim);
        for (final item in localJobs) {
          final cloudItem = cloudJobs.firstWhere(
            (e) => e.id == item.id,
            orElse: () => const JobDetail(id: '', title: '', description: '', date: ''),
          );
          if (cloudItem.id.isEmpty) {
            if (item.updatedAt < lastLogout) continue;
            await firebase.saveJob(nim, item);
          } else if (item.updatedAt > cloudItem.updatedAt) {
            await firebase.saveJob(nim, item);
          }
        }
      }
    } catch (_) {}

    // 4. Dokumen
    try {
      final cached = local.read('documents_$nim');
      if (cached != null) {
        final List decoded = jsonDecode(cached);
        final localDocs = decoded.map((e) => DocChecklist.fromJson(Map<String, dynamic>.from(e))).toList();
        final cloudDocs = await firebase.getDocuments(nim);
        for (final item in localDocs) {
          final cloudItem = cloudDocs.firstWhere(
            (e) => e.id == item.id,
            orElse: () => const DocChecklist(id: '', title: '', category: ''),
          );
          if (cloudItem.id.isEmpty) {
            if (item.updatedAt < lastLogout) continue;
            await firebase.saveDocument(nim, item);
          } else if (item.updatedAt > cloudItem.updatedAt) {
            await firebase.saveDocument(nim, item);
          }
        }
      }
    } catch (_) {}

    // 5. Riset (Research)
    try {
      final cached = local.read('research_$nim');
      if (cached != null) {
        final localResearch = ResearchData.fromJson(jsonDecode(cached));
        final cloudResearch = await firebase.getResearchData(nim);
        if (cloudResearch == null) {
          if (localResearch.updatedAt < lastLogout) return;
          await firebase.saveResearchData(nim, localResearch);
        } else if (localResearch.updatedAt > cloudResearch.updatedAt) {
          await firebase.saveResearchData(nim, localResearch);
        }
      }
    } catch (_) {}
  }

  Future<void> logoutAll({bool force = false}) async {
    final nim = state.nim;
    if (nim.isEmpty) return;
    await ref.read(firebaseServiceProvider).logoutAll(nim, force: force);
    await logout();
  }

  /// Reset data / Logout
  Future<void> logout() async {
    final nim = state.nim;
    final local = ref.read(localStorageProvider);
    final deviceId = local.getDeviceId();
    if (nim.isNotEmpty) {
      try {
        await ref.read(firebaseServiceProvider).deleteSession(nim, deviceId);
      } catch (_) {}
      local.clearAllData(nim);
    }
    local.clearNim();
    state = const StudentProfile(nim: '');
    ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.offline, 'Belum Login');
  }
}

@riverpod
class SyncStatus extends _$SyncStatus {
  @override
  SyncState build() {
    final local = ref.read(localStorageProvider);
    final nim = local.getNim();
    if (nim == null || nim.isEmpty) {
      return const SyncState(status: SyncStatusType.offline, message: 'Belum Login');
    }
    return const SyncState(status: SyncStatusType.idle, message: 'Terhubung');
  }

  void setStatus(SyncStatusType status, String message) {
    state = state.copyWith(
      status: status,
      message: message,
      lastSynced: status == SyncStatusType.synced ? DateTime.now() : state.lastSynced,
    );
  }
}
