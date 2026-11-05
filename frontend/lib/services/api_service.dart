import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

import '../models/api_response.dart';
import '../models/category.dart';
import '../models/faq.dart';
import '../models/menu_item.dart';
import '../models/page_item.dart';
import '../models/post.dart';
import '../models/question.dart';
import '../models/question_topic.dart';
import '../models/slide.dart';

class ApiService {
  static String? _customBaseUrl;

  static void setBaseUrl(String url) {
    _customBaseUrl = url;
  }

  static String get baseUrl {
    if (_customBaseUrl != null && _customBaseUrl!.isNotEmpty) {
      return _customBaseUrl!;
    }

    const envUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }

    if (kIsWeb) {
      final origin = Uri.base.origin;
      // If we are served from Laravel port 8000 or app-muslih.test
      if (origin.contains('8000') || origin.contains('app-muslih')) {
        return '$origin/api/v1';
      }
    }

    // Default development server
    return 'http://localhost:8000/api/v1';
  }

  static String get serverOrigin {
    final uri = Uri.parse(baseUrl);
    return '${uri.scheme}://${uri.host}${uri.hasPort && uri.port != 80 && uri.port != 443 ? ':${uri.port}' : ''}';
  }

  static String? resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$serverOrigin$cleanPath';
  }

  static Map<String, String> _buildHeaders(String locale) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Accept-Language': locale,
    };
  }

  static Uri _buildUri(String path, String locale, [Map<String, dynamic>? queryParams]) {
    final Map<String, dynamic> params = {
      'lang': locale,
      ...?queryParams,
    };

    final base = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final fullUrl = '$base$normalizedPath';

    final uri = Uri.parse(fullUrl);
    final combinedParams = Map<String, String>.from(uri.queryParameters);
    params.forEach((k, v) {
      if (v != null && v.toString().isNotEmpty) {
        combinedParams[k] = v.toString();
      }
    });

    return uri.replace(queryParameters: combinedParams);
  }

  // --- Slides ---
  static Future<List<Slide>> getSlides({String locale = 'id'}) async {
    final uri = _buildUri('/slides', locale);
    final response = await http.get(uri, headers: _buildHeaders(locale));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final list = json['data'] as List? ?? [];
      return list.map((e) => Slide.fromJson(e)).toList();
    }
    return [];
  }

  // --- Posts ---
  static Future<PaginatedList<Post>> getPosts({
    String locale = 'id',
    int page = 1,
    String? search,
    String? categorySlug,
    bool? featured,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      if (search != null && search.isNotEmpty) 'search': search,
      if (categorySlug != null && categorySlug.isNotEmpty) 'category': categorySlug,
      if (featured != null) 'featured': featured ? '1' : '0',
    };

    final uri = _buildUri('/posts', locale, query);
    final response = await http.get(uri, headers: _buildHeaders(locale));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final list = (json['data'] as List? ?? [])
          .map((e) => Post.fromJson(e))
          .toList();
      final meta = json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null;
      return PaginatedList(data: list, meta: meta);
    }
    return PaginatedList(data: []);
  }

  static Future<Post?> getPostBySlug(String slug, {String locale = 'id'}) async {
    final uri = _buildUri('/posts/$slug', locale);
    final response = await http.get(uri, headers: _buildHeaders(locale));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['data'] != null) {
        return Post.fromJson(json['data']);
      }
    }
    return null;
  }

  // --- Categories ---
  static Future<List<Category>> getCategories({String locale = 'id'}) async {
    final uri = _buildUri('/categories', locale);
    final response = await http.get(uri, headers: _buildHeaders(locale));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final list = json['data'] as List? ?? [];
      return list.map((e) => Category.fromJson(e)).toList();
    }
    return [];
  }

  static Future<Category?> getCategoryBySlug(String slug, {String locale = 'id'}) async {
    final uri = _buildUri('/categories/$slug', locale);
    final response = await http.get(uri, headers: _buildHeaders(locale));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['data'] != null) {
        return Category.fromJson(json['data']);
      }
    }
    return null;
  }

  // --- Pages ---
  static Future<List<PageItem>> getPages({String locale = 'id'}) async {
    final uri = _buildUri('/pages', locale);
    final response = await http.get(uri, headers: _buildHeaders(locale));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final list = json['data'] as List? ?? [];
      return list.map((e) => PageItem.fromJson(e)).toList();
    }
    return [];
  }

  static Future<PageItem?> getPageBySlug(String slug, {String locale = 'id'}) async {
    final uri = _buildUri('/pages/$slug', locale);
    final response = await http.get(uri, headers: _buildHeaders(locale));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['data'] != null) {
        return PageItem.fromJson(json['data']);
      }
    }
    return null;
  }

  // --- Menus ---
  static Future<Menu?> getMenuByLocation(String location, {String locale = 'id'}) async {
    final uri = _buildUri('/menus/$location', locale);
    final response = await http.get(uri, headers: _buildHeaders(locale));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['data'] != null) {
        return Menu.fromJson(json['data']);
      }
    }
    return null;
  }

  // --- Settings ---
  static Future<Map<String, dynamic>> getSettings({String locale = 'id', String? group}) async {
    final query = <String, dynamic>{
      if (group != null && group.isNotEmpty) 'group': group,
    };
    final uri = _buildUri('/settings', locale, query);
    final response = await http.get(uri, headers: _buildHeaders(locale));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['meta'] != null && json['meta']['values'] is Map) {
        return Map<String, dynamic>.from(json['meta']['values']);
      }
      final list = json['data'] as List? ?? [];
      final map = <String, dynamic>{};
      for (var item in list) {
        if (item is Map && item['key'] != null) {
          map[item['key'].toString()] = item['value'];
        }
      }
      return map;
    }
    return {};
  }

  // --- Question Topics ---
  static Future<List<QuestionTopic>> getQuestionTopics({String locale = 'id'}) async {
    final uri = _buildUri('/question-topics', locale);
    final response = await http.get(uri, headers: _buildHeaders(locale));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final list = json['data'] as List? ?? [];
      return list.map((e) => QuestionTopic.fromJson(e)).toList();
    }
    return [];
  }

  // --- Questions ---
  static Future<PaginatedList<Question>> getQuestions({
    String locale = 'id',
    int page = 1,
    String? search,
    String? topicSlug,
    String? status,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      if (search != null && search.isNotEmpty) 'search': search,
      if (topicSlug != null && topicSlug.isNotEmpty) 'topic': topicSlug,
      if (status != null && status.isNotEmpty) 'status': status,
    };

    final uri = _buildUri('/questions', locale, query);
    final response = await http.get(uri, headers: _buildHeaders(locale));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final list = (json['data'] as List? ?? [])
          .map((e) => Question.fromJson(e))
          .toList();
      final meta = json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null;
      return PaginatedList(data: list, meta: meta);
    }
    return PaginatedList(data: []);
  }

  static Future<Question?> getQuestionById(int id, {String locale = 'id'}) async {
    final uri = _buildUri('/questions/$id', locale);
    final response = await http.get(uri, headers: _buildHeaders(locale));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['data'] != null) {
        return Question.fromJson(json['data']);
      }
    }
    return null;
  }

  static Future<bool> submitQuestion({
    required String name,
    required String email,
    String? phone,
    required int topicId,
    required String subject,
    required String body,
    String locale = 'id',
  }) async {
    final uri = _buildUri('/questions', locale);
    final response = await http.post(
      uri,
      headers: _buildHeaders(locale),
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'question_topic_id': topicId,
        'subject': subject,
        'body': body,
      }),
    );
    return response.statusCode == 201 || response.statusCode == 200;
  }

  // --- FAQs ---
  static Future<List<Faq>> getFaqs({String locale = 'id', String? topicSlug}) async {
    final query = <String, dynamic>{
      if (topicSlug != null && topicSlug.isNotEmpty) 'topic': topicSlug,
    };
    final uri = _buildUri('/faqs', locale, query);
    final response = await http.get(uri, headers: _buildHeaders(locale));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final list = json['data'] as List? ?? [];
      return list.map((e) => Faq.fromJson(e)).toList();
    }
    return [];
  }
}

