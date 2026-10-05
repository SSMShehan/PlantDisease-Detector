import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';
import 'package:plant_disease_detector/core/localization/app_strings.dart';
import 'package:plant_disease_detector/core/widgets/language_selector_button.dart';
import 'package:plant_disease_detector/features/officer/data/consultation_repository.dart';
import 'package:plant_disease_detector/models/consultation.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CaseInboxScreen — Real data from Supabase + working filters
// ─────────────────────────────────────────────────────────────────────────────
class CaseInboxScreen extends ConsumerStatefulWidget {
  const CaseInboxScreen({super.key});

  @override
  ConsumerState<CaseInboxScreen> createState() => _CaseInboxScreenState();
}

class _CaseInboxScreenState extends ConsumerState<CaseInboxScreen> {
  String _selectedFilter = 'all'; // all | pending | resolved | urgent

  List<Consultation> _applyFilter(List<Consultation> consultations) {
    switch (_selectedFilter) {
      case 'urgent':
        return consultations.where((c) => c.isUrgent && !c.isResolved).toList();
      case 'pending':
        return consultations.where((c) => c.isPending || c.isOpen).toList();
      case 'resolved':
        return consultations.where((c) => c.isResolved).toList();
      default:
        return consultations;
    }
  }

  @override
  Widget build(BuildContext context) {
    final consultationsAsync = ref.watch(consultationsProvider(null));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Background blob
            Positioned(
              bottom: -50,
              right: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0F766E).withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              top: -80,
              left: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFD9734E).withValues(alpha: 0.06),
                ),
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
                      _buildFilterChip(context, label: 'All Cases', filter: 'all'),
                      const SizedBox(width: 12),
                      _buildFilterChip(context, label: 'Urgent', filter: 'urgent',
                          color: const Color(0xFFEF4444)),
                      const SizedBox(width: 12),
                      _buildFilterChip(context, label: 'Pending', filter: 'pending',
                          color: const Color(0xFFF59E0B)),
                      const SizedBox(width: 12),
                      _buildFilterChip(context, label: 'Resolved', filter: 'resolved',
                          color: const Color(0xFF10B981)),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

                // List
                Expanded(
                  child: consultationsAsync.when(
                    loading: () => _buildLoadingList(),
                    error: (_, __) => _buildErrorState(context),
                    data: (consultations) {
                      final filtered = _applyFilter(consultations);
                      if (filtered.isEmpty) return _buildEmptyState(context);
                      return ListView.builder(
                        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 120),
                        physics: const BouncingScrollPhysics(),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildCaseTile(context, filtered[index], index),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
                        BoxShadow(color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10, offset: const Offset(0, 4)),
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
              GestureDetector(
                onTap: () => ref.refresh(consultationsProvider(null)),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.refresh_rounded, color: AppColors.textPrimary),
                    onPressed: () => ref.refresh(consultationsProvider(null)),
                    tooltip: 'Refresh',
                  ),
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

  Widget _buildFilterChip(BuildContext context,
      {required String label, required String filter, Color? color}) {
    final isSelected = _selectedFilter == filter;
    final activeColor = color ?? const Color(0xFF0F766E);
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.shade200,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: activeColor.withValues(alpha: 0.3),
                  blurRadius: 12, offset: const Offset(0, 4))]
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Text(
          label,
          style: AppTextStyles.titleSmall.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 120),
      itemCount: 5,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _buildSkeletonTile(),
      ),
    );
  }

  Widget _buildSkeletonTile() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(width: 80, height: 80,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16))),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(height: 12, width: 80,
                    decoration: BoxDecoration(color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6))),
                Container(height: 16, width: 160,
                    decoration: BoxDecoration(color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6))),
                Container(height: 12, width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF0F766E).withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.inbox_rounded, size: 56,
                color: Color(0xFF0F766E)),
          ),
          const SizedBox(height: 20),
          Text('No Cases Found',
              style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('No ${_selectedFilter == 'all' ? '' : _selectedFilter} cases at the moment.',
              style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, size: 56, color: Color(0xFFEF4444)),
          const SizedBox(height: 16),
          Text('Failed to load cases',
              style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => ref.refresh(consultationsProvider(null)),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildCaseTile(BuildContext context, Consultation c, int index) {
    return GestureDetector(
      onTap: () => context.push('/case_detail', extra: c),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: c.isUrgent
                ? const Color(0xFFFECACA)
                : Colors.white,
            width: c.isUrgent ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: c.isUrgent
                  ? const Color(0xFFEF4444).withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.04),
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
              tag: 'case_image_${c.id}',
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade100,
                  image: c.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(c.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8, offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: c.imageUrl == null
                    ? const Icon(Icons.eco_rounded, color: Color(0xFF0F766E), size: 36)
                    : null,
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
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: c.isResolved
                              ? const Color(0xFFDEF7EC)
                              : (c.isUrgent
                                  ? const Color(0xFFFEE2E2)
                                  : const Color(0xFFFEF3C7)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          c.isResolved
                              ? 'Resolved'
                              : (c.isUrgent ? 'Urgent' : 'Pending'),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: c.isResolved
                                ? const Color(0xFF046C4E)
                                : (c.isUrgent
                                    ? const Color(0xFF991B1B)
                                    : const Color(0xFF92400E)),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Time ago
                      Text(
                        c.timeAgo,
                        style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Farmer name
                  Text(
                    c.farmerName ?? 'Unknown Farmer',
                    style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),

                  // Disease / description
                  Text(
                    c.diseaseName != null
                        ? 'Suspected: ${c.diseaseName}${c.location != null ? ' • ${c.location}' : ''}'
                        : 'Awaiting diagnosis${c.location != null ? ' • ${c.location}' : ''}',
                    style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary, height: 1.3),
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
