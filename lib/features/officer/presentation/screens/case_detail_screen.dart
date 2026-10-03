import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';
import 'package:plant_disease_detector/core/localization/app_strings.dart';
import 'dart:ui';

class CaseDetailScreen extends StatefulWidget {
  const CaseDetailScreen({super.key});

  @override
  State<CaseDetailScreen> createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends State<CaseDetailScreen> {
  final TextEditingController _chatController = TextEditingController();

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Fixed Top Image Background (Parallax Effect)
          Positioned(
            top: 0, left: 0, right: 0,
            height: MediaQuery.of(context).size.height * 0.48,
            child: Hero(
              tag: 'case_image_0', 
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1599940824399-b87987ceb72a?q=80&w=600&auto=format&fit=crop'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.6),
                        Colors.black.withValues(alpha: 0.2),
                        const Color(0xFFF8FAFC),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildPremiumPredictionCard(),
                      _buildChatSection(),
                    ],
                  ),
                ),
                _buildBottomInputArea(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGlassIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onPressed: () {
              if (context.canPop()) context.pop();
            },
          ),
          Text(
            context.tr(en: 'Case Details', si: 'නඩු විස්තර', ta: 'வழக்கு விவரங்கள்'),
            style: AppTextStyles.titleMedium.copyWith(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 0.5),
          ),
          _buildGlassIconButton(
            icon: Icons.more_horiz_rounded,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildGlassIconButton({required IconData icon, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumPredictionCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F766E).withValues(alpha: 0.15),
            blurRadius: 30, offset: const Offset(0, 15),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10, offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                          Text('URGENT', style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFFDC2626), fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF0F766E), Color(0xFF042F2E)]),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF0F766E).withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 3)),
                        ]
                      ),
                      child: Text(
                        '94% Match',
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Late Blight (Phytophthora infestans)', style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.w900, height: 1.1)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [Color(0xFFD9734E), Color(0xFFBA5A31)]),
                        ),
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Farmer John', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                            Text('Zone 4 • 2 hours ago', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F766E).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.call_rounded, color: Color(0xFF0F766E), size: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle indicator
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 16, bottom: 24),
              width: 50, height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          
          // Chat Bubbles (No scroll view here, the parent scrolls)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildChatBubble(
                  message: 'I noticed these brown spots on the lower leaves yesterday. They seem to be spreading fast.',
                  isMe: false,
                  time: '10:30 AM',
                ),
                _buildChatBubble(
                  message: 'Based on the AI scan and your description, it looks like Late Blight. Have you noticed any white mold on the underside of the leaves in the morning?',
                  isMe: true,
                  time: '10:45 AM',
                ),
                _buildChatBubble(
                  message: 'Yes, there is some fuzzy white mold. What should I do?',
                  isMe: false,
                  time: '10:50 AM',
                ),
              ],
            ),
          ),
          
          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFD9734E), Color(0xFF9C4927)]),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFFD9734E).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4)),
                      ]
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.medical_services_rounded, color: Colors.white, size: 20),
                      label: Text('Suggest Pesticide', style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16), // Bottom padding for chat list section
        ],
      ),
    );
  }

  Widget _buildBottomInputArea(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: _chatController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.grey.shade400),
                      border: InputBorder.none,
                      icon: const Icon(Icons.attach_file_rounded, color: Colors.grey, size: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF0F766E), Color(0xFF042F2E)]),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F766E).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                if (context.canPop()) context.pop();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: const Color(0xFF10B981).withValues(alpha: 0.5), width: 2),
                ),
                backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.05),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 22),
                  const SizedBox(width: 8),
                  Text('MARK AS RESOLVED', style: AppTextStyles.titleMedium.copyWith(color: const Color(0xFF10B981), fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble({required String message, required bool isMe, required String time}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) ...[
                const CircleAvatar(
                  radius: 14,
                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop'),
                ),
                const SizedBox(width: 12),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: isMe 
                        ? const LinearGradient(colors: [Color(0xFF0F766E), Color(0xFF042F2E)])
                        : const LinearGradient(colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)]),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(24),
                      topRight: const Radius.circular(24),
                      bottomLeft: Radius.circular(isMe ? 24 : 8),
                      bottomRight: Radius.circular(isMe ? 8 : 24),
                    ),
                    border: isMe ? null : Border.all(color: Colors.grey.shade200),
                    boxShadow: isMe ? [
                      BoxShadow(color: const Color(0xFF0F766E).withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))
                    ] : [],
                  ),
                  child: Text(
                    message,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isMe ? Colors.white : AppColors.textPrimary,
                      height: 1.4,
                      fontWeight: isMe ? FontWeight.w500 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
              if (isMe) const SizedBox(width: 40), 
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.only(left: isMe ? 0 : 40, right: isMe ? 10 : 0),
            child: Text(time, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
