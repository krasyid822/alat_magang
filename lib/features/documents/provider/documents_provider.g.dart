// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DocumentsNotifier)
final documentsProvider = DocumentsNotifierProvider._();

final class DocumentsNotifierProvider
    extends $NotifierProvider<DocumentsNotifier, List<DocChecklist>> {
  DocumentsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentsNotifierHash();

  @$internal
  @override
  DocumentsNotifier create() => DocumentsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DocChecklist> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DocChecklist>>(value),
    );
  }
}

String _$documentsNotifierHash() => r'836a8420aa33838bf9c150acbd1077d0385e99aa';

abstract class _$DocumentsNotifier extends $Notifier<List<DocChecklist>> {
  List<DocChecklist> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<DocChecklist>, List<DocChecklist>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<DocChecklist>, List<DocChecklist>>,
              List<DocChecklist>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(documentsStream)
final documentsStreamProvider = DocumentsStreamProvider._();

final class DocumentsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DocChecklist>>,
          List<DocChecklist>,
          Stream<List<DocChecklist>>
        >
    with
        $FutureModifier<List<DocChecklist>>,
        $StreamProvider<List<DocChecklist>> {
  DocumentsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<DocChecklist>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<DocChecklist>> create(Ref ref) {
    return documentsStream(ref);
  }
}

String _$documentsStreamHash() => r'0db80ad7c7bf91fbbc6900556d468eaf0d71c503';

@ProviderFor(DocumentsController)
final documentsControllerProvider = DocumentsControllerProvider._();

final class DocumentsControllerProvider
    extends $NotifierProvider<DocumentsController, void> {
  DocumentsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentsControllerHash();

  @$internal
  @override
  DocumentsController create() => DocumentsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$documentsControllerHash() =>
    r'39be112c89fda46b33a20014f88a13e760813c40';

abstract class _$DocumentsController extends $Notifier<void> {
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

@ProviderFor(BibliographyNotifier)
final bibliographyProvider = BibliographyNotifierProvider._();

final class BibliographyNotifierProvider
    extends $NotifierProvider<BibliographyNotifier, List<BookReference>> {
  BibliographyNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bibliographyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bibliographyNotifierHash();

  @$internal
  @override
  BibliographyNotifier create() => BibliographyNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<BookReference> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<BookReference>>(value),
    );
  }
}

String _$bibliographyNotifierHash() =>
    r'b6ef67c41d94b454d5d411e6b689d05a0be98e09';

abstract class _$BibliographyNotifier extends $Notifier<List<BookReference>> {
  List<BookReference> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<BookReference>, List<BookReference>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<BookReference>, List<BookReference>>,
              List<BookReference>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
