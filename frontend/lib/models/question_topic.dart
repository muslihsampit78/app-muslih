class QuestionTopic {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? icon;
  final int sortOrder;
  final int questionsCount;
  final int faqsCount;

  QuestionTopic({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.icon,
    this.sortOrder = 0,
    this.questionsCount = 0,
    this.faqsCount = 0,
  });

  factory QuestionTopic.fromJson(Map<String, dynamic> json) {
    return QuestionTopic(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
      questionsCount: json['questions_count'] as int? ?? 0,
      faqsCount: json['faqs_count'] as int? ?? 0,
    );
  }
}

