import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:js/js_util.dart';

String _getCacheUrl(String url) {
  return url.replaceFirst('chunked:', 'https://local-chunked/');
}

Future<Uint8List?> readFromWebCache(String url, String cacheName) async {
  try {
    final cachesObj = html.window.caches;
    if (cachesObj == null) return null;

    final cacheObj = await promiseToFuture(
      callMethod(cachesObj, 'open', [cacheName])
    );
    if (cacheObj == null) return null;

    final cacheUrl = _getCacheUrl(url);
    final responseObj = await promiseToFuture(
      callMethod(cacheObj, 'match', [cacheUrl])
    );
    if (responseObj == null) return null;

    final blob = await promiseToFuture(
      callMethod(responseObj, 'blob', [])
    );
    if (blob == null) return null;

    final reader = html.FileReader();
    reader.readAsArrayBuffer(blob as html.Blob);
    await reader.onLoadEnd.first;
    
    final result = reader.result;
    if (result is Uint8List) {
      return result;
    } else if (result is ByteBuffer) {
      return result.asUint8List();
    } else if (result is List<int>) {
      return Uint8List.fromList(result);
    }
  } catch (e) {
    debugPrint('Error reading from Web Cache: $e');
  }
  return null;
}

Future<void> writeToWebCache(String url, Uint8List bytes, String mimeType, String cacheName) async {
  try {
    final cachesObj = html.window.caches;
    if (cachesObj == null) return;

    final cacheObj = await promiseToFuture(
      callMethod(cachesObj, 'open', [cacheName])
    );
    if (cacheObj == null) return;

    final responseConstructor = getProperty(html.window, 'Response');
    final response = callConstructor(responseConstructor, [
      bytes,
      jsify({
        'headers': {'content-type': mimeType}
      })
    ]);

    final cacheUrl = _getCacheUrl(url);
    await promiseToFuture(
      callMethod(cacheObj, 'put', [cacheUrl, response])
    );
  } catch (e) {
    debugPrint('Error writing to Web Cache: $e');
  }
}
