import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../models/menu_item.dart';
import '../providers/content_provider.dart';
import '../providers/locale_provider.dart';
import '../services/api_service.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  void _handleMenuClick(BuildContext context, MenuItem item) {
    final url = item.url;
    if (url == null || url.isEmpty) return;

    if (url.startsWith('http://') || url.startsWith('https://')) {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      context.go(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeProv = context.watch<LocaleProvider>();
    final contentProv = context.watch<ContentProvider>();
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    final logoUrl = ApiService.resolveImageUrl(contentProv.siteLogo);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                // Site Branding
                InkWell(
                  onTap: () => context.go('/'),
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    children: [
                      if (logoUrl != null)
                        Image.network(
                          logoUrl,
                          height: 40,
                          width: 40,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => _defaultLogoBadge(),
                        )
                      else
                        _defaultLogoBadge(),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            contentProv.siteName.isNotEmpty
                                ? contentProv.siteName
                                : (l10n?.appTitle ?? 'Muslih'),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F766E),
                              letterSpacing: 0.5,
                            ),
                          ),
                          if (contentProv.siteDescription.isNotEmpty)
                            Text(
                              contentProv.siteDescription,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Desktop Navigation Menu
                if (isDesktop) ...[
                  _navLink(
                    context,
                    label: l10n?.home ?? 'Beranda',
                    path: '/',
                  ),
                  _navLink(
                    context,
                    label: l10n?.articles ?? 'Artikel',
                    path: '/posts',
                  ),
                  _navLink(
                    context,
                    label: l10n?.categories ?? 'Kategori',
                    path: '/categories',
                  ),
                  _navLink(
                    context,
                    label: l10n?.questions ?? 'Tanya Jawab',
                    path: '/questions',
                  ),
                  _navLink(
                    context,
                    label: l10n?.faq ?? 'FAQ',
                    path: '/faq',
                  ),

                  // Dynamic items from CMS menu if present
                  if (contentProv.headerMenu != null)
                    ...contentProv.headerMenu!.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: TextButton(
                          onPressed: () => _handleMenuClick(context, item),
                          child: Text(
                            item.label,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 16),
                ],

                // Language Switcher
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _langButton(
                        context,
                        code: 'id',
                        label: '🇮🇩 ID',
                        isSelected: localeProv.languageCode == 'id',
                      ),
                      _langButton(
                        context,
                        code: 'en',
                        label: '🇬🇧 EN',
                        isSelected: localeProv.languageCode == 'en',
                      ),
                    ],
                  ),
                ),

                // Mobile drawer button
                if (!isDesktop) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.menu, color: Color(0xFF0F766E)),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _defaultLogoBadge() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Icon(Icons.mosque, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _navLink(BuildContext context, {required String label, required String path}) {
    final location = GoRouterState.of(context).uri.toString();
    final isActive = path == '/' ? location == '/' : location.startsWith(path);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: isActive ? const Color(0xFF0F766E) : Colors.grey.shade800,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: isActive ? const Color(0xFF0D9488).withValues(alpha: 0.1) : Colors.transparent,
        ),
        onPressed: () => context.go(path),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _langButton(
    BuildContext context, {
    required String code,
    required String label,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        if (!isSelected) {
          final prov = context.read<LocaleProvider>();
          prov.setLocale(Locale(code));
          context.read<ContentProvider>().loadHomeContent(locale: code, force: true);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D9488) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}

