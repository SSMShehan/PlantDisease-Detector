import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';
import 'package:plant_disease_detector/core/providers/locale_provider.dart';
import 'package:plant_disease_detector/core/localization/app_strings.dart';
import 'package:plant_disease_detector/features/officer/presentation/screens/case_inbox_screen.dart';
import 'package:plant_disease_detector/features/profile/presentation/screens/profile_screen.dart';
import 'package:plant_disease_detector/core/widgets/language_selector_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// OfficerDashboardScreen — Handles Bottom Navigation & Core Views (Premium UI)
// ─────────────────────────────────────────────────────────────────────────────
class OfficerDashboardScreen extends ConsumerStatefulWidget {
  const OfficerDashboardScreen({super.key});

  @override
  ConsumerState<OfficerDashboardScreen> createState() => _OfficerDashboardScreenState();
}

class _OfficerDashboardScreenState extends ConsumerState<OfficerDashboardScreen> {
  int _currentIndex = 0;
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);
    final List<Widget> pages = [
      _OfficerHomeTab(
        key: ValueKey('officer_home_${currentLocale.languageCode}'),
        isOnline: _isOnline,
        onToggleStatus: () => setState(() => _isOnline = !_isOnline),
      ),
      CaseInboxScreen(key: ValueKey('officer_inbox_${currentLocale.languageCode}')),
      ProfileScreen(key: ValueKey('officer_profile_${currentLocale.languageCode}')),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background blobs for glassmorphism effect
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0F766E).withValues(alpha: 0.25), // Premium Teal
              ),
            ),
          ),
          Positioned(
            top: 200,
            right: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD9734E).withValues(alpha: 0.15), // Terracotta
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(color: Colors.white.withValues(alpha: 0.4)),
            ),
          ),

          // The active page
          IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
          
          // ── PREMIUM GLASSMORPHIC NAV BAR ──
          Positioned(
            left: 24, right: 24, bottom: 24,
            child: Container(
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.9),
                    const Color(0xFFE2E8F0).withValues(alpha: 0.5), 
                    Colors.white.withValues(alpha: 0.4),
                    const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                  ],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F766E).withValues(alpha: 0.08), 
                    blurRadius: 30, offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNavItem(0, Icons.dashboard_rounded, context.tr(en: 'Dashboard', si: 'උපකරණ පුවරුව', ta: 'முகப்பு')),
                        _buildNavItem(1, Icons.inbox_rounded,     context.tr(en: 'Inbox',     si: 'ලිපිගොනු',      ta: 'பெட்டி')),
                        _buildNavItem(2, Icons.person_rounded,    context.tr(en: 'Profile',   si: 'පැතිකඩ',      ta: 'சுயவிவரம்')),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    const Color activeColor = Color(0xFF0F766E);   // Deep premium teal
    const Color inactiveColor = Color(0xFF9BA6AE); 
    
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.all(isSelected ? 8 : 0),
                decoration: BoxDecoration(
                  color: isSelected ? activeColor.withValues(alpha: 0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: isSelected ? 26 : 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? activeColor : inactiveColor,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _OfficerHomeTab — The main analytics view
// ─────────────────────────────────────────────────────────────────────────────
class _OfficerHomeTab extends StatelessWidget {
  final bool isOnline;
  final VoidCallback onToggleStatus;

  const _OfficerHomeTab({super.key, required this.isOnline, required this.onToggleStatus});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false, // Nav bar is floating
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 100),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.tr(en: 'Analytics Overview', si: 'විශ්ලේෂණ දළ විශ්ලේෂණය', ta: 'பகுப்பாய்வு'), 
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 20),
                  _buildAnalyticsCards(context),
                  const SizedBox(height: 36),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(context.tr(en: 'Urgent Alerts', si: 'හදිසි අනතුරු ඇඟවීම්', ta: 'அவசர எச்சரிக்கைகள்'), 
                        style: AppTextStyles.titleMedium.copyWith(fontSize: 20, fontWeight: FontWeight.w800)),
                      GestureDetector(
                        onTap: () => context.push('/case_inbox'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9734E).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            context.tr(en: 'View All', si: 'සියල්ල පෙන්වන්න', ta: 'அனைத்தையும் காண்க'),
                            style: AppTextStyles.titleSmall.copyWith(color: const Color(0xFFD9734E), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildUrgentAlertsList(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.tr(en: 'Welcome back,', si: 'ආයුබෝවන්,', ta: 'வரவேற்கிறோம்,'), 
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5)),
              Text('Officer Sarah', style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.w800)),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatusToggle(),
              const SizedBox(width: 12),
              const LanguageSelectorButton(isCompact: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusToggle() {
    return GestureDetector(
      onTap: onToggleStatus,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: (isOnline ? const Color(0xFF0F766E) : Colors.grey).withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOnline ? const Color(0xFF22C55E) : Colors.grey.shade400,
                boxShadow: isOnline ? [
                  BoxShadow(color: const Color(0xFF22C55E).withValues(alpha: 0.4), blurRadius: 6, spreadRadius: 2)
                ] : [],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isOnline ? 'Online' : 'Offline',
              style: AppTextStyles.titleSmall.copyWith(
                fontWeight: FontWeight.w700, 
                color: isOnline ? const Color(0xFF0F766E) : Colors.grey.shade600
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildGlassCard(
            context: context,
            title: context.tr(en: 'Pending\nCases', si: 'පොරොත්තු\nනඩු', ta: 'நிலுவையில் உள்ளவை'),
            value: '24',
            icon: Icons.pending_actions_rounded,
            gradientColors: [const Color(0xFF0F766E), const Color(0xFF042F2E)],
            height: 256,
            onTap: () => context.push('/case_inbox'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              _buildGlassCard(
                context: context,
                title: context.tr(en: 'Resolved Today', si: 'අද විසඳූ', ta: 'இன்று தீர்க்கப்பட்டவை'),
                value: '12',
                icon: Icons.check_circle_outline_rounded,
                gradientColors: [const Color(0xFF10B981), const Color(0xFF047857)],
                height: 120,
                isSmall: true,
                onTap: () => context.push('/case_inbox'),
              ),
              const SizedBox(height: 16),
              _buildGlassCard(
                context: context,
                title: context.tr(en: 'High Priority', si: 'ඉහළ ප්‍රමුඛතා', ta: 'அதிக முன்னுரிமை'),
                value: '5',
                icon: Icons.warning_amber_rounded,
                gradientColors: [const Color(0xFFF59E0B), const Color(0xFFB45309)],
                height: 120,
                isSmall: true,
                onTap: () => context.push('/case_inbox'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradientColors,
    required double height,
    required VoidCallback onTap,
    bool isSmall = false,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            gradientColors[0].withValues(alpha: 0.85),
            gradientColors[1].withValues(alpha: 0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: gradientColors[1].withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.2),
            blurRadius: 0,
            spreadRadius: 1,
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          splashColor: Colors.white.withValues(alpha: 0.2),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: Padding(
            padding: EdgeInsets.all(isSmall ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isSmall ? 8 : 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: Icon(icon, color: Colors.white, size: isSmall ? 20 : 32),
                    ),
                    if (!isSmall)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),
                      ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value, style: AppTextStyles.headlineLarge.copyWith(
                      fontSize: isSmall ? 24 : 42, 
                      color: Colors.white, 
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    )),
                    const SizedBox(height: 2),
                    Text(title, style: AppTextStyles.titleSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.9), 
                      fontWeight: FontWeight.w600,
                      fontSize: isSmall ? 13 : 16,
                      height: 1.2,
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUrgentAlertsList(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 4,
        clipBehavior: Clip.none,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => context.push('/case_detail'),
            child: Container(
              width: 280,
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFECACA)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.emergency_rounded, color: Color(0xFFDC2626), size: 14),
                            const SizedBox(width: 4),
                            Text('URGENT', style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFFDC2626), fontWeight: FontWeight.bold, fontSize: 10)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text('${(index + 1) * 10}m ago', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const Spacer(),
                  Text('Late Blight Detected', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text('Zone 4 • Farmer John', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
