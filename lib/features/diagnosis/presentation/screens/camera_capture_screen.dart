import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';
import 'package:plant_disease_detector/features/diagnosis/presentation/screens/scanning_screen.dart';

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> with SingleTickerProviderStateMixin {
  int _selectedMode = 0;
  final List<String> _modes = ['Leaf Spot', 'Pest', 'Soil'];
  
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

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
          // Full-screen viewfinder background with error builder
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1508175688576-0c076b47b5b5?w=800&h=1200&fit=crop&auto=format',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade900,
                child: const Center(child: Icon(Icons.camera_alt, color: Colors.white24, size: 100)),
              ),
            ),
          ),

          // Scanning Reticle with Animation
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // AI Instruction Pill
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.document_scanner_rounded, color: AppColors.secondary, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Point at the affected area',
                            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Animated Scanner Box
                SizedBox(
                  width: 260,
                  height: 260,
                  child: AnimatedBuilder(
                    animation: _scanController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _ModernReticlePainter(scanProgress: _scanController.value),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Top Bar (Glassmorphic)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTopGlassButton(
                      icon: Icons.close_rounded, 
                      onTap: () => Navigator.pop(context),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.flash_auto_rounded, color: Colors.amber, size: 20),
                              const SizedBox(width: 8),
                              Text('AUTO', style: AppTextStyles.titleSmall.copyWith(color: Colors.white, letterSpacing: 1.2)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _buildTopGlassButton(
                      icon: Icons.grid_view_rounded, 
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Control Panel (Premium Glassmorphism)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black.withValues(alpha: 0.6),
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                    border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.15), width: 1.5)),
                  ),
                  padding: const EdgeInsets.only(top: 24, bottom: 48, left: 24, right: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Segmented Mode Selector
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(_modes.length, (index) {
                            final isSelected = _selectedMode == index;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedMode = index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(26),
                                  boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)] : [],
                                ),
                                child: Text(
                                  _modes[index],
                                  style: TextStyle(
                                    color: isSelected ? Colors.black : Colors.white.withValues(alpha: 0.7),
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Bottom Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Gallery Button
                          GestureDetector(
                            onTap: _onGallery,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.1),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                                  ),
                                  child: const Icon(Icons.photo_library_rounded, color: Colors.white, size: 24),
                                ),
                                const SizedBox(height: 8),
                                Text('Gallery', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),

                          // Glowing Shutter Button
                          GestureDetector(
                            onTap: _onCapture,
                            child: Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.secondary.withValues(alpha: 0.5), width: 3),
                                boxShadow: [
                                  BoxShadow(color: AppColors.secondary.withValues(alpha: 0.4), blurRadius: 20, spreadRadius: 2),
                                ],
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),

                          // Advice Button
                          GestureDetector(
                            onTap: () {},
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.1),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                                  ),
                                  child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 26),
                                ),
                                const SizedBox(height: 8),
                                Text('Advice', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11, fontWeight: FontWeight.w600)),
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

  Widget _buildTopGlassButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}

class _ModernReticlePainter extends CustomPainter {
  final double scanProgress;
  
  _ModernReticlePainter({required this.scanProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final framePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final cornerLength = 30.0;
    
    // Draw 4 corners (modern scanner look)
    // Top Left
    canvas.drawLine(const Offset(0, 0), Offset(cornerLength, 0), framePaint);
    canvas.drawLine(const Offset(0, 0), Offset(0, cornerLength), framePaint);
    
    // Top Right
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - cornerLength, 0), framePaint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), framePaint);
    
    // Bottom Left
    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), framePaint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerLength), framePaint);
    
    // Bottom Right
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - cornerLength, size.height), framePaint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - cornerLength), framePaint);

    // Draw animated scanning line
    final lineY = size.height * scanProgress;
    
    final linePaint = Paint()
      ..color = AppColors.secondary
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
      
    canvas.drawLine(Offset(0, lineY), Offset(size.width, lineY), linePaint);
    
    // Glowing gradient effect above the line
    final glowRect = Rect.fromLTRB(0, lineY - 40, size.width, lineY);
    final glowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.secondary.withValues(alpha: 0.0),
          AppColors.secondary.withValues(alpha: 0.3),
        ],
      ).createShader(glowRect);
      
    canvas.drawRect(glowRect, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _ModernReticlePainter oldDelegate) {
    return oldDelegate.scanProgress != scanProgress;
  }
}
