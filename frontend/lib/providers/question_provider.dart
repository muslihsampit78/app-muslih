import 'package:flutter/material.dart';

import '../models/api_response.dart';
import '../models/faq.dart';
import '../models/question.dart';
import '../models/question_topic.dart';
import '../services/api_service.dart';

class QuestionProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  List<QuestionTopic> _topics = [];
  List<Question> _questions = [];
  List<Faq> _faqs = [];
  PaginationMeta? _questionsMeta;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<QuestionTopic> get topics => _topics;
  List<Question> get questions => _questions;
  List<Faq> get faqs => _faqs;
  PaginationMeta? get questionsMeta => _questionsMeta;

  Future<void> loadTopics({required String locale}) async {
    try {
      _topics = await ApiService.getQuestionTopics(locale: locale);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadFaqs({required String locale, String? topicSlug}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _faqs = await ApiService.getFaqs(locale: locale, topicSlug: topicSlug);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadQuestions({
    required String locale,
    int page = 1,
    String? search,
    String? topicSlug,
    String? status,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await ApiService.getQuestions(
        locale: locale,
        page: page,
        search: search,
        topicSlug: topicSlug,
        status: status,
      );
      _questions = res.data;
      _questionsMeta = res.meta;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitQuestion({
    required String name,
    required String email,
    String? phone,
    required int topicId,
    required String subject,
    required String body,
    required String locale,
  }) async {
    try {
      return await ApiService.submitQuestion(
        name: name,
        email: email,
        phone: phone,
        topicId: topicId,
        subject: subject,
        body: body,
        locale: locale,
      );
    } catch (_) {
      return false;
    }
  }
}

