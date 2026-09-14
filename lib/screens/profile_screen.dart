import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ProfileScreen — Matches Figma ProfileScreen.tsx
// ─────────────────────────────────────────────────────────────────────────────
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<_Achievement> _achievements = const [
    _Achievement(icon: "🌾", label: "50 Scans", earned: true),
    _Achievement(icon: "🔬", label: "Disease Expert", earned: true),
    _Achievement(icon: "⭐", label: "Top Farmer", earned: true),
    _Achievement(icon: "🏆", label: "100 Scans", earned: false),
    _Achievement(icon: "🌿", label: "Zero Disease", earned: false),
    _Achievement(icon: "📊", label: "Data Pro", earned: false),
  ];

  final List<_Setting> _settings = [
    _Setting(icon: "🔔", label: "Notifications", sub: "Disease alerts & tips", toggle: true, on: true),
    _Setting(icon: "📍", label: "Location", sub: "Auto-detect field GPS", toggle: true, on: true),
    _Setting(icon: "🌐", label: "Language", sub: "English", toggle: false),
    _Setting(icon: "📱", label: "Offline Mode", sub: "Scan without internet", toggle: true, on: false),
    _Setting(icon: "📞", label: "Emergency Contact", sub: "0771 234 567", toggle: false),
    _Setting(icon: "❓", label: "Help & Support", sub: "FAQs and tutorials", toggle: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Profile', style: AppTextStyles.headlineMedium.copyWith(letterSpacing: -0.5, fontSize: 24)),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                    ]),
                    child: const Icon(Icons.settings_outlined, color: Color(0xFF9AA5B4), size: 20),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileCard(),
                    _buildAchievements(),
                    _buildFarmDetails(),
                    _buildSettings(),
                    
                    // Sign out
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: GestureDetector(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(color: const Color(0xFFFFF5F2), borderRadius: BorderRadius.circular(16)),
                          alignment: Alignment.center,
                          child: const Text('Sign Out', style: TextStyle(color: Color(0xFFE07A5F), fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFE07A5F), Color(0xFFC96A4F)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: const Color(0xFFE07A5F).withOpacity(0.35), blurRadius: 24, offset: const Offset(0, 12)),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 144,
              height: 144,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.15)),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(0.4), width: 3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.network('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=144&h=144&fit=crop&auto=format', fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sunil Bandara', style: AppTextStyles.headlineMedium.copyWith(color: Colors.white, fontSize: 20)),
                        const SizedBox(height: 2),
                        Text('Premium Farmer · Zone 4', style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.75))),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), shape: BoxShape.circle),
                              child: const Icon(Icons.star_rounded, color: Colors.white, size: 10),
                            ),
                            const SizedBox(width: 4),
                            Text('Premium Member since 2023', style: AppTextStyles.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildProfileStat('64', 'Total Scans')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildProfileStat('8.5', 'Acres Managed')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildProfileStat('4.8', 'Accuracy Score')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String val, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Text(val, style: AppTextStyles.headlineMedium.copyWith(color: Colors.white, fontSize: 18)),
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.75), fontSize: 9, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Achievements', style: AppTextStyles.titleSmall),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.95),
            itemCount: _achievements.length,
            itemBuilder: (context, i) {
              final a = _achievements[i];
              return Opacity(
                opacity: a.earned ? 1.0 : 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    color: a.earned ? Colors.white : const Color(0xFFF5F3F0),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      if (a.earned) BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(a.icon, style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 6),
                      Text(
                        a.label,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall.copyWith(color: a.earned ? AppColors.textPrimary : const Color(0xFF9AA5B4), fontWeight: FontWeight.w600, fontSize: 11),
                      ),
                      if (a.earned) ...[
                        const SizedBox(height: 6),
                        Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(color: Color(0xFF81B29A), shape: BoxShape.circle),
                          child: const Icon(Icons.check_rounded, color: Colors.white, size: 10),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFarmDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Text('Farm Details', style: AppTextStyles.titleSmall),
            ),
            const Divider(color: Color(0x0F2D3748), height: 1),
            _buildDetailRow('Farm Name', 'Bandara Organic Farm'),
            const Divider(color: Color(0x0F2D3748), height: 1),
            _buildDetailRow('Location', 'Kandy, Central Province'),
            const Divider(color: Color(0x0F2D3748), height: 1),
            _buildDetailRow('Main Crops', 'Tomatoes, Peppers, Cucumbers'),
            const Divider(color: Color(0x0F2D3748), height: 1),
            _buildDetailRow('Soil Type', 'Red-Yellow Podzolic'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          Text(val, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: AppTextStyles.titleSmall),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              children: List.generate(_settings.length, (i) {
                final s = _settings[i];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      child: Row(
                        children: [
                          Text(s.icon, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s.label, style: AppTextStyles.titleSmall.copyWith(fontSize: 14)),
                                Text(s.sub, style: AppTextStyles.bodySmall.copyWith(fontSize: 12)),
                              ],
                            ),
                          ),
                          if (s.toggle)
                            GestureDetector(
                              onTap: () => setState(() => s.on = !s.on),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 44,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: s.on ? const Color(0xFFE07A5F) : const Color(0xFFEDEAE5),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Stack(
                                  children: [
                                    AnimatedPositioned(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      top: 4,
                                      left: s.on ? 22 : 4,
                                      child: Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4, offset: const Offset(0, 1))],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            const Icon(Icons.chevron_right_rounded, color: Color(0xFFC8D0DA), size: 20),
                        ],
                      ),
                    ),
                    if (i < _settings.length - 1) const Divider(color: Color(0x0F2D3748), height: 1),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _Achievement {
  final String icon, label;
  final bool earned;
  const _Achievement({required this.icon, required this.label, required this.earned});
}

class _Setting {
  final String icon, label, sub;
  final bool toggle;
  bool on;
  _Setting({required this.icon, required this.label, required this.sub, required this.toggle, this.on = false});
}
