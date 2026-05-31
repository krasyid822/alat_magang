import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/data/models.dart';
import '../provider/job_provider.dart';
import 'widgets/job_detail_card.dart';
import 'widgets/job_form.dart';

class JobDetailsScreen extends ConsumerStatefulWidget {
  const JobDetailsScreen({super.key});

  @override
  ConsumerState<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends ConsumerState<JobDetailsScreen> {
  int _selectedFilter = 0; // 0 = Semua, 1 = Selesai, 2 = Kendala
  final _searchController = TextEditingController();
  final _mainScrollController = ScrollController();
  final _filterScrollController = ScrollController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _mainScrollController.dispose();
    _filterScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobsAsync = ref.watch(jobDetailsStreamProvider);
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 1200 ? 3 : (width > 800 ? 2 : 1);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          _buildSearchBar(isDark),
          const SizedBox(height: 20),
          _buildFilters(),
          const SizedBox(height: 20),
          Expanded(
            child: jobsAsync.when(
              data: (jobs) {
                var filtered = jobs.where((job) {
                  if (_selectedFilter == 1) return job.isCompleted;
                  if (_selectedFilter == 2) return !job.isCompleted;
                  return true;
                }).toList();

                if (_searchQuery.isNotEmpty) {
                  filtered = filtered.where((job) {
                    final title = job.title.toLowerCase();
                    final desc = job.description.toLowerCase();
                    final date = job.date.toLowerCase();
                    final kendala = job.reasonOfIncompletion.toLowerCase();
                    return title.contains(_searchQuery) ||
                        desc.contains(_searchQuery) ||
                        date.contains(_searchQuery) ||
                        kendala.contains(_searchQuery);
                  }).toList();
                }

                if (filtered.isEmpty) return _buildEmptyState();

                final columns = List.generate(crossAxisCount, (_) => <JobDetail>[]);
                for (var i = 0; i < filtered.length; i++) {
                  columns[i % crossAxisCount].add(filtered[i]);
                }

                return Scrollbar(
                  controller: _mainScrollController,
                  child: SingleChildScrollView(
                    controller: _mainScrollController,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int colIndex = 0; colIndex < crossAxisCount; colIndex++) ...[
                          if (colIndex > 0) const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              children: columns[colIndex].map((job) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: JobDetailCard(job: job),
                                );
                              }).toList(),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF0D9488))),
              error: (err, _) => Center(child: Text('Gagal memuat tugas: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Cari nama tugas, uraian, tanggal, atau kendala...',
          hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0D9488), size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, color: Color(0xFF64748B), size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Form Detail Pekerjaan',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5),
              ),
              const SizedBox(height: 6),
              Text(
                'Alat 1: Kumpulkan bukti visual berupa foto kegiatan serta kendala tugas.',
                style: TextStyle(color: const Color(0xFF64748B), fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () => showDialog(context: context, builder: (context) => const JobForm()),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D9488),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
          icon: const Icon(Icons.add_rounded, size: 20),
          label: const Text('Tambah Tugas', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _filterScrollController,
      child: Row(
        children: [
          _buildFilterChip('Semua Tugas', 0),
          const SizedBox(width: 8),
          _buildFilterChip('Selesai', 1),
          const SizedBox(width: 8),
          _buildFilterChip('Kendala', 2),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int filterIndex) {
    final isSelected = _selectedFilter == filterIndex;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: const Color(0xFF0D9488).withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF0D9488) : const Color(0xFF64748B),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (_) => setState(() => _selectedFilter = filterIndex),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library_rounded, size: 70, color: const Color(0xFF64748B).withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text('Belum ada dokumentasi tugas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Klik "Tambah Tugas" untuk mengunggah tugas & bukti foto pertama Anda.', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
        ],
      ),
    );
  }
}
