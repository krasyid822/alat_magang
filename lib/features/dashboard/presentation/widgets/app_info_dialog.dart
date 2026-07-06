import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../provider/dashboard_provider.dart';
import '../../../shared/data/firebase_service.dart';
import '../../../shared/data/local_storage.dart';
import '../../../../app_version.dart';
import '../../../shared/presentation/error_dialog.dart';


class AppInfoDialog extends ConsumerWidget {
  const AppInfoDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(dashboardControllerProvider);
    final nim = profile.nim;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (nim.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
        showErrorDialog(context, 'Anda belum login. Silakan masukkan NIM Anda terlebih dahulu.');
      });
      return const SizedBox.shrink();
    }

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
      child: AlertDialog(
        backgroundColor: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.3), width: 1.5),
        ),
        contentPadding: const EdgeInsets.all(24.0),
        content: SizedBox(
          width: 550,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Premium App Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.storage_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Alat Magang Web',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'v$kAppVersion+$kBuildNumber',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '© $kAppYear Politeknik Negeri Medan',
                  style: TextStyle(
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
                const Divider(height: 32, thickness: 1),
                
                // Description Text
                Text(
                  'Dikembangkan khusus untuk mahasiswa Politeknik Negeri Medan untuk mempermudah pencatatan Laporan Magang Bab 1 s.d Bab 4 secara instan dengan penyimpanan lokal yang aman.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 24),

                Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sesi Login Aktif',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        StreamBuilder<int>(
                          stream: ref.read(firebaseServiceProvider).activeSessionsCount(nim),
                          builder: (context, snapshot) {
                            final count = snapshot.data ?? 0;
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$count Device',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 250),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A).withOpacity(0.5) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
                    ),
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: ref.read(firebaseServiceProvider).activeSessionsStream(nim),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).colorScheme.primary),
                            ),
                          );
                        }
                        final sessions = snapshot.data ?? [];
                        if (sessions.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(
                              child: Text(
                                'Tidak ada sesi aktif terdeteksi.',
                                style: TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ),
                          );
                        }

                        final currentDeviceId = ref.read(localStorageProvider).getDeviceId();

                        return ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(12),
                          itemCount: sessions.length,
                          separatorBuilder: (context, index) => const Divider(height: 16),
                          itemBuilder: (context, index) {
                            final session = sessions[index];
                            final deviceId = session['deviceId'] as String? ?? '';
                            final userAgent = session['userAgent'] as String? ?? 'Unknown Device';
                            final lastActive = session['lastActive'] as Timestamp?;
                            final isCurrent = deviceId == currentDeviceId;

                            // Determine device icon
                            IconData deviceIcon = Icons.devices_other_rounded;
                            String deviceType = 'Device';
                            final uaLower = userAgent.toLowerCase();
                            if (uaLower.contains('mobi') || uaLower.contains('android') || uaLower.contains('iphone')) {
                              deviceIcon = Icons.phone_android_rounded;
                              deviceType = 'Mobile';
                            } else if (uaLower.contains('windows') || uaLower.contains('macintosh') || uaLower.contains('linux')) {
                              deviceIcon = Icons.computer_rounded;
                              deviceType = 'Desktop/Web';
                            }

                            // Format user agent nicely
                            String formattedUA = 'Web Browser';
                            if (uaLower.contains('chrome')) {
                              formattedUA = 'Google Chrome';
                            } else if (uaLower.contains('firefox')) {
                              formattedUA = 'Mozilla Firefox';
                            } else if (uaLower.contains('safari') && !uaLower.contains('chrome')) {
                              formattedUA = 'Apple Safari';
                            } else if (uaLower.contains('edge')) {
                              formattedUA = 'Microsoft Edge';
                            }

                            final timeStr = lastActive != null 
                                ? _formatTimestamp(lastActive.toDate()) 
                                : 'Baru saja';

                            return Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isCurrent 
                                        ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
                                        : Colors.grey.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    deviceIcon,
                                    color: isCurrent ? Theme.of(context).colorScheme.primary : Colors.grey,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            formattedUA,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                          ),
                                          if (isCurrent) ...[
                                            const SizedBox(width: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.primary,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: const Text(
                                                'INI',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 8,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '$deviceType • Aktif: $timeStr',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => _confirmLogoutAll(context, ref),
                      icon: const Icon(Icons.no_accounts_rounded, color: Colors.white),
                      label: const Text(
                        'Logout dari Semua Perangkat',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                         backgroundColor: const Color(0xFFF43F5E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
 
  void _confirmLogoutAll(BuildContext context, WidgetRef ref) {
    bool forceLogout = false;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Logout Semua Perangkat?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih metode logout untuk perangkat lain yang mungkin sedang offline:',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
              const SizedBox(height: 16),
              RadioListTile<bool>(
                title: const Text('Sinkronkan dahulu, lalu Logout (Rekomendasi)', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: const Text('Perangkat offline akan mengunggah data lokal terbarunya ke cloud sebelum keluar.', style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                value: false,
                groupValue: forceLogout,
                activeColor: Theme.of(context).colorScheme.primary,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) => setState(() => forceLogout = val ?? false),
              ),
              RadioListTile<bool>(
                title: const Text('Keluar Paksa & Hapus Data', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: const Text('Perangkat offline akan langsung menghapus data lokal tanpa sinkronisasi saat online.', style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                value: true,
                groupValue: forceLogout,
                activeColor: Theme.of(context).colorScheme.primary,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) => setState(() => forceLogout = val ?? true),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                Navigator.pop(ctx); // Close confirmation
                Navigator.pop(context); // Close about dialog
                await ref.read(dashboardControllerProvider.notifier).logoutAll(force: forceLogout);
                messenger.showSnackBar(
                  const SnackBar(content: Text('Perintah logout telah dikirim ke semua perangkat.')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF43F5E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Ya, Logout All', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
