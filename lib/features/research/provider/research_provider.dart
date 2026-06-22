import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/data/models.dart';
import '../../shared/data/local_storage.dart';
import '../../shared/data/firebase_service.dart';
import '../../dashboard/provider/dashboard_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'research_provider.g.dart';

@riverpod
class ResearchNotifier extends _$ResearchNotifier {
  @override
  ResearchData build() {
    final nim = ref.watch(dashboardControllerProvider).nim;
    if (nim.isEmpty) return const ResearchData();

    final local = ref.read(localStorageProvider);
    final localKey = 'research_$nim';
    final cached = local.read(localKey);
    
    if (cached != null) {
      try {
        final data = ResearchData.fromJson(jsonDecode(cached));
        _initCloudSync(nim);
        return data;
      } catch (_) {}
    }
    
    _initCloudSync(nim);
    return const ResearchData();
  }

  void _initCloudSync(String nim) {
    // 1. Rekonsiliasi awal
    Future.microtask(() async {
      try {
        if (!ref.mounted) return;
        ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.downloading, 'Mengecek riset...');
        final cloudData = await ref.read(firebaseServiceProvider).getResearchData(nim);
        if (!ref.mounted) return;
        
        if (cloudData != null) {
          if (cloudData.updatedAt >= state.updatedAt) {
            state = cloudData;
            _saveLocal(cloudData);
            if (!ref.mounted) return;
            ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Riset dimuat');
          } else {
            // Local is newer, upload to cloud
            if (!ref.mounted) return;
            ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.uploading, 'Mengunggah riset terbaru...');
            await ref.read(firebaseServiceProvider).saveResearchData(nim, state);
            if (!ref.mounted) return;
            ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Riset terunggah');
          }
        } else if (state.companyHistory.isNotEmpty || state.jobDescription.isNotEmpty) {
          if (!ref.mounted) return;
          ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.uploading, 'Migrasi riset...');
          await ref.read(firebaseServiceProvider).saveResearchData(nim, state);
          if (!ref.mounted) return;
          ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Riset termigrasi');
        } else {
          if (!ref.mounted) return;
          ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Riset dimuat');
        }
      } catch (e) {
        if (!ref.mounted) return;
        ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.error, 'Gagal sinkron riset');
      }
    });

    // 2. Real-time
    final subscription = ref.read(firebaseServiceProvider).researchDataStream(nim).listen(
      (cloudData) {
        if (!ref.mounted) return;
        if (cloudData != null && cloudData != state && cloudData.updatedAt > state.updatedAt) {
          state = cloudData;
          _saveLocal(cloudData);
          if (!ref.mounted) return;
          ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Riset sinkron');
        }
      },
    );

    ref.onDispose(() {
      subscription.cancel();
    });
  }

  void _saveLocal(ResearchData research) {
    final nim = ref.read(dashboardControllerProvider).nim;
    if (nim.isEmpty) return;
    final local = ref.read(localStorageProvider);
    final localKey = 'research_$nim';
    local.write(localKey, jsonEncode(research.toJson()));
  }

  Future<void> updateResearch(ResearchData research) async {
    final updated = research.copyWith(
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    state = updated;
    _saveLocal(updated);
    
    final nim = ref.read(dashboardControllerProvider).nim;
    try {
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.uploading, 'Mengunggah riset...');
      await ref.read(firebaseServiceProvider).saveResearchData(nim, updated);
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Riset terunggah');
    } catch (e) {
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.error, 'Gagal unggah riset');
    }
  }
}

@riverpod
Stream<ResearchData> researchStream(Ref ref) {
  final research = ref.watch(researchProvider);
  return Stream.value(research);
}

@riverpod
class ResearchController extends _$ResearchController {
  @override
  void build() {}

  /// Delegate method to maintain compatibility with existing UI
  Future<void> updateResearch(ResearchData research) async {
    await ref.read(researchProvider.notifier).updateResearch(research);
  }
}
