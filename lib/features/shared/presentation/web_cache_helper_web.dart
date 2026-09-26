import 'dart:js_interop';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

/// URL chunked bukan URL sungguhan, jadi harus dipetakan ke origin yang valid
/// sebelum dipakai sebagai kunci Cache Storage.
String _toCacheUrl(String url) {
  return url.replaceFirst('chunked:', 'https://local-chunked/');
}

/// Membaca byte dari Web Cache Storage. `null` bila tidak ada / gagal.
Future<Uint8List?> readFromWebCache(String url, String cacheName) async {
  try {
    final cache = await web.window.caches.open(cacheName).toDart;
    final response = await cache.match(_toCacheUrl(url).toJS).toDart;
    if (response == null) return null;

    final blob = await response.blob().toDart;
    final buffer = await blob.arrayBuffer().toDart;
    return buffer.toDart.asUint8List();
  } catch (e) {
    // Cache Storage tidak tersedia di beberapa konteks (mis. iframe non-secure).
    debugPrint('Error reading from Web Cache: $e');
    return null;
  }
}

/// Menyimpan byte ke Web Cache Storage agar tidak diunduh ulang dari Firestore.
Future<void> writeToWebCache(
  String url,
  Uint8List bytes,
  String mimeType,
  String cacheName,
) async {
  try {
    final cache = await web.window.caches.open(cacheName).toDart;

    final headers = web.Headers();
    headers.set('content-type', mimeType);

    final response = web.Response(
      bytes.toJS,
      web.ResponseInit(headers: headers),
    );

    await cache.put(_toCacheUrl(url).toJS, response).toDart;
  } catch (e) {
    // Gagal menulis cache tidak boleh menggagalkan pemuatan gambar.
    debugPrint('Error writing to Web Cache: $e');
  }
}
