import 'dart:ui';
import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String message) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  showDialog(
    context: context,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
      child: AlertDialog(
        backgroundColor: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: BorderSide(color: const Color(0xFFF43F5E).withOpacity(0.3), width: 1.5),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFF43F5E), size: 28),
            const SizedBox(width: 12),
            Text(
              'Peringatan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF43F5E),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ),
  );
}
