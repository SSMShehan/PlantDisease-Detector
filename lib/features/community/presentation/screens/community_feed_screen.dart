import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';

class CommunityFeedScreen extends StatelessWidget {
  const CommunityFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Community Forum', style: AppTextStyles.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('Ask', style: AppTextStyles.titleSmall.copyWith(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildPostCard(
            authorName: 'Kamal Perera',
            time: '2 hours ago',
            content: 'Has anyone tried using neem oil for Early Blight? Did it show good results before switching to chemical fungicides?',
            likes: 12,
            comments: 4,
            imageUrl: null,
          ),
          _buildPostCard(
            authorName: 'Sunil Silva',
            time: '5 hours ago',
            content: 'My tomato yield this season after following the cultural practices suggested here. Very happy!',
            likes: 45,
            comments: 8,
            imageUrl: 'https://images.unsplash.com/photo-1592841200221-a6898f307baa?w=400&h=300&fit=crop',
          ),
          _buildPostCard(
            authorName: 'Farmer Nimal',
            time: '1 day ago',
            content: 'Be careful of fake fungicides in the market. Always buy from authorized dealers.',
            likes: 89,
            comments: 15,
            imageUrl: null,
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard({
    required String authorName,
    required String time,
    required String content,
    required int likes,
    required int comments,
    String? imageUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(authorName[0], style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(authorName, style: AppTextStyles.titleSmall),
                      Text(time, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(content, style: AppTextStyles.bodyLarge),
          ),
          if (imageUrl != null) ...[
            const SizedBox(height: 12),
            Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ] else ...[
            const SizedBox(height: 16),
          ],
          const Divider(height: 1, color: AppColors.divider),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildInteractionButton(Icons.thumb_up_alt_outlined, '$likes Likes', false),
                const SizedBox(width: 24),
                _buildInteractionButton(Icons.mode_comment_outlined, '$comments Comments', false),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.share_outlined, color: AppColors.textSecondary),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionButton(IconData icon, String label, bool isActive) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: isActive ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(label, style: AppTextStyles.bodyMedium.copyWith(
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            )),
          ],
        ),
      ),
    );
  }
}
