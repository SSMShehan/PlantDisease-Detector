import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';
import 'package:plant_disease_detector/core/localization/app_strings.dart';
import 'package:plant_disease_detector/core/widgets/language_selector_button.dart';

class CaseInboxScreen extends StatelessWidget {
  const CaseInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: false,
        child: Stack(
        children: [
          // Background blobs
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0F766E).withValues(alpha: 0.2), // Premium Teal
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
          
          Column(
            children: [
              _buildAppBar(context),
              
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildFilterChip('All Cases', true),
                    const SizedBox(width: 12),
                    _buildFilterChip('Urgent', false, color: const Color(0xFFEF4444)),
                    const SizedBox(width: 12),
                    _buildFilterChip('Pending', false),
                    const SizedBox(width: 12),
                    _buildFilterChip('Resolved', false),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 24, right: 24, bottom: 120),
                  physics: const BouncingScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    final isResolved = index % 4 == 3;
                    final isUrgent = index == 0 || index == 1;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildCaseTile(context, isResolved, isUrgent, index),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (context.canPop()) ...[
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                context.tr(en: 'Case Inbox', si: 'නඩු ලිපිගොනු', ta: 'வழக்குகள்'),
                style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10, offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.search_rounded, color: AppColors.textPrimary),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              const LanguageSelectorButton(isCompact: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, {Color? color}) {
    final activeColor = color ?? const Color(0xFF0F766E);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? activeColor : Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? activeColor : Colors.white, 
          width: 1.5,
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: activeColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ] : [],
      ),
      child: Text(
        label,
        style: AppTextStyles.titleSmall.copyWith(
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCaseTile(BuildContext context, bool isResolved, bool isUrgent, int index) {
    return GestureDetector(
      onTap: () {
        context.push('/case_detail');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Thumbnail
            Hero(
              tag: 'case_image_$index',
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1599940824399-b87987ceb72a?q=80&w=200&auto=format&fit=crop'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isResolved 
                              ? const Color(0xFFDEF7EC) 
                              : (isUrgent ? const Color(0xFFFEE2E2) : const Color(0xFFFEF3C7)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isResolved ? 'Resolved' : (isUrgent ? 'Urgent' : 'Pending'),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isResolved 
                                ? const Color(0xFF046C4E) 
                                : (isUrgent ? const Color(0xFF991B1B) : const Color(0xFF92400E)),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        index == 0 ? 'Just now' : '${index * 2}h ago', 
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Farmer ${['Kamal', 'Nimal', 'Sunil', 'Saman'][index % 4]}', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text('Suspected Leaf Blight in Zone 4. Requires immediate attention.', 
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
