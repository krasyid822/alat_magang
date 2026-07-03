import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/data/models.dart';
import '../../shared/data/local_storage.dart';
import '../../shared/data/firebase_service.dart';
import '../../dashboard/provider/dashboard_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'grading_provider.g.dart';

@riverpod
class GradingNotifier extends _$GradingNotifier {
  @override
  InternshipGrading build() {
    final nim = ref.watch(dashboardControllerProvider).nim;
    if (nim.isEmpty) return InternshipGrading(nim: '');

    final local = ref.read(localStorageProvider);
    final localKey = 'grading_$nim';
    final cached = local.read(localKey);
    
    if (cached != null) {
      try {
        final data = InternshipGrading.fromJson(jsonDecode(cached));
        _initCloudSync(nim);
        return data;
      } catch (_) {}
    }
    
    _initCloudSync(nim);
    return InternshipGrading(nim: nim);
  }

  void _initCloudSync(String nim) {
    // 1. Initial reconciliation
    Future.microtask(() async {
      try {
        if (!ref.mounted) return;
        ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.downloading, 'Mengecek nilai...');
        final cloudData = await ref.read(firebaseServiceProvider).getGrading(nim);
        if (!ref.mounted) return;
        
        if (cloudData != null) {
          if (cloudData.updatedAt >= state.updatedAt) {
            state = cloudData;
            _saveLocal(cloudData);
            if (!ref.mounted) return;
            ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Nilai dimuat');
          } else {
            // Local is newer, upload to cloud
            if (!ref.mounted) return;
            ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.uploading, 'Mengunggah nilai terbaru...');
            await ref.read(firebaseServiceProvider).saveGrading(nim, state);
            if (!ref.mounted) return;
            ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Nilai terunggah');
          }
        } else if (_hasData(state)) {
          if (!ref.mounted) return;
          ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.uploading, 'Migrasi nilai...');
          await ref.read(firebaseServiceProvider).saveGrading(nim, state);
          if (!ref.mounted) return;
          ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Nilai termigrasi');
        } else {
          if (!ref.mounted) return;
          ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Nilai dimuat');
        }
      } catch (e) {
        if (!ref.mounted) return;
        ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.error, 'Gagal sinkron nilai');
      }
    });

    // 2. Real-time stream
    final subscription = ref.read(firebaseServiceProvider).gradingStream(nim).listen(
      (cloudData) {
        if (!ref.mounted) return;
        if (cloudData != null && cloudData != state && cloudData.updatedAt > state.updatedAt) {
          state = cloudData;
          _saveLocal(cloudData);
          if (!ref.mounted) return;
          ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Nilai sinkron');
        }
      },
    );

    ref.onDispose(() {
      subscription.cancel();
    });
  }

  bool _hasData(InternshipGrading data) {
    return data.companyKerapian > 0 ||
        data.companyDisiplin > 0 ||
        data.companyKehadiran > 0 ||
        data.companyTanggungJawab > 0 ||
        data.companyKemandirian > 0 ||
        data.companyInisiatif > 0 ||
        data.companyPemahaman > 0 ||
        data.companyKerjasamaRekan > 0 ||
        data.companyKerjasamaAtasan > 0 ||
        data.companyAdaptasi > 0 ||
        data.dosenFormatLaporan > 0 ||
        data.dosenUraianLaporan > 0 ||
        data.dosenPresentasiLaporan > 0 ||
        data.dosenTanyaJawabLaporan > 0;
  }

  void _saveLocal(InternshipGrading grading) {
    final nim = ref.read(dashboardControllerProvider).nim;
    if (nim.isEmpty) return;
    final local = ref.read(localStorageProvider);
    final localKey = 'grading_$nim';
    local.write(localKey, jsonEncode(grading.toJson()));
  }

  Future<void> updateGrading(InternshipGrading grading) async {
    final updated = grading.copyWith(
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    state = updated;
    _saveLocal(updated);
    
    final nim = ref.read(dashboardControllerProvider).nim;
    try {
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.uploading, 'Mengunggah nilai...');
      await ref.read(firebaseServiceProvider).saveGrading(nim, updated);
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'Nilai terunggah');
    } catch (e) {
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.error, 'Gagal unggah nilai');
    }
  }

  // Helper calculations
  double get averageCompanyScore {
    final total = state.companyKerapian +
        state.companyDisiplin +
        state.companyKehadiran +
        state.companyTanggungJawab +
        state.companyKemandirian +
        state.companyInisiatif +
        state.companyPemahaman +
        state.companyKerjasamaRekan +
        state.companyKerjasamaAtasan +
        state.companyAdaptasi;
    return total / 10.0;
  }

  double get weightedDosenScore {
    return (state.dosenFormatLaporan * 0.15) +
        (state.dosenUraianLaporan * 0.25) +
        (state.dosenPresentasiLaporan * 0.20) +
        (state.dosenTanyaJawabLaporan * 0.40);
  }

  double get finalScore {
    // Rata-rata 50% Nilai Perusahaan dan 50% Nilai Dosen Pembimbing
    return (averageCompanyScore + weightedDosenScore) / 2.0;
  }

  String get companyGradeLetter => _convertToGradeLetter(averageCompanyScore);
  String get dosenGradeLetter => _convertToGradeLetter(weightedDosenScore);
  String get finalGradeLetter => _convertToGradeLetter(finalScore);

  String _convertToGradeLetter(double score) {
    if (score >= 80) return 'A';
    if (score >= 75) return 'B+';
    if (score >= 70) return 'B';
    if (score >= 60) return 'C+';
    if (score >= 50) return 'C';
    return 'D / E';
  }

  String getGradeCriteria(String gradeLetter) {
    switch (gradeLetter) {
      case 'A': return 'Istimewa';
      case 'B+': return 'Sangat Baik';
      case 'B': return 'Baik';
      case 'C+': return 'Cukup Baik';
      case 'C': return 'Cukup';
      default: return 'Tidak Lulus';
    }
  }
}

@riverpod
Stream<InternshipGrading> gradingStream(Ref ref) {
  final grading = ref.watch(gradingProvider);
  return Stream.value(grading);
}

@riverpod
class GradingController extends _$GradingController {
  @override
  void build() {}

  Future<void> updateGrading(InternshipGrading grading) async {
    await ref.read(gradingProvider.notifier).updateGrading(grading);
  }
}
