import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/data/models.dart';
import '../../shared/data/local_storage.dart';
import '../../dashboard/provider/dashboard_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'documents_provider.g.dart';

@riverpod
class DocumentsNotifier extends _$DocumentsNotifier {
  @override
  List<DocChecklist> build() {
    final nim = ref.watch(dashboardControllerProvider).nim;
    if (nim.isEmpty) return [];

    final local = ref.read(localStorageProvider);
    final localKey = 'documents_$nim';

    final defaultDocs = [
      const DocChecklist(id: 'loa', title: 'Surat Penerimaan Perusahaan (Letter of Acceptance)', category: 'Alat 3'),
      const DocChecklist(id: 'perm_surat', title: 'Surat Permohonan & Pengantar Kampus', category: 'Alat 3'),
      const DocChecklist(id: 'nilai_mentor', title: 'Form Penilaian dari Mentor Lapangan', category: 'Alat 3'),
      const DocChecklist(id: 'selesai_magang', title: 'Surat Keterangan Selesai Magang Resmi', category: 'Alat 3'),
      const DocChecklist(id: 'orisinalitas', title: 'Lembar Pernyataan Orisinalitas Laporan', category: 'Alat 4'),
      const DocChecklist(id: 'pengesahan', title: 'Lembar Pengesahan Laporan Akhir', category: 'Alat 4'),
      const DocChecklist(id: 'agenda', title: 'Agenda Kegiatan / Lampiran Absensi Fisik', category: 'Tambahan'),
      const DocChecklist(id: 'nda_integritas', title: 'Pakta Integritas / NDA Perusahaan (Jika Ada)', category: 'Tambahan'),
    ];

    List<DocChecklist> localList = [];
    final cached = local.read(localKey);
    if (cached != null) {
      try {
        final List decoded = jsonDecode(cached);
        localList = decoded.map((e) => DocChecklist.fromJson(Map<String, dynamic>.from(e))).toList();
      } catch (_) {}
    }

    final parsed = List<DocChecklist>.from(localList.isEmpty ? defaultDocs : localList);
    
    // Pastikan item default selalu ada
    for (final defDoc in defaultDocs) {
      if (!parsed.any((e) => e.id == defDoc.id)) {
        parsed.add(defDoc);
      }
    }

    return parsed;
  }

  void _save(List<DocChecklist> docs) {
    final nim = ref.read(dashboardControllerProvider).nim;
    if (nim.isEmpty) return;
    final local = ref.read(localStorageProvider);
    final localKey = 'documents_$nim';
    local.write(localKey, jsonEncode(docs.map((e) => e.toJson()).toList()));
  }

  Future<void> toggleDocument(String id, bool isCompleted, {String notes = '', String fileUrl = ''}) async {
    final updated = state.map((e) {
      if (e.id == id) {
        return e.copyWith(
          isCompleted: isCompleted,
          notes: notes.isNotEmpty ? notes : e.notes,
          fileUrl: fileUrl.isNotEmpty ? fileUrl : e.fileUrl,
        );
      }
      return e;
    }).toList();
    state = updated;
    _save(updated);
  }

  Future<void> addCustomDocument(String title, String category) async {
    final newId = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    final updated = [
      ...state,
      DocChecklist(id: newId, title: title, category: category),
    ];
    state = updated;
    _save(updated);
  }
  Future<void> updateNotes(String id, String notes) async {
    final updated = state.map((e) => e.id == id ? e.copyWith(notes: notes) : e).toList();
    state = updated;
    _save(updated);
  }

  Future<void> updateFileUrl(String id, String fileUrl) async {
    final updated = state.map((e) => e.id == id ? e.copyWith(fileUrl: fileUrl) : e).toList();
    state = updated;
    _save(updated);
  }

  Future<void> removeDocument(String id) async {
    final updated = state.where((e) => e.id != id).toList();
    state = updated;
    _save(updated);
  }
}

@riverpod
Stream<List<DocChecklist>> documentsStream(Ref ref) {
  final docs = ref.watch(documentsProvider);
  return Stream.value(docs);
}

@riverpod
class DocumentsController extends _$DocumentsController {
  @override
  void build() {}

  /// Delegate methods to maintain compatibility with existing UI
  Future<void> toggleDocument(String id, bool isCompleted, {String notes = '', String fileUrl = ''}) async {
    await ref.read(documentsProvider.notifier).toggleDocument(id, isCompleted, notes: notes, fileUrl: fileUrl);
  }

  Future<void> addCustomDocument(String title, String category) async {
    await ref.read(documentsProvider.notifier).addCustomDocument(title, category);
  }

  Future<void> updateNotes(String id, String notes) async {
    await ref.read(documentsProvider.notifier).updateNotes(id, notes);
  }

  Future<void> updateFileUrl(String id, String fileUrl) async {
    await ref.read(documentsProvider.notifier).updateFileUrl(id, fileUrl);
  }

  Future<void> removeDocument(String id) async {
    await ref.read(documentsProvider.notifier).removeDocument(id);
  }
}


// ─── Model Referensi Akademik Lengkap ─────────────────────────────────────

/// Jenis sumber referensi
enum ReferenceType {
  buku,      // Buku teks / textbook
  jurnal,    // Artikel jurnal ilmiah
  website,   // Laman web / internet
  skripsi,   // Skripsi, TA, Tugas Akhir, Tesis
  prosiding, // Prosiding seminar/konferensi
  lainnya,   // Sumber lain
}

extension ReferenceTypeExt on ReferenceType {
  String get label {
    switch (this) {
      case ReferenceType.buku:      return 'Buku';
      case ReferenceType.jurnal:    return 'Jurnal';
      case ReferenceType.website:   return 'Website';
      case ReferenceType.skripsi:   return 'Skripsi/TA';
      case ReferenceType.prosiding: return 'Prosiding';
      case ReferenceType.lainnya:   return 'Lainnya';
    }
  }

  String get icon {
    switch (this) {
      case ReferenceType.buku:      return '📖';
      case ReferenceType.jurnal:    return '📄';
      case ReferenceType.website:   return '🌐';
      case ReferenceType.skripsi:   return '🎓';
      case ReferenceType.prosiding: return '🏛️';
      case ReferenceType.lainnya:   return '📎';
    }
  }
}

class BookReference {
  final String id;

  // ─ Wajib (semua jenis)
  final String author;        // Nama penulis: "Lastname, Firstname" atau "Nama Lembaga"
  final int year;             // Tahun terbit
  final String title;         // Judul buku / artikel / halaman web
  final ReferenceType type;   // Jenis referensi

  // ─ Buku & Skripsi
  final String publisher;     // Penerbit
  final String city;          // Kota terbit
  final String edition;       // Edisi (misal: "Edisi ke-3")

  // ─ Jurnal & Prosiding
  final String journalName;   // Nama jurnal / nama prosiding
  final String volume;        // Volume (misal: "Vol. 12")
  final String issue;         // Nomor (misal: "No. 3")
  final String pages;         // Halaman (misal: "pp. 45–67")
  final String doi;           // DOI (misal: "10.1234/...")

  // ─ Website
  final String url;           // URL lengkap
  final String accessDate;    // Tanggal akses (misal: "15 Mei 2025")

  // ─ Skripsi
  final String institution;   // Nama kampus/lembaga
  
  // ─ eBook / File Terlampir (untuk semua jenis referensi)
  final String fileUrl;

  BookReference({
    String? id,
    required this.author,
    required this.year,
    required this.title,
    this.type = ReferenceType.buku,
    this.publisher = '',
    this.city = '',
    this.edition = '',
    this.journalName = '',
    this.volume = '',
    this.issue = '',
    this.pages = '',
    this.doi = '',
    this.url = '',
    this.accessDate = '',
    this.institution = '',
    this.fileUrl = '',
  }) : id = id ?? 'ref_${DateTime.now().microsecondsSinceEpoch}';

  Map<String, dynamic> toJson() => {
    'id': id,
    'author': author,
    'year': year,
    'title': title,
    'type': type.name,
    'publisher': publisher,
    'city': city,
    'edition': edition,
    'journalName': journalName,
    'volume': volume,
    'issue': issue,
    'pages': pages,
    'doi': doi,
    'url': url,
    'accessDate': accessDate,
    'institution': institution,
    'fileUrl': fileUrl,
  };

  factory BookReference.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'buku';
    final type = ReferenceType.values.firstWhere(
      (t) => t.name == typeStr,
      orElse: () => ReferenceType.buku,
    );
    return BookReference(
      id: json['id'] as String?,
      author: json['author'] as String? ?? '',
      year: (json['year'] as num?)?.toInt() ?? 2024,
      title: json['title'] as String? ?? '',
      type: type,
      publisher: json['publisher'] as String? ?? '',
      city: json['city'] as String? ?? '',
      edition: json['edition'] as String? ?? '',
      journalName: json['journalName'] as String? ?? '',
      volume: json['volume'] as String? ?? '',
      issue: json['issue'] as String? ?? '',
      pages: json['pages'] as String? ?? '',
      doi: json['doi'] as String? ?? '',
      url: json['url'] as String? ?? '',
      accessDate: json['accessDate'] as String? ?? '',
      institution: json['institution'] as String? ?? '',
      fileUrl: json['fileUrl'] as String? ?? '',
    );
  }

  /// Format sitasi otomatis sesuai standar (APA-like) untuk laporan Politeknik
  String get formattedCitation {
    switch (type) {
      case ReferenceType.buku:
        final ed = edition.isNotEmpty ? ' ($edition)' : '';
        final pub = publisher.isNotEmpty ? publisher : '—';
        final kota = city.isNotEmpty ? '$city: ' : '';
        return '$author. ($year). $title$ed. $kota$pub.';
      case ReferenceType.jurnal:
        final vol = volume.isNotEmpty ? ', $volume' : '';
        final iss = issue.isNotEmpty ? '($issue)' : '';
        final pg = pages.isNotEmpty ? ', $pages' : '';
        final doiStr = doi.isNotEmpty ? ' https://doi.org/$doi' : '';
        return '$author. ($year). $title. $journalName$vol$iss$pg.$doiStr';
      case ReferenceType.website:
        final acc = accessDate.isNotEmpty ? ' Diakses $accessDate,' : '';
        return '$author. ($year). $title.$acc dari $url';
      case ReferenceType.skripsi:
        final inst = institution.isNotEmpty ? institution : '—';
        return '$author. ($year). $title [Tugas Akhir/Skripsi]. $inst.';
      case ReferenceType.prosiding:
        final pg = pages.isNotEmpty ? ', $pages' : '';
        return '$author. ($year). $title. Dalam $journalName$pg.';
      case ReferenceType.lainnya:
        return '$author. ($year). $title.';
    }
  }
}

@riverpod
class BibliographyNotifier extends _$BibliographyNotifier {
  static const _storageKey = 'bibliography_refs';

  @override
  List<BookReference> build() {
    final local = ref.read(localStorageProvider);
    final cached = local.read(_storageKey);
    if (cached != null) {
      try {
        final List decoded = jsonDecode(cached);
        return decoded
            .map((e) => BookReference.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      } catch (_) {}
    }
    // Data contoh default
    return [
      BookReference(
        author: 'Sugiyono',
        year: 2022,
        title: 'Metode Penelitian Kuantitatif, Kualitatif dan R&D',
        type: ReferenceType.buku,
        publisher: 'Alfabeta',
        city: 'Bandung',
        edition: 'Edisi ke-2',
      ),
      BookReference(
        author: 'Pressman, R. S., & Maxim, B. R.',
        year: 2021,
        title: 'Software Engineering: A Practitioner\'s Approach',
        type: ReferenceType.buku,
        publisher: 'McGraw-Hill Education',
        city: 'New York',
        edition: 'Edisi ke-9',
      ),
    ];
  }

  void _save() {
    final local = ref.read(localStorageProvider);
    local.write(_storageKey, jsonEncode(state.map((e) => e.toJson()).toList()));
  }

  void addReference(BookReference ref) {
    state = [...state, ref];
    _save();
  }

  void removeReference(String id) {
    state = state.where((e) => e.id != id).toList();
    _save();
  }

  void updateReference(BookReference updated) {
    state = state.map((e) => e.id == updated.id ? updated : e).toList();
    _save();
  }

  // Legacy compat
  void addBook(String title, int year) {
    addReference(BookReference(author: '—', year: year, title: title));
  }

  void removeBook(int index) {
    if (index < state.length) {
      removeReference(state[index].id);
    }
  }
}

