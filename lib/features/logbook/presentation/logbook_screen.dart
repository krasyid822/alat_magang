import 'dart:ui';
import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/logbook_provider.dart';
import 'widgets/logbook_form.dart';
import 'widgets/signature_dialog.dart';
import '../../shared/data/models.dart';
import '../../shared/data/theme_provider.dart';
import '../../shared/presentation/image_preview_dialog.dart';
import '../../shared/presentation/running_text.dart';
import '../../shared/presentation/chunked_image.dart';

class LogbookScreen extends ConsumerStatefulWidget {
  const LogbookScreen({super.key});

  @override
  ConsumerState<LogbookScreen> createState() => _LogbookScreenState();
}

class _LogbookScreenState extends ConsumerState<LogbookScreen> {
  int _selectedWeekFilter = 0; // 0 = Semua
  final _searchController = TextEditingController();
  final _mainScrollController = ScrollController();
  final _chipScrollController = ScrollController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _mainScrollController.dispose();
    _chipScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(logbookStreamProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scrollbar(
      controller: _mainScrollController,
      child: SingleChildScrollView(
        controller: _mainScrollController,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildSearchBar(context, isDark),
            const SizedBox(height: 16),
            _buildWeekFilters(context, logsAsync.value ?? []),
            const SizedBox(height: 16),
            logsAsync.when(
              data: (logs) {
                var filtered = _selectedWeekFilter == 0
                    ? logs
                    : logs.where((l) => l.weekNumber == _selectedWeekFilter).toList();
                
                if (_searchQuery.isNotEmpty) {
                  final specQuery = _searchQuery.trim().toLowerCase();
                  final regExpWDay = RegExp(r'^w(\d+)\s+(\d+)$');
                  final regExpWOnly = RegExp(r'^w(\d+)$');

                  final matchWDay = regExpWDay.firstMatch(specQuery);
                  final matchWOnly = regExpWOnly.firstMatch(specQuery);

                  if (matchWDay != null) {
                    final targetWeek = int.tryParse(matchWDay.group(1) ?? '');
                    var targetDayStr = matchWDay.group(2) ?? '';
                    if (targetDayStr.length == 1) {
                      targetDayStr = '0$targetDayStr';
                    }
                    filtered = filtered.where((l) {
                      final dayPart = l.date.split('-').last;
                      return l.weekNumber == targetWeek && dayPart == targetDayStr;
                    }).toList();
                  } else if (matchWOnly != null) {
                    final targetWeek = int.tryParse(matchWOnly.group(1) ?? '');
                    filtered = filtered.where((l) => l.weekNumber == targetWeek).toList();
                  } else {
                    filtered = filtered.where((l) {
                      final activity = l.activity.toLowerCase();
                      final date = l.date.toLowerCase();
                      return activity.contains(_searchQuery) || date.contains(_searchQuery);
                    }).toList();
                  }
                }
                
                if (filtered.isEmpty) return _buildEmptyState(isDark);
                return _buildLogsTableOrList(context, filtered, isDark);
              },
              loading: () => Center(child: CircularProgressIndicator(color: context.toolColors.logbook)),
              error: (err, _) => Center(child: Text('Gagal memuat logbook: $err')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Cari aktivitas atau tanggal logbook...',
          hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: context.toolColors.logbook, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, color: Color(0xFF64748B), size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Logbook & Absensi Magang',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5),
              ),
              const SizedBox(height: 6),
              Text(
                'Alat 1: Catat kehadiran harian dan mintakan paraf mentor mingguan.',
                style: TextStyle(color: const Color(0xFF64748B), fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () => showDialog(context: context, builder: (context) => const LogbookForm()),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.toolColors.logbook,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
          icon: const Icon(Icons.add_rounded, size: 20),
          label: const Text('Tambah Log', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildWeekFilters(BuildContext context, List<dynamic> logs) {
    final weeks = {0, ...logs.map((e) => e.weekNumber as int)}.toList()..sort();
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _chipScrollController,
      child: Row(
        children: weeks.map((week) {
          final isSelected = _selectedWeekFilter == week;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(week == 0 ? 'Semua Minggu' : 'Minggu $week'),
              selected: isSelected,
              selectedColor: context.toolColors.logbook.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected ? context.toolColors.logbook : const Color(0xFF64748B),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (_) => setState(() => _selectedWeekFilter = week),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note_rounded, size: 70, color: const Color(0xFF64748B).withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text('Belum ada log aktivitas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Klik "Tambah Log" untuk mulai mengisi agenda harian Anda.', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
        ],
      ),
    );
  }


  String _getMonthName(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      const months = [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
      ];
      return months[date.month - 1];
    } catch (_) {
      return '—';
    }
  }

  String _getDayAndDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
      final dayName = days[date.weekday - 1];
      return '$dayName, ${date.day} ${_getMonthName(dateStr)} ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  void _showImagePreview(BuildContext context, String url) {
    showZoomableImagePreview(context, url);
  }

  Widget _buildLogsTableOrList(BuildContext context, List<dynamic> logs, bool isDark) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: logs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, idx) {
        final log = logs[idx];
        return Container(
          decoration: BoxDecoration(
            color: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: context.toolColors.logbook.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('W${log.weekNumber}', style: TextStyle(fontWeight: FontWeight.bold, color: context.toolColors.logbook, fontSize: 13)),
                          const SizedBox(height: 2),
                          Text(log.date.split('-')[2], style: TextStyle(fontSize: 11, color: context.toolColors.logbook, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: RunningText(
                                  text: log.activity.isEmpty ? '(Belum ada uraian kegiatan)' : log.activity,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: log.activity.isEmpty ? Colors.grey : null,
                                    fontStyle: log.activity.isEmpty ? FontStyle.italic : null,
                                  ),
                                ),
                              ),
                              if (log.isDraft) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                                  ),
                                  child: const Text(
                                    'DRAF',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Jam Kerja: ${log.startTime} - ${log.endTime} | ${_getDayAndDate(log.date)}',
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                          ),
                          Text(
                            'Bulan: ${_getMonthName(log.date)} | Minggu Ke-${log.weekNumber}',
                            style: TextStyle(color: context.toolColors.logbook, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    if (log.isSigned && log.signatureData.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: context.toolColors.job.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: context.toolColors.job.withOpacity(0.12)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SignaturePreviewWidget(
                              signatureData: log.signatureData,
                              width: 70,
                              height: 35,
                              color: context.toolColors.job,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Paraf Mentor',
                              style: TextStyle(
                                color: context.toolColors.job,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else if (!log.isDraft) ...[
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => SignatureDialog(logId: log.id),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: context.toolColors.logbook, width: 1.2),
                          foregroundColor: context.toolColors.logbook,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.draw_rounded, size: 14),
                        label: const Text('Paraf', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
                
                // Image Gallery & Doc Link
                if (log.imageUrls.isNotEmpty || log.docLink.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  const Divider(height: 1, color: Colors.white10),
                  if (log.imageUrls.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.photo_library_rounded, size: 13, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          'Dokumentasi Kegiatan (${log.imageUrls.length} Foto)',
                          style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: log.imageUrls.length,
                        itemBuilder: (context, imgIdx) {
                          final imgUrl = log.imageUrls[imgIdx];
                          return GestureDetector(
                            onTap: () => _showImagePreview(context, imgUrl),
                            child: Container(
                              width: 70,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: ChunkedImage(
                                  url: imgUrl,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  if (log.docLink.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        html.window.open(log.docLink, '_blank');
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: context.toolColors.logbook.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: context.toolColors.logbook.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.link_rounded, color: context.toolColors.logbook, size: 16),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Buka Tautan Dokumentasi',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: context.toolColors.logbook,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.open_in_new_rounded, color: context.toolColors.logbook, size: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],

                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.visibility_rounded, color: context.toolColors.logbook, size: 20),
                      onPressed: () => _showViewDialog(context, log),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                      tooltip: 'Lihat Detail',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_rounded, color: Color(0xFFF43F5E), size: 20),
                      onPressed: () {
                        final isDark = Theme.of(context).brightness == Brightness.dark;
                        showDialog(
                          context: context,
                          builder: (context) => BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                            child: AlertDialog(
                              backgroundColor: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.85),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                side: BorderSide(color: const Color(0xFFF43F5E).withOpacity(0.3), width: 1.5),
                              ),
                              title: Row(
                                children: [
                                  const Icon(Icons.warning_amber_rounded, color: Color(0xFFF43F5E), size: 24),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      'Hapus Logbook',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                              content: const Text(
                                'Apakah Anda yakin ingin menghapus logbook kegiatan ini? Tindakan ini tidak dapat dibatalkan.',
                                style: TextStyle(fontSize: 14, height: 1.4),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B))),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    ref.read(logbookControllerProvider.notifier).deleteLog(log.id);
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF43F5E),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                  ),
                                  child: const Text('Hapus', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                      tooltip: 'Hapus Logbook',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showViewDialog(BuildContext context, dynamic log) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: AlertDialog(
            backgroundColor: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.92),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
              side: BorderSide(color: context.toolColors.logbook.withOpacity(0.3), width: 1.5),
            ),
            title: Row(
              children: [
                Icon(Icons.event_note_rounded, color: context.toolColors.logbook, size: 24),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Detail Logbook Absensi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.black12,
                  radius: 16,
                  child: IconButton(
                    iconSize: 16,
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tanggal: ${log.date}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: context.toolColors.logbook.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Minggu Ke-${log.weekNumber}',
                            style: TextStyle(color: context.toolColors.logbook, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Uraian Kegiatan:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: context.toolColors.logbook),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      log.activity,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Jam Kerja: ${log.startTime} - ${log.endTime}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                    ),
                    const Divider(height: 28, thickness: 1, color: Colors.white10),
                    
                    // PARAF AREA
                    if (log.isSigned && log.signatureData.isNotEmpty) ...[
                      Text(
                        'Paraf Mentor Lapangan:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: context.toolColors.job),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: context.toolColors.job.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.toolColors.job.withOpacity(0.15)),
                        ),
                        child: Row(
                          children: [
                            SignaturePreviewWidget(signatureData: log.signatureData, width: 80, height: 40, color: context.toolColors.job),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Paraf Terverifikasi', style: TextStyle(color: context.toolColors.job, fontSize: 13, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 2),
                                  Text('Telah disetujui oleh mentor.', style: TextStyle(color: context.toolColors.job.withOpacity(0.8), fontSize: 11)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_rounded, color: Color(0xFFF43F5E), size: 20),
                              onPressed: () {
                                Navigator.pop(context); // Close view dialog
                                _confirmDeleteSignature(context, log);
                              },
                              tooltip: 'Hapus Paraf',
                            ),
                          ],
                        ),
                      ),
                    ] else if (log.isDraft) ...[
                      const Text(
                        'Status Kegiatan:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.amber),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.amber.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.edit_note_rounded, color: Colors.amber, size: 28),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Draf Kegiatan', style: TextStyle(color: const Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 2),
                                  const Text('Lengkapi dan kirim kegiatan ini agar dapat diparaf mentor.', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      const Text(
                        'Status Paraf:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFF43F5E)),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: context.toolColors.logbook.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.toolColors.logbook.withOpacity(0.1)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.draw_rounded, color: context.toolColors.logbook.withOpacity(0.6), size: 28),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Belum Diparaf', style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 2),
                                  Text('Minta mentor paraf secara digital di beranda.', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    // VERSION HISTORY TRIGGER BUTTON
                    if (log.versionHistory.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _showHistoryDialog(context, log);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: context.toolColors.logbook.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: context.toolColors.logbook.withOpacity(0.2)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Expanded(
                                child: Row(
                                  children: [
                                    Icon(Icons.history_rounded, color: context.toolColors.logbook, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: RunningText(
                                        text: 'Lihat Riwayat Perubahan (${jsonDecode(log.versionHistory).length} Versi)',
                                        style: TextStyle(color: context.toolColors.logbook, fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded, color: context.toolColors.logbook, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup', style: TextStyle(color: Color(0xFF64748B))),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => LogbookForm(existingLog: log),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.toolColors.logbook,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
                icon: const Icon(Icons.edit_rounded, size: 16),
                label: const Text('Sunting', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteSignature(BuildContext context, dynamic log) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: AlertDialog(
          backgroundColor: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.85),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
            side: BorderSide(color: const Color(0xFFF43F5E).withOpacity(0.3), width: 1.5),
          ),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Color(0xFFF43F5E), size: 24),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Hapus Paraf Mentor',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          content: const Text(
            'Apakah Anda yakin ingin menghapus tanda tangan/paraf mentor untuk logbook ini?',
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B))),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(logbookControllerProvider.notifier).saveSignature(log.id, '');
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF43F5E),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
              child: const Text('Hapus', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showHistoryDialog(BuildContext context, dynamic log) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    List<dynamic> history = [];
    try {
      history = jsonDecode(log.versionHistory) as List<dynamic>;
    } catch (_) {}

    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: AlertDialog(
          backgroundColor: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.92),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
            side: BorderSide(color: context.toolColors.logbook.withOpacity(0.3), width: 1.5),
          ),
          title: Row(
            children: [
              Icon(Icons.history_rounded, color: context.toolColors.logbook, size: 24),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Riwayat Versi Kegiatan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 450,
            child: history.isEmpty
                ? const Center(child: Text('Belum ada riwayat perubahan.'))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: history.length,
                    itemBuilder: (context, idx) {
                      final item = history[idx];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black26 : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Versi #${history.length - idx}',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: context.toolColors.logbook, fontSize: 12),
                                ),
                                Text(
                                  item['editedAt'] ?? '',
                                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                                ),
                              ],
                            ),
                            if (item['changeReason'] != null && (item['changeReason'] as String).isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: context.toolColors.logbook.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: context.toolColors.logbook.withOpacity(0.15)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.label_outline_rounded, color: context.toolColors.logbook, size: 12),
                                    const SizedBox(width: 4),
                                    Text(
                                      item['changeReason'] ?? '',
                                      style: TextStyle(color: context.toolColors.logbook, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const Divider(height: 16, thickness: 1),
                            Text(
                              item['activity'] ?? '',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Jam Kerja: ${item['startTime']} - ${item['endTime']} | ${item['date']}',
                                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                                  ),
                                ),
                                if (item['isSigned'] == true && item['signatureData'] != null && (item['signatureData'] as String).isNotEmpty) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: context.toolColors.job.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.verified_rounded, color: context.toolColors.job, size: 10),
                                        const SizedBox(width: 2),
                                        Text('Paraf', style: TextStyle(color: context.toolColors.job, fontSize: 9, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ],
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: () => _restoreVersion(context, log, item, idx),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: context.toolColors.logbook.withOpacity(0.12),
                                    foregroundColor: context.toolColors.logbook,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  icon: const Icon(Icons.settings_backup_restore_rounded, size: 12),
                                  label: const Text('Restore', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup', style: TextStyle(color: Color(0xFF64748B))),
            ),
          ],
        ),
      ),
    );
  }

  void _restoreVersion(BuildContext context, dynamic log, Map<String, dynamic> versionToRestore, int index) {
    // 0. Cek jika versi sama persis dengan yang aktif
    if (log.activity == versionToRestore['activity'] &&
        log.date == versionToRestore['date'] &&
        log.startTime == versionToRestore['startTime'] &&
        log.endTime == versionToRestore['endTime']) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logbook sudah berada di versi ini.'),
          backgroundColor: Color(0xFF64748B),
        ),
      );
      return;
    }

    // 1. Ambil riwayat versi yang ada
    List<dynamic> historyList = [];
    if (log.versionHistory.isNotEmpty) {
      try {
        historyList = jsonDecode(log.versionHistory) as List<dynamic>;
      } catch (_) {}
    }

    // 2. Ambil data versi saat ini (sebelum di-restore)
    final targetVersionNumber = historyList.length - index;
    final currentSnapshot = {
      'activity': log.activity,
      'date': log.date,
      'startTime': log.startTime,
      'endTime': log.endTime,
      'isSigned': log.isSigned,
      'signatureData': log.signatureData,
      'editedAt': '${DateTime.now().toIso8601String().split('T')[0]} ${TimeOfDay.now().format(context)} (Sebelum Restore)',
      'changeReason': 'Dipulihkan ke Versi #$targetVersionNumber',
    };

    // 3. Hapus item versi yang di-restore agar tidak duplikat
    if (index >= 0 && index < historyList.length) {
      historyList.removeAt(index);
    }

    // 4. Masukkan versi saat ini ke dalam riwayat versi
    historyList.insert(0, currentSnapshot);

    // 5. Buat objek log baru dengan data yang di-restore
    final updatedLog = (log as InternshipLog).copyWith(
      activity: versionToRestore['activity'] ?? log.activity,
      date: versionToRestore['date'] ?? log.date,
      startTime: versionToRestore['startTime'] ?? log.startTime,
      endTime: versionToRestore['endTime'] ?? log.endTime,
      isSigned: versionToRestore['isSigned'] ?? false,
      signatureData: versionToRestore['signatureData'] ?? '',
      versionHistory: jsonEncode(historyList),
    );

    // 6. Update data lewat controller
    ref.read(logbookControllerProvider.notifier).updateLog(updatedLog);

    // 7. Tutup dialog riwayat
    Navigator.pop(context);

    // 8. Tampilkan pesan sukses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Berhasil memulihkan logbook ke versi terpilih! Versi sebelumnya disimpan sebagai riwayat.'),
        backgroundColor: Color(0xFF0D9488),
      ),
    );
  }
}
