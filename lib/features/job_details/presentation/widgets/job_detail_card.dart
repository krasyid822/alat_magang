import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/data/models.dart';
import '../../provider/job_provider.dart';
import 'job_form.dart';
import '../../../shared/data/theme_provider.dart';
import '../../../shared/presentation/image_preview_dialog.dart';

class JobDetailCard extends ConsumerWidget {
  final JobDetail job;
  const JobDetailCard({super.key, required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.85),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImageHeader(context),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        job.date,
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      _buildStatusBadge(context),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    job.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: -0.2),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    job.description,
                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!job.isCompleted && job.reasonOfIncompletion.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: context.toolColors.research.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: context.toolColors.research.withOpacity(0.2)),
                      ),
                      child: Text(
                        'Kendala: ${job.reasonOfIncompletion}',
                        style: TextStyle(color: context.toolColors.research, fontSize: 10, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.visibility_rounded, color: context.toolColors.job, size: 18),
                        onPressed: () => _showViewDialog(context),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                        tooltip: 'Lihat Detail',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_rounded, color: Color(0xFFF43F5E), size: 18),
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
                                        'Hapus Detail Pekerjaan',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                                content: Text(
                                  'Apakah Anda yakin ingin menghapus dokumentasi tugas "${job.title}"? Tindakan ini tidak dapat dibatalkan.',
                                  style: const TextStyle(fontSize: 14, height: 1.4),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B))),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      ref.read(jobControllerProvider.notifier).deleteJob(job.id);
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
                        tooltip: 'Hapus',
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageHeader(BuildContext context) {
    final images = job.imageUrl.split('|||').where((s) => s.isNotEmpty).toList();
    final firstImage = images.isNotEmpty ? images.first : '';

    return SizedBox(
      height: 140,
      width: double.infinity,
      child: firstImage.isNotEmpty
          ? Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => showZoomableImagePreview(context, firstImage),
                    child: imgWidget(context, firstImage),
                  ),
                ),
                if (images.length > 1)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '+${images.length - 1} Foto',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            )
          : Container(
              color: context.toolColors.job.withOpacity(0.06),
              child: Center(
                child: Icon(Icons.add_photo_alternate_rounded, color: context.toolColors.job, size: 40),
              ),
            ),
    );
  }

  Widget imgWidget(BuildContext context, String url) {
    if (url.startsWith('data:image')) {
      return Image.network(url, fit: BoxFit.cover);
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: context.toolColors.job.withOpacity(0.06),
        child: const Center(
          child: Icon(Icons.broken_image_rounded, color: Color(0xFF64748B), size: 30),
        ),
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(child: CircularProgressIndicator(strokeWidth: 2, color: context.toolColors.job));
      },
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final bgColor = job.isCompleted ? context.toolColors.job.withOpacity(0.12) : context.toolColors.research.withOpacity(0.12);
    final fgColor = job.isCompleted ? context.toolColors.job : context.toolColors.research;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Text(
        job.isCompleted ? 'Selesai' : 'Kendala',
        style: TextStyle(color: fgColor, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showViewDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final images = job.imageUrl.split('|||').where((s) => s.isNotEmpty).toList();

    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: AlertDialog(
            backgroundColor: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.92),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
              side: BorderSide(color: context.toolColors.job.withOpacity(0.3), width: 1.5),
            ),
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Carousel Header
                    Stack(
                      children: [
                        SizedBox(
                          height: 250,
                          child: images.isNotEmpty
                              ? PageView.builder(
                                  itemCount: images.length,
                                  itemBuilder: (context, idx) {
                                    return GestureDetector(
                                      onTap: () => showZoomableImagePreview(context, images[idx]),
                                      child: imgWidget(context, images[idx]),
                                    );
                                  },
                                )
                              : Container(
                                  color: context.toolColors.job.withOpacity(0.06),
                                  child: Center(
                                    child: Icon(Icons.add_photo_alternate_rounded, color: context.toolColors.job, size: 50),
                                  ),
                                ),
                        ),
                        if (images.length > 1)
                          Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.65),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Geser Gambar (${images.length} Foto)',
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: CircleAvatar(
                            backgroundColor: Colors.black45,
                            radius: 18,
                            child: IconButton(
                              iconSize: 18,
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.close_rounded, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Detail info
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                job.date,
                                style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              _buildStatusBadge(context),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            job.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: -0.3),
                          ),
                          const Divider(height: 24, thickness: 1, color: Colors.white10),
                          Text(
                            'Uraian Pekerjaan:',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: context.toolColors.job),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            job.description,
                            style: const TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF64748B)),
                          ),
                          if (!job.isCompleted && job.reasonOfIncompletion.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: context.toolColors.research.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: context.toolColors.research.withOpacity(0.2)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.warning_amber_rounded, color: context.toolColors.research, size: 16),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Kendala Pelaksanaan:',
                                        style: TextStyle(color: context.toolColors.research, fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    job.reasonOfIncompletion,
                                    style: TextStyle(color: context.toolColors.research, fontSize: 13, height: 1.4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
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
                    builder: (context) => JobForm(existingJob: job),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.toolColors.job,
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
}
