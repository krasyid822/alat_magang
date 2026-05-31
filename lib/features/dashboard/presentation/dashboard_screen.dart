import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/dashboard_provider.dart';
import 'widgets/dashboard_stats.dart';
import 'widgets/nim_setup_dialog.dart';
import 'widgets/progress_circle.dart';

import '../../logbook/provider/logbook_provider.dart';
import '../../job_details/provider/job_provider.dart';
import '../../research/provider/research_provider.dart';
import '../../documents/provider/documents_provider.dart';
import '../../shared/data/models.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  final Function(int) onTabSelected;
  const DashboardScreen({super.key, required this.onTabSelected});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _dialogShown = false;
  final _scrollController = ScrollController();

  void _showInitialDialog() {
    if (_dialogShown) return;
    _dialogShown = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const NimSetupDialog(forceSetup: true),
    ).then((_) {
      if (mounted) setState(() => _dialogShown = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(dashboardControllerProvider);
    final syncState = ref.watch(syncStatusProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Trigger input NIM otomatis jika belum diisi
    if (profile.nim.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showInitialDialog());
    }

    // Hitung progress masing-masing sub-fitur secara riil dan dinamis
    final logs = ref.watch(logbookProvider).where((e) => !e.isDeleted).toList();
    final jobs = ref.watch(jobProvider).where((e) => !e.isDeleted).toList();
    final research = ref.watch(researchProvider);
    final docs = ref.watch(documentsProvider).where((e) => !e.isDeleted).toList();

    // 1. Logbook: 50% pengisian log (target durasi magang), 50% tanda tangan mentor
    final logsProgress = (logs.length / profile.internshipDurationWeeks.toDouble()).clamp(0.0, 1.0);
    final signedProgress = logs.isEmpty ? 0.0 : (logs.where((e) => e.isSigned).length / logs.length);
    final progressLog = logs.isEmpty ? 0.0 : (logsProgress * 0.5) + (signedProgress * 0.5);

    // 2. Detail Pekerjaan: Rasio tugas selesai dibanding seluruh tugas
    final progressJob = jobs.isEmpty ? 0.0 : (jobs.where((e) => e.isCompleted).length / jobs.length);

    // 3. Riset Bab 2: Rasio field terisi dari 6 kriteria utama
    int filledResearchFields = 0;
    if (research.companyHistory.isNotEmpty) filledResearchFields++;
    if (research.companyVisionMission.isNotEmpty) filledResearchFields++;
    if (research.companyStructureUrl.isNotEmpty) filledResearchFields++;
    if (research.jobDescription.isNotEmpty) filledResearchFields++;
    if (research.procedureWork.isNotEmpty) filledResearchFields++;
    if (research.obstacles.isNotEmpty) filledResearchFields++;
    final progressResearch = filledResearchFields / 6.0;

    // 4. Administrasi Alat 3 & 4: Rasio dokumen selesai
    final progressDocs = docs.isEmpty ? 0.0 : (docs.where((e) => e.isCompleted).length / docs.length);

    final averageProgress = (progressLog + progressJob + progressResearch + progressDocs) / 4.0;

    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, profile, syncState, isDark),
            const SizedBox(height: 30),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
                decoration: BoxDecoration(
                  color: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(
                    color: (isDark ? Colors.white10 : Colors.black12),
                  ),
                ),
                child: ProgressCircle(progress: averageProgress),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Ceklis Kelengkapan Laporan Magang',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            ),
            const SizedBox(height: 16),
            DashboardStats(
              progressAlat1Log: progressLog,
              progressAlat1Job: progressJob,
              progressAlat2: progressResearch,
              progressAlat3And4: progressDocs,
              onTabSelected: widget.onTabSelected,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildHeader(BuildContext context, dynamic profile, SyncState syncState, bool isDark) {
    Color statusColor;
    IconData statusIcon;
    bool showLoading = false;

    switch (syncState.status) {
      case SyncStatusType.uploading:
        statusColor = const Color(0xFF38BDF8); // Sky 400
        statusIcon = Icons.cloud_upload_rounded;
        showLoading = true;
        break;
      case SyncStatusType.downloading:
        statusColor = const Color(0xFF38BDF8);
        statusIcon = Icons.cloud_download_rounded;
        showLoading = true;
        break;
      case SyncStatusType.synced:
        statusColor = const Color(0xFF0D9488); // Teal 600
        statusIcon = Icons.cloud_done_rounded;
        break;
      case SyncStatusType.error:
        statusColor = const Color(0xFFEF4444); // Red 500
        statusIcon = Icons.cloud_off_rounded;
        break;
      case SyncStatusType.offline:
        statusColor = const Color(0xFF64748B); // Slate 500
        statusIcon = Icons.cloud_off_rounded;
        break;
      case SyncStatusType.idle:
        statusColor = const Color(0xFF0D9488);
        statusIcon = Icons.cloud_queue_rounded;
        break;
    }

    final headerText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profile.name.isEmpty ? 'Halo Mahasiswa!' : 'Halo, ${profile.name} 👋',
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -1),
        ),
        const SizedBox(height: 6),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 6,
          children: [
            Text(
              profile.nim.isEmpty ? 'Belum terinisialisasi' : 'NIM: ${profile.nim} | ${profile.className}',
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor.withOpacity(0.2), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showLoading)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                        ),
                      ),
                    )
                  else
                    Icon(statusIcon, size: 12, color: statusColor),
                  const SizedBox(width: 6),
                  Text(
                    syncState.message,
                    style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );

    return headerText;
  }
}
