import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/data/models.dart';
import '../../shared/data/local_storage.dart';
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
        return ResearchData.fromJson(jsonDecode(cached));
      } catch (_) {}
    }
    return const ResearchData();
  }

  void _save(ResearchData research) {
    final nim = ref.read(dashboardControllerProvider).nim;
    if (nim.isEmpty) return;
    final local = ref.read(localStorageProvider);
    final localKey = 'research_$nim';
    local.write(localKey, jsonEncode(research.toJson()));
  }

  Future<void> updateResearch(ResearchData research) async {
    state = research;
    _save(research);
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
