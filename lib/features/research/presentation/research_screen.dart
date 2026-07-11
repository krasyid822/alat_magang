import 'dart:html' as html;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/data/models.dart';
import '../../shared/data/theme_provider.dart';
import '../provider/research_provider.dart';
import '../../shared/presentation/running_text.dart';

class ResearchScreen extends ConsumerStatefulWidget {
  const ResearchScreen({super.key});

  @override
  ConsumerState<ResearchScreen> createState() => _ResearchScreenState();
}

class _ResearchScreenState extends ConsumerState<ResearchScreen> {
  Color get _accentColor => context.toolColors.research;
  final _formKey = GlobalKey<FormState>();
  final _historyController = TextEditingController();
  final _visionController = TextEditingController();
  final _historyScrollController = ScrollController();
  final _visionScrollController = ScrollController();
  final _mainScrollController = ScrollController();
  final _tabScrollController = ScrollController();

  List<Map<String, String>> _companyImageList = [];
  List<Map<String, String>> _taskList = [];
  List<Map<String, String>> _stepList = [];
  List<Map<String, String>> _obstacleList = [];

  bool _isSaving = false;
  int _activeTab = 0; // 0 = Profil, 1 = Alur, 2 = Hambatan
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _historyController.addListener(_onTextChanged);
    _visionController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _historyController.removeListener(_onTextChanged);
    _visionController.removeListener(_onTextChanged);

    _historyController.dispose();
    _visionController.dispose();
    _historyScrollController.dispose();
    _visionScrollController.dispose();
    _mainScrollController.dispose();
    _tabScrollController.dispose();
    super.dispose();
  }

  void _populateFields(ResearchData data, [ResearchData? previous]) {
    if (previous == null) {
      _historyController.text = data.companyHistory;
      _visionController.text = data.companyVisionMission;
      _parseCompanyImages(data.companyStructureUrl);
      _parseJobDescription(data.jobDescription);
      _parseProcedure(data.procedureWork);
      _parseObstacles(data.obstacles);
    } else {
      if (_historyController.text == previous.companyHistory) {
        if (_historyController.text != data.companyHistory) {
          _historyController.text = data.companyHistory;
        }
      }
      if (_visionController.text == previous.companyVisionMission) {
        if (_visionController.text != data.companyVisionMission) {
          _visionController.text = data.companyVisionMission;
        }
      }
      if (jsonEncode(_companyImageList) == previous.companyStructureUrl) {
        _parseCompanyImages(data.companyStructureUrl);
      }
      if (jsonEncode(_taskList) == previous.jobDescription) {
        _parseJobDescription(data.jobDescription);
      }
      if (jsonEncode(_stepList) == previous.procedureWork) {
        _parseProcedure(data.procedureWork);
      }
      if (jsonEncode(_obstacleList) == previous.obstacles) {
        _parseObstacles(data.obstacles);
      }
    }
  }

  void _parseCompanyImages(String rawImages) {
    if (rawImages.isEmpty) {
      _companyImageList = [];
      return;
    }
    try {
      final parsed = jsonDecode(rawImages);
      if (parsed is List) {
        _companyImageList = parsed.map((item) {
          return {
            'url': (item['url'] ?? '').toString(),
            'caption': (item['caption'] ?? '').toString(),
          };
        }).toList();
        return;
      }
    } catch (_) {
      // Fallback untuk single URL/Base64 legacy gambar struktur organisasi
      _companyImageList = [
        {
          'url': rawImages,
          'caption': 'Gambar 2.1 Struktur Organisasi Perusahaan',
        },
      ];
    }
  }

  void _parseJobDescription(String rawDesc) {
    if (rawDesc.isEmpty) {
      _taskList = [];
      return;
    }
    try {
      final parsed = jsonDecode(rawDesc);
      if (parsed is List) {
        _taskList = parsed.map((item) {
          return {
            'task': (item['task'] ?? '').toString(),
            'details': (item['details'] ?? '').toString(),
          };
        }).toList();
        return;
      }
    } catch (_) {
      _taskList = [
        {'task': rawDesc, 'details': ''},
      ];
    }
  }

  void _parseProcedure(String rawProc) {
    if (rawProc.isEmpty) {
      _stepList = [];
      return;
    }
    try {
      final parsed = jsonDecode(rawProc);
      if (parsed is List) {
        _stepList = parsed.map((item) {
          return {
            'step': (item['step'] ?? '').toString(),
            'description': (item['description'] ?? '').toString(),
          };
        }).toList();
        return;
      }
    } catch (_) {
      _stepList = [
        {'step': rawProc, 'description': ''},
      ];
    }
  }

  void _parseObstacles(String rawObstacles) {
    if (rawObstacles.isEmpty) {
      _obstacleList = [];
      return;
    }
    try {
      final parsed = jsonDecode(rawObstacles);
      if (parsed is List) {
        _obstacleList = parsed.map((item) {
          return {
            'obstacle': (item['obstacle'] ?? '').toString(),
            'solution': (item['solution'] ?? '').toString(),
          };
        }).toList();
        return;
      }
    } catch (_) {
      _obstacleList = [
        {'obstacle': rawObstacles, 'solution': ''},
      ];
    }
  }

  Future<String> _compressDataUrl(String dataUrl) {
    final completer = Completer<String>();
    final image = html.ImageElement()..src = dataUrl;

    image.onLoad.listen((_) {
      const maxDimension = 1024;
      int width = image.naturalWidth;
      int height = image.naturalHeight;

      if (width > maxDimension || height > maxDimension) {
        if (width > height) {
          height = (height * maxDimension / width).round();
          width = maxDimension;
        } else {
          width = (width * maxDimension / height).round();
          height = maxDimension;
        }
      }

      final canvas = html.CanvasElement(width: width, height: height);
      final ctx = canvas.context2D;
      ctx.drawImageScaled(image, 0, 0, width, height);

      final compressedDataUrl = canvas.toDataUrl('image/jpeg', 0.85);
      completer.complete(compressedDataUrl);
    });

    image.onError.listen((e) {
      completer.complete(dataUrl); // Fallback to original
    });

    return completer.future;
  }

  void _pickImageFromGallery(int index) {
    final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen((e) async {
          final originalUrl = reader.result as String;
          final compressedUrl = await _compressDataUrl(originalUrl);
          if (mounted) {
            setState(() {
              _companyImageList[index]['url'] = compressedUrl;
            });
            _onTextChanged();
          }
        });
      }
    });
  }

  void _addNewImage() {
    setState(() {
      _companyImageList.add({
        'url': '',
        'caption': 'Gambar 2.${_companyImageList.length + 1} Keterangan Gambar',
      });
    });
  }

  void _addNewTask() {
    setState(() {
      _taskList.add({'task': '', 'details': ''});
    });
  }

  void _addNewStep() {
    setState(() {
      _stepList.add({'step': '', 'description': ''});
    });
  }

  void _addNewObstacle() {
    setState(() {
      _obstacleList.add({'obstacle': '', 'solution': ''});
    });
  }

  void _confirmDeleteImage(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E293B)
            : Colors.white,
        title: const Text(
          'Hapus Gambar Profil?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus Gambar #${index + 1}? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _companyImageList.removeAt(index);
              });
              Navigator.pop(context);
              _onTextChanged();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF43F5E),
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTask(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E293B)
            : Colors.white,
        title: const Text(
          'Hapus Poin Tugas?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus Tugas Unit #${index + 1}? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _taskList.removeAt(index);
              });
              Navigator.pop(context);
              _onTextChanged();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF43F5E),
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteStep(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E293B)
            : Colors.white,
        title: const Text(
          'Hapus Langkah Alur?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus Tahapan Alur #${index + 1}? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _stepList.removeAt(index);
              });
              Navigator.pop(context);
              _onTextChanged();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF43F5E),
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteObstacle(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E293B)
            : Colors.white,
        title: const Text(
          'Hapus Poin Hambatan?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus Hambatan #${index + 1}? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _obstacleList.removeAt(index);
              });
              Navigator.pop(context);
              _onTextChanged();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF43F5E),
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final researchAsync = ref.watch(researchStreamProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (researchAsync.hasValue && !_isInitialized) {
      _isInitialized = true;
      final data = researchAsync.value!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _populateFields(data);
          });
        }
      });
    }

    ref.listen<AsyncValue<ResearchData>>(researchStreamProvider, (
      previous,
      next,
    ) {
      if (next.hasValue && !next.isLoading) {
        if (!_isInitialized) {
          _isInitialized = true;
          _populateFields(next.value!);
        } else {
          _populateFields(next.value!, previous?.value);
        }
      }
    });

    return Scrollbar(
      controller: _mainScrollController,
      child: SingleChildScrollView(
        controller: _mainScrollController,
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildTabBar(isDark),
              const SizedBox(height: 20),
              researchAsync.when(
                data: (data) => _buildFormContent(isDark),
                loading: () => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(color: _accentColor),
                  ),
                ),
                error: (err, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text('Gagal memuat riset: $err'),
                  ),
                ),
              ),
            ],
          ),
        ),
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
                'Profil Perusahaan & Bahan Riset',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Alat 2: Kumpulkan bahan baku riset Bab 2 dan Bab Pembahasan Laporan Magang Anda.',
                style: TextStyle(color: const Color(0xFF64748B), fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: _saveResearch,
          style: ElevatedButton.styleFrom(
            backgroundColor: _accentColor,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          icon: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.cloud_upload_rounded, size: 20),
          label: Text(
            _isSaving ? 'Menyimpan...' : 'Simpan Riset',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(bool isDark) {
    final tabs = [
      {
        'title': 'Profil Perusahaan',
        'icon': Icons.business_rounded,
        'subtitle': 'Bab 2 Laporan',
      },
      {
        'title': 'Alur & Unit Kerja',
        'icon': Icons.alt_route_rounded,
        'subtitle': 'Deskripsi & Prosedur',
      },
      {
        'title': 'Hambatan Magang',
        'icon': Icons.warning_amber_rounded,
        'subtitle': 'Bab Pembahasan',
      },
    ];

    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 600;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _tabScrollController,
      child: Row(
        children: List.generate(tabs.length, (idx) {
          final isSelected = _activeTab == idx;
          final color = isSelected ? _accentColor : const Color(0xFF64748B);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: InkWell(
              onTap: () => setState(() => _activeTab = idx),
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: isSmall ? 140 : null,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? _accentColor.withOpacity(0.08)
                      : (isDark ? const Color(0xFF1E293B) : Colors.white)
                            .withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? _accentColor
                        : (isDark ? Colors.white10 : Colors.black12),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(tabs[idx]['icon'] as IconData, color: color, size: 22),
                    const SizedBox(height: 6),
                    RunningText(
                      text: tabs[idx]['title'] as String,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? (isDark ? Colors.white : Colors.black87)
                            : const Color(0xFF64748B),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    RunningText(
                      text: tabs[idx]['subtitle'] as String,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFormContent(bool isDark) {
    Widget activeContent;
    switch (_activeTab) {
      case 0:
        activeContent = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGuidelineBox(
              title: 'Panduan Profil Perusahaan (Bab 2)',
              desc:
                  'Tuliskan sejarah berdiri, visi, misi, dan cantumkan bagan struktur organisasi serta dokumentasi gambar profil unit magang Anda.',
              icon: Icons.info_outline_rounded,
            ),
            const SizedBox(height: 16),
            _buildRichTextEditor(
              label: 'Sejarah Singkat Perusahaan',
              controller: _historyController,
              scrollController: _historyScrollController,
              icon: Icons.history_edu_rounded,
              accentColor: const Color(0xFF0D9488),
              hintText: 'Contoh: PT. XYZ didirikan pada tahun 2005 oleh ...',
              tips: [
                'Tuliskan tahun berdiri dan pendiri perusahaan',
                'Ceritakan perkembangan penting (milestone)',
                'Sebutkan bidang usaha utama dan skala perusahaan',
              ],
            ),
            const SizedBox(height: 18),
            _buildRichTextEditor(
              label: 'Visi & Misi Perusahaan',
              controller: _visionController,
              scrollController: _visionScrollController,
              icon: Icons.track_changes_rounded,
              accentColor: const Color(0xFF38BDF8),
              hintText:
                  'Contoh:\nVisi: Menjadi perusahaan terdepan di ...\n\nMisi:\n1. Menghadirkan layanan berkualitas ...\n2. Mendorong inovasi ...',
              tips: [
                'Tuliskan visi perusahaan (tujuan jangka panjang)',
                'Tuliskan misi poin per poin (beri nomor 1, 2, 3...)',
                'Sertakan nilai-nilai inti perusahaan jika ada',
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Dokumentasi Gambar Profil & Struktur Organisasi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFFD97706),
              ),
            ),
            const SizedBox(height: 10),
            _buildCompanyImageList(isDark),
          ],
        );
        break;
      case 1:
        activeContent = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGuidelineBox(
              title: 'Panduan Deskripsi Unit & Alur Proses Laporan',
              desc:
                  'Gambarkan tugas utama di unit tempat Anda magang dalam bentuk daftar tugas, serta susun langkah-langkah alur kerja sistem/alat secara kronologis.',
              icon: Icons.info_outline_rounded,
            ),
            const SizedBox(height: 20),
            const Text(
              '1. Daftar Tugas & Tanggung Jawab Unit Kerja',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFFD97706),
              ),
            ),
            const SizedBox(height: 10),
            _buildTaskList(isDark),
            const SizedBox(height: 24),
            const Text(
              '2. Alur Proses / Tahapan Kerja Sistem / Prosedur Alat',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFFD97706),
              ),
            ),
            const SizedBox(height: 10),
            _buildStepList(isDark),
          ],
        );
        break;
      case 2:
      default:
        activeContent = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGuidelineBox(
              title: 'Panduan Hambatan Magang (Bab Pembahasan)',
              desc:
                  'Petakan kendala teknis lapangan yang Anda temui beserta solusi nyata yang telah Anda lakukan selama magang untuk kelengkapan Bab Pembahasan Anda.',
              icon: Icons.info_outline_rounded,
            ),
            const SizedBox(height: 16),
            _buildObstaclesList(isDark),
          ],
        );
        break;
    }

    return _buildSectionCard(
      isDark,
      title: _activeTab == 0
          ? 'Bagian A: Profil Perusahaan'
          : (_activeTab == 1
                ? 'Bagian B: Alur & Prosedur Kerja'
                : 'Bagian C: Hambatan & Solusi Lapangan'),
      icon: _activeTab == 0
          ? Icons.business_rounded
          : (_activeTab == 1
                ? Icons.alt_route_rounded
                : Icons.warning_amber_rounded),
      children: [activeContent],
    );
  }

  Widget _buildCompanyImageList(bool isDark) {
    if (_companyImageList.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _accentColor.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _accentColor.withOpacity(0.12)),
        ),
        child: Column(
          children: [
            const Text(
              'Belum ada gambar profil yang ditambahkan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _addNewImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.add_rounded, size: 14),
              label: const Text(
                'Tambah Gambar Profil',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ...List.generate(_companyImageList.length, (idx) {
          final item = _companyImageList[idx];
          return Card(
            key: ValueKey('image_$idx'),
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: _accentColor.withOpacity(0.15)),
            ),
            color: (isDark ? const Color(0xFF1E293B) : Colors.white)
                .withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Gambar #${idx + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color(0xFFD97706),
                        ),
                      ),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Color(0xFFF43F5E),
                          size: 18,
                        ),
                        onPressed: () => _confirmDeleteImage(idx),
                        tooltip: 'Hapus Gambar',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: item['caption'],
                    decoration: _inputDecorationSmall(
                      'Label Keterangan Gambar (Caption)',
                    ),
                    onChanged: (val) {
                      _companyImageList[idx]['caption'] = val;
                      _onTextChanged();
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: item['url'],
                          decoration: _inputDecorationSmall(
                            'URL Gambar / Data Base64',
                          ),
                          onChanged: (val) {
                            _companyImageList[idx]['url'] = val;
                            _onTextChanged();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () => _pickImageFromGallery(idx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accentColor.withOpacity(0.12),
                          foregroundColor: const Color(0xFFD97706),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.photo_library_rounded, size: 14),
                        label: const Text(
                          'Galeri',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if ((item['url'] ?? '').trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildImagePreview(item['url']!.trim(), isDark),
                  ],
                ],
              ),
            ),
          );
        }),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _addNewImage,
            icon: const Icon(
              Icons.add_rounded,
              size: 16,
              color: Color(0xFFD97706),
            ),
            label: const Text(
              'Tambah Gambar Baru',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFD97706),
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskList(bool isDark) {
    if (_taskList.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _accentColor.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _accentColor.withOpacity(0.12)),
        ),
        child: Column(
          children: [
            const Text(
              'Belum ada tugas unit yang ditambahkan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _addNewTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.add_rounded, size: 14),
              label: const Text(
                'Tambah Tugas Unit',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ...List.generate(_taskList.length, (idx) {
          final item = _taskList[idx];
          return Card(
            key: ValueKey('task_$idx'),
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: _accentColor.withOpacity(0.15)),
            ),
            color: (isDark ? const Color(0xFF1E293B) : Colors.white)
                .withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tugas #${idx + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color(0xFFD97706),
                        ),
                      ),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Color(0xFFF43F5E),
                          size: 18,
                        ),
                        onPressed: () => _confirmDeleteTask(idx),
                        tooltip: 'Hapus Tugas',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: item['task'],
                    decoration: _inputDecorationSmall(
                      'Nama Tugas / Tanggung Jawab Unit',
                    ),
                    onChanged: (val) {
                      _taskList[idx]['task'] = val;
                      _onTextChanged();
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: item['details'],
                    maxLines: 2,
                    decoration: _inputDecorationSmall(
                      'Rincian Detail Tugas / Frekuensi Pelaksanaan',
                    ),
                    onChanged: (val) {
                      _taskList[idx]['details'] = val;
                      _onTextChanged();
                    },
                  ),
                ],
              ),
            ),
          );
        }),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _addNewTask,
            icon: const Icon(
              Icons.add_rounded,
              size: 16,
              color: Color(0xFFD97706),
            ),
            label: const Text(
              'Tambah Tugas Baru',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFD97706),
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepList(bool isDark) {
    if (_stepList.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _accentColor.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _accentColor.withOpacity(0.12)),
        ),
        child: Column(
          children: [
            const Text(
              'Belum ada tahapan alur kerja yang ditambahkan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _addNewStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.add_rounded, size: 14),
              label: const Text(
                'Tambah Tahapan Alur',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ...List.generate(_stepList.length, (idx) {
          final item = _stepList[idx];
          return Card(
            key: ValueKey('step_$idx'),
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: _accentColor.withOpacity(0.15)),
            ),
            color: (isDark ? const Color(0xFF1E293B) : Colors.white)
                .withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tahapan #${idx + 1} (Kronologis)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color(0xFFD97706),
                        ),
                      ),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Color(0xFFF43F5E),
                          size: 18,
                        ),
                        onPressed: () => _confirmDeleteStep(idx),
                        tooltip: 'Hapus Tahapan',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: item['step'],
                    decoration: _inputDecorationSmall(
                      'Nama Langkah / Nama Proses',
                    ),
                    onChanged: (val) {
                      _stepList[idx]['step'] = val;
                      _onTextChanged();
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: item['description'],
                    maxLines: 2,
                    decoration: _inputDecorationSmall(
                      'Deskripsi Tindakan / Keterangan Proses Detail',
                    ),
                    onChanged: (val) {
                      _stepList[idx]['description'] = val;
                      _onTextChanged();
                    },
                  ),
                ],
              ),
            ),
          );
        }),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _addNewStep,
            icon: const Icon(
              Icons.add_rounded,
              size: 16,
              color: Color(0xFFD97706),
            ),
            label: const Text(
              'Tambah Tahapan Baru',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFD97706),
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildObstaclesList(bool isDark) {
    if (_obstacleList.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _accentColor.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _accentColor.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: _accentColor.withOpacity(0.6),
              size: 40,
            ),
            const SizedBox(height: 12),
            const Text(
              'Belum ada hambatan yang ditambahkan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            const Text(
              'Klik tombol di bawah untuk menambahkan poin hambatan magang pertama Anda beserta solusinya.',
              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: _addNewObstacle,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text(
                'Tambah Hambatan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ...List.generate(_obstacleList.length, (idx) {
          final item = _obstacleList[idx];
          return Card(
            key: ValueKey('obstacle_$idx'),
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: _accentColor.withOpacity(0.2)),
            ),
            color: (isDark ? const Color(0xFF1E293B) : Colors.white)
                .withOpacity(0.6),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Poin Hambatan #${idx + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFFD97706),
                        ),
                      ),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Color(0xFFF43F5E),
                          size: 20,
                        ),
                        onPressed: () => _confirmDeleteObstacle(idx),
                        tooltip: 'Hapus Hambatan',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: item['obstacle'],
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Hambatan / Perbedaan Teori & Lapangan',
                      labelStyle: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF64748B).withOpacity(0.04),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: _accentColor, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.all(12.0),
                    ),
                    onChanged: (val) {
                      _obstacleList[idx]['obstacle'] = val;
                      _onTextChanged();
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: item['solution'],
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Solusi / Pemecahan Masalah (Tindakan)',
                      labelStyle: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF64748B).withOpacity(0.04),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: _accentColor, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.all(12.0),
                    ),
                    onChanged: (val) {
                      _obstacleList[idx]['solution'] = val;
                      _onTextChanged();
                    },
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: _addNewObstacle,
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentColor.withOpacity(0.12),
              foregroundColor: const Color(0xFFD97706),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.add_rounded, size: 16),
            label: const Text(
              'Tambah Hambatan Baru',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard(
    bool isDark, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(
          0.85,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _accentColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: RunningText(
                  text: title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  /// Widget editor teks kaya: auto-expand, karakter counter, tips, tombol fullscreen
  Widget _buildRichTextEditor({
    required String label,
    required TextEditingController controller,
    required ScrollController scrollController,
    required IconData icon,
    required Color accentColor,
    required String hintText,
    required List<String> tips,
  }) {
    final charCount = controller.text.length;
    final lineCount = '\n'.allMatches(controller.text).length + 1;

    return Container(
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header bar ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.07),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: accentColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: RunningText(
                    text: label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: accentColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Wrap counter and button to prevent overflow
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$charCount kar · $lineCount baris',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 10),
                    // Tombol editor penuh
                    Tooltip(
                      message: 'Buka Editor Layar Penuh',
                      child: InkWell(
                        onTap: () => _openFullscreenEditor(
                          label: label,
                          controller: controller,
                          icon: icon,
                          accentColor: accentColor,
                          hintText: hintText,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.open_in_full_rounded,
                                size: 13,
                                color: accentColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Layar Penuh',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: accentColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- Preview read-only: ketuk untuk buka editor penuh ---
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
            child: GestureDetector(
              onTap: () => _openFullscreenEditor(
                label: label,
                controller: controller,
                icon: icon,
                accentColor: accentColor,
                hintText: hintText,
              ),
              child: Stack(
                children: [
                  // Area teks read-only + scrollbar
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 220),
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: scrollController,
                      child: TextFormField(
                        controller: controller,
                        scrollController: scrollController,
                        maxLines: null,
                        minLines: 5,
                        readOnly: true, // ← tidak bisa diketik langsung
                        showCursor: false, // ← tidak tampilkan kursor
                        enableInteractiveSelection:
                            false, // ← tidak bisa select/copy
                        style: const TextStyle(fontSize: 13.5, height: 1.6),
                        decoration: InputDecoration(
                          hintText: hintText,
                          hintStyle: const TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 12.5,
                            height: 1.6,
                            fontStyle: FontStyle.italic,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Overlay "ketuk untuk mengedit" — muncul jika konten kosong
                  if (controller.text.trim().isEmpty)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.edit_note_rounded,
                                  color: accentColor.withOpacity(0.35),
                                  size: 32,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Ketuk "Layar Penuh" di atas untuk mulai mengetik',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: accentColor.withOpacity(0.45),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Label kunci baca-saja
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: Row(
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 11,
                  color: accentColor.withOpacity(0.5),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Mode tampilan — gunakan tombol "Layar Penuh" untuk mengedit',
                    style: TextStyle(
                      fontSize: 10,
                      color: accentColor.withOpacity(0.5),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // --- Tips & panduan ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 12,
                      color: accentColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Tips Penulisan:',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ...tips.map(
                  (tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '• ',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            tip,
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF64748B),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Membuka dialog editor layar penuh untuk kenyamanan pengetikan teks panjang
  void _openFullscreenEditor({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required Color accentColor,
    required String hintText,
  }) {
    // Buat controller sementara dengan isi saat ini
    final tempController = TextEditingController(text: controller.text);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(ctx).size.height * 0.88,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.08),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  border: Border(
                    bottom: BorderSide(color: accentColor.withOpacity(0.15)),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: accentColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Editor Layar Penuh — ketik dengan nyaman tanpa batas',
                            style: TextStyle(
                              fontSize: 11,
                              color: accentColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Live char count inside dialog
                    StatefulBuilder(
                      builder: (ctx2, setS) {
                        tempController.addListener(() => setS(() {}));
                        final c = tempController.text.length;
                        final l =
                            '\n'.allMatches(tempController.text).length + 1;
                        return Text(
                          '$c kar\n$l baris',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF64748B),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Text area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: tempController,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(fontSize: 14, height: 1.7),
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: const TextStyle(
                        color: Color(0xFF334155),
                        fontSize: 13,
                        height: 1.7,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: accentColor.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(18),
                    ),
                    autofocus: true,
                  ),
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(ctx).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF64748B),
                          side: const BorderSide(color: Color(0xFF334155)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.close_rounded, size: 18),
                        label: const Text(
                          'Batal',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          controller.text = tempController.text;
                          _onTextChanged();
                          Navigator.of(ctx).pop();
                          tempController.dispose();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.check_rounded, size: 18),
                        label: const Text(
                          'Terapkan Perubahan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecorationSmall(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
      filled: true,
      fillColor: const Color(0xFF64748B).withOpacity(0.04),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: _accentColor, width: 1.2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _buildGuidelineBox({
    required String title,
    required String desc,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _accentColor, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Color(0xFFD97706),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(String url, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(
          0.5,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accentColor.withOpacity(0.15)),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 6.0),
            child: Text(
              'Pratinjau Struktur/Gambar:',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              url,
              fit: BoxFit.contain,
              width: double.infinity,
              height: 200,
              errorBuilder: (_, __, ___) => Container(
                height: 100,
                color: Colors.black12,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image_rounded,
                        color: Color(0xFFF43F5E),
                        size: 28,
                      ),
                      SizedBox(height: 6),
                      Text(
                        'URL Gambar tidak valid atau tidak dapat dimuat',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(color: _accentColor),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveResearch() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      final research = ResearchData(
        companyHistory: _historyController.text,
        companyVisionMission: _visionController.text,
        companyStructureUrl: jsonEncode(_companyImageList),
        jobDescription: jsonEncode(_taskList),
        procedureWork: jsonEncode(_stepList),
        obstacles: jsonEncode(_obstacleList),
      );

      await ref
          .read(researchControllerProvider.notifier)
          .updateResearch(research);
      setState(() => _isSaving = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Bahan riset berhasil disimpan di penyimpanan lokal browser!',
            ),
            backgroundColor: Color(0xFF0D9488),
          ),
        );
      }
    }
  }
}
