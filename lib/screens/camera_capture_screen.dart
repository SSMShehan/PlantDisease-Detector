import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../theme/app_theme.dart';
import '../widgets/app_buttons.dart';
import 'scanning_screen.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// CameraCaptureScreen — Light + Forest Green viewfinder
/// ─────────────────────────────────────────────────────────────────────────────
class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen>
    with TickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

  late AnimationController _glowCtrl;
  late Animation<double> _glowAnim;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  late AnimationController _scanCtrl;
  late Animation<double> _scanAnim;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    _glowCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);
    _glowAnim = CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut);

    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.97, end: 1.03).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _scanCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2400))
      ..repeat(reverse: true);
    _scanAnim =
        CurvedAnimation(parent: _scanCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    _pulseCtrl.dispose();
    _scanCtrl.dispose();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_isProcessing) return;
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 95,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (image == null || !mounted) return;
      setState(() => _isProcessing = true);

      final CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: image.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Leaf',
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: AppColors.gold,
          ),
          IOSUiSettings(title: 'Crop Leaf'),
        ],
      );

      if (!mounted) return;
      setState(() => _isProcessing = false);
      if (cropped != null) _navigateToScanning(cropped.path);
    } catch (e) {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _navigateToScanning(String path) {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (_, animation, _) => ScanningScreen(imagePath: path),
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 400),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B0E), // Very dark forest
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),
                _buildTopHint(),
                Expanded(child: _buildGuideFrame(size)),
                _buildBottomPanel(),
              ],
            ),
          ),
          if (_isProcessing) _buildProcessingOverlay(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.maybePop(context),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.2), width: 1),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 17),
        ),
      ),
      title: Text(
        'Scan Leaf',
        style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
      ),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: () => _showTipsSheet(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.4), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.tips_and_updates_outlined,
                    color: AppColors.goldLight, size: 15),
                const SizedBox(width: 4),
                Text('Tips',
                    style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.goldLight,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackground() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Radial gradient - deep forest center
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.2),
              radius: 1.0,
              colors: [Color(0xFF1A3B1C), Color(0xFF0A150B)],
            ),
          ),
        ),
        // Animated glow blob top right
        AnimatedBuilder(
          animation: _glowAnim,
          builder: (_, _) => Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight
                    .withValues(alpha: 0.04 + 0.04 * _glowAnim.value),
              ),
            ),
          ),
        ),
        // Gold glow bottom
        AnimatedBuilder(
          animation: _glowAnim,
          builder: (_, _) => Positioned(
            bottom: 60,
            left: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withValues(
                    alpha: 0.03 + 0.03 * _glowAnim.value),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopHint() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.eco_rounded, color: AppColors.primaryLight, size: 15),
          const SizedBox(width: 8),
          Text(
            'Place the leaf clearly inside the frame',
            style: AppTextStyles.bodySmall
                .withValues(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideFrame(Size size) {
    final frameSize = size.width * 0.74;
    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([_glowAnim, _pulseAnim, _scanAnim]),
        builder: (_, _) {
          return Transform.scale(
            scale: _pulseAnim.value,
            child: SizedBox(
              width: frameSize,
              height: frameSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryLight.withValues(
                              alpha: 0.1 + 0.08 * _glowAnim.value),
                          blurRadius: 50,
                          spreadRadius: 12,
                        ),
                      ],
                    ),
                  ),
                  // Guide frame box
                  Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.primaryLight.withValues(
                            alpha: 0.25 + 0.45 * _glowAnim.value),
                        width: 1.8,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Scan line
                        Positioned(
                          top: _scanAnim.value * (frameSize - 40),
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colors.transparent,
                                AppColors.primaryLight.withValues(alpha: 0.6),
                                AppColors.primaryLight,
                                AppColors.primaryLight.withValues(alpha: 0.6),
                                Colors.transparent,
                              ]),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryLight.withValues(alpha: 0.5),
                                  blurRadius: 8,
                                )
                              ],
                            ),
                          ),
                        ),
                        // Center icon + text
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.eco_rounded,
                                color:
                                    Colors.white.withValues(alpha: 0.12),
                                size: 60),
                            const SizedBox(height: 8),
                            Text(
                              'ශාක කොළය මෙහි තබන්න',
                              style: AppTextStyles.sinhala.copyWith(
                                color: Colors.white.withValues(alpha: 0.28),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Corner markers
                  CustomPaint(
                    size: Size(frameSize, frameSize),
                    painter: _CornerPainter(
                      color: AppColors.primaryLight.withValues(
                          alpha: 0.6 + 0.4 * _glowAnim.value),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label
          Text(
            'Tap the button to capture',
            style: AppTextStyles.bodySmall.withValues(color: Colors.white38),
          ),
          const SizedBox(height: 18),

          // Shutter button
          AnimatedBuilder(
            animation: _glowAnim,
            builder: (_, _) => GestureDetector(
              onTap: () => _pickImage(ImageSource.camera),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow ring
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.gold.withValues(
                            alpha: 0.3 + 0.3 * _glowAnim.value),
                        width: 2,
                      ),
                    ),
                  ),
                  // Inner button
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD740), Color(0xFFFFB300)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withValues(
                              alpha: 0.35 + 0.25 * _glowAnim.value),
                          blurRadius: 28,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.camera_alt_rounded,
                        color: Color(0xFF1A1A00), size: 30),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text('Take Photo',
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.5))),
          const SizedBox(height: 20),

          // Gallery button
          SecondaryButton(
            label: 'Upload from Gallery',
            icon: Icons.photo_library_rounded,
            borderColor: AppColors.primaryLight,
            onTap: () => _pickImage(ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.6),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
            const SizedBox(height: 16),
            Text('Processing...',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  void _showTipsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppGradients.hero,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tips_and_updates_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text('Photo Tips', style: AppTextStyles.headlineMedium),
              ],
            ),
            const SizedBox(height: 20),
            ...[
              (Icons.wb_sunny_rounded, AppColors.gold,
                  'Good Lighting',
                  'Natural daylight gives the best detection accuracy'),
              (Icons.eco_rounded, AppColors.primary,
                  'Single Leaf',
                  'Focus on one affected leaf at a time'),
              (Icons.center_focus_strong_rounded,
                  const Color(0xFF7B1FA2),
                  'Stay Focused',
                  'Keep the leaf steady and in sharp focus'),
              (Icons.flip_rounded, const Color(0xFF0277BD),
                  'Both Sides',
                  'Capture both sides of the leaf if possible'),
            ].map((tip) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: tip.$2.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(tip.$1, color: tip.$2, size: 20),
                  ),
                  title: Text(tip.$3, style: AppTextStyles.titleMedium),
                  subtitle: Text(tip.$4, style: AppTextStyles.bodySmall),
                )),
          ],
        ),
      ),
    );
  }
}

extension on TextStyle {
  TextStyle withValues({Color? color}) =>
      copyWith(color: color);
}

class _CornerPainter extends CustomPainter {
  final Color color;
  _CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const len = 26.0;
    const r = 18.0;

    void corner(double x, double y, double dx, double dy) {
      canvas.drawLine(Offset(x + dx * r, y), Offset(x + dx * (r + len), y), paint);
      canvas.drawLine(Offset(x, y + dy * r), Offset(x, y + dy * (r + len)), paint);
    }

    corner(0, 0, 1, 1);
    corner(size.width, 0, -1, 1);
    corner(0, size.height, 1, -1);
    corner(size.width, size.height, -1, -1);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => old.color != color;
}
