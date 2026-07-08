import 'dart:typed_data';

Future<Uint8List?> readFromWebCache(String url, String cacheName) async {
  return null;
}

Future<void> writeToWebCache(String url, Uint8List bytes, String mimeType, String cacheName) async {
  // Do nothing on non-web platforms
}
