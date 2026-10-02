import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';
import 'package:plant_disease_detector/core/localization/app_strings.dart';
import 'package:plant_disease_detector/core/widgets/language_selector_button.dart';
import 'package:plant_disease_detector/shared/widgets/smart_image.dart';
import 'package:plant_disease_detector/shared/widgets/premium_app_bar.dart';
import 'package:plant_disease_detector/features/community/application/community_provider.dart';
import 'package:plant_disease_detector/features/community/data/community_models.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommunityFeedScreen extends ConsumerStatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  ConsumerState<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends ConsumerState<CommunityFeedScreen> {
  int _selectedFilterIndex = 0;
  final List<Map<String, dynamic>> _filters = [
    {'title': 'Trending', 'icon': Icons.local_fire_department_rounded},
    {'title': 'My Crops', 'icon': Icons.eco_rounded},
    {'title': 'Q&A', 'icon': Icons.help_outline_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(communityFeedProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: Text(context.tr(en: 'Farmer Community', si: 'ගොවි සංසදය', ta: 'விவசாயிகள் மன்றம்')),
        actions: const [
          LanguageSelectorButton(isCompact: true),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded, color: AppColors.textSecondary),
                      hintText: context.tr(en: 'Search discussions...', si: 'සාකච්ඡා සොයන්න...', ta: 'விவாதங்களைத் தேடுங்கள்...'),
                      hintStyle: AppTextStyles.bodyMedium,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Filter Tabs
              SizedBox(
                height: 40,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedFilterIndex == index;
                    final filterTitles = [
                      context.tr(en: 'Trending', si: 'ජනප්‍රිය', ta: 'பிரபலமானது'),
                      context.tr(en: 'My Crops', si: 'මගේ බෝග', ta: 'என் பயிர்கள்'),
                      context.tr(en: 'Q&A', si: 'ප්‍රශ්නෝත්තර', ta: 'கேள்வி & பதில்'),
                    ];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFilterIndex = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: isSelected ? Border.all(color: AppColors.primary, width: 1.5) : Border.all(color: Colors.grey.shade400),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _filters[index]['icon'],
                              size: 18,
                              color: isSelected ? AppColors.primary : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              filterTitles[index],
                              style: AppTextStyles.titleSmall.copyWith(
                                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Feed List
              Expanded(
                child: postsAsync.when(
                  data: (posts) {
                    if (posts.isEmpty) {
                      return Center(
                        child: Text(
                          context.tr(en: 'No posts yet.', si: 'පළකිරීම් කිසිවක් නැත.', ta: 'இடுகைகள் எதுவும் இல்லை.'),
                          style: AppTextStyles.bodyLarge,
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () => ref.read(communityFeedProvider.notifier).refresh(),
                      color: AppColors.primary,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return _buildFeedCard(post);
                        },
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  error: (error, _) => Center(child: Text('Error: $error')),
                ),
              ),
            ],
          ),
          
          // Centered FAB for New Post
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppGradients.primary,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  heroTag: 'create_post',
                  onPressed: () {
                    context.push('/create_post');
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  highlightElevation: 0,
                  child: const Icon(Icons.add_rounded, size: 32, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedCard(CommunityPost post) {
    final authorName = post.author?.fullName ?? 'Farmer';
    final avatarUrl = post.author?.imagePath;
    final timeAgoStr = timeago.format(post.createdAt, locale: 'en_short');

    return GestureDetector(
      onTap: () {
        context.push('/post_detail', extra: post);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: avatarUrl != null
                      ? SmartImage(src: avatarUrl, fit: BoxFit.cover)
                      : const Icon(Icons.person, color: Colors.grey, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(authorName, style: AppTextStyles.titleSmall),
                    if (post.category.isNotEmpty)
                      Text(
                        post.category,
                        style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
                const Spacer(),
                Text(timeAgoStr, style: AppTextStyles.bodySmall),
              ],
            ),
            const SizedBox(height: 12),
            if (post.title != null && post.title!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  post.title!,
                  style: AppTextStyles.titleMedium.copyWith(fontSize: 16),
                ),
              ),
            Text(
              post.content,
              style: AppTextStyles.bodyLarge.copyWith(height: 1.4),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            if (post.imageUrl != null && post.imageUrl!.isNotEmpty) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SmartImage(
                  src: post.imageUrl!,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                _buildActionButton(
                  icon: post.isLikedByMe ? Icons.thumb_up_rounded : Icons.thumb_up_alt_outlined,
                  label: '${post.likesCount}',
                  color: post.isLikedByMe ? AppColors.primary : AppColors.textSecondary,
                  onTap: () {
                    ref.read(communityFeedProvider.notifier).toggleLike(post.id);
                  },
                ),
                const SizedBox(width: 24),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: '${post.commentsCount}',
                  color: AppColors.textSecondary,
                  onTap: () {
                    context.push('/post_detail', extra: post);
                  },
                ),
                const Spacer(),
                _buildActionButton(
                  icon: Icons.share_rounded,
                  label: '',
                  color: AppColors.textSecondary,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );
  }
}
