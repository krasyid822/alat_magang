import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/data/models.dart';
import '../../shared/data/theme_provider.dart';
import '../provider/grading_provider.dart';

class GradingScreen extends ConsumerStatefulWidget {
  const GradingScreen({super.key});

  @override
  ConsumerState<GradingScreen> createState() => _GradingScreenState();
}

class _GradingScreenState extends ConsumerState<GradingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _companySaranController = TextEditingController();
  final _mainScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Fill text controller from provider
    Future.microtask(() {
      final grading = ref.read(gradingProvider);
      _companySaranController.text = grading.companySaranKritik;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _companySaranController.dispose();
    _mainScrollController.dispose();
    super.dispose();
  }

  void _updateCompanyScore(String field, double value) {
    final current = ref.read(gradingProvider);
    InternshipGrading updated;
    switch (field) {
      case 'kerapian': updated = current.copyWith(companyKerapian: value); break;
      case 'disiplin': updated = current.copyWith(companyDisiplin: value); break;
      case 'kehadiran': updated = current.copyWith(companyKehadiran: value); break;
      case 'tanggungJawab': updated = current.copyWith(companyTanggungJawab: value); break;
      case 'kemandirian': updated = current.copyWith(companyKemandirian: value); break;
      case 'inisiatif': updated = current.copyWith(companyInisiatif: value); break;
      case 'pemahaman': updated = current.copyWith(companyPemahaman: value); break;
      case 'kerjasamaRekan': updated = current.copyWith(companyKerjasamaRekan: value); break;
      case 'kerjasamaAtasan': updated = current.copyWith(companyKerjasamaAtasan: value); break;
      case 'adaptasi': updated = current.copyWith(companyAdaptasi: value); break;
      default: return;
    }
    ref.read(gradingProvider.notifier).updateGrading(updated);
  }

  void _updateDosenScore(String field, double value) {
    final current = ref.read(gradingProvider);
    InternshipGrading updated;
    switch (field) {
      case 'format': updated = current.copyWith(dosenFormatLaporan: value); break;
      case 'uraian': updated = current.copyWith(dosenUraianLaporan: value); break;
      case 'presentasi': updated = current.copyWith(dosenPresentasiLaporan: value); break;
      case 'tanyaJawab': updated = current.copyWith(dosenTanyaJawabLaporan: value); break;
      default: return;
    }
    ref.read(gradingProvider.notifier).updateGrading(updated);
  }

  void _saveSaran(String val) {
    final current = ref.read(gradingProvider);
    final updated = current.copyWith(companySaranKritik: val);
    ref.read(gradingProvider.notifier).updateGrading(updated);
  }

  @override
  Widget build(BuildContext context) {
    final grading = ref.watch(gradingProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    
    final averageCompany = ref.watch(gradingProvider.notifier).averageCompanyScore;
    final weightedDosen = ref.watch(gradingProvider.notifier).weightedDosenScore;
    final finalScore = ref.watch(gradingProvider.notifier).finalScore;
    final finalLetter = ref.watch(gradingProvider.notifier).finalGradeLetter;
    final finalCriteria = ref.watch(gradingProvider.notifier).getGradeCriteria(finalLetter);

    // Sync saran text on external update
    if (_companySaranController.text != grading.companySaranKritik) {
      _companySaranController.text = grading.companySaranKritik;
    }

    final summaryPanel = _buildSummaryPanel(context, averageCompany, weightedDosen, finalScore, finalLetter, finalCriteria, isDark);

    return Scrollbar(
      controller: _mainScrollController,
      child: SingleChildScrollView(
        controller: _mainScrollController,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildTabsContent(context, grading, isDark)),
                  const SizedBox(width: 24),
                  Expanded(flex: 2, child: summaryPanel),
                ],
              )
            else
              Column(
                children: [
                  summaryPanel,
                  const SizedBox(height: 24),
                  _buildTabsContent(context, grading, isDark),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryPanel(
    BuildContext context,
    double averageCompany,
    double weightedDosen,
    double finalScore,
    String finalLetter,
    String finalCriteria,
    bool isDark,
  ) {
    final isPassed = finalScore >= 50.0;
    final scoreColor = isPassed ? Theme.of(context).colorScheme.primary : const Color(0xFFF43F5E);
    
    return Container(
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.assessment_rounded, color: context.toolColors.job, size: 22),
              const SizedBox(width: 8),
              const Text(
                'Ringkasan Nilai Akhir',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scoreColor.withOpacity(0.08),
                border: Border.all(color: scoreColor.withOpacity(0.3), width: 3),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    finalScore.toStringAsFixed(1),
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: scoreColor),
                  ),
                  Text(
                    'Predikat: $finalLetter',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: scoreColor.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildSummaryRow('Rata-rata Perusahaan (Form-3.30)', averageCompany.toStringAsFixed(1)),
          const SizedBox(height: 8),
          _buildSummaryRow('Nilai Dosen Pembimbing (Form-3.31)', weightedDosen.toStringAsFixed(1)),
          const Divider(height: 24, color: Colors.white10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Kriteria Kelulusan:', style: TextStyle(fontSize: 13, color: Colors.grey)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: scoreColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  finalCriteria.toUpperCase(),
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: scoreColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Scale guide info card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Skala Nilai Polmed:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                SizedBox(height: 4),
                Text('A  (80-100) : Istimewa\nB+ (75-79)  : Sangat Baik\nB  (70-74)  : Baik\nC+ (60-69)  : Cukup Baik\nC  (50-59)  : Cukup',
                  style: TextStyle(fontSize: 10, color: Colors.grey, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTabsContent(BuildContext context, InternshipGrading grading, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(icon: Icon(Icons.business_rounded), text: 'Nilai Perusahaan (Form-3.30)'),
              Tab(icon: Icon(Icons.school_rounded), text: 'Nilai Dosen (Form-3.31)'),
            ],
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 600,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCompanyGradingTab(context, grading, isDark),
                _buildDosenGradingTab(context, grading, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyGradingTab(BuildContext context, InternshipGrading grading, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Form-3.30 Evaluasi Keberhasilan Mahasiswa oleh Perusahaan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 6),
        const Text(
          'Tarik slider atau input nilai (0-100) untuk setiap komponen yang dinilai oleh mentor.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        _buildGradingInputRow('1. Kerapian dan kebersihan pakaian, penampilan', grading.companyKerapian, (val) => _updateCompanyScore('kerapian', val)),
        _buildGradingInputRow('2. Disiplin kerja', grading.companyDisiplin, (val) => _updateCompanyScore('disiplin', val)),
        _buildGradingInputRow('3. Tingkat Kehadiran', grading.companyKehadiran, (val) => _updateCompanyScore('kehadiran', val)),
        _buildGradingInputRow('4. Tanggung jawab terhadap pekerjaan', grading.companyTanggungJawab, (val) => _updateCompanyScore('tanggungJawab', val)),
        _buildGradingInputRow('5. Kemandirian dalam bekerja', grading.companyKemandirian, (val) => _updateCompanyScore('kemandirian', val)),
        _buildGradingInputRow('6. Inisiatif', grading.companyInisiatif, (val) => _updateCompanyScore('inisiatif', val)),
        _buildGradingInputRow('7. Pemahaman terhadap pekerjaan', grading.companyPemahaman, (val) => _updateCompanyScore('pemahaman', val)),
        _buildGradingInputRow('8. Kerjasama dengan rekan kerja/karyawan', grading.companyKerjasamaRekan, (val) => _updateCompanyScore('kerjasamaRekan', val)),
        _buildGradingInputRow('9. Kerjasama dengan atasan', grading.companyKerjasamaAtasan, (val) => _updateCompanyScore('kerjasamaAtasan', val)),
        _buildGradingInputRow('10. Kemampuan menyesuaikan diri / adaptasi', grading.companyAdaptasi, (val) => _updateCompanyScore('adaptasi', val)),
        const SizedBox(height: 16),
        const Text(
          'Saran dan kritik terhadap hasil kerja mahasiswa:',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _companySaranController,
          maxLines: 3,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Masukkan feedback dari pembimbing lapangan...',
            hintStyle: const TextStyle(fontSize: 12),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white10)),
          ),
          onChanged: _saveSaran,
        ),
      ],
    );
  }

  Widget _buildDosenGradingTab(BuildContext context, InternshipGrading grading, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Form-3.31 Evaluasi Laporan Magang oleh Dosen Pembimbing',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 6),
        const Text(
          'Masukkan nilai untuk setiap kriteria. Perhitungan bobot dilakukan secara otomatis.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        _buildGradingInputRow('Format Laporan (Bobot 15%)', grading.dosenFormatLaporan, (val) => _updateDosenScore('format', val)),
        _buildGradingInputRow('Uraian Laporan (Bobot 25%)', grading.dosenUraianLaporan, (val) => _updateDosenScore('uraian', val)),
        _buildGradingInputRow('Pemaparan/Presentasi (Bobot 20%)', grading.dosenPresentasiLaporan, (val) => _updateDosenScore('presentasi', val)),
        _buildGradingInputRow('Tanya Jawab Laporan (Bobot 40%)', grading.dosenTanyaJawabLaporan, (val) => _updateDosenScore('tanyaJawab', val)),
      ],
    );
  }

  Widget _buildGradingInputRow(String title, double value, ValueChanged<double> onChanged) {
    final textController = TextEditingController(text: value == 0 ? '' : value.toStringAsFixed(0));
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 70,
                height: 35,
                child: TextField(
                  controller: textController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.05),
                    hintText: '0',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white10)),
                  ),
                  onSubmitted: (text) {
                    final val = double.tryParse(text) ?? 0.0;
                    final clamped = val.clamp(0.0, 100.0);
                    onChanged(clamped);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  ),
                  child: Slider(
                    value: value,
                    min: 0,
                    max: 100,
                    activeColor: Theme.of(context).colorScheme.primary,
                    inactiveColor: Colors.grey.withOpacity(0.2),
                    onChanged: onChanged,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${value.toStringAsFixed(0)} pt',
                style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
