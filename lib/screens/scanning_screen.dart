import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/disease_result.dart';
import 'diagnostic_result_screen.dart';

/// Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
/// ScanningScreen Ã¢â‚¬â€œ AI processing animation with scan line
/// Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
class ScanningScreen extends StatefulWidget {
  final String imagePath;

  const ScanningScreen({super.key, required this.imagePath});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen>
    with TickerProviderStateMixin {
  // Scan line animation
  late AnimationController _scanCtrl;
  late Animation<double> _scanAnim;

  // Pulse rings
  late AnimationController _ringCtrl;
  late Animation<double> _ringAnim;

  // Text cycling
  late AnimationController _textCtrl;
  late Animation<double> _textFade;
  int _textIndex = 0;

  // Progress
  late AnimationController _progressCtrl;
  late Animation<double> _progressAnim;

  bool _navigated = false;

  final List<String> _analysingTexts = [
    'Analyzing plant health...',
    'Detecting disease patterns...',
    'Comparing with database...',
    'Calculating confidence score...',
    'Preparing diagnosis...',
  ];

  @override
  void initState() {
    super.initState();

    // Scan line bouncing up and down
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _scanAnim = CurvedAnimation(parent: _scanCtrl, curve: Curves.easeInOut);

    // Pulsing glow rings
    _ringCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: false);
    _ringAnim = CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOut);

    // Progress bar filling over ~3s
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    _progressAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressCtrl, curve: Curves.easeInOut),
    );
    _progressCtrl.forward();

    // Text cycling
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _textFade = CurvedAnimation(parent: _textCtrl, curve: Curves.easeInOut);
    _textCtrl.value = 1.0;
    _cycleText();

    // Navigate after 3.5s
    Future.delayed(const Duration(milliseconds: 3600), _navigate);
  }

  void _cycleText() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 720));
      if (!mounted) break;
      await _textCtrl.reverse();
      if (!mounted) break;
      setState(() => _textIndex = (_textIndex + 1) % _analysingTexts.length);
      await _textCtrl.forward();
    }
  }

  void _navigate() {
    if (_navigated || !mounted) return;
    _navigated = true;

    final result = DiseaseResult.mock(widget.imagePath);
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, _) =>
            DiagnosticResultScreen(result: result),
        transitionsBuilder: (_, animation, _, child) {
          return SlideTransition(
            position: Tween<Offset>(
                    begin: const Offset(0, 0.05), end: Offset.zero)
                .animate(CurvedAnimation(
                    parent: animation, curve: Curves.easeOutCubic)),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _scanCtrl.dispose();
    _ringCtrl.dispose();
    _progressCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background leaf image (blurred / darkened)
          _buildBackground(size),

          // Scan overlay
          _buildScanOverlay(size),

          // UI chrome (labels, progress)
          _buildUiChrome(size),
        ],
      ),
    );
  }

  Widget _buildBackground(Size size) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(
          File(widget.imagePath),
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
        ),
        // Dark scrim
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.72),
                Colors.black.withValues(alpha: 0.55),
                Colors.black.withValues(alpha: 0.72),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScanOverlay(Size size) {
    final frameW = size.width * 0.75;
    final frameH = size.height * 0.45;

    return Center(
      child: SizedBox(
        width: frameW,
        height: frameH,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // Frame border
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.7),
                  width: 2,
                ),
              ),
            ),

            // Pulsing rings
            AnimatedBuilder(
              animation: _ringAnim,
              builder: (_, _) {
                return CustomPaint(
                  size: Size(frameW, frameH),
                  painter: _PulseRingPainter(_ringAnim.value),
                );
              },
            ),

            // Scan line
            AnimatedBuilder(
              animation: _scanAnim,
              builder: (_, _) {
                final top = _scanAnim.value * (frameH - 6);
                return Positioned(
                  top: top,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Glow trail above
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.primary.withValues(alpha: 0.08),
                            ],
                          ),
                        ),
                      ),
                      // Scan line itself
                      Container(
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.primary.withValues(alpha: 0.9),
                              AppColors.primaryLight,
                              AppColors.primary.withValues(alpha: 0.9),
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.8),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      // Glow trail below
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.primary.withValues(alpha: 0.08),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Grid overlay for tech feel
            CustomPaint(
              size: Size(frameW, frameH),
              painter: _GridPainter(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUiChrome(Size size) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 60),
          // Logo / icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4), width: 1.5),
            ),
            child: const Icon(Icons.biotech_rounded,
                color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: 14),
          Text(
            'AI Analysis',
            style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
          ),
          const Spacer(),
          // Animated analysing text
          FadeTransition(
            opacity: _textFade,
            child: Text(
              _analysingTexts[_textIndex],
              style: AppTextStyles.bodyMedium
                  .copyWith(color: Colors.white70, fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 20),
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: AnimatedBuilder(
              animation: _progressAnim,
              builder: (_, _) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _progressAnim.value,
                        minHeight: 5,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(_progressAnim.value * 100).toInt()}%',
                      style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 48),
          // Sinhala subtitle
          Text(
            'ශාකයේ රෝගය හඳුනා ගනිමින් පවතී...',
            style: AppTextStyles.sinhala.copyWith(color: Colors.white38),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

/// Pulsing ring painter
class _PulseRingPainter extends CustomPainter {
  final double progress;
  _PulseRingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) * 0.5;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 3; i++) {
      final phase = (progress + i * 0.33) % 1.0;
      final radius = maxRadius * phase;
      final opacity = (1.0 - phase) * 0.3;
      paint.color = AppColors.primary.withValues(alpha: opacity);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_PulseRingPainter old) => old.progress != progress;
}

/// Subtle grid overlay
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 0.5;

    const step = 24.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}
