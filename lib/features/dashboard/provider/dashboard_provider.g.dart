// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DashboardController)
final dashboardControllerProvider = DashboardControllerProvider._();

final class DashboardControllerProvider
    extends $NotifierProvider<DashboardController, StudentProfile> {
  DashboardControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardControllerHash();

  @$internal
  @override
  DashboardController create() => DashboardController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StudentProfile value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StudentProfile>(value),
    );
  }
}

String _$dashboardControllerHash() =>
    r'1f1fd58e7ae26799c6fa0e561d5c63eeb7c80899';

abstract class _$DashboardController extends $Notifier<StudentProfile> {
  StudentProfile build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<StudentProfile, StudentProfile>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StudentProfile, StudentProfile>,
              StudentProfile,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(SyncStatus)
final syncStatusProvider = SyncStatusProvider._();

final class SyncStatusProvider
    extends $NotifierProvider<SyncStatus, SyncState> {
  SyncStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncStatusHash();

  @$internal
  @override
  SyncStatus create() => SyncStatus();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncState>(value),
    );
  }
}

String _$syncStatusHash() => r'178ee8d84ddb08ec924bcddee079a228cf64fcfc';

abstract class _$SyncStatus extends $Notifier<SyncState> {
  SyncState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SyncState, SyncState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncState, SyncState>,
              SyncState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
