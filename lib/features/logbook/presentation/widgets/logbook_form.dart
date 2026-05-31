import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/data/models.dart';
import '../../provider/logbook_provider.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.existingLog != null) {
      final log = widget.existingLog!;
      _activityController.text = log.activity;
      _selectedDate = DateTime.tryParse(log.date) ?? DateTime.now();
      _startTime = _parseTime(log.startTime);
      _endTime = _parseTime(log.endTime);
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
    
    return existing.activity != _activityController.text ||
        existing.date != formattedDate ||
        existing.startTime != formattedStartTime ||
        existing.endTime != formattedEndTime;
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
          side: BorderSide(color: const Color(0xFF38BDF8).withOpacity(0.3), width: 1.5),
        ),
        title: Row(
          children: [
            const Icon(Icons.calendar_month_rounded, color: Color(0xFF38BDF8), size: 24),
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
                      color: const Color(0xFF38BDF8).withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.15)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, color: Color(0xFF38BDF8), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Pelaksanaan: Minggu Ke-$calculatedWeek (Dihitung Otomatis)',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF38BDF8), fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _activityController,
                    maxLines: 3,
                    decoration: _inputDecoration('Uraian Kegiatan / Pekerjaan', Icons.description_rounded),
                    validator: (v) => v!.trim().isEmpty ? 'Uraian kegiatan wajib diisi' : null,
                  ),
                  if (widget.existingLog != null) ...[
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _reasonController,
                      decoration: _inputDecoration('Alasan Perubahan (Opsional)', Icons.rate_review_rounded),
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
          ElevatedButton(
            onPressed: (widget.existingLog != null && !_hasChanges) ? null : () => _save(calculatedWeek),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF38BDF8),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            child: const Text('Simpan Kegiatan', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
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
        decoration: _inputDecoration('Tanggal Kegiatan', Icons.calendar_today_rounded),
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
        decoration: _inputDecoration(label, Icons.access_time_rounded),
        child: Text(time.format(context)),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20, color: const Color(0xFF38BDF8)),
      filled: true,
      fillColor: const Color(0xFF64748B).withOpacity(0.06),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  void _save(int calculatedWeek) {
    if (_formKey.currentState!.validate()) {
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
