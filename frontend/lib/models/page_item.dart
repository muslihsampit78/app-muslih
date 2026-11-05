class PageItem {
  final int id;
  final String title;
  final String slug;
  final String? content;
  final String? imageUrl;
  final int sortOrder;
  final bool showInMenu;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PageItem({
    required this.id,
    required this.title,
    required this.slug,
    this.content,
    this.imageUrl,
    this.sortOrder = 0,
    this.showInMenu = true,
    this.createdAt,
    this.updatedAt,
  });

  factory PageItem.fromJson(Map<String, dynamic> json) {
    return PageItem(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      content: json['content'] as String?,
      imageUrl: json['image_url'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
      showInMenu: json['show_in_menu'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }
}

