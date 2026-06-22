import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:html' as html;
import '../../../shared/data/indexed_db_service.dart';
import '../../provider/documents_provider.dart';

class BibliographyChecker extends ConsumerStatefulWidget {
  const BibliographyChecker({super.key});

  @override
  ConsumerState<BibliographyChecker> createState() => _BibliographyCheckerState();
}

class _BibliographyCheckerState extends ConsumerState<BibliographyChecker> {
  static const _accentColor = Color(0xFFEC4899);

  @override
  Widget build(BuildContext context) {
    final refs = ref.watch(bibliographyProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Kriteria kelayakan — batas tahun dihitung dinamis (5 tahun terakhir)
    final int recentThreshold = DateTime.now().year - 5;
    final hasMin5 = refs.length >= 5;
    final allRecent = refs.isNotEmpty && refs.every((r) => r.year >= recentThreshold);
    final hasVariety = ReferenceType.values.where((t) => refs.any((r) => r.type == t)).length >= 2;
    final isValid = hasMin5 && allRecent;

    return Container(
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleRow(),
          const SizedBox(height: 16),
          _buildValidationCard(refs, hasMin5, allRecent, hasVariety, isValid, recentThreshold),
          const SizedBox(height: 20),
          _buildTypeStats(refs),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _showAddDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentColor,
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.add_rounded, size: 20),
            label: const Text('Tambah Referensi Baru', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          _buildReferenceList(refs, isDark),
        ],
      ),
    );
  }

  Widget _buildTitleRow() {
    return const Row(
      children: [
        Icon(Icons.menu_book_rounded, color: Color(0xFFEC4899), size: 22),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            'Validator Daftar Pustaka',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildValidationCard(List<BookReference> refs, bool hasMin5, bool allRecent, bool hasVariety, bool isValid, int recentThreshold) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (isValid ? const Color(0xFF0D9488) : const Color(0xFFF43F5E)).withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: (isValid ? const Color(0xFF0D9488) : const Color(0xFFF43F5E)).withOpacity(0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isValid ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                color: isValid ? const Color(0xFF0D9488) : const Color(0xFFF43F5E),
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isValid ? 'Daftar Pustaka Layak' : 'Syarat Kelayakan Belum Terpenuhi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.5,
                    color: isValid ? const Color(0xFF0D9488) : const Color(0xFFF43F5E),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isValid ? const Color(0xFF0D9488) : const Color(0xFFF43F5E)).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isValid ? 'LAYAK' : 'BELUM',
                  style: TextStyle(
                    color: isValid ? const Color(0xFF0D9488) : const Color(0xFFF43F5E),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Colors.white10),
          const SizedBox(height: 8),
          // Compact inline criteria stats badges so no detail is lost
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCriterionBadge('≥ 5 Ref', hasMin5, '${refs.length}/5'),
                const SizedBox(width: 6),
                _buildCriterionBadge('≤ 5 Thn', allRecent, '≥ $recentThreshold'),
                const SizedBox(width: 6),
                _buildCriterionBadge('Variasi', hasVariety, '${ReferenceType.values.where((t) => refs.any((r) => r.type == t)).length}/2 jenis', isWarning: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriterionBadge(String label, bool ok, String detail, {bool isWarning = false}) {
    final color = ok
        ? const Color(0xFF0D9488)
        : (isWarning ? const Color(0xFFF59E0B) : const Color(0xFFF43F5E));
    final icon = ok ? Icons.check_circle_rounded : (isWarning ? Icons.warning_amber_rounded : Icons.cancel_rounded);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            '$label ($detail)',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeStats(List<BookReference> refs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Distribusi Jenis Referensi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF64748B))),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ReferenceType.values.map((t) {
            final count = refs.where((r) => r.type == t).length;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: count > 0 ? _accentColor.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: count > 0 ? _accentColor.withOpacity(0.3) : const Color(0xFF334155),
                ),
              ),
              child: Text(
                '${t.icon} ${t.label}: $count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: count > 0 ? _accentColor : const Color(0xFF64748B),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReferenceList(List<BookReference> refs, bool isDark) {
    if (refs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text('Belum ada referensi terdaftar.', style: TextStyle(color: Color(0xFF64748B), fontSize: 12))),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${refs.length} Referensi Terdaftar', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 10),
        // Sort alphabetically by author
        ...refs.asMap().entries.map((entry) {
          final i = entry.key + 1;
          final ref = entry.value;
          return _buildRefCard(i, ref, isDark);
        }),
      ],
    );
  }

  Widget _buildRefCard(int index, BookReference ref, bool isDark) {
    final isRecent = ref.year >= DateTime.now().year - 5;
    final typeColor = _typeColor(ref.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRecent ? Colors.white10 : const Color(0xFFF43F5E).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nomor urut
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('$index', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _accentColor)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tipe badge + tahun
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${ref.type.icon} ${ref.type.label}',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: typeColor),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: isRecent ? const Color(0xFF0D9488).withOpacity(0.1) : const Color(0xFFF43F5E).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${ref.year}${isRecent ? '' : ' ⚠️'}',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: isRecent ? const Color(0xFF0D9488) : const Color(0xFFF43F5E),
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Edit + Delete
                        InkWell(
                          onTap: () => _showEditDialog(context, ref),
                          borderRadius: BorderRadius.circular(6),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.edit_rounded, size: 14, color: Color(0xFF64748B)),
                          ),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () => _confirmDelete(context, ref),
                          borderRadius: BorderRadius.circular(6),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.delete_rounded, size: 14, color: Color(0xFFF43F5E)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Formatted citation
                    Text(
                      ref.formattedCitation,
                      style: const TextStyle(fontSize: 11, height: 1.5, color: Color(0xFF94A3B8)),
                    ),
                    if (ref.fileUrl.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _buildRefFileBadge(ref.fileUrl),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRefFileBadge(String fileUrl) {
    final isLocal = fileUrl.startsWith('local:');
    String displayFileName = 'Lihat Lampiran';
    if (isLocal) {
      final parts = fileUrl.substring(6).split('|');
      displayFileName = parts.length > 1 ? parts.sublist(1).join('|') : 'eBook Terlampir';
      return InkWell(
        onTap: () {
          final parts = fileUrl.substring(6).split('|');
          indexedDBService.downloadFile(parts[0]);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF38BDF8).withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.picture_as_pdf_rounded, size: 12, color: Color(0xFF38BDF8)),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  displayFileName,
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.download_rounded, size: 12, color: Color(0xFF38BDF8)),
            ],
          ),
        ),
      );
    } else {
      // It's a URL link (Google Drive / Online source)
      return InkWell(
        onTap: () {
          final anchor = html.AnchorElement(href: fileUrl)
            ..target = '_blank'
            ..rel = 'noopener';
          anchor.click();
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B).withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.link_rounded, size: 12, color: Color(0xFFF59E0B)),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  fileUrl,
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.open_in_new_rounded, size: 12, color: Color(0xFFF59E0B)),
            ],
          ),
        ),
      );
    }
  }

  Color _typeColor(ReferenceType type) {
    switch (type) {
      case ReferenceType.buku:      return const Color(0xFF0D9488);
      case ReferenceType.jurnal:    return const Color(0xFF38BDF8);
      case ReferenceType.website:   return const Color(0xFFF59E0B);
      case ReferenceType.skripsi:   return const Color(0xFFEC4899);
      case ReferenceType.prosiding: return const Color(0xFF8B5CF6);
      case ReferenceType.lainnya:   return const Color(0xFF64748B);
    }
  }

  void _confirmDelete(BuildContext context, BookReference ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Referensi?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('"${ref.title}" oleh ${ref.author} akan dihapus.', style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              this.ref.read(bibliographyProvider.notifier).removeReference(ref.id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF43F5E), foregroundColor: Colors.white, elevation: 0),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) => _showReferenceDialog(context, null);
  void _showEditDialog(BuildContext context, BookReference existing) => _showReferenceDialog(context, existing);

  void _showReferenceDialog(BuildContext context, BookReference? existing) {
    final isEdit = existing != null;
    ReferenceType selectedType = existing?.type ?? ReferenceType.buku;

    // Controllers
    final authorCtrl    = TextEditingController(text: existing?.author ?? '');
    final yearCtrl      = TextEditingController(text: existing?.year.toString() ?? '2024');
    final titleCtrl     = TextEditingController(text: existing?.title ?? '');
    final publisherCtrl = TextEditingController(text: existing?.publisher ?? '');
    final cityCtrl      = TextEditingController(text: existing?.city ?? '');
    final editionCtrl   = TextEditingController(text: existing?.edition ?? '');
    final journalCtrl   = TextEditingController(text: existing?.journalName ?? '');
    final volumeCtrl    = TextEditingController(text: existing?.volume ?? '');
    final issueCtrl     = TextEditingController(text: existing?.issue ?? '');
    final pagesCtrl     = TextEditingController(text: existing?.pages ?? '');
    final doiCtrl       = TextEditingController(text: existing?.doi ?? '');
    final urlCtrl       = TextEditingController(text: existing?.url ?? '');
    final accessCtrl    = TextEditingController(text: existing?.accessDate ?? '');
    final institutionCtrl = TextEditingController(text: existing?.institution ?? '');
    final fileUrlCtrl   = TextEditingController(text: existing?.fileUrl ?? '');

    void disposeAll() {
      for (final c in [authorCtrl, yearCtrl, titleCtrl, publisherCtrl, cityCtrl, editionCtrl,
          journalCtrl, volumeCtrl, issueCtrl, pagesCtrl, doiCtrl, urlCtrl, accessCtrl, institutionCtrl, fileUrlCtrl]) {
        c.dispose();
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setS) {
          Widget buildField(String label, TextEditingController ctrl, {int maxLines = 1, String hint = ''}) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                controller: ctrl,
                maxLines: maxLines,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  labelText: label,
                  hintText: hint.isNotEmpty ? hint : null,
                  hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                  labelStyle: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.04),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF334155))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF334155))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _accentColor, width: 1.5)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            );
          }

          // Fields dinamis berdasarkan tipe
          List<Widget> typeFields;
          switch (selectedType) {
            case ReferenceType.buku:
              typeFields = [
                buildField('Penerbit *', publisherCtrl, hint: 'Alfabeta, Erlangga, Gramedia, ...'),
                buildField('Kota Terbit', cityCtrl, hint: 'Bandung, Jakarta, ...'),
                buildField('Edisi', editionCtrl, hint: 'Edisi ke-3'),
              ];
              break;
            case ReferenceType.jurnal:
              typeFields = [
                buildField('Nama Jurnal *', journalCtrl, hint: 'Jurnal Informatika, IEEE Access, ...'),
                buildField('Volume', volumeCtrl, hint: 'Vol. 12'),
                buildField('Nomor', issueCtrl, hint: 'No. 3'),
                buildField('Halaman', pagesCtrl, hint: 'pp. 45–67'),
                buildField('DOI', doiCtrl, hint: '10.xxxx/xxxxx'),
              ];
              break;
            case ReferenceType.website:
              typeFields = [
                buildField('URL *', urlCtrl, hint: 'https://...'),
                buildField('Tanggal Akses', accessCtrl, hint: '15 Mei 2025'),
              ];
              break;
            case ReferenceType.skripsi:
              typeFields = [
                buildField('Institusi / Kampus *', institutionCtrl, hint: 'Politeknik Negeri Medan'),
                buildField('Kota', cityCtrl, hint: 'Medan'),
              ];
              break;
            case ReferenceType.prosiding:
              typeFields = [
                buildField('Nama Seminar / Konferensi *', journalCtrl, hint: 'Seminar Nasional Teknologi Informasi...'),
                buildField('Halaman', pagesCtrl, hint: 'pp. 12–18'),
              ];
              break;
            case ReferenceType.lainnya:
              typeFields = [
                buildField('Keterangan Tambahan', publisherCtrl, hint: 'Sumber, lembaga, dll.'),
              ];
              break;
          }

          return Dialog(
            insetPadding: const EdgeInsets.all(16),
            backgroundColor: const Color(0xFF0F172A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(ctx).size.height * 0.9,
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: _accentColor.withOpacity(0.08),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      border: Border(bottom: BorderSide(color: _accentColor.withOpacity(0.15))),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: _accentColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.menu_book_rounded, color: _accentColor, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isEdit ? 'Edit Referensi' : 'Tambah Referensi Baru',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),

                  // Form area scrollable
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ─ Jenis Referensi
                          const Text('Jenis Referensi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: ReferenceType.values.map((t) {
                              final isSel = selectedType == t;
                              final tColor = _typeColor(t);
                              return ChoiceChip(
                                label: Text('${t.icon} ${t.label}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSel ? tColor : const Color(0xFF64748B))),
                                selected: isSel,
                                selectedColor: tColor.withOpacity(0.15),
                                backgroundColor: Colors.white.withOpacity(0.04),
                                side: BorderSide(color: isSel ? tColor : const Color(0xFF334155)),
                                onSelected: (_) => setS(() => selectedType = t),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),

                          // ─ Field umum (wajib semua jenis)
                          const Text('Informasi Wajib', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                          const SizedBox(height: 10),
                          buildField('Penulis / Pengarang *',
                            authorCtrl,
                            hint: 'Sugiyono  atau  Lastname, F., & Lastname2, F.',
                          ),
                          buildField('Tahun Terbit *', yearCtrl, hint: '2024'),
                          buildField('Judul *', titleCtrl, hint: 'Judul buku / artikel / halaman web', maxLines: 2),
                          const SizedBox(height: 4),
                          // ─ Field spesifik tipe
                          if (typeFields.isNotEmpty) ...[
                            const Text('Detail Tambahan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                            const SizedBox(height: 10),
                            ...typeFields,
                          ],
                          
                          const SizedBox(height: 12),
                          const Text('eBook / Berkas Referensi (Opsional)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                          const SizedBox(height: 10),
                          StatefulBuilder(
                            builder: (ctx3, setStateField) {
                              final isLocalFile = fileUrlCtrl.text.startsWith('local:');
                              String displayFileName = 'Belum ada file terlampir';
                              if (isLocalFile) {
                                final parts = fileUrlCtrl.text.substring(6).split('|');
                                displayFileName = parts.length > 1 ? parts.sublist(1).join('|') : 'File Terlampir';
                              }
                              
                              if (isLocalFile) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF38BDF8).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.2)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.insert_drive_file_rounded, color: Color(0xFF38BDF8), size: 20),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          displayFileName,
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.download_rounded, color: Color(0xFF38BDF8), size: 20),
                                        onPressed: () {
                                          final parts = fileUrlCtrl.text.substring(6).split('|');
                                          indexedDBService.downloadFile(parts[0]);
                                        },
                                        tooltip: 'Unduh File',
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      const SizedBox(width: 16),
                                      IconButton(
                                        icon: const Icon(Icons.close_rounded, color: Color(0xFFF43F5E), size: 20),
                                        onPressed: () {
                                          final parts = fileUrlCtrl.text.substring(6).split('|');
                                          indexedDBService.deleteFile(parts[0]);
                                          setStateField(() {
                                            fileUrlCtrl.text = '';
                                          });
                                        },
                                        tooltip: 'Hapus File',
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              
                              return Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: fileUrlCtrl,
                                      style: const TextStyle(fontSize: 12),
                                      decoration: InputDecoration(
                                        labelText: 'Link eBook (URL / Google Drive)',
                                        hintText: 'https://drive.google.com/...',
                                        hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                                        labelStyle: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(0.04),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF334155))),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF334155))),
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _accentColor, width: 1.5)),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      final result = await FilePicker.pickFiles(withData: true);
                                      if (result != null && result.files.isNotEmpty) {
                                        final file = result.files.first;
                                        if (file.bytes != null) {
                                          final fileId = 'ref_file_${DateTime.now().millisecondsSinceEpoch}';
                                          await indexedDBService.saveFile(
                                            id: fileId,
                                            fileName: file.name,
                                            bytes: file.bytes!,
                                            mimeType: file.extension != null ? 'application/${file.extension}' : null,
                                          );
                                          
                                          setStateField(() {
                                            fileUrlCtrl.text = 'local:$fileId|${file.name}';
                                          });
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF38BDF8).withOpacity(0.15),
                                      foregroundColor: const Color(0xFF38BDF8),
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    icon: const Icon(Icons.upload_file_rounded, size: 16),
                                    label: const Text('Upload', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () { disposeAll(); Navigator.pop(ctx); },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF64748B),
                              side: const BorderSide(color: Color(0xFF334155)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Batal'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final author = authorCtrl.text.trim();
                              final title = titleCtrl.text.trim();
                              final year = int.tryParse(yearCtrl.text.trim()) ?? 0;

                              if (author.isEmpty || title.isEmpty || year < 1900) return;

                              final newRef = BookReference(
                                id: existing?.id,
                                author: author,
                                year: year,
                                title: title,
                                type: selectedType,
                                publisher: publisherCtrl.text.trim(),
                                city: cityCtrl.text.trim(),
                                edition: editionCtrl.text.trim(),
                                journalName: journalCtrl.text.trim(),
                                volume: volumeCtrl.text.trim(),
                                issue: issueCtrl.text.trim(),
                                pages: pagesCtrl.text.trim(),
                                doi: doiCtrl.text.trim(),
                                url: urlCtrl.text.trim(),
                                accessDate: accessCtrl.text.trim(),
                                institution: institutionCtrl.text.trim(),
                                fileUrl: fileUrlCtrl.text.trim(),
                              );

                              if (isEdit) {
                                ref.read(bibliographyProvider.notifier).updateReference(newRef);
                              } else {
                                ref.read(bibliographyProvider.notifier).addReference(newRef);
                              }

                              disposeAll();
                              Navigator.pop(ctx);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _accentColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: Icon(isEdit ? Icons.check_rounded : Icons.add_rounded, size: 18),
                            label: Text(isEdit ? 'Simpan Perubahan' : 'Tambahkan', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
