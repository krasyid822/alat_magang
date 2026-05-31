// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(JobNotifier)
final jobProvider = JobNotifierProvider._();

final class JobNotifierProvider
    extends $NotifierProvider<JobNotifier, List<JobDetail>> {
  JobNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jobProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jobNotifierHash();

  @$internal
  @override
  JobNotifier create() => JobNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<JobDetail> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<JobDetail>>(value),
    );
  }
}

String _$jobNotifierHash() => r'0f429619a72f74a83ab8a9dc1acb2961bdcb243d';

abstract class _$JobNotifier extends $Notifier<List<JobDetail>> {
  List<JobDetail> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<JobDetail>, List<JobDetail>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<JobDetail>, List<JobDetail>>,
              List<JobDetail>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(jobDetailsStream)
final jobDetailsStreamProvider = JobDetailsStreamProvider._();

final class JobDetailsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<JobDetail>>,
          List<JobDetail>,
          Stream<List<JobDetail>>
        >
    with $FutureModifier<List<JobDetail>>, $StreamProvider<List<JobDetail>> {
  JobDetailsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jobDetailsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jobDetailsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<JobDetail>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<JobDetail>> create(Ref ref) {
    return jobDetailsStream(ref);
  }
}

String _$jobDetailsStreamHash() => r'd4d11f2ee1c4d70c395b8dd6336570b731b4bcb8';

@ProviderFor(JobController)
final jobControllerProvider = JobControllerProvider._();

final class JobControllerProvider
    extends $NotifierProvider<JobController, void> {
  JobControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jobControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jobControllerHash();

  @$internal
  @override
  JobController create() => JobController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$jobControllerHash() => r'6c279e61b0ff08a0e050e61de0034b7533b87579';

abstract class _$JobController extends $Notifier<void> {
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
