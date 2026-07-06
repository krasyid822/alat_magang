import 'dart:ui';
import 'dart:convert';
import 'dart:async';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';


import '../../../shared/data/models.dart';
import '../../provider/logbook_provider.dart';
import '../../../shared/data/theme_provider.dart';
import '../../../shared/data/file_chunk_service.dart';
import '../../../dashboard/provider/dashboard_provider.dart';
import '../../../shared/presentation/chunked_image.dart';


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
  final _linkController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);
  List<String> _imageUrls = [];
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  final _scrollController = ScrollController();
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
      _linkController.text = log.docLink;
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
        imagesChanged ||
        existing.docLink != _linkController.text;
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

  Future<Uint8List> _compressImage(Uint8List bytes) {
    final completer = Completer<Uint8List>();
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final image = html.ImageElement()..src = url;

    image.onLoad.listen((_) {
      const maxDimension = 1024;
      int width = image.naturalWidth;
      int height = image.naturalHeight;

      if (width > maxDimension || height > maxDimension) {
        if (width > height) {
          height = (height * maxDimension / width).round();
          width = maxDimension;
        } else {
          width = (width * maxDimension / height).round();
          height = maxDimension;
        }
      }

      final canvas = html.CanvasElement(width: width, height: height);
      final ctx = canvas.context2D;
      ctx.drawImageScaled(image, 0, 0, width, height);

      final dataUrl = canvas.toDataUrl('image/jpeg', 0.85);
      html.Url.revokeObjectUrl(url);

      final base64String = dataUrl.split(',')[1];
      completer.complete(base64Decode(base64String));
    });

    image.onError.listen((err) {
      html.Url.revokeObjectUrl(url);
      completer.completeError(Exception('Gagal memproses/kompresi gambar'));
    });

    return completer.future;
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

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final compressedBytes = await _compressImage(file.bytes!);
      final fileName = '${file.name.replaceAll(RegExp(r'\.[^.]+$'), '')}_compressed.jpg';
      const mimeType = 'image/jpeg';

      final cloudUrl = await fileChunkService.uploadFile(
        nim: nim,
        fileName: fileName,
        bytes: compressedBytes,
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

  Future<void> _uploadWebcamImage(String dataUrl) async {
    final base64Str = dataUrl.split(',').last;
    final bytes = base64.decode(base64Str);

    final nim = ref.read(dashboardControllerProvider).nim;
    if (nim.isEmpty) return;

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final compressedBytes = await _compressImage(bytes);
      final fileName = 'webcam_${DateTime.now().millisecondsSinceEpoch}.jpg';
      const mimeType = 'image/jpeg';

      final cloudUrl = await fileChunkService.uploadFile(
        nim: nim,
        fileName: fileName,
        bytes: compressedBytes,
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
          SnackBar(
            content: Text('Gagal mengunggah foto: $e'),
            backgroundColor: const Color(0xFFF43F5E),
          ),
        );
      }
    }
  }

  void _captureFromCamera() async {
    html.document.getElementById('webcam_overlay')?.remove();

    final mediaDevices = html.window.navigator.mediaDevices;
    if (mediaDevices == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kamera tidak didukung oleh browser Anda!'),
          backgroundColor: Color(0xFFF43F5E),
        ),
      );
      return;
    }

    final overlay = html.DivElement()
      ..style.position = 'fixed'
      ..style.top = '0'
      ..style.left = '0'
      ..style.width = '100vw'
      ..style.height = '100vh'
      ..style.backgroundColor = 'rgba(15, 23, 42, 0.85)'
      ..style.setProperty('backdrop-filter', 'blur(10px)')
      ..style.display = 'flex'
      ..style.flexDirection = 'column'
      ..style.alignItems = 'center'
      ..style.justifyContent = 'center'
      ..style.zIndex = '999999'
      ..id = 'webcam_overlay';

    final card = html.DivElement()
      ..style.width = '95%'
      ..style.maxWidth = '550px'
      ..style.backgroundColor = '#1E293B'
      ..style.borderRadius = '24px'
      ..style.padding = '24px'
      ..style.border = '1.5px solid rgba(${context.toolColors.logbook.red}, ${context.toolColors.logbook.green}, ${context.toolColors.logbook.blue}, 0.3)'
      ..style.boxShadow = '0 25px 50px -12px rgba(0, 0, 0, 0.5)'
      ..style.display = 'flex'
      ..style.flexDirection = 'column'
      ..style.gap = '16px';

    final header = html.HeadingElement.h3()
      ..text = 'Kamera Dokumentasi Magang'
      ..style.color = 'rgb(${context.toolColors.logbook.red}, ${context.toolColors.logbook.green}, ${context.toolColors.logbook.blue})'
      ..style.margin = '0'
      ..style.fontSize = '20px'
      ..style.fontWeight = 'bold'
      ..style.fontFamily = 'system-ui, sans-serif'
      ..style.textAlign = 'center';

    final video = html.VideoElement()
      ..autoplay = true
      ..style.width = '100%'
      ..style.height = '320px'
      ..style.borderRadius = '16px'
      ..style.objectFit = 'cover'
      ..style.backgroundColor = '#0F172A';

    final buttonRow = html.DivElement()
      ..style.display = 'flex'
      ..style.justifyContent = 'center'
      ..style.flexWrap = 'wrap'
      ..style.gap = '10px'
      ..style.marginTop = '8px';

    final cancelBtn = html.ButtonElement()
      ..text = 'Batal'
      ..style.padding = '10px 16px'
      ..style.borderRadius = '10px'
      ..style.border = 'none'
      ..style.backgroundColor = 'rgba(255, 255, 255, 0.1)'
      ..style.color = '#94A3B8'
      ..style.fontSize = '12px'
      ..style.fontWeight = 'bold'
      ..style.cursor = 'pointer'
      ..style.fontFamily = 'system-ui, sans-serif';

    final switchCamBtn = html.ButtonElement()
      ..text = 'Ganti Kamera'
      ..style.padding = '10px 16px'
      ..style.borderRadius = '10px'
      ..style.border = 'none'
      ..style.backgroundColor = 'rgba(255, 255, 255, 0.1)'
      ..style.color = '#FFFFFF'
      ..style.fontSize = '12px'
      ..style.fontWeight = 'bold'
      ..style.cursor = 'pointer'
      ..style.fontFamily = 'system-ui, sans-serif';

    final mirrorBtn = html.ButtonElement()
      ..text = 'Cermin: NONAKTIF'
      ..style.padding = '10px 16px'
      ..style.borderRadius = '10px'
      ..style.border = 'none'
      ..style.backgroundColor = 'rgba(255, 255, 255, 0.1)'
      ..style.color = '#FFFFFF'
      ..style.fontSize = '12px'
      ..style.fontWeight = 'bold'
      ..style.cursor = 'pointer'
      ..style.fontFamily = 'system-ui, sans-serif';

    final captureBtn = html.ButtonElement()
      ..text = 'Ambil Foto'
      ..style.padding = '10px 20px'
      ..style.borderRadius = '10px'
      ..style.border = 'none'
      ..style.backgroundColor = 'rgb(${context.toolColors.logbook.red}, ${context.toolColors.logbook.green}, ${context.toolColors.logbook.blue})'
      ..style.color = '#FFFFFF'
      ..style.fontSize = '12px'
      ..style.fontWeight = 'bold'
      ..style.cursor = 'pointer'
      ..style.fontFamily = 'system-ui, sans-serif';

    buttonRow.append(cancelBtn);
    buttonRow.append(switchCamBtn);
    buttonRow.append(mirrorBtn);
    buttonRow.append(captureBtn);

    card.append(header);
    card.append(video);
    card.append(buttonRow);
    overlay.append(card);

    html.document.body?.append(overlay);

    bool isClosed = false;
    html.MediaStream? activeStream;
    String facingMode = 'environment';
    bool isMirrored = false;

    void updateMirrorButtonUI() {
      if (isMirrored) {
        mirrorBtn.text = 'Cermin: AKTIF';
        mirrorBtn.style.backgroundColor = 'rgba(59, 130, 246, 0.4)';
        mirrorBtn.style.border = '1px solid #3B82F6';
      } else {
        mirrorBtn.text = 'Cermin: NONAKTIF';
        mirrorBtn.style.backgroundColor = 'rgba(255, 255, 255, 0.1)';
        mirrorBtn.style.border = 'none';
      }
    }

    void closeCamera() {
      isClosed = true;
      if (activeStream != null) {
        try {
          final tracks = (activeStream as dynamic).getTracks() as List;
          for (final track in tracks) {
            try {
              (track as dynamic).stop();
            } catch (_) {}
          }
        } catch (_) {}
      }
      overlay.remove();
    }

    Future<void> startStream() async {
      if (activeStream != null) {
        try {
          final tracks = (activeStream as dynamic).getTracks() as List;
          for (final track in tracks) {
            try {
              (track as dynamic).stop();
            } catch (_) {}
          }
        } catch (_) {}
      }

      try {
        final stream = await mediaDevices.getUserMedia({
          'video': {
            'facingMode': facingMode,
            'width': {'ideal': 1280},
            'height': {'ideal': 720}
          }
        });
        if (isClosed) {
          final tracks = (stream as dynamic).getTracks() as List;
          for (final track in tracks) {
            try {
              (track as dynamic).stop();
            } catch (_) {}
          }
          return;
        }
        activeStream = stream;
        video.srcObject = stream;
        video.style.transform = isMirrored ? 'scaleX(-1)' : 'scaleX(1)';
      } catch (e) {
        if (!isClosed) {
          closeCamera();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Gagal membuka kamera: ${e.toString()}'),
                backgroundColor: const Color(0xFFF43F5E),
              ),
            );
          }
        }
      }
    }

    cancelBtn.addEventListener('click', (_) => closeCamera());

    switchCamBtn.addEventListener('click', (_) {
      facingMode = (facingMode == 'user') ? 'environment' : 'user';
      isMirrored = (facingMode == 'user'); // Auto mirror if front camera
      updateMirrorButtonUI();
      startStream();
    });

    mirrorBtn.addEventListener('click', (_) {
      isMirrored = !isMirrored;
      updateMirrorButtonUI();
      video.style.transform = isMirrored ? 'scaleX(-1)' : 'scaleX(1)';
    });

    await startStream();

    captureBtn.addEventListener('click', (_) {
      try {
        final canvas = html.CanvasElement(width: video.videoWidth, height: video.videoHeight);
        final ctx = canvas.context2D;
        
        if (isMirrored) {
          ctx.translate(canvas.width ?? 0, 0);
          ctx.scale(-1, 1);
        }
        
        ctx.drawImage(video, 0, 0);
        
        final dataUrl = canvas.toDataUrl('image/jpeg', 0.85);
        _uploadWebcamImage(dataUrl);
      } catch (err) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal memproses gambar: $err'),
              backgroundColor: const Color(0xFFF43F5E),
            ),
          );
        }
      } finally {
        closeCamera();
      }
    });
  }

  void _showLinkDialog() {
    final controller = TextEditingController(text: _linkController.text);
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Tambah Tautan Dokumentasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'https://example.com/dokumentasi',
              prefixIcon: const Icon(Icons.link_rounded),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _linkController.text = controller.text;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.toolColors.logbook,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _activityController.removeListener(_onTextChanged);
    _activityController.dispose();
    _reasonController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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
            controller: _scrollController,
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
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ChunkedImage(
                          url: url,
                          width: 90,
                          height: 90,
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
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isUploading ? null : _captureFromCamera,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: color, width: 1.2),
                  foregroundColor: color,
                  minimumSize: const Size(0, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
                icon: const Icon(Icons.camera_alt_rounded, size: 16),
                label: const Text('Kamera', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isUploading ? null : _uploadImage,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: color, width: 1.2),
                  foregroundColor: color,
                  minimumSize: const Size(0, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
                icon: const Icon(Icons.photo_library_rounded, size: 16),
                label: const Text('Galeri', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isUploading ? null : _showLinkDialog,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: color, width: 1.2),
                  foregroundColor: color,
                  minimumSize: const Size(0, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
                icon: const Icon(Icons.link_rounded, size: 16),
                label: const Text('Tautan', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
        if (_linkController.text.isNotEmpty) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: context.toolColors.logbook.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.toolColors.logbook.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.link_rounded, color: context.toolColors.logbook, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tautan Terlampir',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      Text(
                        _linkController.text,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: context.toolColors.logbook,
                          decoration: TextDecoration.underline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _linkController.text = '';
                    });
                  },
                ),
              ],
            ),
          ),
        ],
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
    if (!_formKey.currentState!.validate()) {
      _scrollToTop();
      return;
    }
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
            existing.endTime != formattedEndTime ||
            existing.docLink != _linkController.text;

        if (hasChanged) {
          final snapshot = {
            'activity': existing.activity,
            'date': existing.date,
            'startTime': existing.startTime,
            'endTime': existing.endTime,
            'isSigned': existing.isSigned,
            'signatureData': existing.signatureData,
            'docLink': existing.docLink,
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
        docLink: _linkController.text,
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
