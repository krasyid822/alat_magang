import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/data/models.dart';
import '../../shared/data/local_storage.dart';
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
        return list;
      } catch (_) {}
    }
    return [];
  }

  void _save(List<InternshipLog> logs) {
    final nim = ref.read(dashboardControllerProvider).nim;
    if (nim.isEmpty) return;
    final local = ref.read(localStorageProvider);
    final localKey = 'logs_$nim';
    local.write(localKey, jsonEncode(logs.map((e) => e.toJson()).toList()));
  }

  Future<void> addLog(InternshipLog log) async {
    final updated = [...state, log]..sort((a, b) => b.date.compareTo(a.date));
    state = updated;
    _save(updated);
  }

  Future<void> updateLog(InternshipLog log) async {
    final updated = state.map((e) => e.id == log.id ? log : e).toList()..sort((a, b) => b.date.compareTo(a.date));
    state = updated;
    _save(updated);
  }

  Future<void> deleteLog(String id) async {
    final updated = state.where((e) => e.id != id).toList();
    state = updated;
    _save(updated);
  }

  Future<void> toggleSign(String id, bool isSigned) async {
    final updated = state.map((e) => e.id == id ? e.copyWith(isSigned: isSigned, signatureData: isSigned ? e.signatureData : '') : e).toList();
    state = updated;
    _save(updated);
  }

  Future<void> saveSignature(String id, String signatureData) async {
    final updated = state.map((e) => e.id == id ? e.copyWith(isSigned: signatureData.isNotEmpty, signatureData: signatureData) : e).toList();
    state = updated;
    _save(updated);
  }
}

@riverpod
Stream<List<InternshipLog>> logbookStream(Ref ref) {
  final logs = ref.watch(logbookProvider);
  return Stream.value(logs);
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
