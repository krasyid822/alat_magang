import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import '../../../shared/data/models.dart';
import '../../provider/logbook_provider.dart';
import '../../../shared/data/theme_provider.dart';
import '../../../shared/data/file_chunk_service.dart';
import '../../../dashboard/provider/dashboard_provider.dart';

class LogbookForm extends ConsumerStatefulWidget {
  final InternshipLog? existingLog;
  const LogbookForm({super.key, this.existingLog});

  @override
  ConsumerState<LogbookForm> createState() => _LogbookFormState();
}

class _LogbookFormState extends ConsumerState<LogbookForm> {
  final _formKey = GlobalKey<FormState>();
  final _activityController = TextEditingController();
  final _reasonController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);
  List<String> _imageUrls = [];
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  bool _isDraftSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingLog != null) {
      final log = widget.existingLog!;
      _activityController.text = log.activity;
      _selectedDate = DateTime.tryParse(log.date) ?? DateTime.now();
      _startTime = _parseTime(log.startTime);
      _endTime = _parseTime(log.endTime);
      _imageUrls = List<String>.from(log.imageUrls);
    }
    _activityController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  bool get _hasChanges {
    if (widget.existingLog == null) return true; // Adding a new log always has changes
    final existing = widget.existingLog!;
    final formattedDate = _selectedDate.toIso8601String().split('T')[0];
    final formattedStartTime = '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}';
    final formattedEndTime = '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}';
    
    // Check if images changed
    final imagesChanged = !listEquals(existing.imageUrls, _imageUrls);

    return existing.activity != _activityController.text ||
        existing.date != formattedDate ||
        existing.startTime != formattedStartTime ||
        existing.endTime != formattedEndTime ||
        imagesChanged;
  }

  TimeOfDay _parseTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (_) {
      return const TimeOfDay(hour: 8, minute: 0);
    }
  }

  int _calculateWeekNumber(DateTime date, List<InternshipLog> logs) {
    final otherLogs = widget.existingLog != null
        ? logs.where((e) => e.id != widget.existingLog!.id).toList()
        : logs;

    if (otherLogs.isEmpty) return 1;

    DateTime earliest = date;
    for (final log in otherLogs) {
      final parsed = DateTime.tryParse(log.date);
      if (parsed != null && parsed.isBefore(earliest)) {
        earliest = parsed;
      }
    }

    final earliestMonday = earliest.subtract(Duration(days: earliest.weekday - 1));
    final inputMonday = date.subtract(Duration(days: date.weekday - 1));

    final diffDays = inputMonday.difference(earliestMonday).inDays;
    final week = (diffDays / 7).floor() + 1;
    return week > 0 ? week : 1;
  }

  Future<void> _uploadImage() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.bytes == null) return;

    final nim = ref.read(dashboardControllerProvider).nim;
    if (nim.isEmpty) return;

    final mimeType = file.extension != null
        ? 'image/${file.extension}'
        : 'image/jpeg';

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final cloudUrl = await fileChunkService.uploadFile(
        nim: nim,
        fileName: file.name,
        bytes: file.bytes!,
        mimeType: mimeType,
        onProgress: (p) {
          setState(() {
            _uploadProgress = p;
          });
        },
      );

      setState(() {
        _imageUrls.add(cloudUrl);
        _isUploading = false;
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunggah foto: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    _activityController.removeListener(_onTextChanged);
    _activityController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logs = ref.watch(logbookStreamProvider).value ?? [];
    final calculatedWeek = _calculateWeekNumber(_selectedDate, logs);
    
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
      child: AlertDialog(
        backgroundColor: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.85),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: BorderSide(color: context.toolColors.logbook.withOpacity(0.3), width: 1.5),
        ),
        title: Row(
          children: [
            Icon(Icons.calendar_month_rounded, color: context.toolColors.logbook, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.existingLog == null ? 'Tambah Kegiatan Logbook' : 'Sunting Kegiatan Logbook',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.existingLog?.isSigned == true) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Logbook Sudah Diparaf',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD97706), fontSize: 13),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Perubahan data pada logbook ini akan otomatis menghapus paraf yang sudah ada dan Anda harus meminta mentor memberikan paraf kembali.',
                                  style: TextStyle(color: const Color(0xFFD97706).withOpacity(0.85), fontSize: 11, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                  _buildDatePicker(context),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: _buildTimePicker(context, 'Mulai', _startTime, (t) => setState(() => _startTime = t))),
                      const SizedBox(width: 14),
                      Expanded(child: _buildTimePicker(context, 'Selesai', _endTime, (t) => setState(() => _endTime = t))),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: context.toolColors.logbook.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.toolColors.logbook.withOpacity(0.15)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: context.toolColors.logbook, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Pelaksanaan: Minggu Ke-$calculatedWeek (Dihitung Otomatis)',
                            style: TextStyle(fontWeight: FontWeight.bold, color: context.toolColors.logbook, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _activityController,
                    maxLines: 3,
                    decoration: _inputDecoration(context, 'Uraian Kegiatan / Pekerjaan', Icons.description_rounded),
                    validator: (v) => (!_isDraftSaving && v!.trim().isEmpty) ? 'Uraian kegiatan wajib diisi' : null,
                  ),
                  const SizedBox(height: 14),
                  
                  // Dokumentasi Foto Section
                  _buildPhotoSection(context, isDark),
                  
                  if (widget.existingLog != null) ...[
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _reasonController,
                      decoration: _inputDecoration(context, 'Alasan Perubahan (Opsional)', Icons.rate_review_rounded),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B))),
          ),
          if (widget.existingLog == null || widget.existingLog!.isDraft) ...[
            OutlinedButton(
              onPressed: () => _save(calculatedWeek, isDraft: true),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: context.toolColors.logbook, width: 1.2),
                foregroundColor: context.toolColors.logbook,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
              child: const Text('Simpan sebagai Draf', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _save(calculatedWeek, isDraft: false),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.toolColors.logbook,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
              child: const Text('Simpan & Kirim', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ] else ...[
            ElevatedButton(
              onPressed: !_hasChanges ? null : () => _save(calculatedWeek, isDraft: false),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.toolColors.logbook,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
              child: const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPhotoSection(BuildContext context, bool isDark) {
    final hasMinPhotos = _imageUrls.length >= 3;
    final color = hasMinPhotos ? const Color(0xFF0D9488) : const Color(0xFFF43F5E);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.photo_library_rounded, size: 18, color: color),
                const SizedBox(width: 8),
                Text(
                  'Dokumentasi Kegiatan',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${_imageUrls.length}/3 Foto',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Pedoman Polmed mewajibkan minimal 3 foto kegiatan.',
          style: TextStyle(fontSize: 11, color: isDark ? Colors.grey[400] : Colors.grey[600]),
        ),
        const SizedBox(height: 10),
        
        // Horizontal list of images
        if (_imageUrls.isNotEmpty || _isUploading)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imageUrls.length + (_isUploading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _imageUrls.length && _isUploading) {
                  return Container(
                    width: 90,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: context.toolColors.logbook.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: context.toolColors.logbook.withOpacity(0.15)),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        value: _uploadProgress > 0 ? _uploadProgress : null,
                        color: context.toolColors.logbook,
                      ),
                    ),
                  );
                }
                
                final url = _imageUrls[index];
                return Stack(
                  children: [
                    Container(
                      width: 90,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
                        image: DecorationImage(
                          image: NetworkImage(url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 14,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _imageUrls.removeAt(index);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close_rounded, size: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _isUploading ? null : _uploadImage,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: color, width: 1.2),
            foregroundColor: color,
            minimumSize: const Size(double.infinity, 44),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: const Icon(Icons.add_photo_alternate_rounded, size: 18),
          label: const Text('Unggah Foto Kegiatan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2025),
          lastDate: DateTime(2030),
        );
        if (date != null) setState(() => _selectedDate = date);
      },
      child: InputDecorator(
        decoration: _inputDecoration(context, 'Tanggal Kegiatan', Icons.calendar_today_rounded),
        child: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context, String label, TimeOfDay time, Function(TimeOfDay) onPicked) {
    return InkWell(
      onTap: () async {
        final t = await showTimePicker(context: context, initialTime: time);
        if (t != null) onPicked(t);
      },
      child: InputDecorator(
        decoration: _inputDecoration(context, label, Icons.access_time_rounded),
        child: Text(time.format(context)),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20, color: context.toolColors.logbook),
      filled: true,
      fillColor: const Color(0xFF64748B).withOpacity(0.06),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: context.toolColors.logbook, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  void _save(int calculatedWeek, {required bool isDraft}) {
    _isDraftSaving = isDraft;
    if (_formKey.currentState!.validate()) {
      if (!isDraft && _imageUrls.length < 3) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Dokumentasi Kurang', style: TextStyle(fontWeight: FontWeight.bold)),
            content: const Text('Laporan magang wajib dilengkapi dengan minimal 3 foto kegiatan sebagai dokumentasi pelaksanaan magang.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      final formattedDate = _selectedDate.toIso8601String().split('T')[0];
      final formattedStartTime = '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}';
      final formattedEndTime = '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}';

      final willResetParaf = widget.existingLog != null && widget.existingLog!.isSigned;
      final existing = widget.existingLog;
      String newVersionHistory = existing?.versionHistory ?? '';

      if (existing != null) {
        final hasChanged = existing.activity != _activityController.text ||
            existing.date != formattedDate ||
            existing.startTime != formattedStartTime ||
            existing.endTime != formattedEndTime;

        if (hasChanged) {
          final snapshot = {
            'activity': existing.activity,
            'date': existing.date,
            'startTime': existing.startTime,
            'endTime': existing.endTime,
            'isSigned': existing.isSigned,
            'signatureData': existing.signatureData,
            'editedAt': '${DateTime.now().toIso8601String().split('T')[0]} ${TimeOfDay.now().format(context)}',
            'changeReason': _reasonController.text.trim().isEmpty ? 'Perbaikan data' : _reasonController.text.trim(),
          };

          List<dynamic> historyList = [];
          if (newVersionHistory.isNotEmpty) {
            try {
              historyList = jsonDecode(newVersionHistory) as List<dynamic>;
            } catch (_) {}
          }
          historyList.insert(0, snapshot);
          newVersionHistory = jsonEncode(historyList);
        }
      }

      final log = InternshipLog(
        id: widget.existingLog?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        date: formattedDate,
        activity: _activityController.text,
        startTime: formattedStartTime,
        endTime: formattedEndTime,
        weekNumber: calculatedWeek,
        isSigned: willResetParaf ? false : (widget.existingLog?.isSigned ?? false),
        signatureData: willResetParaf ? '' : (widget.existingLog?.signatureData ?? ''),
        versionHistory: newVersionHistory,
        imageUrls: _imageUrls,
        isDraft: isDraft,
      );

      final controller = ref.read(logbookControllerProvider.notifier);
      if (widget.existingLog == null) {
        controller.addLog(log);
      } else {
        controller.updateLog(log);
      }
      Navigator.pop(context);
    }
  }
}
