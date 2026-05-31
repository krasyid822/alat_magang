import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/data/local_storage.dart';
import '../../shared/data/models.dart';

part 'dashboard_provider.g.dart';

@riverpod
class DashboardController extends _$DashboardController {
  @override
  StudentProfile build() {
    final local = ref.read(localStorageProvider);
    final savedNim = local.getNim();
    if (savedNim != null && savedNim.isNotEmpty) {
      final cached = local.read('profile_$savedNim');
      if (cached != null) {
        try {
          return StudentProfile.fromJson(jsonDecode(cached));
        } catch (_) {}
      }
      return StudentProfile(nim: savedNim);
    }
    return const StudentProfile(nim: '');
  }

  /// Memperbarui NIM aktif dan menyimpannya secara lokal
  void setNim(String nim) {
    if (nim.trim().isEmpty) return;
    final trimmed = nim.trim();
    final local = ref.read(localStorageProvider);
    local.saveNim(trimmed);

    // Cari profil lokal yang tersimpan untuk NIM ini
    final cached = local.read('profile_$trimmed');
    if (cached != null) {
      try {
        state = StudentProfile.fromJson(jsonDecode(cached));
        return;
      } catch (_) {}
    }
    state = StudentProfile(nim: trimmed);
  }

  /// Memperbarui informasi profil mahasiswa ke lokal
  Future<void> updateProfile({
    required String name,
    required String className,
    required String major,
    required String companyName,
    int? internshipDurationWeeks,
  }) async {
    final updated = state.copyWith(
      name: name,
      className: className,
      major: major,
      companyName: companyName,
      internshipDurationWeeks: internshipDurationWeeks ?? state.internshipDurationWeeks,
    );
    state = updated;
    
    final local = ref.read(localStorageProvider);
    local.write('profile_${state.nim}', jsonEncode(updated.toJson()));
  }

  /// Reset data / Logout
  void logout() {
    ref.read(localStorageProvider).clearNim();
    state = const StudentProfile(nim: '');
  }
}

@riverpod
Stream<Map<String, dynamic>?> studentDataStream(Ref ref) {
  return Stream.value(null);
}

@riverpod
class SyncStatus extends _$SyncStatus {
  @override
  String build() {
    final nim = ref.watch(dashboardControllerProvider).nim;
    if (nim.isEmpty) return 'Belum Login';
    return 'Penyimpanan Lokal (Aktif)';
  }
}
