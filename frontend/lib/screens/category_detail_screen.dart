import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/category.dart';
import '../models/post.dart';
import '../providers/locale_provider.dart';
import '../services/api_service.dart';
import '../widgets/post_card.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String slug;

  const CategoryDetailScreen({super.key, required this.slug});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  Category? _category;
  List<Post> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchCategoryAndPosts());
  }

  Future<void> _fetchCategoryAndPosts() async {
    setState(() => _isLoading = true);
    final locale = context.read<LocaleProvider>().languageCode;

    try {
      final results = await Future.wait([
        ApiService.getCategoryBySlug(widget.slug, locale: locale),
        ApiService.getPosts(locale: locale, categorySlug: widget.slug),
      ]);

      if (mounted) {
        setState(() {
          _category = results[0] as Category?;
          _posts = (results[1] as dynamic).data as List<Post>;
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

    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(80),
          child: CircularProgressIndicator(color: Color(0xFF0F766E)),
        ),
      );
    }

    final catName = _category?.name ?? widget.slug;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go('/categories'),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => context.go('/categories'),
                  child: Text(
                    l10n?.categories ?? 'Kategori',
                    style: const TextStyle(
                      color: Color(0xFF0F766E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                ),
                Text(
                  catName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Header banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xFF0D9488).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF0D9488).withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    catName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F766E),
                    ),
                  ),
                  if (_category?.description != null && _category!.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      _category!.description!,
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.4),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 36),

            // Posts grid
            if (_posts.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(60),
                  child: Text(
                    l10n?.noPostsFound ?? 'Belum ada artikel dalam kategori ini.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 3;
                  if (constraints.maxWidth < 650) {
                    crossAxisCount = 1;
                  } else if (constraints.maxWidth < 950) {
                    crossAxisCount = 2;
                  }

                  final itemWidth =
                      (constraints.maxWidth - ((crossAxisCount - 1) * 20)) / crossAxisCount;

                  return Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: _posts.map((post) {
                      return SizedBox(
                        width: itemWidth,
                        child: PostCard(post: post),
                      );
                    }).toList(),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

