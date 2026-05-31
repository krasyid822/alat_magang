import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/logbook/presentation/logbook_screen.dart';
import 'features/job_details/presentation/job_details_screen.dart';
import 'features/research/presentation/research_screen.dart';
import 'features/documents/presentation/documents_screen.dart';
import 'features/splash/presentation/splash_screen.dart';

import 'features/dashboard/presentation/widgets/nim_setup_dialog.dart';
import 'features/dashboard/provider/dashboard_provider.dart';

import 'app_version.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alat Magang - Polmed',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark, // Estetika premium default dark mode
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
        primaryColor: const Color(0xFF0D9488), // Teal
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF0D9488),
          secondary: Color(0xFF38BDF8),
          surface: Color(0xFF1E293B), // Slate 800
        ),
        useMaterial3: true,
      ),
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
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex], style: const TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: false,
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded, color: Color(0xFF0D9488), size: 28),
            tooltip: 'Sunting Profil',
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const NimSetupDialog(forceSetup: false),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFF43F5E), size: 26),
            tooltip: 'Keluar',
            onPressed: () => ref.read(dashboardControllerProvider.notifier).logout(),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded, color: Color(0xFF64748B)),
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
      backgroundColor: const Color(0xFF0F172A),
      labelType: NavigationRailLabelType.all,
      selectedLabelTextStyle: const TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold, fontSize: 11),
      unselectedLabelTextStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.dashboard_rounded), selectedIcon: Icon(Icons.dashboard_rounded, color: Color(0xFF0D9488)), label: Text('Dashboard')),
        NavigationRailDestination(icon: Icon(Icons.calendar_month_rounded), selectedIcon: Icon(Icons.calendar_month_rounded, color: Color(0xFF38BDF8)), label: Text('Logbook')),
        NavigationRailDestination(icon: Icon(Icons.photo_library_rounded), selectedIcon: Icon(Icons.photo_library_rounded, color: Color(0xFF0D9488)), label: Text('Pekerjaan')),
        NavigationRailDestination(icon: Icon(Icons.analytics_rounded), selectedIcon: Icon(Icons.analytics_rounded, color: Color(0xFFF59E0B)), label: Text('Bahan Riset')),
        NavigationRailDestination(icon: Icon(Icons.folder_zip_rounded), selectedIcon: Icon(Icons.folder_zip_rounded, color: Color(0xFFEC4899)), label: Text('Dokumen')),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (idx) => setState(() => _currentIndex = idx),
      backgroundColor: const Color(0xFF1E293B),
      selectedItemColor: const Color(0xFF0D9488),
      unselectedItemColor: const Color(0xFF64748B),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dash'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'Log'),
        BottomNavigationBarItem(icon: Icon(Icons.photo_library_rounded), label: 'Tugas'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics_rounded), label: 'Riset'),
        BottomNavigationBarItem(icon: Icon(Icons.folder_zip_rounded), label: 'Berkas'),
      ],
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Alat Magang Web',
      applicationVersion: 'v$kAppVersion+$kBuildNumber',
      applicationIcon: const Icon(Icons.storage_rounded, color: Color(0xFF0D9488), size: 40),
      children: const [
        Text('Dikembangkan khusus untuk mahasiswa Politeknik Negeri Medan untuk mempermudah pencatatan Laporan Magang Bab 1 s.d Bab 4 secara instan dengan penyimpanan lokal yang aman.'),
      ],
    );
  }
}
