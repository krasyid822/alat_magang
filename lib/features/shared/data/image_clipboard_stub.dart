import 'dart:typed_data';

/// Fallback untuk platform non-web. Proyek ini web-only, jadi file ini hanya
/// menjaga agar kode tetap bisa dikompilasi di analyzer dan unit test.
bool get isImageClipboardSupported => false;

Future<void> writePngToClipboard(Uint8List pngBytes) async {
  throw UnsupportedError('Copy gambar ke clipboard hanya tersedia di web.');
}

Future<Uint8List?> fetchUrlAsBytes(String url) async => null;
