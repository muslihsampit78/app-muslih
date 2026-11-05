import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/post.dart';
import '../providers/locale_provider.dart';
import '../services/api_service.dart';
import '../widgets/rich_content_view.dart';

class PostDetailScreen extends StatefulWidget {
  final String slug;

  const PostDetailScreen({super.key, required this.slug});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Post? _post;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchPost());
  }

  Future<void> _fetchPost() async {
    setState(() => _isLoading = true);
    final locale = context.read<LocaleProvider>().languageCode;

    try {
      final p = await ApiService.getPostBySlug(widget.slug, locale: locale);
      if (mounted) setState(() => _post = p);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(80),
          child: CircularProgressIndicator(color: Color(0xFF0F766E)),
        ),
      );
    }

    if (_post == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(60),
          child: Column(
            children: [
              const Icon(Icons.error_outline, size: 56, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                l10n?.pageNotFound ?? 'Artikel Tidak Ditemukan',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                l10n?.pageNotFoundDesc ?? 'Artikel yang Anda tuju mungkin telah dihapus.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                ),
                onPressed: () => context.go('/posts'),
                icon: const Icon(Icons.arrow_back),
                label: Text(l10n?.backToHome ?? 'Kembali'),
              ),
            ],
          ),
        ),
      );
    }

    final post = _post!;
    final imageUrl = ApiService.resolveImageUrl(post.imageUrl);
    String dateStr = '';
    if (post.publishedAt != null) {
      dateStr = DateFormat('EEEE, d MMMM yyyy', locale).format(post.publishedAt!);
    }

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 860),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumbs / Back button
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.canPop() ? context.pop() : context.go('/posts'),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => context.go('/posts'),
                  child: Text(
                    l10n?.articles ?? 'Artikel',
                    style: const TextStyle(
                      color: Color(0xFF0F766E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (post.category != null) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                  ),
                  InkWell(
                    onTap: () => context.go('/categories/${post.category!.slug}'),
                    child: Text(
                      post.category!.name,
                      style: const TextStyle(
                        color: Color(0xFF0F766E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),

            // Category tag
            if (post.category != null)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  post.category!.name,
                  style: const TextStyle(
                    color: Color(0xFF0F766E),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),

            // Title
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                height: 1.3,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),

            // Meta Info: Author, Date, Views
            Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (post.author?.name != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: const Color(0xFF0F766E),
                        backgroundImage: post.author?.avatarUrl != null
                            ? NetworkImage(ApiService.resolveImageUrl(post.author!.avatarUrl)!)
                            : null,
                        child: post.author?.avatarUrl == null
                            ? const Icon(Icons.person, size: 14, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        post.author!.name!,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ],
                  ),
                if (dateStr.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(dateStr, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  ),
                if (post.viewCount > 0)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.visibility_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        '${post.viewCount} ${l10n?.views ?? "dilihat"}',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 24),

            // Main Image
            if (imageUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 32),
            ],

            // Summary
            if (post.summary != null && post.summary!.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.shade100),
                ),
                child: Text(
                  post.summary!,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.teal.shade900,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 28),
            ],

            // HTML Body Content
            if (post.content != null && post.content!.isNotEmpty)
              RichContentView(html: post.content!),

            const SizedBox(height: 48),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 20),

            // Back button at bottom
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0F766E),
                  side: const BorderSide(color: Color(0xFF0F766E)),
                ),
                onPressed: () => context.canPop() ? context.pop() : context.go('/posts'),
                icon: const Icon(Icons.arrow_back),
                label: Text(l10n?.backToHome ?? 'Kembali'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

