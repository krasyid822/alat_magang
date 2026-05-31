import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/data/models.dart';
import '../../shared/data/local_storage.dart';
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
        return list;
      } catch (_) {}
    }
    return [];
  }

  void _save(List<JobDetail> jobs) {
    final nim = ref.read(dashboardControllerProvider).nim;
    if (nim.isEmpty) return;
    final local = ref.read(localStorageProvider);
    final localKey = 'jobs_$nim';
    local.write(localKey, jsonEncode(jobs.map((e) => e.toJson()).toList()));
  }

  Future<void> addJob(JobDetail job) async {
    final updated = [...state, job]..sort((a, b) => b.date.compareTo(a.date));
    state = updated;
    _save(updated);
  }

  Future<void> updateJob(JobDetail job) async {
    final updated = state.map((e) => e.id == job.id ? job : e).toList()..sort((a, b) => b.date.compareTo(a.date));
    state = updated;
    _save(updated);
  }

  Future<void> deleteJob(String id) async {
    final updated = state.where((e) => e.id != id).toList();
    state = updated;
    _save(updated);
  }

  Future<void> toggleJobCompletion(String id, bool isCompleted, String reason) async {
    final updated = state.map((e) {
      if (e.id == id) {
        return e.copyWith(
          isCompleted: isCompleted,
          reasonOfIncompletion: isCompleted ? '' : reason,
        );
      }
      return e;
    }).toList();
    state = updated;
    _save(updated);
  }
}

@riverpod
Stream<List<JobDetail>> jobDetailsStream(Ref ref) {
  final jobs = ref.watch(jobProvider);
  return Stream.value(jobs);
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
