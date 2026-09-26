import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Browser hanya menerima `image/png` di `ClipboardItem`. Format lain (JPEG,
/// WebP) harus dikonversi lebih dulu oleh pemanggil.
const String kClipboardImageMimeType = 'image/png';

/// Apakah browser mendukung `ClipboardItem` untuk gambar PNG.
bool get isImageClipboardSupported {
  try {
    return web.ClipboardItem.supports(kClipboardImageMimeType);
  } catch (_) {
    return false;
  }
}

/// Menulis [pngBytes] ke clipboard browser sebagai gambar.
///
/// Wajib dipanggil langsung dari gesture pengguna, dan halaman harus berada di
/// secure context (HTTPS atau localhost).
Future<void> writePngToClipboard(Uint8List pngBytes) async {
  if (!isImageClipboardSupported) {
    throw UnsupportedError('Browser tidak mendukung copy gambar ke clipboard.');
  }

  final blob = web.Blob(
    <web.BlobPart>[pngBytes.toJS].toJS,
    web.BlobPropertyBag(type: kClipboardImageMimeType),
  );

  // `ClipboardItem` menerima JSObject, jadi record dibangun eksplisit.
  final record = JSObject();
  record.setProperty(kClipboardImageMimeType.toJS, blob);
  final item = web.ClipboardItem(record);

  await web.window.navigator.clipboard.write(<web.ClipboardItem>[item].toJS).toDart;
}

/// Mengambil byte mentah dari URL http(s) biasa.
Future<Uint8List?> fetchUrlAsBytes(String url) async {
  try {
    final response = await web.window.fetch(url.toJS).toDart;
    if (!response.ok) return null;
    final buffer = await response.arrayBuffer().toDart;
    return buffer.toDart.asUint8List();
  } catch (e) {
    return null;
  }
}
