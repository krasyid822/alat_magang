import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Batas ukuran setiap chunk base64 (karakter), aman untuk Firestore 1MB/doc limit.
/// 700.000 chars base64 ≈ ~525 KB data binary.
const int _kChunkSizeChars = 700000;

/// Prefix untuk URL file yang disimpan secara chunked
const String kChunkedPrefix = 'chunked:';

/// Format URL: `chunked:<fileId>|<fileName>|<totalChunks>|<mimeType>`
class ChunkedFileRef {
  final String fileId;
  final String fileName;
  final int totalChunks;
  final String mimeType;

  const ChunkedFileRef({
    required this.fileId,
    required this.fileName,
    required this.totalChunks,
    required this.mimeType,
  });

  /// Encode menjadi string URL yang disimpan di field fileUrl
  String toUrl() => '$kChunkedPrefix$fileId|$fileName|$totalChunks|$mimeType';

  /// Parse dari field fileUrl
  static ChunkedFileRef? fromUrl(String url) {
    if (!url.startsWith(kChunkedPrefix)) return null;
    final parts = url.substring(kChunkedPrefix.length).split('|');
    if (parts.length < 4) return null;
    return ChunkedFileRef(
      fileId: parts[0],
      fileName: parts[1],
      totalChunks: int.tryParse(parts[2]) ?? 1,
      mimeType: parts.sublist(3).join('|'), // mimeType bisa mengandung '/'
    );
  }
}

class FileChunkService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String _studentsCol = 'students';
  static const String _chunksCol = 'file_chunks';

  // ─── Upload ────────────────────────────────────────────────────────────────

  /// Upload file sebagai chunk ke Firestore.
  /// Mengembalikan URL string yang bisa disimpan ke field `fileUrl`.
  Future<String> uploadFile({
    required String nim,
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
    void Function(double progress)? onProgress,
  }) async {
    final fileId = 'cf_${DateTime.now().millisecondsSinceEpoch}';
    final base64Full = base64Encode(bytes);
    final totalLength = base64Full.length;

    // Potong jadi chunk
    final chunks = <String>[];
    for (int i = 0; i < totalLength; i += _kChunkSizeChars) {
      chunks.add(base64Full.substring(
        i,
        (i + _kChunkSizeChars).clamp(0, totalLength),
      ));
    }

    final totalChunks = chunks.length;

    // Upload tiap chunk ke sub-collection file_chunks/{fileId}/chunks/{index}
    final fileDocRef = _db
        .collection(_studentsCol)
        .doc(nim)
        .collection(_chunksCol)
        .doc(fileId);

    // Simpan metadata di dokumen induk
    await fileDocRef.set({
      'fileId': fileId,
      'fileName': fileName,
      'mimeType': mimeType,
      'totalChunks': totalChunks,
      'sizeBytes': bytes.length,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });

    // Upload setiap chunk
    for (int i = 0; i < totalChunks; i++) {
      await fileDocRef.collection('chunks').doc('$i').set({
        'index': i,
        'data': chunks[i],
      });
      onProgress?.call((i + 1) / totalChunks);
    }

    final ref = ChunkedFileRef(
      fileId: fileId,
      fileName: fileName,
      totalChunks: totalChunks,
      mimeType: mimeType,
    );
    return ref.toUrl();
  }

  // ─── Download / Reassemble ─────────────────────────────────────────────────

  /// Rakit ulang semua chunk menjadi Uint8List.
  Future<Uint8List?> downloadFile(String nim, ChunkedFileRef ref) async {
    final fileDocRef = _db
        .collection(_studentsCol)
        .doc(nim)
        .collection(_chunksCol)
        .doc(ref.fileId);

    // Ambil semua chunk sekaligus
    final chunksSnap = await fileDocRef
        .collection('chunks')
        .orderBy('index')
        .get();

    if (chunksSnap.docs.isEmpty) return null;

    final buffer = StringBuffer();
    for (final doc in chunksSnap.docs) {
      buffer.write(doc.data()['data'] as String? ?? '');
    }

    return base64Decode(buffer.toString());
  }

  /// Ambil data URL (data:mime;base64,...) langsung dari cloud chunks.
  Future<String?> getDataUrl(String nim, ChunkedFileRef ref) async {
    final bytes = await downloadFile(nim, ref);
    if (bytes == null) return null;
    return 'data:${ref.mimeType};base64,${base64Encode(bytes)}';
  }

  // ─── Delete ────────────────────────────────────────────────────────────────

  /// Hapus semua chunk dari cloud (gunakan saat dokumen dihapus).
  Future<void> deleteFile(String nim, String fileId) async {
    final fileDocRef = _db
        .collection(_studentsCol)
        .doc(nim)
        .collection(_chunksCol)
        .doc(fileId);

    // Hapus semua sub-chunks terlebih dahulu
    final chunksSnap = await fileDocRef.collection('chunks').get();
    for (final doc in chunksSnap.docs) {
      await doc.reference.delete();
    }
    // Hapus dokumen induk
    await fileDocRef.delete();
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  /// Buat data URL langsung dari bytes — tanpa upload (untuk preview cepat lokal)
  static String bytesToDataUrl(Uint8List bytes, String mimeType) {
    return 'data:$mimeType;base64,${base64Encode(bytes)}';
  }
}

/// Instance global
final fileChunkService = FileChunkService();
