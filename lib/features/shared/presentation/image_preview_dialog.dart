import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/image_clipboard_provider.dart';
import 'chunked_image.dart';
import 'feedback_banner.dart';

void showZoomableImagePreview(BuildContext context, String url) {
  showDialog(
    context: context,
    builder: (context) => _ImagePreviewDialog(url: url),
  );
}

class _ImagePreviewDialog extends ConsumerStatefulWidget {
  final String url;

  const _ImagePreviewDialog({required this.url});

  @override
  ConsumerState<_ImagePreviewDialog> createState() => _ImagePreviewDialogState();
}

class _ImagePreviewDialogState extends ConsumerState<_ImagePreviewDialog> {
  String? _feedback;
  bool _feedbackIsError = false;
  Timer? _feedbackTimer;

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    // Jangan biarkan status "success" terbawa ke dialog berikutnya.
    ref.read(imageClipboardProvider.notifier).reset();
    super.dispose();
  }

  /// Notifikasi dirender di dalam dialog, bukan lewat ScaffoldMessenger.
  /// SnackBar milik app berada di bawah route Dialog sehingga tertutup modal.
  void _showFeedback(String message, {bool isError = false}) {
    _feedbackTimer?.cancel();
    setState(() {
      _feedback = message;
      _feedbackIsError = isError;
    });
    _feedbackTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _feedback = null);
    });
  }

  Future<void> _copy() async {
    final ok = await ref.read(imageClipboardProvider.notifier).copyFromUrl(widget.url);
    if (!mounted) return;

    final state = ref.read(imageClipboardProvider);
    if (ok) {
      _showFeedback('Gambar disalin ke clipboard');
    } else {
      _showFeedback(state.message ?? 'Gagal menyalin gambar.', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clipboard = ref.watch(imageClipboardProvider);

    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: const EdgeInsets.all(10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          InteractiveViewer(
            panEnabled: true,
            boundaryMargin: const EdgeInsets.all(20),
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: ChunkedImage(
                url: widget.url,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.broken_image_rounded, color: Colors.white, size: 50),
                ),
              ),
            ),
          ),
          Positioned(
            top: 15,
            left: 15,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: clipboard.isBusy
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : IconButton(
                      tooltip: 'Copy gambar ke clipboard',
                      icon: const Icon(Icons.copy_rounded, color: Colors.white),
                      onPressed: _copy,
                    ),
            ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: FeedbackBanner(message: _feedback, isError: _feedbackIsError),
          ),
        ],
      ),
    );
  }
}
