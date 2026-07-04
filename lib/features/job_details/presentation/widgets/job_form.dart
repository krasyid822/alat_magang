import 'dart:ui';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/data/models.dart';
import '../../provider/job_provider.dart';
import '../../../shared/data/theme_provider.dart';
import '../../../shared/presentation/image_preview_dialog.dart';

class JobForm extends ConsumerStatefulWidget {
  final JobDetail? existingJob;
  const JobForm({super.key, this.existingJob});

  @override
  ConsumerState<JobForm> createState() => _JobFormState();
}

class _JobFormState extends ConsumerState<JobForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _imageController = TextEditingController();
  final _reasonController = TextEditingController();
  
  bool _isCompleted = true;
  DateTime _selectedDate = DateTime.now();
  bool _showUrlField = false;
  String? _imageError;
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    if (widget.existingJob != null) {
      final job = widget.existingJob!;
      _titleController.text = job.title;
      _descController.text = job.description;
      _imageUrls = job.imageUrl.split('|||').where((s) => s.isNotEmpty).toList();
      _isCompleted = job.isCompleted;
      _reasonController.text = job.reasonOfIncompletion;
      _selectedDate = DateTime.tryParse(job.date) ?? DateTime.now();
    }
  }

  void _pickFromGallery() {
    final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen((e) {
          setState(() {
            _imageUrls.add(reader.result as String);
            _imageError = null;
          });
        });
      }
    });
  }

  void _captureFromCamera() async {
    // Hapus sisa overlay lama jika ada (antisipasi sisa hot-reload)
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
      ..style.border = '1.5px solid rgba(${context.toolColors.job.red}, ${context.toolColors.job.green}, ${context.toolColors.job.blue}, 0.3)'
      ..style.boxShadow = '0 25px 50px -12px rgba(0, 0, 0, 0.5)'
      ..style.display = 'flex'
      ..style.flexDirection = 'column'
      ..style.gap = '16px';

    final header = html.HeadingElement.h3()
      ..text = 'Kamera Dokumentasi Magang'
      ..style.color = 'rgb(${context.toolColors.job.red}, ${context.toolColors.job.green}, ${context.toolColors.job.blue})'
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
      ..style.backgroundColor = 'rgb(${context.toolColors.job.red}, ${context.toolColors.job.green}, ${context.toolColors.job.blue})'
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

    // Jalankan stream pertama kali
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
        
        setState(() {
          _imageUrls.add(dataUrl);
          _imageError = null;
        });
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

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _imageController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
      child: AlertDialog(
        backgroundColor: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.85),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: BorderSide(color: context.toolColors.job.withOpacity(0.3), width: 1.5),
        ),
        title: Row(
          children: [
            Icon(Icons.add_photo_alternate_rounded, color: context.toolColors.job, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.existingJob == null ? 'Tambah Detail Pekerjaan' : 'Sunting Detail Pekerjaan',
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
                  _buildDatePicker(context),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _titleController,
                    decoration: _inputDecoration(context, 'Nama Tugas / Pekerjaan Utama (Non-Harian)', Icons.task_alt_rounded),
                    validator: (v) => v!.trim().isEmpty ? 'Nama tugas wajib diisi' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _descController,
                    maxLines: 3,
                    decoration: _inputDecoration(context, 'Uraian Pekerjaan / Langkah Kerja', Icons.description_rounded),
                    validator: (v) => v!.trim().isEmpty ? 'Uraian pekerjaan wajib diisi' : null,
                  ),
                  const SizedBox(height: 14),
                  // --- AREA FOTO DOKUMENTASI ---
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Foto Dokumentasi Kegiatan (Bisa Lebih dari 1)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: context.toolColors.job.withOpacity(0.9)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Preview jika ada foto
                  if (_imageUrls.isNotEmpty) ...[
                    SizedBox(
                      height: 110,
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _imageUrls.length,
                        itemBuilder: (context, index) {
                          final imgUrl = _imageUrls[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: context.toolColors.job.withOpacity(0.3)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: GestureDetector(
                                      onTap: () => showZoomableImagePreview(context, imgUrl),
                                      child: imgUrl.startsWith('data:image')
                                          ? Image.network(imgUrl, fit: BoxFit.cover)
                                          : Image.network(
                                              imgUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => const Center(
                                                child: Icon(Icons.broken_image_rounded, size: 24, color: Color(0xFF64748B)),
                                              ),
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black54,
                                      radius: 12,
                                      child: IconButton(
                                        iconSize: 12,
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(Icons.close_rounded, color: Color(0xFFF43F5E)),
                                        onPressed: () => setState(() {
                                          _imageUrls.removeAt(index);
                                        }),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  // Pilihan tombol penambah foto
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF64748B).withOpacity(0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF64748B).withOpacity(0.1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildOptionButton(
                          context,
                          icon: Icons.camera_alt_rounded,
                          label: 'Kamera',
                          onTap: _captureFromCamera,
                        ),
                        _buildOptionButton(
                          context,
                          icon: Icons.photo_library_rounded,
                          label: 'Galeri',
                          onTap: _pickFromGallery,
                        ),
                        _buildOptionButton(
                          context,
                          icon: Icons.link_rounded,
                          label: 'Tautan URL',
                          onTap: () => setState(() => _showUrlField = !_showUrlField),
                        ),
                      ],
                    ),
                  ),
                  
                  // Jika tombol Tautan URL ditekan, tampilkan text inputnya
                  if (_showUrlField) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _imageController,
                            decoration: _inputDecoration(context, 'Tempel / Input URL Foto Baru', Icons.link_rounded),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.add_circle_rounded, color: context.toolColors.job, size: 28),
                          onPressed: () {
                            final val = _imageController.text.trim();
                            if (val.isNotEmpty) {
                              setState(() {
                                _imageUrls.add(val);
                                _imageController.clear();
                                _showUrlField = false;
                                _imageError = null;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                  if (_imageError != null) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded, color: Color(0xFFF43F5E), size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _imageError!,
                              style: const TextStyle(
                                color: Color(0xFFF43F5E),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  _buildCompletionStatusSwitch(context),
                  if (!_isCompleted) ...[
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _reasonController,
                      maxLines: 2,
                      decoration: _inputDecoration(context, 'Alasan Tugas Tidak Selesai', Icons.warning_amber_rounded),
                      validator: (v) => !_isCompleted && v!.trim().isEmpty ? 'Wajib menuliskan alasan jika belum selesai' : null,
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
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.toolColors.job,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            child: const Text('Simpan Detail', style: TextStyle(fontWeight: FontWeight.bold)),
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
        decoration: _inputDecoration(context, 'Tanggal Eksekusi', Icons.calendar_today_rounded),
        child: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
      ),
    );
  }

  Widget _buildCompletionStatusSwitch(BuildContext context) {
    return SwitchListTile(
      title: const Text('Status Tugas: Selesai?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      value: _isCompleted,
      activeColor: context.toolColors.job,
      onChanged: (val) => setState(() => _isCompleted = val),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: const Color(0xFF64748B).withOpacity(0.06),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20, color: context.toolColors.job),
      filled: true,
      fillColor: const Color(0xFF64748B).withOpacity(0.06),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: context.toolColors.job, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _buildOptionButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.toolColors.job.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: context.toolColors.job, size: 22),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (_imageUrls.isEmpty) {
      setState(() {
        _imageError = 'Foto dokumentasi wajib diambil minimal 1 foto dari Kamera, Galeri, atau URL!';
      });
      return;
    }

    if (_formKey.currentState!.validate()) {
      final formattedDate = _selectedDate.toIso8601String().split('T')[0];

      final job = JobDetail(
        id: widget.existingJob?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descController.text,
        imageUrl: _imageUrls.join('|||'),
        isCompleted: _isCompleted,
        reasonOfIncompletion: _isCompleted ? '' : _reasonController.text,
        date: formattedDate,
      );

      final controller = ref.read(jobControllerProvider.notifier);
      if (widget.existingJob == null) {
        controller.addJob(job);
      } else {
        controller.updateJob(job);
      }
      Navigator.pop(context);
    }
  }
}
