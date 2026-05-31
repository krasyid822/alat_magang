import 'package:flutter/material.dart';

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

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 165,
      ),
      itemCount: 4,
      itemBuilder: (context, i) {
        final cards = [
          _buildStatCard(context, title: 'Alat 1: Logbook & Absensi Magang Mingguan', subtitle: 'Catatan Mingguan & Absensi Harian Terintegrasi', progress: progressAlat1Log, color: const Color(0xFF0F172A), accentColor: const Color(0xFF38BDF8), icon: Icons.calendar_month_rounded, isDark: isDark, index: 1),
          _buildStatCard(context, title: 'Alat 1: Detail Pekerjaan & Dokumentasi', subtitle: 'Deskripsi Tugas & Foto Kegiatan Lapangan', progress: progressAlat1Job, color: const Color(0xFF0F172A), accentColor: const Color(0xFF0D9488), icon: Icons.photo_library_rounded, isDark: isDark, index: 2),
          _buildStatCard(context, title: 'Alat 2: Data & Bahan Riset Laporan', subtitle: 'Profil Perusahaan, Prosedur & Hambatan Kerja', progress: progressAlat2, color: const Color(0xFF0F172A), accentColor: const Color(0xFFF59E0B), icon: Icons.analytics_rounded, isDark: isDark, index: 3),
          _buildStatCard(context, title: 'Alat 3 & 4: Administrasi & Pustaka', subtitle: 'Surat Resmi & Daftar Pustaka Terakreditasi', progress: progressAlat3And4, color: const Color(0xFF0F172A), accentColor: const Color(0xFFEC4899), icon: Icons.folder_zip_rounded, isDark: isDark, index: 4),
        ];
        return cards[i];
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required double progress,
    required Color color,
    required Color accentColor,
    required IconData icon,
    required bool isDark,
    required int index,
  }) {
    final percentage = (progress * 100).toInt();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onTabSelected(index),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Icon(icon, color: accentColor, size: 22),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RunningText(
                    text: title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  RunningText(
                    text: subtitle,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: accentColor.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                  minHeight: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RunningText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const RunningText({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  State<RunningText> createState() => _RunningTextState();
}

class _RunningTextState extends State<RunningText> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _startScrolling() async {
    if (!_scrollController.hasClients) return;

    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    if (maxScrollExtent > 0) {
      while (mounted) {
        // Jeda di awal
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) break;
        
        // Animasi ke ujung kanan
        await _scrollController.animateTo(
          maxScrollExtent,
          duration: Duration(milliseconds: (maxScrollExtent * 40).toInt()),
          curve: Curves.easeInOut,
        );
        
        // Jeda di ujung kanan
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) break;
        
        // Animasi kembali ke ujung kiri (bolak-balik)
        await _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: (maxScrollExtent * 40).toInt()),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Text(
        widget.text,
        style: widget.style,
        maxLines: 1,
      ),
    );
  }
}
