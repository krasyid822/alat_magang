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
    if (url.startsWith('chunked:') || url.startsWith('chunked://')) {
      final cleanUrl = url.startsWith('chunked://') ? 'chunked:${url.substring(10)}' : url;
      final ref = ChunkedFileRef.fromUrl(cleanUrl);
      if (ref != null) {
        return await fileChunkService.downloadFile(nim, ref);
      }
    } else if (url.startsWith('cloudfile:')) {
      try {
        final content = url.substring(10);
        final firstPipe = content.indexOf('|');
        if (firstPipe != -1) {
          final secondPipe = content.indexOf('|', firstPipe + 1);
          if (secondPipe != -1) {
            final base64Str = content.substring(secondPipe + 1);
            return base64Decode(base64Str.trim());
          }
        }
      } catch (_) {}
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

  static String _escapeCsv(String val) {
    if (val.contains('"') || val.contains(',') || val.contains('\n') || val.contains('\r')) {
      return '"${val.replaceAll('"', '""')}"';
    }
    return val;
  }

  static Future<void> downloadInternshipZip(WidgetRef ref) async {
    final profile = ref.read(dashboardControllerProvider);
    final nim = profile.nim;
    if (nim.isEmpty) return;

    ref.read(syncStatusProvider.notifier).setStatus(SyncStatusType.uploading, 'Menyiapkan arsip ZIP...');

    try {
      final archive = Archive();

      // 1. Student Profile
      final profileTxt = '==================================================\n'
          'PROFIL MAHASISWA MAGANG\n'
          '==================================================\n'
          'NAMA MAHASISWA      : ${profile.name}\n'
          'NIM                 : ${profile.nim}\n'
          'KELAS               : ${profile.className}\n'
          'JURUSAN             : ${profile.major}\n'
          'PERUSAHAAN MAGANG   : ${profile.companyName}\n'
          'BAGIAN / DIVISI     : ${profile.division}\n'
          'PEMBIMBING LAPANGAN : ${profile.mentorName}\n'
          'DURASI MAGANG       : ${profile.internshipDurationWeeks} Minggu\n'
          'NOMOR WHATSAPP      : ${profile.whatsappNumber}\n'
          '==================================================\n';

      final profileBytes = utf8.encode(profileTxt);
      archive.addFile(ArchiveFile('profil_mahasiswa.txt', profileBytes.length, profileBytes));

      // 2. Logbooks (CSV)
      final logs = ref.read(logbookProvider).where((e) => !e.isDeleted && !e.isDraft).toList();
      final logbookCsvHeader = 'Minggu,Tanggal,Jam Mulai,Jam Selesai,Uraian Kegiatan,Status Paraf,File Paraf,File Foto Kegiatan\n';
      final List<String> logsRows = [];

      for (final log in logs) {
        final statusParaf = log.isSigned ? 'Sudah Diparaf' : 'Belum Diparaf';
        String parafZipPath = '—';
        final List<String> photosZipPaths = [];

        // Paraf/Signature
        if (log.isSigned && log.signatureData.isNotEmpty) {
          final signatureBytes = await _getBytesFromUrl(nim, log.signatureData);
          if (signatureBytes != null) {
            parafZipPath = 'logbook/paraf_dan_foto/paraf_logbook_minggu_${log.weekNumber}_${log.id.substring(0, 5)}.png';
            archive.addFile(ArchiveFile(parafZipPath, signatureBytes.length, signatureBytes));
          }
        }
        
        // Photos
        for (int i = 0; i < log.imageUrls.length; i++) {
          final photoBytes = await _getBytesFromUrl(nim, log.imageUrls[i]);
          if (photoBytes != null) {
            final photoZipPath = 'logbook/paraf_dan_foto/foto_logbook_minggu_${log.weekNumber}_${log.id.substring(0, 5)}_$i.jpg';
            photosZipPaths.add(photoZipPath);
            archive.addFile(ArchiveFile(photoZipPath, photoBytes.length, photoBytes));
          }
        }

        final photosCell = photosZipPaths.isEmpty ? '—' : photosZipPaths.join('; ');
        logsRows.add(
          '${log.weekNumber},'
          '${_escapeCsv(log.date)},'
          '${_escapeCsv(log.startTime)},'
          '${_escapeCsv(log.endTime)},'
          '${_escapeCsv(log.activity)},'
          '$statusParaf,'
          '${_escapeCsv(parafZipPath)},'
          '${_escapeCsv(photosCell)}'
        );
      }
      final logbookCsv = '\uFEFF$logbookCsvHeader${logsRows.join('\n')}';
      final logbookCsvBytes = utf8.encode(logbookCsv);
      archive.addFile(ArchiveFile('logbook/logbook.csv', logbookCsvBytes.length, logbookCsvBytes));

      // 3. Job Details (CSV)
      final jobs = ref.read(jobProvider).where((e) => !e.isDeleted).toList();
      final jobsCsvHeader = 'Tanggal,Nama Tugas / Pekerjaan,Uraian / Langkah Kerja,Status,Kendala jika belum selesai,File Dokumentasi\n';
      final List<String> jobsRows = [];

      for (final job in jobs) {
        final status = job.isCompleted ? 'Selesai' : 'Belum Selesai';
        final List<String> photosZipPaths = [];
        
        final imageUrls = job.imageUrl.split('|||').where((s) => s.isNotEmpty).toList();
        for (int i = 0; i < imageUrls.length; i++) {
          final photoBytes = await _getBytesFromUrl(nim, imageUrls[i]);
          if (photoBytes != null) {
            final photoZipPath = 'pekerjaan/dokumentasi/foto_tugas_${job.id.substring(0, 5)}_$i.jpg';
            photosZipPaths.add(photoZipPath);
            archive.addFile(ArchiveFile(photoZipPath, photoBytes.length, photoBytes));
          }
        }

        final photosCell = photosZipPaths.isEmpty ? '—' : photosZipPaths.join('; ');
        jobsRows.add(
          '${_escapeCsv(job.date)},'
          '${_escapeCsv(job.title)},'
          '${_escapeCsv(job.description)},'
          '$status,'
          '${_escapeCsv(job.reasonOfIncompletion)},'
          '${_escapeCsv(photosCell)}'
        );
      }
      final jobsCsv = '\uFEFF$jobsCsvHeader${jobsRows.join('\n')}';
      final jobsCsvBytes = utf8.encode(jobsCsv);
      archive.addFile(ArchiveFile('pekerjaan/tugas.csv', jobsCsvBytes.length, jobsCsvBytes));

      // 4. Research Data (TXT)
      final research = ref.read(researchProvider);
      final researchTxt = '==================================================\n'
          'BAHAN RISET LAPORAN BAB 2\n'
          '==================================================\n\n'
          '1. SEJARAH PERUSAHAAN:\n${research.companyHistory}\n\n'
          '2. VISI & MISI PERUSAHAAN:\n${research.companyVisionMission}\n\n'
          '3. URL STRUKTUR ORGANISASI:\n${research.companyStructureUrl}\n\n'
          '4. DESKRIPSI PEKERJAAN (JOB DESC):\n${research.jobDescription}\n\n'
          '5. PROSEDUR KERJA:\n${research.procedureWork}\n\n'
          '6. HAMBATAN KERJA:\n${research.obstacles}\n';
      final researchBytes = utf8.encode(researchTxt);
      archive.addFile(ArchiveFile('riset/riset_bab2.txt', researchBytes.length, researchBytes));

      // 5. Document Checklist (CSV)
      final docs = ref.read(documentsProvider).where((e) => !e.isDeleted).toList();
      final docsCsvHeader = 'Kategori,Nama Dokumen,Status Kelengkapan,Catatan,File Dokumentasi / Pendukung\n';
      final List<String> docsRows = [];

      for (final doc in docs) {
        final status = doc.isCompleted ? 'Lengkap' : 'Belum Lengkap';
        String zipFilePath = '—';

        if (doc.fileUrl.isNotEmpty) {
          final fileBytes = await _getBytesFromUrl(nim, doc.fileUrl);
          if (fileBytes != null) {
            String entryName = '';
            if (doc.fileUrl.startsWith('chunked:') || doc.fileUrl.startsWith('chunked://')) {
              final cleanUrl = doc.fileUrl.startsWith('chunked://') ? 'chunked:${doc.fileUrl.substring(10)}' : doc.fileUrl;
              final chunkRef = ChunkedFileRef.fromUrl(cleanUrl);
              if (chunkRef != null) {
                entryName = chunkRef.fileName;
              }
            }
            if (entryName.isEmpty) {
              final cleanTitle = doc.title.replaceAll(RegExp(r'[^\w\s\-]'), '_').replaceAll(' ', '_');
              entryName = 'dokumen_${doc.id.substring(0, 5)}_$cleanTitle.pdf';
            }

            final cleanCategory = doc.category.replaceAll(RegExp(r'[^\w\s\-]'), '_').replaceAll(' ', '_');
            zipFilePath = 'dokumen/file_pendukung/${cleanCategory}_$entryName';
            archive.addFile(ArchiveFile(zipFilePath, fileBytes.length, fileBytes));
          }
        }

        docsRows.add(
          '${_escapeCsv(doc.category)},'
          '${_escapeCsv(doc.title)},'
          '$status,'
          '${_escapeCsv(doc.notes)},'
          '${_escapeCsv(zipFilePath)}'
        );
      }
      final docsCsv = '\uFEFF$docsCsvHeader${docsRows.join('\n')}';
      final docsCsvBytes = utf8.encode(docsCsv);
      archive.addFile(ArchiveFile('dokumen/checklist.csv', docsCsvBytes.length, docsCsvBytes));

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
