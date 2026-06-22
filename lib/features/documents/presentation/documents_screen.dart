import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:async';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import '../../shared/data/models.dart';
import '../../shared/data/theme_provider.dart';
import '../../shared/data/indexed_db_service.dart';
import '../../shared/data/file_chunk_service.dart';
import '../../dashboard/provider/dashboard_provider.dart';
import '../provider/documents_provider.dart';
import 'widgets/bibliography_checker.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  Color get _accentColor => context.toolColors.documents;
  // Set of expanded card IDs
  final Set<String> _expandedIds = {};
  final _scrollController = ScrollController();

  // Temporary controllers per doc for notes & file URL
  final Map<String, TextEditingController> _notesControllers = {};
  final Map<String, TextEditingController> _fileUrlControllers = {};
  final Map<String, Timer> _debounceTimers = {};

  // Upload progress per docId: null = idle, 0.0–1.0 = uploading
  final Map<String, double?> _uploadProgress = {};

  @override
  void dispose() {
    for (final c in _notesControllers.values) {
      c.dispose();
    }
    for (final c in _fileUrlControllers.values) {
      c.dispose();
    }
    for (final t in _debounceTimers.values) {
      t.cancel();
    }
    _scrollController.dispose();
    super.dispose();
  }

  bool _isImageFile(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    return ['png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp'].contains(ext);
  }

  bool _isPdfFile(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    return ext == 'pdf';
  }

  Future<void> _downloadFile(DocChecklist doc, {
    required bool isLocalFile,
    required bool isCloudFile,
    required bool isChunkedFile,
    required String localId,
    required String cloudDataUrl,
    required ChunkedFileRef? chunkedRef,
    required String displayFileName,
  }) async {
    try {
      if (isChunkedFile && chunkedRef != null) {
        final nim = ref.read(dashboardControllerProvider).nim;
        final bytes = await fileChunkService.downloadFile(nim, chunkedRef);
        if (bytes != null) {
          final blob = html.Blob([bytes], chunkedRef.mimeType);
          final url = html.Url.createObjectUrlFromBlob(blob);
          html.AnchorElement(href: url)
            ..setAttribute('download', chunkedRef.fileName)
            ..click();
          html.Url.revokeObjectUrl(url);
        }
      } else if (isCloudFile && cloudDataUrl.isNotEmpty) {
        final res = await html.window.fetch(cloudDataUrl);
        final blob = await res.blob();
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..setAttribute('download', displayFileName)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else if (isLocalFile) {
        await indexedDBService.downloadFile(localId);
      }
    } catch (e) {
      debugPrint('Error downloading file: $e');
    }
  }

  void _showPreviewDialog(
    BuildContext context,
    String title,
    String url,
    String fileName, {
    required VoidCallback onDownload,
  }) {
    final isImage = _isImageFile(fileName);
    final isPdf = _isPdfFile(fileName);

    Widget content;
    if (isImage) {
      content = InteractiveViewer(
        maxScale: 5.0,
        child: Image.network(
          url,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8)));
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Text(
                'Gagal memuat gambar',
                style: TextStyle(color: Color(0xFFF43F5E)),
              ),
            );
          },
        ),
      );
    } else if (isPdf) {
      final viewId = 'pdf-view-${DateTime.now().millisecondsSinceEpoch}';
      // ignore: undefined_prefixed_name
      ui_web.platformViewRegistry.registerViewFactory(viewId, (int id) {
        return html.IFrameElement()
          ..src = url
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';
      });
      content = HtmlElementView(viewType: viewId);
    } else {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.insert_drive_file_outlined, size: 64, color: Color(0xFF64748B)),
            const SizedBox(height: 16),
            Text(
              'Pratinjau tidak didukung untuk tipe file ini (${fileName.split('.').last.toUpperCase()})',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onDownload();
              },
              icon: const Icon(Icons.download_rounded),
              label: const Text('Unduh File'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF38BDF8),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFF334155)),
                Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(8), child: content)),
              ],
            ),
          ),
        );
      },
    );
  }

  TextEditingController _notesCtrl(DocChecklist doc) {
    return _notesControllers.putIfAbsent(doc.id, () => TextEditingController(text: doc.notes));
  }

  TextEditingController _fileCtrl(DocChecklist doc) {
    return _fileUrlControllers.putIfAbsent(doc.id, () => TextEditingController(text: doc.fileUrl));
  }

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final docsAsync = ref.watch(documentsStreamProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            // Premium Search Bar
            TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Cari berkas administratif, catatan, atau kategori...',
                hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                prefixIcon: Icon(Icons.search_rounded, color: _accentColor, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: _accentColor, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 24),
            docsAsync.when(
              data: (docs) {
                // Sync controllers with fresh data on rebuild
                for (final doc in docs) {
                  _notesControllers[doc.id]?.text != doc.notes
                      ? _notesControllers[doc.id]?.text = doc.notes
                      : null;
                  _fileUrlControllers[doc.id]?.text != doc.fileUrl
                      ? _fileUrlControllers[doc.id]?.text = doc.fileUrl
                      : null;
                }

                // Filter documents by search query
                final filteredDocs = docs.where((doc) {
                  return doc.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      doc.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      doc.notes.toLowerCase().contains(_searchQuery.toLowerCase());
                }).toList();

                return Column(
                  children: [
                    if (width > 1000)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: _buildDocumentPanel(filteredDocs, isDark)),
                          const SizedBox(width: 24),
                          const Expanded(flex: 2, child: BibliographyChecker()),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildDocumentPanel(filteredDocs, isDark),
                          const SizedBox(height: 24),
                          const BibliographyChecker(),
                        ],
                      ),
                  ],
                );
              },
              loading: () => Center(child: Padding(padding: const EdgeInsets.all(40), child: CircularProgressIndicator(color: _accentColor))),
              error: (err, _) => Center(child: Text('Gagal: $err')),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Checklist Dokumen Laporan',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5),
              ),
              SizedBox(height: 6),
              Text(
                'Alat 3 & 4: Pastikan seluruh dokumen pendukung telah lengkap dan tervalidasi.',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: _showAddCustomDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: _accentColor,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
          icon: const Icon(Icons.add_task_rounded, size: 20),
          label: const Text('Dokumen Kustom', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }



  // ─── Document Panel ────────────────────────────────────────────────────────

  Widget _buildDocumentPanel(List<DocChecklist> docs, bool isDark) {
    final categories = [
      ('Alat 3', 'Berkas Administratif Wajib', Icons.assignment_rounded, _accentColor),
      ('Alat 4', 'Kelengkapan Laporan Akhir', Icons.verified_rounded, context.toolColors.research),
    ];

    // Gather all non-standard categories as "Tambahan"
    final customDocs = docs.where((d) => d.category != 'Alat 3' && d.category != 'Alat 4').toList();

    return Column(
      children: [
        ...categories.map((cat) {
          final catDocs = docs.where((d) => d.category == cat.$1).toList();
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildCategorySection(
              label: '${cat.$1}: ${cat.$2}',
              icon: cat.$3,
              color: cat.$4,
              docs: catDocs,
              isDark: isDark,
              allowDelete: false,
            ),
          );
        }),
        if (customDocs.isNotEmpty)
          _buildCategorySection(
            label: 'Dokumen Tambahan / Kustom',
            icon: Icons.add_box_rounded,
            color: const Color(0xFF0D9488),
            docs: customDocs,
            isDark: isDark,
            allowDelete: true,
          ),
      ],
    );
  }

  Widget _buildCategorySection({
    required String label,
    required IconData icon,
    required Color color,
    required List<DocChecklist> docs,
    required bool isDark,
    required bool allowDelete,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: Column(
        children: [
          // Section header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.06),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(bottom: BorderSide(color: color.withOpacity(0.12))),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 10),
                Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${docs.where((d) => d.isCompleted).length}/${docs.length}',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                  ),
                ),
              ],
            ),
          ),
          // Doc cards
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: docs.map((doc) => _buildDocCard(doc, color, isDark, allowDelete)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocCard(DocChecklist doc, Color catColor, bool isDark, bool allowDelete) {
    final isExpanded = _expandedIds.contains(doc.id);
    final hasNotes = doc.notes.isNotEmpty;
    final hasFile = doc.fileUrl.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: doc.isCompleted
            ? catColor.withOpacity(0.06)
            : (isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.02)),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: doc.isCompleted ? catColor.withOpacity(0.3) : (isDark ? Colors.white10 : Colors.black12),
          width: doc.isCompleted ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          // Main row
          InkWell(
            onTap: () => setState(() {
              if (isExpanded) {
                _expandedIds.remove(doc.id);
              } else {
                _expandedIds.add(doc.id);
              }
            }),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Checkbox button
                  GestureDetector(
                    onTap: () => ref
                        .read(documentsControllerProvider.notifier)
                        .toggleDocument(doc.id, !doc.isCompleted),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: doc.isCompleted ? catColor : Colors.transparent,
                        border: Border.all(
                          color: doc.isCompleted ? catColor : const Color(0xFF64748B),
                          width: 2,
                        ),
                      ),
                      child: doc.isCompleted
                          ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title + badges
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            decoration: doc.isCompleted ? TextDecoration.lineThrough : null,
                            color: doc.isCompleted ? const Color(0xFF64748B) : null,
                          ),
                        ),
                        if (hasNotes || hasFile) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (hasNotes) _buildBadge(Icons.notes_rounded, 'Ada catatan', const Color(0xFF64748B)),
                              if (hasNotes && hasFile) const SizedBox(width: 6),
                              if (hasFile) _buildBadge(Icons.link_rounded, 'Ada file', const Color(0xFF38BDF8)),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Expand icon
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF64748B),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Expansion: notes, file URL, delete
          if (isExpanded) _buildDocExpansion(doc, catColor, isDark, allowDelete || doc.id.startsWith('custom_')),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 3),
          Text(label, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDocExpansion(DocChecklist doc, Color catColor, bool isDark, bool allowDelete) {
    final notesCtrl = _notesCtrl(doc);
    final fileCtrl = _fileCtrl(doc);

    // Deteksi jenis URL file
    final isLocalFile = doc.fileUrl.startsWith('local:');          // legacy lokal
    final isCloudFile = doc.fileUrl.startsWith('cloudfile:');      // legacy inline base64
    final isChunkedFile = doc.fileUrl.startsWith(kChunkedPrefix);  // chunked baru

    final hasAttachment = isLocalFile || isCloudFile || isChunkedFile;

    // Parse info tampilan
    String localId = '';
    String displayFileName = '';
    String cloudDataUrl = '';     // untuk legacy cloudfile:
    ChunkedFileRef? chunkedRef;   // untuk chunked:

    if (isLocalFile) {
      final parts = doc.fileUrl.substring(6).split('|');
      localId = parts[0];
      displayFileName = parts.length > 1 ? parts.sublist(1).join('|') : 'File Terlampir';
    } else if (isCloudFile) {
      final content = doc.fileUrl.substring(10);
      final fp = content.indexOf('|');
      final sp = fp != -1 ? content.indexOf('|', fp + 1) : -1;
      if (fp != -1 && sp != -1) {
        localId = content.substring(0, fp);
        displayFileName = content.substring(fp + 1, sp);
        cloudDataUrl = content.substring(sp + 1);
      } else if (fp != -1) {
        localId = content.substring(0, fp);
        displayFileName = content.substring(fp + 1);
      } else {
        displayFileName = 'File Cloud';
      }
    } else if (isChunkedFile) {
      chunkedRef = ChunkedFileRef.fromUrl(doc.fileUrl);
      displayFileName = chunkedRef?.fileName ?? 'File Cloud';
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: catColor.withOpacity(0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: catColor.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Catatan
          _buildExpansionField(
            label: 'Catatan (kapan diterima, dari siapa, keterangan)',
            controller: notesCtrl,
            icon: Icons.notes_rounded,
            color: catColor,
            maxLines: 3,
            onChanged: (text) {
              _debounce('notes_${doc.id}', () {
                ref.read(documentsControllerProvider.notifier).updateNotes(doc.id, text);
              });
            },
          ),
          const SizedBox(height: 12),
          // Attachment (local legacy / cloud inline / chunked)
          if (hasAttachment)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.file_present_rounded, size: 12, color: Color(0xFF38BDF8)),
                    const SizedBox(width: 6),
                    const Text('File Terlampir', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8))),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayFileName,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              isChunkedFile
                                  ? '☁️ Tersedia di semua perangkat'
                                  : isCloudFile
                                      ? '☁️ Tersedia di semua perangkat'
                                      : '💻 File lokal (lama)',
                              style: TextStyle(
                                fontSize: 9,
                                color: (isChunkedFile || isCloudFile)
                                    ? const Color(0xFF38BDF8)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.visibility_rounded, color: Color(0xFF38BDF8), size: 20),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                              child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
                            ),
                          );
                          try {
                            String? url;
                            if (isChunkedFile && chunkedRef != null) {
                              final nim = ref.read(dashboardControllerProvider).nim;
                              url = await fileChunkService.getDataUrl(nim, chunkedRef);
                            } else if (isCloudFile && cloudDataUrl.isNotEmpty) {
                              url = cloudDataUrl;
                            } else if (isLocalFile) {
                              final fileData = await indexedDBService.getFile(localId);
                              if (fileData != null) {
                                final blob = fileData['data'] as html.Blob;
                                url = html.Url.createObjectUrlFromBlob(blob);
                              }
                            }

                            if (mounted) Navigator.pop(context); // Pop loading

                            if (url != null && mounted) {
                              _showPreviewDialog(
                                context,
                                displayFileName,
                                url,
                                displayFileName,
                                onDownload: () => _downloadFile(
                                  doc,
                                  isLocalFile: isLocalFile,
                                  isCloudFile: isCloudFile,
                                  isChunkedFile: isChunkedFile,
                                  localId: localId,
                                  cloudDataUrl: cloudDataUrl,
                                  chunkedRef: chunkedRef,
                                  displayFileName: displayFileName,
                                ),
                              );
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Gagal memuat file untuk pratinjau')),
                                );
                              }
                            }
                          } catch (e) {
                            if (mounted) Navigator.pop(context); // Pop loading
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Terjadi kesalahan: $e')),
                              );
                            }
                          }
                        },
                        tooltip: 'Pratinjau File',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.download_rounded, color: Color(0xFF38BDF8), size: 20),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                              child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
                            ),
                          );
                          try {
                            await _downloadFile(
                              doc,
                              isLocalFile: isLocalFile,
                              isCloudFile: isCloudFile,
                              isChunkedFile: isChunkedFile,
                              localId: localId,
                              cloudDataUrl: cloudDataUrl,
                              chunkedRef: chunkedRef,
                              displayFileName: displayFileName,
                            );
                          } finally {
                            if (mounted) Navigator.pop(context);
                          }
                        },
                        tooltip: 'Unduh File',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Color(0xFFF43F5E), size: 20),
                        onPressed: () => _confirmDeleteFile(doc, localId, chunkedRef: chunkedRef),
                        tooltip: 'Hapus File',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            _buildExpansionField(
              label: 'Link File (URL / Google Drive) atau Upload File',
              controller: fileCtrl,
              icon: Icons.link_rounded,
              color: const Color(0xFF38BDF8),
              maxLines: 1,
              onChanged: (text) {
                _debounce('file_${doc.id}', () {
                  ref.read(documentsControllerProvider.notifier).updateFileUrl(doc.id, text);
                });
              },
              actionButton: _buildUploadButton(doc),
            ),
          // Progress bar saat upload
          if (_uploadProgress[doc.id] != null) ...[  
            const SizedBox(height: 8),
            _buildUploadProgress(doc.id, _uploadProgress[doc.id]!),
          ],
          if (doc.fileUrl.isNotEmpty && !isLocalFile && !isCloudFile && !isChunkedFile) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF38BDF8).withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link_rounded, color: Color(0xFF38BDF8), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      doc.fileUrl,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                   TextButton.icon(
                    onPressed: () {
                      // Open URL without download
                      final anchor = html.AnchorElement(href: doc.fileUrl)
                        ..target = '_blank'
                        ..rel = 'noopener';
                      anchor.click();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF38BDF8),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    ),
                    icon: const Icon(Icons.open_in_new_rounded, size: 14),
                    label: const Text('Buka', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
          // Delete hanya untuk dokumen kustom
          if (allowDelete) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _confirmDelete(doc),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFF43F5E),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                icon: const Icon(Icons.delete_outline_rounded, size: 16),
                label: const Text('Hapus Dokumen Ini', style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ],
      ),
    );
  }
  Widget _buildUploadButton(DocChecklist doc) {
    final isUploading = _uploadProgress[doc.id] != null;
    return ElevatedButton.icon(
      onPressed: isUploading ? null : () async {
        final result = await FilePicker.pickFiles(withData: true);
        if (result == null || result.files.isEmpty) return;
        final file = result.files.first;
        if (file.bytes == null) return;

        final nim = ref.read(dashboardControllerProvider).nim;
        final mimeType = file.extension != null
            ? 'application/${file.extension}'
            : 'application/octet-stream';

        // Mulai upload dengan chunking otomatis
        setState(() => _uploadProgress[doc.id] = 0.0);

        try {
          final cloudUrl = await fileChunkService.uploadFile(
            nim: nim,
            fileName: file.name,
            bytes: file.bytes!,
            mimeType: mimeType,
            onProgress: (progress) {
              if (mounted) {
                setState(() => _uploadProgress[doc.id] = progress);
              }
            },
          );

          // Simpan referensi ke Firestore doc
          ref.read(documentsControllerProvider.notifier).updateFileUrl(doc.id, cloudUrl);
          _fileUrlControllers[doc.id]?.text = cloudUrl;

          if (mounted) {
            setState(() => _uploadProgress.remove(doc.id));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('☁️ ${file.name} berhasil diunggah ke cloud'),
                backgroundColor: const Color(0xFF0D9488),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            setState(() => _uploadProgress.remove(doc.id));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Gagal upload: $e'),
                backgroundColor: const Color(0xFFF43F5E),
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF38BDF8).withOpacity(isUploading ? 0.05 : 0.15),
        foregroundColor: const Color(0xFF38BDF8),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: isUploading
          ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF38BDF8)))
          : const Icon(Icons.upload_file_rounded, size: 16),
      label: Text(
        isUploading ? 'Mengunggah...' : 'Upload',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  Widget _buildUploadProgress(String docId, double progress) {
    final pct = (progress * 100).round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF38BDF8).withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cloud_upload_rounded, size: 13, color: Color(0xFF38BDF8)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Mengunggah ke cloud... $pct%',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF38BDF8), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: const Color(0xFF38BDF8).withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF38BDF8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required Color color,
    required int maxLines,
    VoidCallback? onSave,
    ValueChanged<String>? onChanged,
    Widget? actionButton,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
            const Spacer(),
            // Autosaved badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cloud_done_rounded, size: 9, color: color.withOpacity(0.7)),
                  const SizedBox(width: 3),
                  Text('Autosaved', style: TextStyle(fontSize: 9, color: color.withOpacity(0.7), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: maxLines,
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  hintText: maxLines > 1 ? 'Tambahkan catatan...' : 'https://drive.google.com/...',
                  hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                  filled: true,
                  fillColor: color.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: color.withOpacity(0.15)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: color.withOpacity(0.15)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: color, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                onChanged: onChanged ?? (text) {
                  if (onSave != null) onSave();
                },
              ),
            ),
            if (actionButton != null) ...[
              const SizedBox(width: 8),
              actionButton,
            ],
          ],
        ),
      ],
    );
  }

  /// Debounce helper for autosave
  void _debounce(String key, VoidCallback callback, {Duration delay = const Duration(milliseconds: 800)}) {
    _debounceTimers[key]?.cancel();
    _debounceTimers[key] = Timer(delay, callback);
  }

  // ─── Dialogs ───────────────────────────────────────────────────────────────

  void _confirmDelete(DocChecklist doc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Dokumen?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Dokumen "${doc.title}" akan dihapus permanen.', style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              ref.read(documentsControllerProvider.notifier).removeDocument(doc.id);
              _expandedIds.remove(doc.id);
              _notesControllers.remove(doc.id)?.dispose();
              _fileUrlControllers.remove(doc.id)?.dispose();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF43F5E), foregroundColor: Colors.white, elevation: 0),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteFile(DocChecklist doc, String localId, {ChunkedFileRef? chunkedRef}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Berkas?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Berkas yang diupload untuk "${doc.title}" akan dihapus permanen dari cloud.', style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              // Hapus referensi dari provider
              ref.read(documentsControllerProvider.notifier).updateFileUrl(doc.id, '');
              _fileUrlControllers[doc.id]?.text = '';
              // Hapus file dari IndexedDB (jika ada)
              if (localId.isNotEmpty) {
                indexedDBService.deleteFile(localId);
              }
              // Hapus chunks dari Firestore (jika file chunked)
              if (chunkedRef != null) {
                final nim = ref.read(dashboardControllerProvider).nim;
                try {
                  await fileChunkService.deleteFile(nim, chunkedRef.fileId);
                } catch (_) {}
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF43F5E), foregroundColor: Colors.white, elevation: 0),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showAddCustomDialog() {
    final titleCtrl = TextEditingController();
    String selectedCat = 'Tambahan';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setS) => Dialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _accentColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.add_task_rounded, color: _accentColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text('Tambah Dokumen Kustom', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 20),
                // Nama dokumen
                const Text('Nama Dokumen / Berkas', style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextField(
                  controller: titleCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Contoh: Surat Izin Akses Data Penelitian',
                    hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF334155)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF334155)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _accentColor, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                // Kategori
                const Text('Kategori', style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ['Alat 3', 'Alat 4', 'Tambahan'].map((cat) {
                    final isSelected = selectedCat == cat;
                    final catColor = cat == 'Alat 3'
                        ? _accentColor
                        : cat == 'Alat 4'
                            ? context.toolColors.research
                            : context.toolColors.job;
                    return ChoiceChip(
                      label: Text(cat, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isSelected ? catColor : const Color(0xFF64748B))),
                      selected: isSelected,
                      selectedColor: catColor.withOpacity(0.15),
                      backgroundColor: Colors.white.withOpacity(0.05),
                      side: BorderSide(color: isSelected ? catColor : const Color(0xFF334155)),
                      onSelected: (_) => setS(() => selectedCat = cat),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
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
                          if (titleCtrl.text.trim().isNotEmpty) {
                            ref.read(documentsControllerProvider.notifier).addCustomDocument(
                              titleCtrl.text.trim(),
                              selectedCat,
                            );
                            titleCtrl.dispose();
                            Navigator.pop(ctx);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accentColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Tambahkan', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
