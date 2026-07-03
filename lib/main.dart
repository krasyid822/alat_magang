import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/logbook/presentation/logbook_screen.dart';
import 'features/job_details/presentation/job_details_screen.dart';
import 'features/research/presentation/research_screen.dart';
import 'features/documents/presentation/documents_screen.dart';
import 'features/grading/presentation/grading_screen.dart';
import 'features/splash/presentation/splash_screen.dart';

import 'features/dashboard/presentation/widgets/nim_setup_dialog.dart';
import 'features/dashboard/presentation/widgets/app_info_dialog.dart';
import 'features/dashboard/provider/dashboard_provider.dart';
import 'features/shared/data/models.dart';
import 'features/shared/data/theme_provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

ThemeData _buildTheme(Brightness brightness, ThemeColorVariant variant) {
  final isDark = brightness == Brightness.dark;
  final Color scaffoldBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
  final Color surfaceColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF);
  
  Color primary;
  Color secondary;
  Color tertiary;
  Color errorColor;
  
  switch (variant) {
    case ThemeColorVariant.gold:
      primary = isDark ? const Color(0xFFD97706) : const Color(0xFFB45309);
      secondary = isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706);
      tertiary = isDark ? const Color(0xFF92400E) : const Color(0xFF78350F);
      errorColor = isDark ? const Color(0xFFF43F5E) : const Color(0xFFE11D48);
      break;
    case ThemeColorVariant.emerald:
      primary = isDark ? const Color(0xFF059669) : const Color(0xFF047857);
      secondary = isDark ? const Color(0xFF34D399) : const Color(0xFF10B981);
      tertiary = isDark ? const Color(0xFF065F46) : const Color(0xFF064E3B);
      errorColor = isDark ? const Color(0xFF84CC16) : const Color(0xFF65A30D);
      break;
    case ThemeColorVariant.deepBlue:
      primary = isDark ? const Color(0xFF2563EB) : const Color(0xFF1D4ED8);
      secondary = isDark ? const Color(0xFF06B6D4) : const Color(0xFF0891B2);
      tertiary = isDark ? const Color(0xFF4F46E5) : const Color(0xFF3730A3);
      errorColor = isDark ? const Color(0xFF7C3AED) : const Color(0xFF6D28D9);
      break;
    case ThemeColorVariant.standard:
      primary = const Color(0xFF0D9488);
      secondary = const Color(0xFF38BDF8);
      tertiary = const Color(0xFFF59E0B);
      errorColor = const Color(0xFFEC4899);
      break;
  }
  
  final toolColors = ToolColors(
    job: primary,
    logbook: secondary,
    research: tertiary,
    documents: errorColor,
  );
  
  final isStandard = variant == ThemeColorVariant.standard;
  
  return ThemeData(
    brightness: brightness,
    scaffoldBackgroundColor: scaffoldBg,
    primaryColor: primary,
    colorScheme: isDark
        ? ColorScheme.dark(
            primary: primary,
            secondary: secondary,
            tertiary: tertiary,
            error: errorColor,
            surface: surfaceColor,
            secondaryContainer: primary.withOpacity(0.15),
          )
        : ColorScheme.light(
            primary: primary,
            secondary: secondary,
            tertiary: tertiary,
            error: errorColor,
            surface: surfaceColor,
            secondaryContainer: primary.withOpacity(0.1),
          ),
    extensions: [toolColors],
    appBarTheme: AppBarTheme(
      backgroundColor: isStandard ? surfaceColor : primary,
      foregroundColor: isStandard ? (isDark ? Colors.white : Colors.black) : Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: isStandard ? primary : Colors.white),
      actionsIconTheme: IconThemeData(color: isStandard ? primary : Colors.white),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: surfaceColor,
      indicatorColor: primary.withOpacity(0.15),
      selectedIconTheme: IconThemeData(color: primary),
      unselectedIconTheme: const IconThemeData(color: Color(0xFF64748B)),
      selectedLabelTextStyle: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 11),
      unselectedLabelTextStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      selectedItemColor: primary,
      unselectedItemColor: const Color(0xFF64748B),
    ),
    useMaterial3: true,
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Alat Magang - Polmed',
      debugShowCheckedModeBanner: false,
      themeMode: themeState.themeMode,
      theme: _buildTheme(Brightness.light, themeState.colorVariant),
      darkTheme: _buildTheme(Brightness.dark, themeState.colorVariant),
      home: const AppRoot(),
    );
  }
}

/// Root widget yang mengatur transisi dari SplashScreen → MainNavigationShell
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool _splashDone = false;

  void _onSplashFinished() {
    if (mounted) setState(() => _splashDone = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_splashDone) {
      return SplashScreen(onFinished: _onSplashFinished);
    }
    return const MainNavigationShell();
  }
}

class MainNavigationShell extends ConsumerStatefulWidget {
  const MainNavigationShell({super.key});

  @override
  ConsumerState<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends ConsumerState<MainNavigationShell> {
  int _currentIndex = 0;

  final List<String> _titles = [
    'Dashboard Kelayakan',
    'Logbook & Absensi',
    'Form Detail Pekerjaan',
    'Bahan Riset Bab 2',
    'Dokumen Administratif',
    'Simulasi Nilai Magang',
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 850;

    final List<Widget> screens = [
      DashboardScreen(onTabSelected: (idx) => setState(() => _currentIndex = idx)),
      const LogbookScreen(),
      const JobDetailsScreen(),
      const ResearchScreen(),
      const DocumentsScreen(),
      const GradingScreen(),
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeState = ref.watch(themeProvider);
    final isStandard = themeState.colorVariant == ThemeColorVariant.standard;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex], 
          style: TextStyle(
            fontWeight: FontWeight.w900, 
            color: isStandard ? (isDark ? Colors.white : Colors.black87) : Colors.white,
          ),
        ),
        centerTitle: false,
        backgroundColor: isStandard ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.palette_rounded, color: isStandard ? Theme.of(context).colorScheme.primary : Colors.white, size: 24),
            tooltip: 'Ubah Tema',
            onPressed: () => _showThemeSelectionDialog(context, ref),
          ),
          IconButton(
            icon: Icon(Icons.edit_note_rounded, color: isStandard ? Theme.of(context).colorScheme.primary : Colors.white, size: 28),
            tooltip: 'Sunting Profil',
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const NimSetupDialog(forceSetup: false),
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout_rounded, color: isStandard ? const Color(0xFFF43F5E) : Colors.white, size: 26),
            tooltip: 'Keluar',
            onPressed: () {
              final syncState = ref.read(syncStatusProvider);
              if (syncState.status == SyncStatusType.uploading || syncState.status == SyncStatusType.downloading) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sinkronisasi data sedang berlangsung. Harap tunggu hingga selesai agar data Anda tersimpan sempurna.'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                  title: const Text('Keluar dari Sesi?', style: TextStyle(fontWeight: FontWeight.bold)),
                  content: const Text('Semua data lokal Anda akan dihapus bersih dari perangkat ini demi keamanan. Pastikan semua perangkat terlogin lainnya telah sinkron.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await ref.read(dashboardControllerProvider.notifier).logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF43F5E),
                        foregroundColor: Colors.white,
                        elevation: 0,
                      ),
                      child: const Text('Keluar & Hapus Data'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.info_outline_rounded, color: isStandard ? const Color(0xFF64748B) : Colors.white),
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
      body: Row(
        children: [
          if (isDesktop) _buildSidebar(),
          Expanded(child: screens[_currentIndex]),
        ],
      ),
      bottomNavigationBar: !isDesktop ? _buildBottomNavBar() : null,
    );
  }

  Widget _buildSidebar() {
    return NavigationRail(
      selectedIndex: _currentIndex,
      onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.dashboard_rounded), label: Text('Dashboard')),
        NavigationRailDestination(icon: Icon(Icons.calendar_month_rounded), label: Text('Logbook')),
        NavigationRailDestination(icon: Icon(Icons.photo_library_rounded), label: Text('Pekerjaan')),
        NavigationRailDestination(icon: Icon(Icons.analytics_rounded), label: Text('Riset')),
        NavigationRailDestination(icon: Icon(Icons.folder_zip_rounded), label: Text('Berkas')),
        NavigationRailDestination(icon: Icon(Icons.assessment_rounded), label: Text('Nilai')),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (idx) => setState(() => _currentIndex = idx),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dash'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'Log'),
        BottomNavigationBarItem(icon: Icon(Icons.photo_library_rounded), label: 'Tugas'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics_rounded), label: 'Riset'),
        BottomNavigationBarItem(icon: Icon(Icons.folder_zip_rounded), label: 'Berkas'),
        BottomNavigationBarItem(icon: Icon(Icons.assessment_rounded), label: 'Nilai'),
      ],
    );
  }

  void _showThemeSelectionDialog(BuildContext context, WidgetRef ref) {
    final themeState = ref.read(themeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Pilih Tema & Warna', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Mode Tampilan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ref.read(themeProvider.notifier).setThemeMode(ThemeMode.light);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.light_mode_rounded),
                      label: const Text('Terang'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: themeState.themeMode == ThemeMode.light
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                        side: BorderSide(
                          color: themeState.themeMode == ThemeMode.light
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ref.read(themeProvider.notifier).setThemeMode(ThemeMode.dark);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.dark_mode_rounded),
                      label: const Text('Gelap'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: themeState.themeMode == ThemeMode.dark
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                        side: BorderSide(
                          color: themeState.themeMode == ThemeMode.dark
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Variasi Warna', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 10),
              _buildColorOption(context, ref, ThemeColorVariant.standard, 'Default (Teal)', const Color(0xFF0D9488), themeState.colorVariant),
              _buildColorOption(context, ref, ThemeColorVariant.gold, 'Gold / Amber', const Color(0xFFD97706), themeState.colorVariant),
              _buildColorOption(context, ref, ThemeColorVariant.emerald, 'Emerald Green', const Color(0xFF059669), themeState.colorVariant),
              _buildColorOption(context, ref, ThemeColorVariant.deepBlue, 'Deep Blue', const Color(0xFF2563EB), themeState.colorVariant),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildColorOption(
    BuildContext context,
    WidgetRef ref,
    ThemeColorVariant variant,
    String label,
    Color color,
    ThemeColorVariant selected,
  ) {
    return RadioListTile<ThemeColorVariant>(
      title: Row(
        children: [
          Container(width: 16, height: 16, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
      value: variant,
      groupValue: selected,
      activeColor: Theme.of(context).colorScheme.primary,
      contentPadding: EdgeInsets.zero,
      onChanged: (val) {
        if (val != null) {
          ref.read(themeProvider.notifier).setColorVariant(val);
          Navigator.pop(context);
        }
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AppInfoDialog(),
    );
  }
}
