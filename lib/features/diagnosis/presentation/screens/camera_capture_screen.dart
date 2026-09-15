import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';
import 'package:plant_disease_detector/features/diagnosis/presentation/screens/scanning_screen.dart';

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  int _selectedMode = 0;
  final List<String> _modes = ['Leaf Spot', 'Pest', 'Soil'];

  void _onCapture() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ScanningScreen()),
    );
  }

  void _onGallery() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ScanningScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen viewfinder background
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1508175688576-0c076b47b5b5?w=800&h=1200&fit=crop&auto=format',
              fit: BoxFit.cover,
            ),
          ),

          // Translucent top gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                ),
              ),
            ),
          ),

          // Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.flash_auto_rounded, color: Colors.white, size: 22),
                        const SizedBox(width: 6),
                        Text(
                          'AUTO',
                          style: AppTextStyles.titleSmall.copyWith(color: Colors.white, letterSpacing: 1.2),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 24),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Circular Alignment Reticle
          Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: CustomPaint(
                painter: _ReticlePainter(),
              ),
            ),
          ),

          // Bottom Control Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    border: Border(
                      top: BorderSide(color: Colors.white.withValues(alpha: 0.2), width: 1),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 24, bottom: 48, left: 24, right: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Mode Switcher Carousel
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chevron_left_rounded, color: Colors.white.withValues(alpha: 0.5)),
                          const SizedBox(width: 8),
                          ...List.generate(_modes.length, (index) {
                            final isSelected = _selectedMode == index;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedMode = index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.white.withValues(alpha: 0.2) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    if (isSelected) ...[
                                      Icon(
                                        index == 0 ? Icons.energy_savings_leaf_rounded : index == 1 ? Icons.bug_report_rounded : Icons.grass_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                    ],
                                    Text(
                                      _modes[index],
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          const SizedBox(width: 8),
                          Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.5)),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // Bottom Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Gallery Shortcut
                          GestureDetector(
                            onTap: _onGallery,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                                    image: const DecorationImage(
                                      image: NetworkImage('https://images.unsplash.com/photo-1592841200221-a6898f307baa?w=100&h=100&fit=crop'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('GALLERY', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                              ],
                            ),
                          ),

                          // Floating Capture Button
                          GestureDetector(
                            onTap: _onCapture,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 4),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4)),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Advice Shortcut
                          GestureDetector(
                            onTap: () {},
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.15),
                                  ),
                                  child: const Icon(Icons.tips_and_updates_outlined, color: Colors.white, size: 24),
                                ),
                                const SizedBox(height: 8),
                                Text('ADVICE', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw main circle
    canvas.drawCircle(center, radius, paint);

    // Draw crosshairs
    final crosshairLength = 20.0;
    
    // Top
    canvas.drawLine(Offset(center.dx, center.dy - radius + 5), Offset(center.dx, center.dy - radius - crosshairLength), paint);
    // Bottom
    canvas.drawLine(Offset(center.dx, center.dy + radius - 5), Offset(center.dx, center.dy + radius + crosshairLength), paint);
    // Left
    canvas.drawLine(Offset(center.dx - radius + 5, center.dy), Offset(center.dx - radius - crosshairLength, center.dy), paint);
    // Right
    canvas.drawLine(Offset(center.dx + radius - 5, center.dy), Offset(center.dx + radius + crosshairLength, center.dy), paint);

    // Draw dashed inner rectangle (Leaf Guides)
    final rectSize = radius * 1.1;
    final rect = Rect.fromCenter(center: center, width: rectSize, height: rectSize);
    
    _drawDashedRect(canvas, rect, paint);
  }

  void _drawDashedRect(Canvas canvas, Rect rect, Paint paint) {
    // Top edge
    _drawDashedLine(canvas, rect.topLeft, rect.topRight, paint);
    // Right edge
    _drawDashedLine(canvas, rect.topRight, rect.bottomRight, paint);
    // Bottom edge
    _drawDashedLine(canvas, rect.bottomRight, rect.bottomLeft, paint);
    // Left edge
    _drawDashedLine(canvas, rect.bottomLeft, rect.topLeft, paint);
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashWidth = 8.0;
    const dashSpace = 6.0;
    final distance = (p2 - p1).distance;
    final direction = (p2 - p1) / distance;
    
    double currentDistance = 0.0;
    while (currentDistance < distance) {
      final start = p1 + direction * currentDistance;
      double endDistance = currentDistance + dashWidth;
      if (endDistance > distance) {
        endDistance = distance;
      }
      final end = p1 + direction * endDistance;
      canvas.drawLine(start, end, paint);
      currentDistance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
