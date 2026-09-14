import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import 'scanning_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CameraCaptureScreen — Matches Figma CameraScreen.tsx
// ─────────────────────────────────────────────────────────────────────────────
class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  final ImagePicker _picker = ImagePicker();

  void _onCapture() async {
    // Simulate picking an image or opening camera
    // In a real app, you would use:
    // final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    // if (photo != null) { ... }
    
    // For now, immediately move to ScanningScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ScanningScreen()),
    );
  }

  void _onUpload() async {
    // Simulate picking from gallery
    // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
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
          // Full-screen camera background
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1508175688576-0c076b47b5b5?w=800&h=1200&fit=crop&auto=format',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.15),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          // Dark overlay gradient top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 180,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.55), Colors.transparent],
                ),
              ),
            ),
          ),

          // Dark overlay gradient bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                ),
              ),
            ),
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                    ),
                    child: const Text(
                      'Scan Leaf',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // AI hint text
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: Text(
                  'Place leaf inside the frame',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),

          // Focus Frame — center
          Positioned(
            top: 0,
            bottom: 160,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    Positioned(top: 0, left: 0, child: _buildCorner(top: true, left: true)),
                    Positioned(top: 0, right: 0, child: _buildCorner(top: true, left: false)),
                    Positioned(bottom: 0, left: 0, child: _buildCorner(top: false, left: true)),
                    Positioned(bottom: 0, right: 0, child: _buildCorner(top: false, left: false)),
                    Center(
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: Stack(
                          children: [
                            Align(alignment: Alignment.center, child: Container(width: 32, height: 1, color: Colors.white.withOpacity(0.4))),
                            Align(alignment: Alignment.center, child: Container(width: 1, height: 32, color: Colors.white.withOpacity(0.4))),
                            Align(alignment: Alignment.center, child: Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.white.withOpacity(0.7), shape: BoxShape.circle))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Glassmorphism control panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(32, 28, 32, 44),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A).withOpacity(0.85),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Hold steady · Good lighting recommended',
                    style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Gallery
                      GestureDetector(
                        onTap: _onUpload,
                        child: Column(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withOpacity(0.25), width: 2),
                                image: const DecorationImage(
                                  image: NetworkImage('https://images.unsplash.com/photo-1603442506725-80c47a1a3aaf?w=100&h=100&fit=crop&auto=format'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Gallery', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      
                      // Capture Button
                      GestureDetector(
                        onTap: _onCapture,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFE07A5F), Color(0xFFC96A4F)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: const Color(0xFFE07A5F).withOpacity(0.5), blurRadius: 24, offset: const Offset(0, 8)),
                            ],
                            border: Border.all(color: const Color(0xFFE07A5F).withOpacity(0.25), width: 4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                              ),
                              child: const Center(
                                child: Icon(Icons.camera_alt_outlined, color: Colors.white, size: 28),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // AI Mode
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                              ),
                              child: const Center(
                                child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 26),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('AI Scan', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner({required bool top, required bool left}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        border: Border(
          top: top ? BorderSide(color: Colors.white.withOpacity(0.95), width: 2) : BorderSide.none,
          bottom: !top ? BorderSide(color: Colors.white.withOpacity(0.95), width: 2) : BorderSide.none,
          left: left ? BorderSide(color: Colors.white.withOpacity(0.95), width: 2) : BorderSide.none,
          right: !left ? BorderSide(color: Colors.white.withOpacity(0.95), width: 2) : BorderSide.none,
        ),
      ),
    );
  }
}
