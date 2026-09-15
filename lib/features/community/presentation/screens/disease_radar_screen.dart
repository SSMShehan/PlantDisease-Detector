import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';
import 'package:plant_disease_detector/core/providers/location_provider.dart';
import 'package:plant_disease_detector/models/outbreak_report.dart';

class DiseaseRadarScreen extends ConsumerStatefulWidget {
  const DiseaseRadarScreen({super.key});

  @override
  ConsumerState<DiseaseRadarScreen> createState() => _DiseaseRadarScreenState();
}

class _DiseaseRadarScreenState extends ConsumerState<DiseaseRadarScreen>
    with TickerProviderStateMixin {
  OutbreakReport? _selectedOutbreak;
  bool _alertDismissed = false;
  bool _reported = false;

  late AnimationController _pulseCtrl;
  late AnimationController _scanCtrl;
  late Animation<double> _pulseAnim;
  late Animation<double> _scanAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _scanCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..repeat();
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _scanAnim = Tween<double>(begin: 0, end: 2 * math.pi).animate(_scanCtrl);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _scanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      body: Stack(
        children: [
          // ── Deep space background gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.3),
                  radius: 1.2,
                  colors: [Color(0xFF1A2340), Color(0xFF0A0F1E)],
                ),
              ),
            ),
          ),

          // ── Satellite map placeholder with overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.18,
              child: Image.network(
                'https://images.unsplash.com/photo-1508175688576-0c076b47b5b5?w=800&fit=crop&auto=format',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
          ),

          // ── Grid lines overlay
          Positioned.fill(child: CustomPaint(painter: _GridPainter())),

          // ── Radar sweep animation
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _scanAnim,
              builder: (_, __) => CustomPaint(
                painter: _RadarSweepPainter(_scanAnim.value),
              ),
            ),
          ),

          // ── Outbreak heat zones
          Positioned.fill(
            child: LayoutBuilder(builder: (context, constraints) {
              return Stack(
                children: mockOutbreaks.map((outbreak) {
                  final x = outbreak.mapPosition.dx * constraints.maxWidth;
                  final y = outbreak.mapPosition.dy * constraints.maxHeight;
                  final isSelected = _selectedOutbreak?.id == outbreak.id;
                  final baseRadius = 30.0 + (outbreak.severity * 40);
                  return Positioned(
                    left: x - baseRadius,
                    top: y - baseRadius,
                    child: GestureDetector(
                      onTap: () => setState(() =>
                          _selectedOutbreak = isSelected ? null : outbreak),
                      child: AnimatedBuilder(
                        animation: _pulseAnim,
                        builder: (_, __) => SizedBox(
                          width: baseRadius * 2,
                          height: baseRadius * 2,
                          child: CustomPaint(
                            painter: _HeatZonePainter(
                              color: outbreak.color,
                              pulse: isSelected ? _pulseAnim.value : 1.0,
                              severity: outbreak.severity,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
          ),

          // ── User location dot (center)
          Positioned.fill(
            child: LayoutBuilder(builder: (context, constraints) {
              return Stack(
                children: [
                  Positioned(
                    left: constraints.maxWidth * 0.48 - 12,
                    top: constraints.maxHeight * 0.44 - 12,
                    child: AnimatedBuilder(
                      animation: _pulseCtrl,
                      builder: (_, __) => Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.6 * _pulseAnim.value),
                              blurRadius: 20,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.my_location_rounded, size: 14, color: Color(0xFF0A0F1E)),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),

          // ── Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                            ),
                            child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.radar_rounded, color: Colors.white, size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Disease Radar',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                                      ),
                                      Text(
                                        locationState.isLoading ? 'Locating...' : locationState.address,
                                        style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE07A5F).withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFFE07A5F).withValues(alpha: 0.5)),
                                  ),
                                  child: const Text('LIVE', style: TextStyle(color: Color(0xFFE07A5F), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
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
          ),

          // ── Alert banner (dismissable)
          if (!_alertDismissed)
            Positioned(
              top: 110,
              left: 20,
              right: 20,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => setState(() => _alertDismissed = true),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE07A5F).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE07A5F).withValues(alpha: 0.5), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE07A5F).withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(child: Text('⚠️', style: TextStyle(fontSize: 16))),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Outbreak Alert Nearby!',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                                  ),
                                  Text(
                                    'Tomato Blight detected within 2.3km. Spray fungicides.',
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.close_rounded, color: Colors.white.withValues(alpha: 0.5), size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // ── Legend (bottom-left)
          Positioned(
            bottom: _selectedOutbreak != null ? 300 : 120,
            left: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SEVERITY', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1)),
                      const SizedBox(height: 8),
                      _buildLegendItem(const Color(0xFFE07A5F), 'High'),
                      const SizedBox(height: 4),
                      _buildLegendItem(const Color(0xFFF2A34A), 'Medium'),
                      const SizedBox(height: 4),
                      _buildLegendItem(const Color(0xFF81B29A), 'Low'),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Outbreak count badge (bottom-right)
          Positioned(
            bottom: _selectedOutbreak != null ? 300 : 120,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${mockOutbreaks.length}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 22),
                      ),
                      Text('Active\nZones', textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 9, height: 1.3)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Bottom: Outbreak detail sheet OR report button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _selectedOutbreak != null
                  ? _buildOutbreakSheet(_selectedOutbreak!)
                  : _buildBottomBar(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color.withValues(alpha: 0.8), shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11)),
      ],
    );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: GestureDetector(
              onTap: () {
                setState(() => _reported = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('🌿 Outbreak reported! Thank you for keeping the community safe.'),
                    backgroundColor: const Color(0xFF81B29A),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: _reported
                      ? const LinearGradient(colors: [Color(0xFF81B29A), Color(0xFF5A9E7C)])
                      : const LinearGradient(colors: [Color(0xFFE07A5F), Color(0xFFC96A4F)]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: ((_reported) ? const Color(0xFF81B29A) : const Color(0xFFE07A5F)).withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_reported ? Icons.check_circle_rounded : Icons.add_alert_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      _reported ? 'Outbreak Reported!' : 'Report a Disease Outbreak',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutbreakSheet(OutbreakReport outbreak) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0A0F1E).withValues(alpha: 0.85),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.15), width: 1)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: outbreak.color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: outbreak.color.withValues(alpha: 0.4)),
                    ),
                    child: Center(
                      child: Icon(Icons.coronavirus_rounded, color: outbreak.color, size: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(outbreak.diseaseName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                        Text('${outbreak.cropType} · ${outbreak.timeAgo}', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _selectedOutbreak = null),
                    child: Icon(Icons.close_rounded, color: Colors.white.withValues(alpha: 0.4), size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildStatChip('📍', '${outbreak.distanceKm} km', 'Distance'),
                  const SizedBox(width: 12),
                  _buildStatChip('👥', '${outbreak.reportCount}', 'Reports'),
                  const SizedBox(width: 12),
                  _buildStatChip('🔥', '${(outbreak.severity * 100).round()}%', 'Severity'),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: outbreak.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: outbreak.color.withValues(alpha: 0.25)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.tips_and_updates_rounded, color: outbreak.color, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Recommended: Apply copper-based fungicide. Inspect your ${outbreak.cropType.toLowerCase()} crop immediately.',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12, height: 1.4),
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

  Widget _buildStatChip(String emoji, String val, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
            Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

// ── Custom Painters ─────────────────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 0.5;
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RadarSweepPainter extends CustomPainter {
  final double angle;
  _RadarSweepPainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.48, size.height * 0.44);
    final radius = size.width * 0.42;

    // Draw radar circles
    final circlePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * i / 4, circlePaint);
    }

    // Sweep gradient
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: angle,
        endAngle: angle + 1.2,
        colors: [Colors.transparent, const Color(0xFF81B29A).withValues(alpha: 0.35)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      angle,
      1.2,
      true,
      sweepPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RadarSweepPainter old) => old.angle != angle;
}

class _HeatZonePainter extends CustomPainter {
  final Color color;
  final double pulse;
  final double severity;

  _HeatZonePainter({required this.color, required this.pulse, required this.severity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) * pulse;

    // Outer glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: 0.5 * severity),
          color.withValues(alpha: 0.2 * severity),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, glowPaint);

    // Inner core
    final corePaint = Paint()..color = color.withValues(alpha: 0.7 * severity);
    canvas.drawCircle(center, radius * 0.25, corePaint);
  }

  @override
  bool shouldRepaint(covariant _HeatZonePainter old) =>
      old.pulse != pulse || old.color != color;
}
