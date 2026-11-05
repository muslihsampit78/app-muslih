import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/content_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final contentProv = context.watch<ContentProvider>();

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              color: const Color(0xFF0F766E),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.mosque, size: 40, color: Colors.white),
                  const SizedBox(height: 12),
                  Text(
                    contentProv.siteName.isNotEmpty ? contentProv.siteName : 'Muslih',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (contentProv.siteDescription.isNotEmpty)
                    Text(
                      contentProv.siteDescription,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _drawerItem(
                    context,
                    icon: Icons.home_outlined,
                    title: l10n?.home ?? 'Beranda',
                    path: '/',
                  ),
                  _drawerItem(
                    context,
                    icon: Icons.article_outlined,
                    title: l10n?.articles ?? 'Artikel',
                    path: '/posts',
                  ),
                  _drawerItem(
                    context,
                    icon: Icons.grid_view_outlined,
                    title: l10n?.categories ?? 'Kategori',
                    path: '/categories',
                  ),
                  _drawerItem(
                    context,
                    icon: Icons.help_outline,
                    title: l10n?.questions ?? 'Tanya Jawab',
                    path: '/questions',
                  ),
                  _drawerItem(
                    context,
                    icon: Icons.quiz_outlined,
                    title: l10n?.faq ?? 'FAQ',
                    path: '/faq',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String path,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0F766E)),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      onTap: () {
        Navigator.of(context).pop();
        context.go(path);
      },
    );
  }
}

