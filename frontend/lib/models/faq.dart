import 'question_topic.dart';

class Faq {
  final int id;
  final String question;
  final String answer;
  final int sortOrder;
  final QuestionTopic? topic;

  Faq({
    required this.id,
    required this.question,
    required this.answer,
    this.sortOrder = 0,
    this.topic,
  });

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      id: json['id'] as int? ?? 0,
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      sortOrder: json['sort_order'] as int? ?? 0,
      topic: json['topic'] is Map<String, dynamic>
          ? QuestionTopic.fromJson(json['topic'] as Map<String, dynamic>)
          : null,
    );
  }
}

