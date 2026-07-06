import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/dashboard_provider.dart';
import '../../../shared/data/firebase_service.dart';
import '../../../shared/data/models.dart';
import 'dart:convert';
import 'dart:html' as html;
import '../../../shared/presentation/error_dialog.dart';

class NimSetupDialog extends ConsumerStatefulWidget {
  final bool forceSetup;
  const NimSetupDialog({super.key, this.forceSetup = false});

  @override
  ConsumerState<NimSetupDialog> createState() => _NimSetupDialogState();
}

class _NimSetupDialogState extends ConsumerState<NimSetupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nimController = TextEditingController();
  final _nameController = TextEditingController();
  final _classController = TextEditingController();
  final _majorController = TextEditingController();
  final _companyController = TextEditingController();
  final _divisionController = TextEditingController();
  final _mentorController = TextEditingController();
  final _waController = TextEditingController();
  final _scrollController = ScrollController();
  int _durationWeeks = 16;

  bool _isLoading = false;
  String? _errorMessage;
  StudentProfile? _registeredProfile;

  bool _hasCloudName = false;
  bool _hasCloudClass = false;
  bool _hasCloudMajor = false;
  bool _hasCloudCompany = false;
  bool _hasCloudWa = false;

  // Base64 login
  bool _isBase64Mode = false;
  final _base64Controller = TextEditingController();
  bool _base64Decoded = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(dashboardControllerProvider);
    _nimController.text = profile.nim;
    _nameController.text = profile.name;
    _classController.text = profile.className;
    _majorController.text = profile.major;
    _companyController.text = profile.companyName;
    _divisionController.text = profile.division;
    _mentorController.text = profile.mentorName;
    _waController.text = profile.whatsappNumber;
    _durationWeeks = profile.internshipDurationWeeks;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nimController.dispose();
    _nameController.dispose();
    _classController.dispose();
    _majorController.dispose();
    _companyController.dispose();
    _divisionController.dispose();
    _mentorController.dispose();
    _waController.dispose();
    _base64Controller.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /// Decode Base64 token and pre-fill the form fields
  void _decodeBase64Token() {
    final token = _base64Controller.text.trim();
    if (token.isEmpty) {
      showErrorDialog(context, 'Token Base64 tidak boleh kosong.');
      return;
    }
    try {
      final bytes = base64Decode(token);
      final jsonStr = utf8.decode(bytes);
      final Map<String, dynamic> profileData = jsonDecode(jsonStr);
      final profile = StudentProfile.fromJson(profileData);

      setState(() {
        _nimController.text = profile.nim;
        _nameController.text = profile.name;
        _classController.text = profile.className;
        _majorController.text = profile.major;
        _companyController.text = profile.companyName;
        _divisionController.text = profile.division;
        _mentorController.text = profile.mentorName;
        _waController.text = profile.whatsappNumber;
        _durationWeeks = profile.internshipDurationWeeks;
        _base64Decoded = true;
        _isBase64Mode = false; // Switch back to form mode
        _errorMessage = null;
      });
    } catch (e) {
      showErrorDialog(context, 'Token Base64 tidak valid atau rusak. Pastikan Anda menyalin seluruh kode.');
    }
  }

  Future<void> _checkNimAndProceed() async {
    // 1. Jalankan validasi awal
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) {
      _scrollToTop();
      return;
    }

    setState(() => _isLoading = true);
    try {
      final nim = _nimController.text.trim();
      final profile = await ref.read(firebaseServiceProvider).getProfile(nim);

      if (profile != null) {
        // Update aturan validasi (required) berdasarkan isi data di Cloud
        setState(() {
          _registeredProfile = profile;
          _hasCloudName = profile.name.isNotEmpty;
          _hasCloudClass = profile.className.isNotEmpty;
          _hasCloudMajor = profile.major.isNotEmpty;
          _hasCloudCompany = profile.companyName.isNotEmpty;
          _hasCloudWa = profile.whatsappNumber.isNotEmpty;
        });

        // 2. Jalankan validasi ulang sekarang setelah aturan "required" aktif
        if (!_formKey.currentState!.validate()) {
          setState(() => _isLoading = false);
          _scrollToTop();
          return;
        }

        // 3. Validasi khusus durasi magang (stepper) - hanya saat login
        if (widget.forceSetup &&
            _durationWeeks != profile.internshipDurationWeeks) {
          setState(() {
            _isLoading = false;
          });
          if (mounted) {
            showErrorDialog(context, 'Durasi magang tidak sesuai dengan database');
          }
          return;
        }

        // 4. Jika ini forceSetup (login) dan data cloud sudah ada, JANGAN timpa.
        //    Load dari cloud, bukan dari input form.
        if (widget.forceSetup) {
          _saveFromCloud(nim, profile);
          return;
        }
      }

      _save();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        showErrorDialog(context, 'Gagal mengecek NIM. Periksa koneksi Anda.');
      }
    }
  }

  /// Login berhasil — load data dari cloud, tidak timpa dengan form input
  void _saveFromCloud(String nim, StudentProfile cloudProfile) {
    final controller = ref.read(dashboardControllerProvider.notifier);
    controller.setNim(nim);
    // Profile akan otomatis diambil dari cloud via _initCloudSync
    // Kita cukup setNim saja, cloud sync akan menangani sisanya
    Navigator.pop(context);
  }

  void _save() {
    final controller = ref.read(dashboardControllerProvider.notifier);
    if (widget.forceSetup) {
      controller.setNim(_nimController.text);
    }

    controller.updateProfile(
      name: _nameController.text,
      className: _classController.text,
      major: _majorController.text,
      companyName: _companyController.text,
      division: _divisionController.text,
      mentorName: _mentorController.text,
      internshipDurationWeeks: _durationWeeks,
      whatsappNumber: _waController.text,
    );

    Navigator.pop(context);
  }

  void _showForgotPasswordDialog() {
    final waController = TextEditingController();
    final typedNim = _nimController.text.trim();
    bool dialogLoading = false;
    String? forgotError;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: Text(
                'Lupa Akun NIM: $typedNim?',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Masukkan nomor WhatsApp Anda yang terdaftar untuk NIM ini. Kami akan memverifikasi kecocokan nomor WhatsApp dengan NIM tersebut.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: waController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Nomor WhatsApp Terdaftar',
                      prefixIcon: Icon(
                        Icons.phone_android_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF64748B).withOpacity(0.06),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  if (forgotError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFEF4444).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: Color(0xFFEF4444),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                forgotError!,
                                style: const TextStyle(
                                  color: Color(0xFFEF4444),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
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
                  onPressed: dialogLoading
                      ? null
                      : () async {
                          final wa = waController.text.trim();
                          if (wa.isEmpty) return;
                          setDialogState(() {
                            dialogLoading = true;
                            forgotError = null;
                          });
                          try {
                            final profile = await ref
                                .read(firebaseServiceProvider)
                                .getProfileByWhatsapp(wa);

                            // Cek kecocokan nomor whatsapp terdaftar dengan NIM yang dimasukkan
                            if (profile != null &&
                                profile.nim.trim().toLowerCase() ==
                                    typedNim.toLowerCase()) {
                              // Generate Base64 dari seluruh data profil
                              final profileJson = profile.toJson();
                              final credentials = jsonEncode(profileJson);
                              final bytes = utf8.encode(credentials);
                              final base64Text = base64Encode(bytes);

                              // Kirim ke WhatsApp
                              final message =
                                  'Halo ${profile.name}, berikut adalah kode pemulihan akun Anda (Base64): $base64Text\n\nSalin kode ini dan decoder untuk login.';
                              final url =
                                  'https://api.whatsapp.com/send?phone=${profile.whatsappNumber}&text=${Uri.encodeComponent(message)}';

                              // Buka link WhatsApp
                              html.window.open(url, '_blank');

                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            } else {
                              if (context.mounted) {
                                setDialogState(() {
                                  forgotError =
                                      'NIM dan nomor WhatsApp tidak cocok dengan data terdaftar!';
                                });
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              setDialogState(() {
                                forgotError = 'Gagal memproses permintaan.';
                              });
                            }
                          } finally {
                            if (context.mounted) {
                              setDialogState(() => dialogLoading = false);
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: dialogLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Kirim ke WhatsApp'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isBase64Mode ? _buildBase64View() : _buildSetupView();
  }

  Widget _buildBase64View() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
      child: AlertDialog(
        backgroundColor: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: BorderSide(
            color: const Color(0xFF38BDF8).withOpacity(0.4),
            width: 1.5,
          ),
        ),
        title: Row(
          children: [
            const Icon(Icons.qr_code_rounded, color: Color(0xFF38BDF8), size: 28),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Login dengan Kode Pemulihan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38BDF8).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.2)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline_rounded, color: Color(0xFF38BDF8), size: 18),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Tempel kode Base64 yang dikirim ke WhatsApp Anda melalui fitur "Lupa Akun". Kode ini akan mengisi form login secara otomatis.',
                          style: TextStyle(fontSize: 12, height: 1.4, color: Color(0xFF38BDF8)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded, color: Color(0xFFEF4444), size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Color(0xFFEF4444), fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _errorMessage = null),
                            child: const Icon(Icons.close_rounded, color: Color(0xFFEF4444), size: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                TextField(
                  controller: _base64Controller,
                  maxLines: 6,
                  style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                  decoration: InputDecoration(
                    labelText: 'Kode Pemulihan Base64',
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(Icons.code_rounded, color: Color(0xFF38BDF8), size: 20),
                    filled: true,
                    fillColor: const Color(0xFF64748B).withOpacity(0.06),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.content_paste_rounded, color: Color(0xFF38BDF8), size: 18),
                      tooltip: 'Tempel dari clipboard',
                      onPressed: () async {
                        final data = await Clipboard.getData(Clipboard.kTextPlain);
                        if (data?.text != null) {
                          _base64Controller.text = data!.text!;
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              _isBase64Mode = false;
              _errorMessage = null;
            }),
            child: const Text('Kembali ke Form', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton.icon(
            onPressed: _decodeBase64Token,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF38BDF8),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            icon: const Icon(Icons.login_rounded, size: 18),
            label: const Text('Decode & Isi Form', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupView() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
      child: AlertDialog(
        backgroundColor: (isDark ? const Color(0xFF1E293B) : Colors.white)
            .withOpacity(0.85),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.storage_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.forceSetup
                    ? 'Inisialisasi NIM & Profil'
                    : 'Sunting Profil Magang',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Seluruh data Anda disinkronkan ke cloud secara otomatis. Gunakan NIM Anda untuk memuat data profil dan riwayat pengerjaan laporan.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  // Error message banner (inside dialog, visible above backdrop blur)
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFEF4444).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: Color(0xFFEF4444),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Color(0xFFEF4444),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _errorMessage = null),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Color(0xFFEF4444),
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  _buildField(
                    'NIM (Wajib)',
                    _nimController,
                    Icons.badge_rounded,
                    enabled: widget.forceSetup,
                    autofocus: widget.forceSetup,
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        v!.trim().isEmpty ? 'NIM wajib diisi' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildField(
                    widget.forceSetup && _hasCloudName
                        ? 'Nama Lengkap (Wajib & Sesuai)'
                        : 'Nama Lengkap',
                    _nameController,
                    Icons.person_rounded,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (!widget.forceSetup) return null;
                      final val = v?.trim() ?? '';
                      if (_hasCloudName) {
                        if (val.isEmpty) return 'Nama Lengkap wajib diisi';
                        if (val.toLowerCase() !=
                            _registeredProfile!.name.trim().toLowerCase()) {
                          return 'Nama tidak sesuai dengan database';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildField(
                    widget.forceSetup && _hasCloudWa
                        ? 'Nomor WhatsApp (Wajib & Sesuai)'
                        : 'Nomor WhatsApp',
                    _waController,
                    Icons.phone_android_rounded,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    validator: (v) {
                      if (!widget.forceSetup) return null;
                      final val = v?.trim() ?? '';
                      if (_hasCloudWa) {
                        if (val.isEmpty) return 'Nomor WhatsApp wajib diisi';
                        if (val != _registeredProfile!.whatsappNumber.trim()) {
                          return 'Nomor WhatsApp tidak sesuai dengan database';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildField(
                    widget.forceSetup && _hasCloudClass
                        ? 'Kelas (Wajib & Sesuai)'
                        : 'Kelas',
                    _classController,
                    Icons.class_rounded,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (!widget.forceSetup) return null;
                      final val = v?.trim() ?? '';
                      if (_hasCloudClass) {
                        if (val.isEmpty) return 'Kelas wajib diisi';
                        if (val.toLowerCase() !=
                            _registeredProfile!.className
                                .trim()
                                .toLowerCase()) {
                          return 'Kelas tidak sesuai dengan database';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildField(
                    widget.forceSetup && _hasCloudMajor
                        ? 'Jurusan / Prodi (Wajib & Sesuai)'
                        : 'Jurusan / Prodi',
                    _majorController,
                    Icons.school_rounded,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (!widget.forceSetup) return null;
                      final val = v?.trim() ?? '';
                      if (_hasCloudMajor) {
                        if (val.isEmpty) return 'Jurusan wajib diisi';
                        if (val.toLowerCase() !=
                            _registeredProfile!.major.trim().toLowerCase()) {
                          return 'Jurusan tidak sesuai dengan database';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildField(
                    widget.forceSetup && _hasCloudCompany
                        ? 'Perusahaan Tempat Magang (Wajib & Sesuai)'
                        : 'Perusahaan Tempat Magang',
                    _companyController,
                    Icons.business_rounded,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (!widget.forceSetup) return null;
                      final val = v?.trim() ?? '';
                      if (_hasCloudCompany) {
                        if (val.isEmpty) return 'Perusahaan wajib diisi';
                        if (val.toLowerCase() !=
                            _registeredProfile!.companyName
                                .trim()
                                .toLowerCase()) {
                          return 'Perusahaan tidak sesuai dengan database';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildField(
                    'Bagian / Divisi Kerja',
                    _divisionController,
                    Icons.schema_rounded,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 14),
                  _buildField(
                    'Nama Pembimbing Lapangan',
                    _mentorController,
                    Icons.supervisor_account_rounded,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 20),
                  _buildDurationStepper(isDark),
                  const SizedBox(height: 16),
                  if (_base64Decoded) ...[  
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_rounded, color: Theme.of(context).colorScheme.primary, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Form berhasil diisi dari kode pemulihan. Verifikasi dan simpan.',
                              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (_nimController.text.trim().isEmpty) {
                              showErrorDialog(context, 'Silakan masukkan NIM Anda terlebih dahulu pada form utama.');
                              return;
                            }
                            _showForgotPasswordDialog();
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text(
                              'Lupa NIM / Akun?',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (widget.forceSetup)
                        InkWell(
                          onTap: () => setState(() {
                            _isBase64Mode = true;
                            _errorMessage = null;
                          }),
                          borderRadius: BorderRadius.circular(8),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.qr_code_rounded, size: 13, color: Color(0xFF38BDF8)),
                                SizedBox(width: 4),
                                Text(
                                  'Login dengan Kode',
                                  style: TextStyle(
                                    color: Color(0xFF38BDF8),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        actions: [
          if (!widget.forceSetup)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Batal',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ),
          ElevatedButton(
            onPressed: _isLoading ? null : _checkNimAndProceed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Mulai & Simpan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationStepper(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF64748B).withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_month_rounded,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Durasi Magang',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
                Text(
                  '$_durationWeeks minggu',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _stepperButton(
            icon: Icons.remove_rounded,
            onPressed: _durationWeeks > 1
                ? () => setState(() => _durationWeeks--)
                : null,
          ),
          const SizedBox(width: 8),
          _stepperButton(
            icon: Icons.add_rounded,
            onPressed: _durationWeeks < 52
                ? () => setState(() => _durationWeeks++)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _stepperButton({required IconData icon, VoidCallback? onPressed}) {
    return Material(
      color: Theme.of(context).colorScheme.primary.withOpacity(onPressed == null ? 0.2 : 0.15),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 18,
            color: onPressed == null
                ? const Color(0xFF94A3B8)
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool enabled = true,
    bool autofocus = false,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      autofocus: autofocus,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        filled: true,
        fillColor: const Color(0xFF64748B).withOpacity(0.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
