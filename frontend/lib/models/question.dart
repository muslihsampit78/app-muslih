import 'question_topic.dart';

class QuestionAnswer {
  final int id;
  final String body;
  final DateTime? answeredAt;
  final String officerName;

  QuestionAnswer({
    required this.id,
    required this.body,
    this.answeredAt,
    this.officerName = 'Petugas',
  });

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionAnswer(
      id: json['id'] as int? ?? 0,
      body: json['body'] as String? ?? '',
      answeredAt: json['answered_at'] != null
          ? DateTime.tryParse(json['answered_at'] as String)
          : null,
      officerName: json['officer_name'] as String? ?? 'Petugas',
    );
  }
}

class Question {
  final int id;
  final String name;
  final String subject;
  final String body;
  final String status;
  final DateTime? createdAt;
  final QuestionTopic? topic;
  final QuestionAnswer? answer;

  Question({
    required this.id,
    required this.name,
    required this.subject,
    required this.body,
    this.status = 'pending',
    this.createdAt,
    this.topic,
    this.answer,
  });

  bool get isAnswered => status == 'answered' || answer != null;

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      body: json['body'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      topic: json['topic'] is Map<String, dynamic>
          ? QuestionTopic.fromJson(json['topic'] as Map<String, dynamic>)
          : null,
      answer: json['answer'] is Map<String, dynamic>
          ? QuestionAnswer.fromJson(json['answer'] as Map<String, dynamic>)
          : null,
    );
  }
}

