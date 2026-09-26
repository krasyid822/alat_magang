import 'package:flutter/material.dart';

/// Banner notifikasi yang tampil di dalam widget tree, bukan lewat `SnackBar`.
///
/// Dipakai di dalam `Dialog`: `ScaffoldMessenger` aplikasi berada di bawah
/// route `Dialog`, sehingga `SnackBar` akan tertutup modal. Banner yang
/// dirender langsung di dalam dialog tidak memiliki masalah layer tersebut.
class FeedbackBanner extends StatelessWidget {
  final String? message;
  final bool isError;

  const FeedbackBanner({
    super.key,
    required this.message,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: message == null
            ? const SizedBox.shrink()
            : Center(
                key: ValueKey(message),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isError ? Colors.red.shade700 : Colors.white12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ),
      ),
    );
  }
}
