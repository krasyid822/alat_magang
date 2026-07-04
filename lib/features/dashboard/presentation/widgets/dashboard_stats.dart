import 'package:flutter/material.dart';
import '../../../shared/data/theme_provider.dart';

class DashboardStats extends StatelessWidget {
  final double progressAlat1Log;
  final double progressAlat1Job;
  final double progressAlat2;
  final double progressAlat3And4;
  final Function(int) onTabSelected;

  const DashboardStats({
    super.key,
    required this.progressAlat1Log,
    required this.progressAlat1Job,
    required this.progressAlat2,
    required this.progressAlat3And4,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final toolColors = Theme.of(context).extension<ToolColors>()!;

    final steps = [
      _TimelineStep(
        title: 'Tahap 1: Administrasi Dokumen (Alat 3 & 4)',
        subtitle: 'Lengkapi berkas surat izin/selesai magang & rancang daftar pustaka laporan.',
        progress: progressAlat3And4,
        accentColor: toolColors.documents,
        icon: Icons.folder_zip_rounded,
        tabIndex: 4,
        typeLabel: 'Sekali Isi (Mandatori)',
        typeColor: toolColors.documents,
      ),
      _TimelineStep(
        title: 'Tahap 2: Catatan Logbook (Alat 1)',
        subtitle: 'Catat kehadiran harian dan ringkasan aktivitas mingguan.',
        progress: progressAlat1Log,
        accentColor: toolColors.logbook,
        icon: Icons.calendar_month_rounded,
        tabIndex: 1,
        typeLabel: 'Tugas Rutin (Harian / Mingguan)',
        typeColor: toolColors.logbook,
      ),
      _TimelineStep(
        title: 'Tahap 3: Dokumentasi Detail Pekerjaan (Alat 1)',
        subtitle: 'Catat daftar tugas utama/proyek besar yang diberikan (bukan jurnal harian).',
        progress: progressAlat1Job,
        accentColor: toolColors.job,
        icon: Icons.photo_library_rounded,
        tabIndex: 2,
        typeLabel: 'Berbasis Proyek / Tugas Utama (Non-Harian)',
        typeColor: toolColors.job,
      ),
      _TimelineStep(
        title: 'Tahap 4: Bahan Riset Bab 2 Laporan (Alat 2)',
        subtitle: 'Kumpulkan profil perusahaan, sejarah, prosedur & hambatan kerja.',
        progress: progressAlat2,
        accentColor: toolColors.research,
        icon: Icons.analytics_rounded,
        tabIndex: 3,
        typeLabel: 'Sekali Isi (6 Kriteria)',
        typeColor: toolColors.research,
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Timeline line & indicator
              _buildTimelineIndicator(context, index + 1, step.accentColor, step.progress == 1.0, isLast, isDark),
              const SizedBox(width: 16),
              // Step Card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: _buildStepCard(context, step, isDark),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimelineIndicator(
    BuildContext context,
    int stepNumber,
    Color accentColor,
    bool isCompleted,
    bool isLast,
    bool isDark,
  ) {
    return Column(
      children: [
        // Glowing circle containing step number
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted
                ? accentColor
                : (isDark ? const Color(0xFF1E293B) : Colors.white),
            shape: BoxShape.circle,
            border: Border.all(
              color: accentColor,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                : Text(
                    '$stepNumber',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: accentColor,
                    ),
                  ),
          ),
        ),
        // Connecting line
        if (!isLast)
          Expanded(
            child: Container(
              width: 2,
              color: accentColor.withOpacity(0.3),
            ),
          ),
      ],
    );
  }

  Widget _buildStepCard(
    BuildContext context,
    _TimelineStep step,
    bool isDark,
  ) {
    final percentage = (step.progress * 100).toInt();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onTabSelected(step.tabIndex),
        child: Container(
          decoration: BoxDecoration(
            color: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.85),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: (isDark ? Colors.white10 : Colors.black12),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              // Icon & details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: step.accentColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Icon(step.icon, color: step.accentColor, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: step.typeColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: step.typeColor.withOpacity(0.25), width: 1),
                                ),
                                child: Text(
                                  step.typeLabel,
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: step.typeColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      step.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: LinearProgressIndicator(
                              value: step.progress,
                              backgroundColor: step.accentColor.withOpacity(0.1),
                              valueColor: AlwaysStoppedAnimation<Color>(step.accentColor),
                              minHeight: 5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '$percentage%',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: step.accentColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Action indicator button
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: step.accentColor.withOpacity(0.6),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineStep {
  final String title;
  final String subtitle;
  final double progress;
  final Color accentColor;
  final IconData icon;
  final int tabIndex;
  final String typeLabel;
  final Color typeColor;

  const _TimelineStep({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.accentColor,
    required this.icon,
    required this.tabIndex,
    required this.typeLabel,
    required this.typeColor,
  });
}
