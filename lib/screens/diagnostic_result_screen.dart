import 'dart:io';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../theme/app_theme.dart';
import '../models/disease_result.dart';
import '../widgets/app_buttons.dart';
import '../widgets/info_card.dart';
import 'home_screen.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// DiagnosticResultScreen — Light theme results page
/// ─────────────────────────────────────────────────────────────────────────────
class DiagnosticResultScreen extends StatefulWidget {
  final DiseaseResult result;
  const DiagnosticResultScreen({super.key, required this.result});

  @override
  State<DiagnosticResultScreen> createState() =>
      _DiagnosticResultScreenState();
}

class _DiagnosticResultScreenState extends State<DiagnosticResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _enterCtrl;
  late AnimationController _circleCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _circleAnim;

  @override
  void initState() {
    super.initState();
    _enterCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim =
        CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
            begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _enterCtrl, curve: Curves.easeOutCubic));

    _circleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600));
    _circleAnim =
        CurvedAnimation(parent: _circleCtrl, curve: Curves.easeOut);

    _enterCtrl.forward().then((_) => _circleCtrl.forward());
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    _circleCtrl.dispose();
    super.dispose();
  }

  Color _confColor(double s) {
    if (s > 0.8) return AppColors.success;
    if (s >= 0.5) return AppColors.warning;
    return AppColors.error;
  }

  Color _confBg(double s) {
    if (s > 0.8) return AppColors.successLight;
    if (s >= 0.5) return AppColors.warningLight;
    return AppColors.errorLight;
  }

  String _confLabel(double s) {
    if (s > 0.8) return 'High Confidence';
    if (s >= 0.5) return 'Moderate Confidence';
    return 'Low Confidence';
  }

  void _scanAnother() {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, animation, _) => const HomeScreen(),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    final confColor = _confColor(r.confidenceScore);
    final confBg = _confBg(r.confidenceScore);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(r),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 20),
                    _buildConfidenceCard(r, confColor, confBg),
                    const SizedBox(height: 16),
                    _buildDiseaseCard(r, confColor),
                    const SizedBox(height: 16),
                    InfoCard(
                      title: 'Symptoms',
                      icon: Icons.search_rounded,
                      iconColor: AppColors.warning,
                      iconBg: AppColors.warningLight,
                      items: r.symptoms,
                      initiallyExpanded: true,
                    ),
                    const SizedBox(height: 12),
                    InfoCard(
                      title: 'Treatment Recommendations',
                      icon: Icons.healing_rounded,
                      iconColor: AppColors.success,
                      iconBg: AppColors.successLight,
                      items: r.treatments,
                    ),
                    const SizedBox(height: 28),
                    PrimaryButton(
                      label: 'Scan Another Plant',
                      icon: Icons.camera_alt_rounded,
                      onTap: _scanAnother,
                    ),
                    const SizedBox(height: 12),
                    SecondaryButton(
                      label: 'Share Results',
                      icon: Icons.share_rounded,
                      borderColor: AppColors.primary,
                      onTap: () {},
                    ),
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(DiseaseResult r) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: GestureDetector(
        onTap: () => Navigator.maybePop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 18),
        ),
      ),
      title: Text('Diagnosis Result',
          style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.bookmark_outline_rounded,
                color: Colors.white, size: 20),
            onPressed: () {},
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(File(r.imagePath), fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.25),
                    AppColors.primary.withValues(alpha: 0.9),
                  ],
                  stops: const [0.35, 1.0],
                ),
              ),
            ),
            // Bottom left info
            Positioned(
              bottom: 18,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(r.cropType,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textOnGold,
                          fontWeight: FontWeight.w800,
                        )),
                  ),
                  const SizedBox(height: 6),
                  Text(r.diseaseName,
                      style: AppTextStyles.headlineLarge
                          .copyWith(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfidenceCard(
      DiseaseResult r, Color confColor, Color confBg) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: const Border.fromBorderSide(
            BorderSide(color: AppColors.cardBorder)),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 20,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _circleAnim,
            builder: (_, _) {
              final v = r.confidenceScore * _circleAnim.value;
              return CircularPercentIndicator(
                radius: 52,
                lineWidth: 9,
                percent: v,
                center: Text(
                  '${(v * 100).toInt()}%',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: confColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 19,
                  ),
                ),
                progressColor: confColor,
                backgroundColor: confColor.withValues(alpha: 0.1),
                circularStrokeCap: CircularStrokeCap.round,
                animation: false,
              );
            },
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_confLabel(r.confidenceScore),
                    style: AppTextStyles.titleMedium.copyWith(
                        color: confColor, fontWeight: FontWeight.w700)),
                const SizedBox(height: 5),
                Text(
                  'AI confidence in this diagnosis based on visual pattern matching.',
                  style: AppTextStyles.bodySmall.copyWith(height: 1.5),
                ),
                const SizedBox(height: 10),
                SeverityBadge(severity: r.severity),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseCard(DiseaseResult r, Color confColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppGradients.hero,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.bug_report_rounded,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 10),
              Text('Detected Disease',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: Colors.white54)),
            ],
          ),
          const SizedBox(height: 14),
          Text(r.diseaseName,
              style: AppTextStyles.displayMedium.copyWith(
                  color: Colors.white, fontSize: 22, height: 1.2)),
          const SizedBox(height: 6),
          Text(
            'ශාකයේ රෝගය: ${r.diseaseName}',
            style: AppTextStyles.sinhala.copyWith(
                color: Colors.white.withValues(alpha: 0.4), fontSize: 11),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _chip(Icons.local_florist_rounded, r.cropType),
              const SizedBox(width: 8),
              _chip(Icons.calendar_today_rounded, _date()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
            color: Colors.white.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 13),
          const SizedBox(width: 5),
          Text(label,
              style: AppTextStyles.caption
                  .copyWith(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }

  String _date() {
    final n = DateTime.now();
    const m = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${n.day} ${m[n.month - 1]} ${n.year}';
  }
}
