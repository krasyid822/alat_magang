import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:archive/archive_io.dart';
import '../../dashboard/provider/dashboard_provider.dart';
import '../../logbook/provider/logbook_provider.dart';
import '../../job_details/provider/job_provider.dart';
import '../../research/provider/research_provider.dart';
import '../../documents/provider/documents_provider.dart';
import 'file_chunk_service.dart';
import 'models.dart';

class ZipService {
  static Future<Uint8List?> _getBytesFromUrl(String nim, String url) async {
    if (url.startsWith('chunked://')) {
      final ref = ChunkedFileRef.fromUrl(url);
      if (ref != null) {
        return await fileChunkService.downloadFile(nim, ref);
      }
    } else if (url.startsWith('data:')) {
      try {
        final commaIdx = url.indexOf(',');
        if (commaIdx != -1) {
          final base64Str = url.substring(commaIdx + 1);
          return base64Decode(base64Str.trim());
        }
      } catch (_) {}
    }
    return null;
  }

  static Future<void> downloadInternshipZip(WidgetRef ref) async {
    final profile = ref.read(dashboardControllerProvider);
    final nim = profile.nim;
    if (nim.isEmpty) return;

    ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.uploading, 'Menyiapkan arsip ZIP...');

    try {
      final archive = Archive();

      // 1. Student Profile
      final profileTxt = 'NAMA MAHASISWA      : ${profile.name}\n'
          'NIM                 : ${profile.nim}\n'
          'KELAS               : ${profile.className}\n'
          'JURUSAN             : ${profile.major}\n'
          'PERUSAHAAN MAGANG   : ${profile.companyName}\n'
          'BAGIAN / DIVISI     : ${profile.division}\n'
          'PEMBIMBING LAPANGAN : ${profile.mentorName}\n'
          'DURASI MAGANG       : ${profile.internshipDurationWeeks} Minggu\n'
          'NOMOR WHATSAPP      : ${profile.whatsappNumber}\n';

      archive.addFile(ArchiveFile('profil_mahasiswa.txt', profileTxt.length, utf8.encode(profileTxt)));
      archive.addFile(ArchiveFile('profil_mahasiswa.json', jsonEncode(profile.toJson()).length, utf8.encode(jsonEncode(profile.toJson()))));

      // 2. Logbooks
      final logs = ref.read(logbookProvider);
      archive.addFile(ArchiveFile('logbook/logbook.json', jsonEncode(logs.map((e) => e.toJson()).toList()).length, utf8.encode(jsonEncode(logs.map((e) => e.toJson()).toList()))));

      for (final log in logs) {
        // Paraf/Signature
        if (log.isSigned && log.signatureData.isNotEmpty) {
          final signatureBytes = await _getBytesFromUrl(nim, log.signatureData);
          if (signatureBytes != null) {
            archive.addFile(ArchiveFile('logbook/paraf_dan_foto/paraf_logbook_minggu_${log.weekNumber}_${log.id.substring(0, 5)}.png', signatureBytes.length, signatureBytes));
          }
        }
        // Photos
        for (int i = 0; i < log.imageUrls.length; i++) {
          final photoBytes = await _getBytesFromUrl(nim, log.imageUrls[i]);
          if (photoBytes != null) {
            archive.addFile(ArchiveFile('logbook/paraf_dan_foto/foto_logbook_minggu_${log.weekNumber}_${log.id.substring(0, 5)}_$i.jpg', photoBytes.length, photoBytes));
          }
        }
      }

      // 3. Job Details
      final jobs = ref.read(jobProvider);
      archive.addFile(ArchiveFile('pekerjaan/tugas.json', jsonEncode(jobs.map((e) => e.toJson()).toList()).length, utf8.encode(jsonEncode(jobs.map((e) => e.toJson()).toList()))));

      for (final job in jobs) {
        final imageUrls = job.imageUrl.split('|||').where((s) => s.isNotEmpty).toList();
        for (int i = 0; i < imageUrls.length; i++) {
          final photoBytes = await _getBytesFromUrl(nim, imageUrls[i]);
          if (photoBytes != null) {
            archive.addFile(ArchiveFile('pekerjaan/dokumentasi/foto_tugas_${job.id.substring(0, 5)}_$i.jpg', photoBytes.length, photoBytes));
          }
        }
      }

      // 4. Research Data
      final research = ref.read(researchProvider);
      archive.addFile(ArchiveFile('riset/riset_bab2.json', jsonEncode(research.toJson()).length, utf8.encode(jsonEncode(research.toJson()))));

      // 5. Document Checklist
      final docs = ref.read(documentsProvider);
      archive.addFile(ArchiveFile('dokumen/checklist.json', jsonEncode(docs.map((e) => e.toJson()).toList()).length, utf8.encode(jsonEncode(docs.map((e) => e.toJson()).toList()))));

      // Encode ZIP
      final zipEncoder = ZipEncoder();
      final zipData = zipEncoder.encode(archive);

      // Trigger Web Download
      final blob = html.Blob([zipData], 'application/zip');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', 'AlatMagang_${profile.nim}_${profile.name.replaceAll(' ', '_')}.zip')
        ..click();

      html.Url.revokeObjectUrl(url);

      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.synced, 'ZIP berhasil didownload!');
    } catch (e) {
      ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.error, 'Gagal membuat ZIP: $e');
    }
  }
}
