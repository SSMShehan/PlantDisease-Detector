class CommunityUser {
  final String id;
  final String fullName;
  final String? imagePath;
  final String location;

  CommunityUser({
    required this.id,
    required this.fullName,
    this.imagePath,
    this.location = '',
  });
}

class CommunityPost {
  final String id;
  final String userId;
  final String? title;
  final String content;
  final String? imageUrl;
  final String category;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  
  // Joined fields
  final CommunityUser? author;
  final bool isLikedByMe;

  CommunityPost({
    required this.id,
    required this.userId,
    this.title,
    required this.content,
    this.imageUrl,
    this.category = 'General',
    this.likesCount = 0,
    this.commentsCount = 0,
    required this.createdAt,
    this.author,
    this.isLikedByMe = false,
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json, {CommunityUser? author, bool isLikedByMe = false}) {
    return CommunityPost(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String?,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      category: json['category'] as String? ?? 'General',
      likesCount: json['likes_count'] as int? ?? 0,
      commentsCount: json['comments_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      author: author,
      isLikedByMe: isLikedByMe,
    );
  }

  CommunityPost copyWith({
    int? likesCount,
    int? commentsCount,
    bool? isLikedByMe,
    CommunityUser? author,
  }) {
    return CommunityPost(
      id: id,
      userId: userId,
      title: title,
      content: content,
      imageUrl: imageUrl,
      category: category,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt,
      author: author ?? this.author,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
    );
  }
}

class CommunityComment {
  final String id;
  final String postId;
  final String userId;
  final String content;
  final DateTime createdAt;
  
  // Joined field
  final CommunityUser? author;

  CommunityComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.author,
  });

  factory CommunityComment.fromJson(Map<String, dynamic> json, {CommunityUser? author}) {
    return CommunityComment(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      userId: json['user_id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      author: author,
    );
  }
}
