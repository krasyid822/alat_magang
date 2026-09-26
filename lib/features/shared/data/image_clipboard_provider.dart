import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../dashboard/provider/dashboard_provider.dart';
import '../presentation/web_cache_helper.dart';
import 'file_chunk_service.dart';
import 'image_clipboard.dart';
import 'image_png_encoder.dart';

part 'image_clipboard_provider.g.dart';

enum ImageClipboardStatus { idle, copying, success, failure }

class ImageClipboardState {
  final ImageClipboardStatus status;
  final String? message;

  const ImageClipboardState(this.status, [this.message]);

  bool get isBusy => status == ImageClipboardStatus.copying;
}

/// Menyediakan aksi "copy gambar ke clipboard" untuk seluruh aplikasi.
///
/// Alur: resolve URL → byte asli → konversi PNG → tulis ke clipboard browser.
/// Konversi ke PNG wajib karena Clipboard API hanya menerima `image/png`.
@riverpod
class ImageClipboardNotifier extends _$ImageClipboardNotifier {
  /// Harus sama dengan cache yang ditulis `ChunkedImage` agar tidak mengunduh
  /// ulang gambar yang sudah pernah dimuat.
  // TODO: `web_cache_helper` sebenarnya layanan IO platform, bukan UI —
  // Idealnya dipindahkan ke shared/data/ agar lapisan ini tidak import presentation.
  static const String _webCacheName = 'chunked_image_cache';

  @override
  ImageClipboardState build() => const ImageClipboardState(ImageClipboardStatus.idle);

  void reset() => state = const ImageClipboardState(ImageClipboardStatus.idle);

  /// Menyalin gambar pada [url] ke clipboard. Mengembalikan `true` bila sukses.
  Future<bool> copyFromUrl(String url) async {
    if (state.isBusy) return false;
    if (!isImageClipboardSupported) {
      state = const ImageClipboardState(
        ImageClipboardStatus.failure,
        'Browser tidak mendukung copy gambar ke clipboard.',
      );
      return false;
    }

    state = const ImageClipboardState(ImageClipboardStatus.copying);

    try {
      final bytes = await _resolveBytes(url);
      if (bytes == null || bytes.isEmpty) {
        state = const ImageClipboardState(
          ImageClipboardStatus.failure,
          'Gambar tidak ditemukan atau gagal dimuat.',
        );
        return false;
      }

      final png = await _toPng(bytes, _mimeTypeOf(url));
      await writePngToClipboard(png);

      state = const ImageClipboardState(ImageClipboardStatus.success);
      return true;
    } catch (e) {
      state = ImageClipboardState(ImageClipboardStatus.failure, _describeError(e));
      return false;
    }
  }

  /// Mengambil byte gambar dari berbagai bentuk URL yang dipakai aplikasi.
  Future<Uint8List?> _resolveBytes(String url) async {
    if (url.isEmpty) return null;

    // 1. Data URL (hasil kamera: canvas.toDataUrl)
    if (url.startsWith('data:')) {
      final comma = url.indexOf(',');
      if (comma < 0) return null;
      final payload = url.substring(comma + 1);
      if (url.substring(0, comma).contains(';base64')) {
        return base64Decode(payload);
      }
      // Data URL non-base64 (jarang, hasil kamera di app ini selalu base64).
      return Uint8List.fromList(Uri.decodeComponent(payload).codeUnits);
    }

    // 2. File chunked di Firestore
    if (url.startsWith(kChunkedPrefix)) {
      // Jangan sebut `ref` — variabel itu akan memblokir `ref` milik Riverpod.
      final fileRef = ChunkedFileRef.fromUrl(url);
      if (fileRef == null) return null;

      final cached = await readFromWebCache(url, _webCacheName);
      if (cached != null) return cached;

      final nim = ref.read(dashboardControllerProvider).nim;
      if (nim.isEmpty) return null;
      return fileChunkService.downloadFile(nim, fileRef);
    }

    // 3. URL http(s) biasa
    return fetchUrlAsBytes(url);
  }

  Future<Uint8List> _toPng(Uint8List bytes, String mimeType) {
    return encodeToPng(bytes, mimeType: mimeType);
  }

  String _mimeTypeOf(String url) {
    final ref = ChunkedFileRef.fromUrl(url);
    if (ref != null) return ref.mimeType;
    if (url.startsWith('data:')) {
      final comma = url.indexOf(',');
      if (comma > 0) return url.substring(5, comma).split(';').first;
    }
    return '';
  }

  String _describeError(Object error) {
    final text = error.toString();
    if (text.contains('NotAllowedError')) {
      return 'Browser menolak akses clipboard. Coba lagi dengan cara klik langsung.';
    }
    if (text.contains('DOMException') || text.contains('UnknownError')) {
      return 'Gagal menulis ke clipboard. Pastikan halaman dalam status aktif.';
    }
    return 'Gagal menyalin gambar.';
  }
}
