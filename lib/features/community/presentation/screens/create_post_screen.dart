import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';
import 'package:plant_disease_detector/shared/widgets/premium_app_bar.dart';
import 'package:plant_disease_detector/features/community/application/community_provider.dart';
import 'package:plant_disease_detector/core/localization/app_strings.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageUrlController = TextEditingController(); // Simulating image upload via URL for now
  String _selectedCategory = 'General';
  bool _isLoading = false;

  final List<String> _categories = ['General', 'Trending', 'My Crops', 'Q&A'];

  Future<void> _submitPost() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post content cannot be empty.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(communityFeedProvider.notifier).createPost(
        _contentController.text.trim(),
        title: _titleController.text.trim(),
        imageUrl: _imageUrlController.text.trim().isNotEmpty ? _imageUrlController.text.trim() : null,
        category: _selectedCategory,
      );
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create post: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: const Text('Create Post'),
        actions: [
          _isLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                )
              : TextButton(
                  onPressed: _submitPost,
                  child: const Text('Post', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Selector
            Text('Category', style: AppTextStyles.titleSmall),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCategory = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            TextField(
              controller: _titleController,
              style: AppTextStyles.titleMedium,
              decoration: InputDecoration(
                hintText: 'Title (Optional)',
                hintStyle: AppTextStyles.titleMedium.copyWith(color: Colors.grey.shade400),
                border: InputBorder.none,
              ),
            ),
            const Divider(),

            // Content
            TextField(
              controller: _contentController,
              style: AppTextStyles.bodyLarge,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'What\'s on your mind?',
                hintStyle: AppTextStyles.bodyLarge.copyWith(color: Colors.grey.shade400),
                border: InputBorder.none,
              ),
            ),

            const SizedBox(height: 16),
            // Image URL Placeholder (Since we can't easily upload files without integrating supabase storage)
            TextField(
              controller: _imageUrlController,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Image URL (Optional)',
                prefixIcon: const Icon(Icons.image_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
