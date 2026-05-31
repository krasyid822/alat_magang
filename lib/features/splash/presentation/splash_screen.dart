import 'dart:async';
import 'package:flutter/material.dart';
import '../../../app_version.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinished;

  const SplashScreen({super.key, required this.onFinished});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // --- Animation Controllers ---
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _taglineController;
  late final AnimationController _progressController;
  late final AnimationController _shimmerController;
  late final AnimationController _glowController;
  late final AnimationController _fadeOutController;

  // --- Animations ---
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _taglineOpacity;
  late final Animation<Offset> _taglineSlide;
  late final Animation<double> _progressValue;
  late final Animation<double> _shimmer;
  late final Animation<double> _glowRadius;
  late final Animation<double> _fadeOut;

  String _statusText = 'Memuat aplikasi...';

  static const _primaryTeal = Color(0xFF0D9488);
  static const _skyBlue = Color(0xFF38BDF8);
  static const _bgDark = Color(0xFF0F172A);

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startSequence();
  }

  void _initAnimations() {
    // Logo pop-in
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = CurvedAnimation(parent: _logoController, curve: Curves.elasticOut)
        .drive(Tween(begin: 0.0, end: 1.0));
    _logoOpacity = CurvedAnimation(parent: _logoController, curve: const Interval(0.0, 0.5))
        .drive(Tween(begin: 0.0, end: 1.0));

    // Title slide-up
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textOpacity = CurvedAnimation(parent: _textController, curve: Curves.easeOut)
        .drive(Tween(begin: 0.0, end: 1.0));
    _textSlide = CurvedAnimation(parent: _textController, curve: Curves.easeOut)
        .drive(Tween(begin: const Offset(0, 0.5), end: Offset.zero));

    // Tagline slide-up
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _taglineOpacity = CurvedAnimation(parent: _taglineController, curve: Curves.easeOut)
        .drive(Tween(begin: 0.0, end: 1.0));
    _taglineSlide = CurvedAnimation(parent: _taglineController, curve: Curves.easeOut)
        .drive(Tween(begin: const Offset(0, 0.5), end: Offset.zero));

    // Progress bar fill
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _progressValue = CurvedAnimation(parent: _progressController, curve: Curves.easeInOut)
        .drive(Tween(begin: 0.0, end: 1.0));

    // Shimmer sweep
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _shimmer = _shimmerController.drive(Tween(begin: -2.0, end: 2.0));

    // Glow pulse
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _glowRadius = CurvedAnimation(parent: _glowController, curve: Curves.easeInOut)
        .drive(Tween(begin: 20.0, end: 55.0));

    // Fade out whole screen
    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeOut = CurvedAnimation(parent: _fadeOutController, curve: Curves.easeIn)
        .drive(Tween(begin: 1.0, end: 0.0));
  }

  Future<void> _startSequence() async {
    // Step 1: Logo pop-in
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();

    // Step 2: Title slide-up
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();

    // Step 3: Tagline
    await Future.delayed(const Duration(milliseconds: 250));
    _taglineController.forward();

    // Step 4: Progress bar starts
    await Future.delayed(const Duration(milliseconds: 300));
    _progressController.forward();

    // Update status midway
    await Future.delayed(const Duration(milliseconds: 1100));
    if (mounted) setState(() => _statusText = 'Menyiapkan data lokal...');
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _statusText = 'Siap! Selamat datang 👋');
    await Future.delayed(const Duration(milliseconds: 500));

    // Step 5: Fade out
    if (mounted) {
      await _fadeOutController.forward();
      widget.onFinished();
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    _progressController.dispose();
    _shimmerController.dispose();
    _glowController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeOut,
      child: Scaffold(
        backgroundColor: _bgDark,
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        // Radial gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.0, -0.2),
              radius: 1.2,
              colors: [Color(0xFF0D2131), _bgDark],
            ),
          ),
        ),

        // Decorative floating orbs
        _buildOrb(Alignment(-1.1, -0.9), 200, _primaryTeal.withOpacity(0.06)),
        _buildOrb(Alignment(1.2, 0.8), 260, _skyBlue.withOpacity(0.05)),
        _buildOrb(Alignment(-0.8, 1.0), 180, _primaryTeal.withOpacity(0.04)),

        // Animated grid dots overlay
        CustomPaint(
          size: Size.infinite,
          painter: _DotGridPainter(),
        ),

        // Main content
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildGlowingLogo(),
              const SizedBox(height: 32),
              _buildTitle(),
              const SizedBox(height: 10),
              _buildTagline(),
              const SizedBox(height: 56),
              _buildProgressSection(),
            ],
          ),
        ),

        // Bottom branding
        Positioned(
          bottom: 32,
          left: 0,
          right: 0,
          child: Center(
            child: FadeTransition(
              opacity: _taglineOpacity,
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Color(0xFF334155),
                    fontSize: 12,
                    letterSpacing: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'Politeknik Negeri Medan \u2022 $kAppYear'),
                    WidgetSpan(
                      baseline: TextBaseline.alphabetic,
                      alignment: PlaceholderAlignment.aboveBaseline,
                      child: Transform.translate(
                        offset: const Offset(0, -4),
                        child: Text(
                          '+$kBuildNumber',
                          style: const TextStyle(
                            color: Color(0xFF334155),
                            fontSize: 8,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrb(AlignmentGeometry alignment, double size, Color color) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }

  Widget _buildGlowingLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoController, _glowController]),
      builder: (context, _) {
        return Opacity(
          opacity: _logoOpacity.value,
          child: Transform.scale(
            scale: _logoScale.value,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F766E), _primaryTeal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _primaryTeal.withOpacity(0.55),
                    blurRadius: _glowRadius.value,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: _skyBlue.withOpacity(0.2),
                    blurRadius: _glowRadius.value * 1.5,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: const Icon(
                Icons.storage_rounded,
                color: Colors.white,
                size: 52,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return SlideTransition(
      position: _textSlide,
      child: FadeTransition(
        opacity: _textOpacity,
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [_primaryTeal, _skyBlue],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds),
          child: const Text(
            'Alat Magang',
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagline() {
    return SlideTransition(
      position: _taglineSlide,
      child: FadeTransition(
        opacity: _taglineOpacity,
        child: const Text(
          'Platform Pencatatan Laporan Magang Terpadu',
          style: TextStyle(
            color: Color(0xFF64748B),
            fontSize: 13.5,
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return FadeTransition(
      opacity: _taglineOpacity,
      child: SizedBox(
        width: 240,
        child: Column(
          children: [
            // Progress bar with shimmer
            AnimatedBuilder(
              animation: Listenable.merge([_progressController, _shimmerController]),
              builder: (context, _) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: SizedBox(
                    height: 4,
                    child: Stack(
                      children: [
                        // Track
                        Container(color: const Color(0xFF1E293B)),
                        // Fill
                        FractionallySizedBox(
                          widthFactor: _progressValue.value,
                          child: Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [_primaryTeal, _skyBlue],
                                  ),
                                ),
                              ),
                              // Shimmer sweep
                              Transform.translate(
                                offset: Offset(_shimmer.value * 120, 0),
                                child: Container(
                                  width: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0),
                                        Colors.white.withOpacity(0.35),
                                        Colors.white.withOpacity(0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            // Status text
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _statusText,
                key: ValueKey(_statusText),
                style: const TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 12,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Paints a subtle dot grid on the background
class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E293B).withOpacity(0.6)
      ..style = PaintingStyle.fill;

    const spacing = 36.0;
    const dotRadius = 1.0;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
