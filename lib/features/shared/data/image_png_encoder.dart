import 'dart:typed_data';
import 'dart:ui' as ui;

/// Dimensi terpanjang yang aman untuk clipboard. Beberapa aplikasi penerima
/// (mis. Office) menolak gambar berukuran sangat besar.
const int kMaxClipboardDimension = 4096;

/// Mengubah [bytes] gambar apa pun menjadi PNG.
///
/// Clipboard API browser hanya menerima `image/png`, sedangkan aplikasi ini
/// menyimpan hasil kamera sebagai JPEG — jadi konversi ini wajib.
/// Bila [mimeType] sudah PNG, bytes dikembalikan apa adanya tanpa re-encode.
Future<Uint8List> encodeToPng(
  Uint8List bytes, {
  required String mimeType,
  int maxDimension = kMaxClipboardDimension,
}) async {
  if (mimeType.toLowerCase() == 'image/png') return bytes;

  final codec = await ui.instantiateImageCodec(bytes);
  try {
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final scaled = await _limitDimension(image, maxDimension);
    final data = await scaled.toByteData(format: ui.ImageByteFormat.png);

    image.dispose();
    if (!identical(scaled, image)) scaled.dispose();

    if (data == null) throw StateError('Gagal mengonversi gambar ke PNG.');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  } finally {
    codec.dispose();
  }
}

/// Perkecil sisi terpanjang bila melebihi [maxDimension].
Future<ui.Image> _limitDimension(ui.Image image, int maxDimension) async {
  final longest = image.width > image.height ? image.width : image.height;
  if (longest <= maxDimension) return image;

  final scale = maxDimension / longest;
  final recorder = ui.PictureRecorder();
  ui.Canvas(recorder).drawImageRect(
        image,
        ui.Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        ui.Rect.fromLTWH(0, 0, image.width * scale, image.height * scale),
        ui.Paint(),
      );

  return recorder.endRecording().toImage(
        (image.width * scale).round(),
        (image.height * scale).round(),
      );
}
