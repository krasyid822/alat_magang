import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/dashboard_provider.dart';

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
  int _durationWeeks = 16;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(dashboardControllerProvider);
    _nimController.text = profile.nim;
    _nameController.text = profile.name;
    _classController.text = profile.className;
    _majorController.text = profile.major;
    _companyController.text = profile.companyName;
    _durationWeeks = profile.internshipDurationWeeks;
  }

  @override
  void dispose() {
    _nimController.dispose();
    _nameController.dispose();
    _classController.dispose();
    _majorController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
      child: AlertDialog(
        backgroundColor: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.85),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: BorderSide(color: const Color(0xFF0D9488).withOpacity(0.3), width: 1.5),
        ),
        title: Row(
          children: [
            const Icon(Icons.storage_rounded, color: Color(0xFF0D9488), size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.forceSetup ? 'Inisialisasi NIM & Profil' : 'Sunting Profil Magang',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Masukkan NIM Anda untuk memuat profil. Seluruh data Anda disimpan secara aman langsung di dalam browser dan tidak akan hilang walau browser di-refresh.',
                    style: TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 20),
                  _buildField('NIM (Wajib)', _nimController, Icons.badge_rounded,
                      enabled: widget.forceSetup,
                      autofocus: widget.forceSetup,
                      textInputAction: TextInputAction.next,
                      validator: (v) => v!.trim().isEmpty ? 'NIM wajib diisi' : null),
                  const SizedBox(height: 14),
                  _buildField('Nama Lengkap', _nameController, Icons.person_rounded, textInputAction: TextInputAction.next),
                  const SizedBox(height: 14),
                  _buildField('Kelas (contoh: CE-5A)', _classController, Icons.class_rounded, textInputAction: TextInputAction.next),
                  const SizedBox(height: 14),
                  _buildField('Jurusan / Prodi', _majorController, Icons.school_rounded, textInputAction: TextInputAction.next),
                  const SizedBox(height: 14),
                  _buildField('Perusahaan Tempat Magang', _companyController, Icons.business_rounded, textInputAction: TextInputAction.done),
                  const SizedBox(height: 20),
                  _buildDurationStepper(isDark),
                ],
              ),
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        actions: [
          if (!widget.forceSetup)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B))),
            ),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D9488),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            child: const Text('Mulai & Simpan', style: TextStyle(fontWeight: FontWeight.bold)),
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
          const Icon(Icons.calendar_month_rounded, size: 20, color: Color(0xFF0D9488)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Durasi Magang',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                Text(
                  '$_durationWeeks minggu',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          _stepperButton(
            icon: Icons.remove_rounded,
            onPressed: _durationWeeks > 1 ? () => setState(() => _durationWeeks--) : null,
          ),
          const SizedBox(width: 8),
          _stepperButton(
            icon: Icons.add_rounded,
            onPressed: _durationWeeks < 52 ? () => setState(() => _durationWeeks++) : null,
          ),
        ],
      ),
    );
  }

  Widget _stepperButton({required IconData icon, VoidCallback? onPressed}) {
    return Material(
      color: const Color(0xFF0D9488).withOpacity(onPressed == null ? 0.2 : 0.15),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 18,
            color: onPressed == null ? const Color(0xFF94A3B8) : const Color(0xFF0D9488),
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      autofocus: autofocus,
      textInputAction: textInputAction,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFF0D9488)),
        filled: true,
        fillColor: const Color(0xFF64748B).withOpacity(0.06),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(dashboardControllerProvider.notifier);
      if (widget.forceSetup) {
        controller.setNim(_nimController.text);
      }
      controller.updateProfile(
        name: _nameController.text,
        className: _classController.text,
        major: _majorController.text,
        companyName: _companyController.text,
        internshipDurationWeeks: _durationWeeks,
      );
      Navigator.pop(context);
    }
  }
}
