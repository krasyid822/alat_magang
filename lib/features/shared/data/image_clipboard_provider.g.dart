// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_clipboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Menyediakan aksi "copy gambar ke clipboard" untuk seluruh aplikasi.
///
/// Alur: resolve URL → byte asli → konversi PNG → tulis ke clipboard browser.
/// Konversi ke PNG wajib karena Clipboard API hanya menerima `image/png`.

@ProviderFor(ImageClipboardNotifier)
final imageClipboardProvider = ImageClipboardNotifierProvider._();

/// Menyediakan aksi "copy gambar ke clipboard" untuk seluruh aplikasi.
///
/// Alur: resolve URL → byte asli → konversi PNG → tulis ke clipboard browser.
/// Konversi ke PNG wajib karena Clipboard API hanya menerima `image/png`.
final class ImageClipboardNotifierProvider
    extends $NotifierProvider<ImageClipboardNotifier, ImageClipboardState> {
  /// Menyediakan aksi "copy gambar ke clipboard" untuk seluruh aplikasi.
  ///
  /// Alur: resolve URL → byte asli → konversi PNG → tulis ke clipboard browser.
  /// Konversi ke PNG wajib karena Clipboard API hanya menerima `image/png`.
  ImageClipboardNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageClipboardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageClipboardNotifierHash();

  @$internal
  @override
  ImageClipboardNotifier create() => ImageClipboardNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageClipboardState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageClipboardState>(value),
    );
  }
}

String _$imageClipboardNotifierHash() =>
    r'c1c1faa20494dff28042d6838aef36491aa09cab';

/// Menyediakan aksi "copy gambar ke clipboard" untuk seluruh aplikasi.
///
/// Alur: resolve URL → byte asli → konversi PNG → tulis ke clipboard browser.
/// Konversi ke PNG wajib karena Clipboard API hanya menerima `image/png`.

abstract class _$ImageClipboardNotifier extends $Notifier<ImageClipboardState> {
  ImageClipboardState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ImageClipboardState, ImageClipboardState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ImageClipboardState, ImageClipboardState>,
              ImageClipboardState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
