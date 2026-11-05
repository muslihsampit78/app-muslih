import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/content_provider.dart';
import '../providers/locale_provider.dart';
import '../widgets/category_card.dart';
import '../widgets/hero_banner.dart';
import '../widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locale = context.read<LocaleProvider>().languageCode;
      context.read<ContentProvider>().loadHomeContent(locale: locale);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.go('/posts?search=${Uri.encodeComponent(query)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final contentProv = context.watch<ContentProvider>();

    if (contentProv.isLoading && contentProv.latestPosts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(80),
          child: CircularProgressIndicator(color: Color(0xFF0F766E)),
        ),
      );
    }

    return Column(
      children: [
        // Hero Slider
        HeroBanner(slides: contentProv.slides),

        // Search Bar Bar
        _buildSearchBar(l10n),

        // Main Content Container
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Featured Posts Section
                if (contentProv.featuredPosts.isNotEmpty) ...[
                  _buildSectionHeader(
                    title: l10n?.featuredPosts ?? 'Artikel Pilihan',
                    icon: Icons.star_outline,
                    onViewAll: () => context.go('/posts'),
                    viewAllText: l10n?.viewAll ?? 'Lihat Semua',
                  ),
                  const SizedBox(height: 20),
                  _buildPostsGrid(contentProv.featuredPosts.take(3).toList()),
                  const SizedBox(height: 50),
                ],

                // Categories Section
                if (contentProv.categories.isNotEmpty) ...[
                  _buildSectionHeader(
                    title: l10n?.categories ?? 'Kategori Artikel',
                    icon: Icons.category_outlined,
                    onViewAll: () => context.go('/categories'),
                    viewAllText: l10n?.viewAll ?? 'Lihat Semua',
                  ),
                  const SizedBox(height: 20),
                  _buildCategoriesGrid(contentProv.categories.take(6).toList()),
                  const SizedBox(height: 50),
                ],

                // Latest Posts Section
                _buildSectionHeader(
                  title: l10n?.latestPosts ?? 'Berita & Artikel Terbaru',
                  icon: Icons.newspaper_outlined,
                  onViewAll: () => context.go('/posts'),
                  viewAllText: l10n?.viewAll ?? 'Lihat Semua',
                ),
                const SizedBox(height: 20),
                if (contentProv.latestPosts.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Text(
                        l10n?.noPostsFound ?? 'Belum ada artikel.',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  )
                else
                  _buildPostsGrid(contentProv.latestPosts.take(6).toList()),

                const SizedBox(height: 60),

                // Ask Question & FAQ Banner
                _buildCtaBanner(context, l10n),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(AppLocalizations? l10n) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 18),
                child: Icon(Icons.search, color: Color(0xFF0F766E)),
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (_) => _onSearch(),
                  decoration: InputDecoration(
                    hintText: l10n?.searchPlaceholder ?? 'Cari artikel, topik, atau informasi...',
                    hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: _onSearch,
                  child: Text(l10n?.search ?? 'Cari'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    VoidCallback? onViewAll,
    required String viewAllText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF0F766E), size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        if (onViewAll != null)
          TextButton.icon(
            onPressed: onViewAll,
            icon: const Icon(Icons.arrow_forward, size: 16, color: Color(0xFF0F766E)),
            label: Text(
              viewAllText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F766E),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPostsGrid(List<dynamic> posts) {
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

  Widget _buildCategoriesGrid(List<dynamic> categories) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;
        if (constraints.maxWidth < 600) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 900) {
          crossAxisCount = 2;
        }

        final itemWidth = (constraints.maxWidth - ((crossAxisCount - 1) * 16)) / crossAxisCount;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: categories.map((cat) {
            return SizedBox(
              width: itemWidth,
              child: CategoryCard(category: cat),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCtaBanner(BuildContext context, AppLocalizations? l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF134E4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 700;

          return Flex(
            direction: isSmall ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: isSmall ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: isSmall ? 0 : 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n?.questions ?? 'Layanan Tanya Jawab Masyarakat',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Punya pertanyaan seputar layanan kami atau ingin berkonsultasi? Ajukan pertanyaan atau baca FAQ kami.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSmall) const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0F766E),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => context.go('/questions'),
                    icon: const Icon(Icons.send_outlined, size: 18),
                    label: Text(
                      l10n?.askQuestion ?? 'Tanya Sekarang',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => context.go('/faq'),
                    icon: const Icon(Icons.help_outline, size: 18),
                    label: Text(
                      l10n?.faq ?? 'Baca FAQ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

