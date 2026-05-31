// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logbook_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LogbookNotifier)
final logbookProvider = LogbookNotifierProvider._();

final class LogbookNotifierProvider
    extends $NotifierProvider<LogbookNotifier, List<InternshipLog>> {
  LogbookNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logbookProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logbookNotifierHash();

  @$internal
  @override
  LogbookNotifier create() => LogbookNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<InternshipLog> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<InternshipLog>>(value),
    );
  }
}

String _$logbookNotifierHash() => r'b2dc2edfa3da57d3458e2539b56f4150fc7a7126';

abstract class _$LogbookNotifier extends $Notifier<List<InternshipLog>> {
  List<InternshipLog> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<InternshipLog>, List<InternshipLog>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<InternshipLog>, List<InternshipLog>>,
              List<InternshipLog>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(logbookStream)
final logbookStreamProvider = LogbookStreamProvider._();

final class LogbookStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<InternshipLog>>,
          List<InternshipLog>,
          Stream<List<InternshipLog>>
        >
    with
        $FutureModifier<List<InternshipLog>>,
        $StreamProvider<List<InternshipLog>> {
  LogbookStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logbookStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logbookStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<InternshipLog>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<InternshipLog>> create(Ref ref) {
    return logbookStream(ref);
  }
}

String _$logbookStreamHash() => r'9777f75b828080e16136a2cb17ad05156463e7b8';

@ProviderFor(LogbookController)
final logbookControllerProvider = LogbookControllerProvider._();

final class LogbookControllerProvider
    extends $NotifierProvider<LogbookController, void> {
  LogbookControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logbookControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logbookControllerHash();

  @$internal
  @override
  LogbookController create() => LogbookController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$logbookControllerHash() => r'65e22a87eee49d7117e6d380f0cfd8360fb1f247';

abstract class _$LogbookController extends $Notifier<void> {
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
