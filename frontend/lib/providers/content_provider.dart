import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/menu_item.dart';
import '../models/post.dart';
import '../models/slide.dart';
import '../services/api_service.dart';

class ContentProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  List<Slide> _slides = [];
  List<Post> _featuredPosts = [];
  List<Post> _latestPosts = [];
  List<Category> _categories = [];
  Menu? _headerMenu;
  Menu? _footerMenu;
  Map<String, dynamic> _settings = {};

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Slide> get slides => _slides;
  List<Post> get featuredPosts => _featuredPosts;
  List<Post> get latestPosts => _latestPosts;
  List<Category> get categories => _categories;
  Menu? get headerMenu => _headerMenu;
  Menu? get footerMenu => _footerMenu;
  Map<String, dynamic> get settings => _settings;

  String get siteName => _settings['site_name'] as String? ?? 'Muslih';
  String get siteDescription => _settings['site_description'] as String? ?? '';
  String? get siteLogo => _settings['site_logo'] as String?;
  String? get sitePhone => _settings['contact_phone'] as String?;
  String? get siteEmail => _settings['contact_email'] as String?;
  String? get siteAddress => _settings['contact_address'] as String?;

  Future<void> loadHomeContent({required String locale, bool force = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        ApiService.getSlides(locale: locale),
        ApiService.getPosts(locale: locale, featured: true),
        ApiService.getPosts(locale: locale, page: 1),
        ApiService.getCategories(locale: locale),
        ApiService.getMenuByLocation('header', locale: locale),
        ApiService.getMenuByLocation('footer', locale: locale),
        ApiService.getSettings(locale: locale),
      ]);

      _slides = results[0] as List<Slide>;
      _featuredPosts = (results[1] as dynamic).data as List<Post>;
      _latestPosts = (results[2] as dynamic).data as List<Post>;
      _categories = results[3] as List<Category>;
      _headerMenu = results[4] as Menu?;
      _footerMenu = results[5] as Menu?;
      _settings = results[6] as Map<String, dynamic>;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

