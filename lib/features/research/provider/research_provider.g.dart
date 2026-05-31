// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'research_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ResearchNotifier)
final researchProvider = ResearchNotifierProvider._();

final class ResearchNotifierProvider
    extends $NotifierProvider<ResearchNotifier, ResearchData> {
  ResearchNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'researchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$researchNotifierHash();

  @$internal
  @override
  ResearchNotifier create() => ResearchNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResearchData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResearchData>(value),
    );
  }
}

String _$researchNotifierHash() => r'fdecaef92a71ec2ff5567190db0c1d0fecf5c195';

abstract class _$ResearchNotifier extends $Notifier<ResearchData> {
  ResearchData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ResearchData, ResearchData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ResearchData, ResearchData>,
              ResearchData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(researchStream)
final researchStreamProvider = ResearchStreamProvider._();

final class ResearchStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<ResearchData>,
          ResearchData,
          Stream<ResearchData>
        >
    with $FutureModifier<ResearchData>, $StreamProvider<ResearchData> {
  ResearchStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'researchStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$researchStreamHash();

  @$internal
  @override
  $StreamProviderElement<ResearchData> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ResearchData> create(Ref ref) {
    return researchStream(ref);
  }
}

String _$researchStreamHash() => r'b1928ebb0cc258ef9f0e6d7429d5095f5e750644';

@ProviderFor(ResearchController)
final researchControllerProvider = ResearchControllerProvider._();

final class ResearchControllerProvider
    extends $NotifierProvider<ResearchController, void> {
  ResearchControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'researchControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$researchControllerHash();

  @$internal
  @override
  ResearchController create() => ResearchController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$researchControllerHash() =>
    r'ad651e0bc65b0f2665afc0e1472274fdfffb0839';

abstract class _$ResearchController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
