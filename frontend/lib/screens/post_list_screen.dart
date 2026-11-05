import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/api_response.dart';
import '../models/category.dart';
import '../models/post.dart';
import '../providers/locale_provider.dart';
import '../services/api_service.dart';
import '../widgets/post_card.dart';

class PostListScreen extends StatefulWidget {
  final String? initialSearch;
  final String? initialCategory;

  const PostListScreen({
    super.key,
    this.initialSearch,
    this.initialCategory,
  });

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late TextEditingController _searchController;
  String? _selectedCategory;
  int _currentPage = 1;
  bool _isLoading = false;
  List<Post> _posts = [];
  PaginationMeta? _meta;
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialSearch ?? '');
    _selectedCategory = widget.initialCategory;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategories();
      _fetchPosts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    final locale = context.read<LocaleProvider>().languageCode;
    try {
      final cats = await ApiService.getCategories(locale: locale);
      if (mounted) setState(() => _categories = cats);
    } catch (_) {}
  }

  Future<void> _fetchPosts({int page = 1}) async {
    setState(() => _isLoading = true);
    final locale = context.read<LocaleProvider>().languageCode;

    try {
      final res = await ApiService.getPosts(
        locale: locale,
        page: page,
        search: _searchController.text.trim(),
        categorySlug: _selectedCategory,
      );
      if (mounted) {
        setState(() {
          _posts = res.data;
          _meta = res.meta;
          _currentPage = page;
        });
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.article_outlined, color: Color(0xFF0F766E), size: 26),
                ),
                const SizedBox(width: 14),
                Text(
                  l10n?.articles ?? 'Artikel & Berita',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Filter Bar
            _buildFilters(l10n),
            const SizedBox(height: 32),

            // Content
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(60),
                  child: CircularProgressIndicator(color: Color(0xFF0F766E)),
                ),
              )
            else if (_posts.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(60),
                  child: Column(
                    children: [
                      Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        l10n?.noPostsFound ?? 'Tidak ada artikel ditemukan.',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              _buildPostsGrid(_posts),
              const SizedBox(height: 40),
              if (_meta != null && _meta!.lastPage > 1) _buildPagination(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(AppLocalizations? l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;

        return Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          children: [
            Expanded(
              flex: isMobile ? 0 : 2,
              child: TextField(
                controller: _searchController,
                onSubmitted: (_) => _fetchPosts(page: 1),
                decoration: InputDecoration(
                  hintText: l10n?.searchPlaceholder ?? 'Cari artikel...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF0F766E)),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ),
            if (isMobile) const SizedBox(height: 12) else const SizedBox(width: 16),
            Expanded(
              flex: isMobile ? 0 : 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String?>(
                    value: _selectedCategory,
                    isExpanded: true,
                    hint: Text(l10n?.allCategories ?? 'Semua Kategori'),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(l10n?.allCategories ?? 'Semua Kategori'),
                      ),
                      ..._categories.map(
                        (c) => DropdownMenuItem<String?>(
                          value: c.slug,
                          child: Text(c.name),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() => _selectedCategory = val);
                      _fetchPosts(page: 1);
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPostsGrid(List<Post> posts) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;
        if (constraints.maxWidth < 650) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 950) {
          crossAxisCount = 2;
        }

        final itemWidth = (constraints.maxWidth - ((crossAxisCount - 1) * 20)) / crossAxisCount;

        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: posts.map((post) {
            return SizedBox(
              width: itemWidth,
              child: PostCard(post: post),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _currentPage > 1 ? () => _fetchPosts(page: _currentPage - 1) : null,
        ),
        const SizedBox(width: 8),
        Text(
          'Halaman $_currentPage dari ${_meta?.lastPage ?? 1}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _currentPage < (_meta?.lastPage ?? 1)
              ? () => _fetchPosts(page: _currentPage + 1)
              : null,
        ),
      ],
    );
  }
}

