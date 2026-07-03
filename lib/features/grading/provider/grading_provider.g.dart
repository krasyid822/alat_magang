// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grading_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GradingNotifier)
final gradingProvider = GradingNotifierProvider._();

final class GradingNotifierProvider
    extends $NotifierProvider<GradingNotifier, InternshipGrading> {
  GradingNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gradingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gradingNotifierHash();

  @$internal
  @override
  GradingNotifier create() => GradingNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InternshipGrading value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InternshipGrading>(value),
    );
  }
}

String _$gradingNotifierHash() => r'346f197889c12b9f870e467c1489fd36f29bd29f';

abstract class _$GradingNotifier extends $Notifier<InternshipGrading> {
  InternshipGrading build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<InternshipGrading, InternshipGrading>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InternshipGrading, InternshipGrading>,
              InternshipGrading,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(gradingStream)
final gradingStreamProvider = GradingStreamProvider._();

final class GradingStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<InternshipGrading>,
          InternshipGrading,
          Stream<InternshipGrading>
        >
    with
        $FutureModifier<InternshipGrading>,
        $StreamProvider<InternshipGrading> {
  GradingStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gradingStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gradingStreamHash();

  @$internal
  @override
  $StreamProviderElement<InternshipGrading> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<InternshipGrading> create(Ref ref) {
    return gradingStream(ref);
  }
}

String _$gradingStreamHash() => r'9f82c1c669386338ac7d21a4384406abf35ec9f2';

@ProviderFor(GradingController)
final gradingControllerProvider = GradingControllerProvider._();

final class GradingControllerProvider
    extends $NotifierProvider<GradingController, void> {
  GradingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gradingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gradingControllerHash();

  @$internal
  @override
  GradingController create() => GradingController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$gradingControllerHash() => r'03c496e3e4a4750b8ccf9a175f257b94caf4b461';

abstract class _$GradingController extends $Notifier<void> {
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
