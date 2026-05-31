import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

class IndexedDBService {
  static const String dbName = 'AlatMagangFilesDB';
  static const int dbVersion = 1;
  static const String storeName = 'files';

  dynamic _db;

  Future<void> initDB() async {
    if (_db != null) return;
    
    final idb = html.window.indexedDB;
    if (idb == null) {
      throw Exception('IndexedDB is not supported in this browser.');
    }
    
    _db = await idb.open(
      dbName,
      version: dbVersion,
      onUpgradeNeeded: (dynamic e) {
        final db = e.target.result;
        if (!db.objectStoreNames!.contains(storeName)) {
          db.createObjectStore(storeName, keyPath: 'id');
        }
      },
    );
  }

  Future<void> saveFile({
    required String id,
    required String fileName,
    required Uint8List bytes,
    String? mimeType,
  }) async {
    await initDB();
    
    final transaction = _db!.transaction(storeName, 'readwrite');
    final store = transaction.objectStore(storeName);
    
    final blob = html.Blob([bytes], mimeType ?? 'application/octet-stream');
    
    await store.put({
      'id': id,
      'fileName': fileName,
      'data': blob,
      'mimeType': mimeType,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    
    await transaction.completed;
  }

  Future<Map<String, dynamic>?> getFile(String id) async {
    await initDB();
    
    final transaction = _db!.transaction(storeName, 'readonly');
    final store = transaction.objectStore(storeName);
    
    try {
      final record = await store.getObject(id);
      if (record != null) {
        // idb returns a JS/Dart map object.
        final map = record as Map<dynamic, dynamic>;
        return Map<String, dynamic>.from(map);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<void> deleteFile(String id) async {
    await initDB();
    
    final transaction = _db!.transaction(storeName, 'readwrite');
    final store = transaction.objectStore(storeName);
    
    await store.delete(id);
    await transaction.completed;
  }

  // Helper method to download the file directly
  Future<void> downloadFile(String id) async {
    final fileData = await getFile(id);
    if (fileData != null) {
      final blob = fileData['data'] as html.Blob;
      final fileName = fileData['fileName'] as String;
      
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();
        
      html.Url.revokeObjectUrl(url);
    }
  }
}

// Global instance for easy access
final indexedDBService = IndexedDBService();
