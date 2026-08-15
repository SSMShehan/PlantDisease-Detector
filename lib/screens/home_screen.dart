import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'camera_capture_screen.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// HomeScreen – "Botanical Luxe" premium landing page
/// ─────────────────────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Entrance animations
  late AnimationController _entranceCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // Hero card floating blob
  late AnimationController _blobCtrl;
  late Animation<double> _blobAnim;

  // Stats counter
  late AnimationController _statsCtrl;
  late Animation<double> _statsAnim;

  // Scan button pulse
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim =
        CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
            begin: const Offset(0, 0.05), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _entranceCtrl, curve: Curves.easeOutCubic));

    _blobCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);
    _blobAnim =
        CurvedAnimation(parent: _blobCtrl, curve: Curves.easeInOut);

    _statsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _statsAnim =
        CurvedAnimation(parent: _statsCtrl, curve: Curves.easeOutCubic);

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.06).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _entranceCtrl.forward().then((_) => _statsCtrl.forward());
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _blobCtrl.dispose();
    _statsCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _goToCamera() {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (_, animation, _) => const CameraCaptureScreen(),
      transitionsBuilder: (_, animation, _, child) => SlideTransition(
        position: Tween<Offset>(
                begin: const Offset(0, 1), end: Offset.zero)
            .animate(CurvedAnimation(
                parent: animation, curve: Curves.easeOutCubic)),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 450),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildHeroCard()),
              SliverToBoxAdapter(child: _buildStatsRow()),
              SliverToBoxAdapter(child: _buildHowItWorks()),
              SliverToBoxAdapter(child: _buildCommonDiseases()),
              SliverToBoxAdapter(child: _buildTips()),
              const SliverToBoxAdapter(child: SizedBox(height: 110)),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // ─────────── Header ────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 20, 0),
        child: Row(
          children: [
            // Greeting
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _greeting(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textHint,
                      letterSpacing: 0.3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Plant',
                          style: AppTextStyles.headlineLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: 'Doc',
                          style: AppTextStyles.headlineLarge.copyWith(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Notification bell
            _iconBtn(
              icon: Icons.notifications_outlined,
              onTap: () {},
              badge: true,
            ),
            const SizedBox(width: 10),
            // Avatar
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppGradients.hero,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.person_rounded,
                  color: Colors.white, size: 22),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn({
    required IconData icon,
    required VoidCallback onTap,
    bool badge = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: const Border.fromBorderSide(
                  BorderSide(color: AppColors.cardBorder, width: 1)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon,
                color: AppColors.textSecondary, size: 20),
          ),
          if (badge)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─────────── Hero Card ─────────────────────────────────────────────────────
  Widget _buildHeroCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          height: 240,
          decoration: const BoxDecoration(gradient: AppGradients.hero),
          child: Stack(
            children: [
              // Animated blobs
              AnimatedBuilder(
                animation: _blobAnim,
                builder: (_, _) {
                  return Stack(
                    children: [
                      Positioned(
                        top: -40 + 20 * _blobAnim.value,
                        right: -30 + 15 * _blobAnim.value,
                        child: _blob(180,
                            Colors.white.withValues(alpha: 0.08)),
                      ),
                      Positioned(
                        bottom: -50 + 20 * _blobAnim.value,
                        left: 100 - 10 * _blobAnim.value,
                        child:
                            _blob(140, Colors.white.withValues(alpha: 0.05)),
                      ),
                    ],
                  );
                },
              ),

              // Decorative leaf silhouette (right side)
              Positioned(
                right: -10,
                bottom: -10,
                child: _buildLeafIllustration(),
              ),

              // Content (left side)
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 26, 160, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.goldLight,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'AI Powered',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.goldLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Headline
                    Text(
                      'Detect Crop\nDiseases\nInstantly',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'ශාක රෝග AI හරහා\nහඳුනා ගන්න',
                      style: AppTextStyles.sinhala.copyWith(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                    const Spacer(),

                    // Mini scan CTA
                    GestureDetector(
                      onTap: _goToCamera,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.gold.withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.search_rounded,
                                color: Color(0xFF1A1A00), size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'Scan a Leaf',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: const Color(0xFF1A1A00),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward_rounded,
                                color: Color(0xFF1A1A00), size: 14),
                          ],
                        ),
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

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildLeafIllustration() {
    return SizedBox(
      width: 160,
      height: 200,
      child: CustomPaint(painter: _LeafPainter()),
    );
  }

  // ─────────── Stats Row ─────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          _statCard('1,240+', 'Scans Done',
              Icons.qr_code_scanner_rounded, AppColors.primaryPale,
              AppColors.primary),
          const SizedBox(width: 12),
          _statCard('96%', 'Accuracy',
              Icons.verified_rounded, AppColors.goldPale,
              AppColors.gold),
          const SizedBox(width: 12),
          _statCard('48', 'Diseases DB',
              Icons.biotech_rounded,
              const Color(0xFFEDE7F6), const Color(0xFF7B1FA2)),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, IconData icon,
      Color bg, Color iconColor) {
    return Expanded(
      child: AnimatedBuilder(
        animation: _statsAnim,
        builder: (_, _) => Opacity(
          opacity: _statsAnim.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 16 * (1 - _statsAnim.value)),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: const Border.fromBorderSide(
                    BorderSide(color: AppColors.cardBorder)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: iconColor, size: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    value,
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(label, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────── How It Works ──────────────────────────────────────────────────
  Widget _buildHowItWorks() {
    final steps = [
      (Icons.camera_alt_rounded, 'Capture', 'Take or upload a leaf photo',
          AppColors.primaryPale, AppColors.primary),
      (Icons.auto_awesome_rounded, 'AI Scan', 'Our model analyzes in seconds',
          AppColors.goldPale, AppColors.goldDark),
      (Icons.article_rounded, 'Results', 'Get diagnosis & treatment',
          const Color(0xFFE3F2FD), const Color(0xFF1565C0)),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('How It Works', 'Fast, simple, accurate'),
          const SizedBox(height: 16),
          Row(
            children: steps.asMap().entries.map((e) {
              final (icon, title, desc, bg, color) = e.value;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: e.key < steps.length - 1 ? 10 : 0),
                  child: _stepCard(
                      e.key + 1, icon, title, desc, bg, color),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _stepCard(int num, IconData icon, String title,
      String desc, Color bg, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: const Border.fromBorderSide(
            BorderSide(color: AppColors.cardBorder)),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: bg, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                '0$num',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textHint,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: AppTextStyles.titleMedium),
          const SizedBox(height: 4),
          Text(desc,
              style: AppTextStyles.bodySmall.copyWith(height: 1.45),
              maxLines: 2),
        ],
      ),
    );
  }

  // ─────────── Common Diseases Chips ────────────────────────────────────────
  Widget _buildCommonDiseases() {
    final diseases = [
      ('🍅', 'Tomato Blight', 'High Risk'),
      ('🌽', 'Corn Rust', 'Medium'),
      ('🌿', 'Leaf Spot', 'Low'),
      ('🫑', 'Pepper Wilt', 'High Risk'),
      ('🍃', 'Downy Mildew', 'Medium'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 28, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _sectionHeader('Common in Your Region',
                'Tap to learn more'),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 96,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              itemCount: diseases.length,
              itemBuilder: (_, i) {
                final (emoji, name, risk) = diseases[i];
                final isHigh = risk == 'High Risk';
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isHigh
                          ? AppColors.error.withValues(alpha: 0.2)
                          : AppColors.cardBorder,
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 10,
                          offset: const Offset(0, 3)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(emoji,
                              style: const TextStyle(fontSize: 22)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isHigh
                                  ? AppColors.errorLight
                                  : risk == 'Medium'
                                      ? AppColors.warningLight
                                      : AppColors.primaryPale,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              risk,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isHigh
                                    ? AppColors.error
                                    : risk == 'Medium'
                                        ? AppColors.warning
                                        : AppColors.primary,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        name,
                        style: AppTextStyles.titleMedium
                            .copyWith(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─────────── Tips ──────────────────────────────────────────────────────────
  Widget _buildTips() {
    final tips = [
      (Icons.wb_sunny_rounded, AppColors.gold, 'Use Natural Light',
          'Photograph leaves in bright outdoor light for best results.'),
      (Icons.zoom_in_rounded, AppColors.primary, 'Focus Clearly',
          'Make sure the leaf fills the guide frame and is in sharp focus.'),
      (Icons.flip_rounded, const Color(0xFF7B1FA2), 'Both Sides',
          'Capture both sides of the leaf to improve detection accuracy.'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Tips for Better Results', 'Get accurate diagnoses'),
          const SizedBox(height: 14),
          ...tips.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: const Border.fromBorderSide(
                      BorderSide(color: AppColors.cardBorder)),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 10,
                        offset: const Offset(0, 3)),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: t.$2.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(t.$1, color: t.$2, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.$3,
                              style: AppTextStyles.titleMedium
                                  .copyWith(fontSize: 13)),
                          const SizedBox(height: 3),
                          Text(t.$4,
                              style: AppTextStyles.bodySmall
                                  .copyWith(height: 1.45)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        color: AppColors.textHint, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────── Floating Scan Button ──────────────────────────────────────────
  Widget _buildFAB() {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, _) => Transform.scale(
        scale: _pulseAnim.value,
        child: GestureDetector(
          onTap: _goToCamera,
          child: Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              gradient: AppGradients.gold,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.45),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.camera_alt_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Start Scanning Now',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textOnGold,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_forward_rounded,
                    color: Color(0xFF1A1A00), size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────── Helpers ───────────────────────────────────────────────────────
  Widget _sectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.headlineMedium),
        const SizedBox(height: 2),
        Text(subtitle, style: AppTextStyles.bodySmall),
      ],
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning 🌤';
    if (hour < 17) return 'Good Afternoon ☀️';
    return 'Good Evening 🌙';
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// Decorative leaf illustration painter
/// ─────────────────────────────────────────────────────────────────────────────
class _LeafPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Large leaf shape
    paint.color = Colors.white.withValues(alpha: 0.12);
    final path1 = Path();
    path1.moveTo(size.width * 0.5, size.height * 0.9);
    path1.cubicTo(
      size.width * 0.1, size.height * 0.7,
      -size.width * 0.1, size.height * 0.3,
      size.width * 0.5, size.height * 0.05,
    );
    path1.cubicTo(
      size.width * 1.1, size.height * 0.3,
      size.width * 0.9, size.height * 0.7,
      size.width * 0.5, size.height * 0.9,
    );
    canvas.drawPath(path1, paint);

    // Inner leaf / vein accent
    paint.color = Colors.white.withValues(alpha: 0.08);
    final path2 = Path();
    path2.moveTo(size.width * 0.55, size.height * 0.82);
    path2.cubicTo(
      size.width * 0.3, size.height * 0.65,
      size.width * 0.2, size.height * 0.35,
      size.width * 0.55, size.height * 0.1,
    );
    path2.cubicTo(
      size.width * 0.9, size.height * 0.35,
      size.width * 0.8, size.height * 0.65,
      size.width * 0.55, size.height * 0.82,
    );
    canvas.drawPath(path2, paint);

    // Center vein line
    final veinPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final veinPath = Path();
    veinPath.moveTo(size.width * 0.52, size.height * 0.88);
    veinPath.cubicTo(
      size.width * 0.52, size.height * 0.6,
      size.width * 0.52, size.height * 0.35,
      size.width * 0.52, size.height * 0.08,
    );
    canvas.drawPath(veinPath, veinPaint);

    // Small circular accent dots
    paint.color = Colors.white.withValues(alpha: 0.15);
    canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.2), 8, paint);
    canvas.drawCircle(
        Offset(size.width * 0.25, size.height * 0.55), 5, paint);
  }

  @override
  bool shouldRepaint(_LeafPainter old) => false;
}
