import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/logbook_provider.dart';

class SignatureDialog extends ConsumerStatefulWidget {
  final String logId;
  final String existingSignatureData;

  const SignatureDialog({
    super.key,
    required this.logId,
    this.existingSignatureData = '',
  });

  @override
  ConsumerState<SignatureDialog> createState() => _SignatureDialogState();
}

class _SignatureDialogState extends ConsumerState<SignatureDialog> {
  List<List<Offset>> _strokes = [];
  final List<List<Offset>> _undoneStrokes = [];
  String _mentorName = '';
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final data = widget.existingSignatureData;
    if (data.contains('@')) {
      final parts = data.split('@');
      _strokes = _deserializeSignature(parts[0]);
      _mentorName = parts[1];
      _nameController.text = parts[1];
    } else {
      _strokes = _deserializeSignature(data);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _serializeSignature(List<List<Offset>> strokes, String name) {
    final strokesStr = strokes
        .map((stroke) => stroke.map((p) => '${p.dx.toStringAsFixed(1)},${p.dy.toStringAsFixed(1)}').join(';'))
        .join('|');
    return '$strokesStr@$name';
  }

  List<List<Offset>> _deserializeSignature(String data) {
    if (data.isEmpty) return [];
    try {
      return data.split('|').map((strokeStr) {
        if (strokeStr.isEmpty) return <Offset>[];
        return strokeStr.split(';').map((pointStr) {
          final parts = pointStr.split(',');
          return Offset(double.parse(parts[0]), double.parse(parts[1]));
        }).toList();
      }).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
      child: AlertDialog(
        backgroundColor: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: BorderSide(color: const Color(0xFF38BDF8).withOpacity(0.3), width: 1.5),
        ),
        title: Row(
          children: [
            const Icon(Icons.gesture_rounded, color: Color(0xFF38BDF8), size: 28),
            const SizedBox(width: 12),
            const Text(
              'Paraf Mentor Lapangan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Minta mentor Anda mencoretkan paraf/tanda tangan secara langsung pada area di bawah ini menggunakan mouse, trackpad, atau layar sentuh.',
                style: TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 20),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF38BDF8).withOpacity(0.2),
                    style: BorderStyle.solid,
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // Grid background for guidelines
                      Positioned.fill(
                        child: CustomPaint(
                          painter: GridBackgroundPainter(isDark: isDark),
                        ),
                      ),
                      Positioned.fill(
                        child: MouseRegion(
                          cursor: SystemMouseCursors.precise,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onPanStart: (details) {
                              setState(() {
                                _strokes.add([details.localPosition]);
                                _undoneStrokes.clear();
                              });
                            },
                            onPanUpdate: (details) {
                              if (_strokes.isEmpty) return;
                              setState(() {
                                _strokes.last.add(details.localPosition);
                              });
                            },
                            child: CustomPaint(
                              painter: SignaturePainter(strokes: _strokes, color: const Color(0xFF38BDF8), mentorName: _mentorName),
                            ),
                          ),
                        ),
                      ),
                      if (_strokes.isEmpty && _mentorName.isEmpty)
                        const Center(
                          child: Text(
                            'Area Coretan Paraf',
                            style: TextStyle(color: Color(0xFF64748B), fontSize: 14, fontStyle: FontStyle.italic),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Mentor (Ketik untuk tanda tangan digital)',
                  prefixIcon: const Icon(Icons.person_rounded, size: 20, color: Color(0xFF38BDF8)),
                  filled: true,
                  fillColor: const Color(0xFF64748B).withOpacity(0.06),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 1.5)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (val) {
                  setState(() {
                    _mentorName = val;
                  });
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: _strokes.isNotEmpty
                        ? () {
                            setState(() {
                              final last = _strokes.removeLast();
                              _undoneStrokes.add(last);
                            });
                          }
                        : null,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF38BDF8),
                      disabledForegroundColor: Colors.grey.withOpacity(0.4),
                    ),
                    icon: const Icon(Icons.undo_rounded, size: 18),
                    label: const Text('Undo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  TextButton.icon(
                    onPressed: _undoneStrokes.isNotEmpty
                        ? () {
                            setState(() {
                              final last = _undoneStrokes.removeLast();
                              _strokes.add(last);
                            });
                          }
                        : null,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF38BDF8),
                      disabledForegroundColor: Colors.grey.withOpacity(0.4),
                    ),
                    icon: const Icon(Icons.redo_rounded, size: 18),
                    label: const Text('Redo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B))),
              ),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                     ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _strokes.clear();
                          _undoneStrokes.clear();
                          _mentorName = '';
                          _nameController.clear();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF43F5E).withOpacity(0.1),
                        foregroundColor: const Color(0xFFF43F5E),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                      icon: const Icon(Icons.clear_rounded, size: 16),
                      label: const Text('Bersihkan', style: TextStyle(fontSize: 12)),
                    ),
                    ElevatedButton.icon(
                      onPressed: (_strokes.isNotEmpty || _mentorName.isNotEmpty)
                          ? () {
                              final data = _serializeSignature(_strokes, _mentorName);
                              ref.read(logbookControllerProvider.notifier).saveSignature(widget.logId, data);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Paraf mentor berhasil disimpan!'),
                                  backgroundColor: Color(0xFF0D9488),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF38BDF8),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                      icon: const Icon(Icons.check_rounded, size: 16),
                      label: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GridBackgroundPainter extends CustomPainter {
  final bool isDark;
  GridBackgroundPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withOpacity(0.03)
      ..strokeWidth = 1.0;

    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    
    // Draw signature line helper
    final linePaint = Paint()
      ..color = (isDark ? Colors.white12 : Colors.black12)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    
    canvas.drawLine(
      Offset(30, size.height - 50),
      Offset(size.width - 30, size.height - 50),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SignaturePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Color color;
  final double strokeWidth;
  final String mentorName;

  SignaturePainter({
    required this.strokes,
    required this.color,
    this.strokeWidth = 3.5,
    required this.mentorName,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (mentorName.isNotEmpty) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: mentorName,
          style: TextStyle(
            color: color.withOpacity(0.85),
            fontSize: 22,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cursive',
            fontStyle: FontStyle.italic,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset((size.width - textPainter.width) / 2, size.height - 85),
      );
    }

    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      if (stroke.length == 1) {
        canvas.drawCircle(
          stroke.first,
          strokeWidth / 2,
          Paint()
            ..color = color
            ..style = PaintingStyle.fill,
        );
      } else {
        final path = Path();
        path.moveTo(stroke.first.dx, stroke.first.dy);
        for (int i = 1; i < stroke.length; i++) {
          path.lineTo(stroke[i].dx, stroke[i].dy);
        }
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SignaturePainter oldDelegate) => true;
}

class SignaturePreviewWidget extends StatelessWidget {
  final String signatureData;
  final double width;
  final double height;
  final Color color;

  const SignaturePreviewWidget({
    super.key,
    required this.signatureData,
    this.width = 60,
    this.height = 30,
    this.color = const Color(0xFF38BDF8),
  });

  List<List<Offset>> _deserializeSignature(String data) {
    if (data.isEmpty) return [];
    try {
      return data.split('|').map((strokeStr) {
        if (strokeStr.isEmpty) return <Offset>[];
        return strokeStr.split(';').map((pointStr) {
          final parts = pointStr.split(',');
          return Offset(double.parse(parts[0]), double.parse(parts[1]));
        }).toList();
      }).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    String coordData = signatureData;
    String name = '';
    if (signatureData.contains('@')) {
      final parts = signatureData.split('@');
      coordData = parts[0];
      name = parts[1];
    }
    
    final strokes = _deserializeSignature(coordData);
    if (strokes.isEmpty && name.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.transparent,
      );
    }

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(2.0),
      child: CustomPaint(
        painter: SignaturePreviewPainter(strokes: strokes, color: color, mentorName: name),
      ),
    );
  }
}

class SignaturePreviewPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Color color;
  final String mentorName;

  SignaturePreviewPainter({
    required this.strokes,
    required this.color,
    required this.mentorName,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (strokes.isEmpty && mentorName.isNotEmpty) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: mentorName,
          style: TextStyle(
            color: color,
            fontSize: size.height * 0.45,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cursive',
            fontStyle: FontStyle.italic,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2),
      );
      return;
    }

    double minX = double.infinity, minY = double.infinity;
    double maxX = double.negativeInfinity, maxY = double.negativeInfinity;
    int pointCount = 0;

    for (final stroke in strokes) {
      for (final point in stroke) {
        if (point.dx < minX) minX = point.dx;
        if (point.dy < minY) minY = point.dy;
        if (point.dx > maxX) maxX = point.dx;
        if (point.dy > maxY) maxY = point.dy;
        pointCount++;
      }
    }

    if (pointCount == 0) return;

    final double sigWidth = maxX - minX;
    final double sigHeight = maxY - minY;

    if (sigWidth <= 0 || sigHeight <= 0) return;

    final double scaleX = size.width / sigWidth;
    final double scaleY = size.height / sigHeight;
    final double scale = scaleX < scaleY ? scaleX : scaleY;

    final double dx = (size.width - sigWidth * scale) / 2 - minX * scale;
    final double dy = (size.height - sigHeight * scale) / 2 - minY * scale;

    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(scale);

    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      final path = Path();
      path.moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }

    canvas.restore();

    // Draw the name centered at the bottom of the strokes in preview if both exist
    if (mentorName.isNotEmpty) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: mentorName,
          style: TextStyle(
            color: color.withOpacity(0.8),
            fontSize: size.height * 0.25,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cursive',
            fontStyle: FontStyle.italic,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset((size.width - textPainter.width) / 2, size.height - textPainter.height),
      );
    }
  }

  @override
  bool shouldRepaint(covariant SignaturePreviewPainter oldDelegate) =>
      oldDelegate.strokes != strokes || oldDelegate.color != color;
}
