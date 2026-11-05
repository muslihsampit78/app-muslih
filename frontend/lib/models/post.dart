import 'category.dart';

class Author {
  final int? id;
  final String? name;
  final String? avatarUrl;

  Author({this.id, this.name, this.avatarUrl});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] as int?,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}

class Post {
  final int id;
  final String title;
  final String slug;
  final String? summary;
  final String? content;
  final String? imageUrl;
  final String? status;
  final bool isFeatured;
  final int viewCount;
  final DateTime? publishedAt;
  final DateTime? createdAt;
  final Category? category;
  final Author? author;

  Post({
    required this.id,
    required this.title,
    required this.slug,
    this.summary,
    this.content,
    this.imageUrl,
    this.status,
    this.isFeatured = false,
    this.viewCount = 0,
    this.publishedAt,
    this.createdAt,
    this.category,
    this.author,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      summary: json['summary'] as String?,
      content: json['content'] as String?,
      imageUrl: json['image_url'] as String?,
      status: json['status'] as String?,
      isFeatured: json['is_featured'] as bool? ?? false,
      viewCount: json['view_count'] as int? ?? 0,
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      category: json['category'] is Map<String, dynamic>
          ? Category.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      author: json['author'] is Map<String, dynamic>
          ? Author.fromJson(json['author'] as Map<String, dynamic>)
          : null,
    );
  }
}

