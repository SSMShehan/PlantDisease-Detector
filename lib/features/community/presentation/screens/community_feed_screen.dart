import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';
import 'package:plant_disease_detector/core/localization/app_strings.dart';
import 'package:plant_disease_detector/core/providers/user_provider.dart';
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
    final userData = ref.watch(userProvider);
    final String displayName = userData.fullName.isNotEmpty ? userData.fullName : 'U';

    return Scaffold(
      backgroundColor: Colors.grey.shade200, // Facebook-style grey background behind cards
      appBar: PremiumAppBar(
        title: Text(context.tr(en: 'Farmer Community', si: 'ගොවි සංසදය', ta: 'விவசாயிகள் மன்றம்')),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {}, // Future search feature
          )
        ],
      ),
      body: postsAsync.when(
        data: (posts) {
          return RefreshIndicator(
            onRefresh: () => ref.read(communityFeedProvider.notifier).refresh(),
            color: AppColors.primary,
            child: CustomScrollView(
              slivers: [
                // "What's on your mind?" Input (Facebook Style)
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    margin: const EdgeInsets.only(bottom: 8), // Gap before feed
                    child: Row(
                      children: [
                        _buildUserAvatar(userData.imagePath, displayName, 40),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.push('/create_post'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(
                                context.tr(en: "What's on your mind?", si: "ඔබේ අදහස කුමක්ද?", ta: "உங்கள் மனதில் என்ன இருக்கிறது?"),
                                style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey.shade600),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(Icons.photo_library_rounded, color: Colors.green),
                          onPressed: () => context.push('/create_post'),
                        ),
                      ],
                    ),
                  ),
                ),

                // Filter Tabs (LinkedIn/Insta style chips)
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    height: 56,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
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
                              color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _filters[index]['icon'],
                                  size: 16,
                                  color: isSelected ? AppColors.primary : Colors.grey.shade600,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  filterTitles[index],
                                  style: TextStyle(
                                    color: isSelected ? AppColors.primary : Colors.grey.shade600,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Feed List
                if (posts.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        context.tr(en: 'No posts yet.', si: 'පළකිරීම් කිසිවක් නැත.', ta: 'இடுகைகள் எதுவும் இல்லை.'),
                        style: AppTextStyles.bodyLarge,
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildPremiumFeedCard(posts[index]),
                      childCount: posts.length,
                    ),
                  ),
                
                const SliverToBoxAdapter(child: SizedBox(height: 80)), // Padding for FAB
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (error, _) => Center(child: Text('Error: \$error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create_post'),
        backgroundColor: AppColors.primary,
        elevation: 4,
        child: const Icon(Icons.edit_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildUserAvatar(String? imagePath, String fallbackName, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: imagePath != null && imagePath.isNotEmpty
            ? SmartImage(src: imagePath, fit: BoxFit.cover)
            : Center(
                child: Text(
                  fallbackName.isNotEmpty ? fallbackName[0].toUpperCase() : 'U',
                  style: TextStyle(color: AppColors.primary, fontSize: size * 0.45, fontWeight: FontWeight.bold),
                ),
              ),
      ),
    );
  }

  Widget _buildPremiumFeedCard(CommunityPost post) {
    final authorName = post.author?.fullName ?? 'Independent Farmer';
    final district = post.author?.location ?? 'Sri Lanka';
    final avatarUrl = post.author?.imagePath;
    final timeAgoStr = timeago.format(post.createdAt, locale: 'en');

    return Container(
      margin: const EdgeInsets.only(bottom: 8), // Gap between posts like Facebook
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildUserAvatar(avatarUrl, authorName, 44),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(authorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                      Row(
                        children: [
                          if (post.category.isNotEmpty) ...[
                            Text(post.category, style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500)),
                            Text(' • ', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                          ],
                          Text('\$timeAgoStr • \$district', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                          const SizedBox(width: 4),
                          Icon(Icons.public, size: 12, color: Colors.grey.shade500),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz, color: Colors.grey.shade600),
                  onPressed: () {}, // Future post options
                ),
              ],
            ),
          ),

          // Post Content
          GestureDetector(
            onTap: () => context.push('/post_detail', extra: post),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.title != null && post.title!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(post.title!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  Text(
                    post.content,
                    style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.black87),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // Edge-to-edge Image
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => context.push('/post_detail', extra: post),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: SizedBox(
                  width: double.infinity,
                  child: SmartImage(src: post.imageUrl!, fit: BoxFit.cover),
                ),
              ),
            ),
          ],

          // Stats Row
          if (post.likesCount > 0 || post.commentsCount > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  if (post.likesCount > 0) ...[
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.thumb_up, color: Colors.white, size: 10),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      post.isLikedByMe 
                        ? (post.likesCount == 1 ? 'You' : 'You and ${post.likesCount - 1} others') 
                        : '${post.likesCount}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13)
                    ),
                  ],
                  const Spacer(),
                  if (post.commentsCount > 0)
                    Text(
                      post.commentsCount == 1 ? '1 comment' : '${post.commentsCount} comments', 
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13)
                    ),
                ],
              ),
            ),

          const Divider(height: 1, thickness: 1),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: _buildInteractionButton(
                  icon: post.isLikedByMe ? Icons.thumb_up : Icons.thumb_up_outlined,
                  label: 'Like',
                  color: post.isLikedByMe ? AppColors.primary : Colors.grey.shade700,
                  onTap: () => ref.read(communityFeedProvider.notifier).toggleLike(post.id),
                ),
              ),
              Expanded(
                child: _buildInteractionButton(
                  icon: Icons.chat_bubble_outline,
                  label: 'Comment',
                  color: Colors.grey.shade700,
                  onTap: () => context.push('/post_detail', extra: post),
                ),
              ),
              Expanded(
                child: _buildInteractionButton(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  color: Colors.grey.shade700,
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildInteractionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
