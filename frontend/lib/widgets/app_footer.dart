import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/content_provider.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final contentProv = context.watch<ContentProvider>();
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Container(
      color: const Color(0xFF134E4A), // Deep teal
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            children: [
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildSiteInfo(contentProv, l10n)),
                    const SizedBox(width: 48),
                    Expanded(flex: 2, child: _buildQuickLinks(context, l10n)),
                    const SizedBox(width: 48),
                    Expanded(flex: 3, child: _buildContactInfo(contentProv, l10n)),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSiteInfo(contentProv, l10n),
                    const SizedBox(height: 32),
                    _buildQuickLinks(context, l10n),
                    const SizedBox(height: 32),
                    _buildContactInfo(contentProv, l10n),
                  ],
                ),
              const SizedBox(height: 48),
              Divider(color: Colors.white.withValues(alpha: 0.15)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '© ${DateTime.now().year} ${contentProv.siteName}. ${l10n?.copyright ?? "Semua Hak Dilindungi."}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSiteInfo(ContentProvider prov, AppLocalizations? l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.mosque, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              prov.siteName.isNotEmpty ? prov.siteName : 'Muslih',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          prov.siteDescription.isNotEmpty
              ? prov.siteDescription
              : (l10n?.footerDescription ??
                  'Portal informasi resmi dan layanan tanya jawab masyarakat.'),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            height: 1.6,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLinks(BuildContext context, AppLocalizations? l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n?.quickLinks ?? 'Tautan Cepat',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _footerLink(context, l10n?.home ?? 'Beranda', '/'),
        _footerLink(context, l10n?.articles ?? 'Artikel', '/posts'),
        _footerLink(context, l10n?.categories ?? 'Kategori', '/categories'),
        _footerLink(context, l10n?.questions ?? 'Tanya Jawab', '/questions'),
        _footerLink(context, l10n?.faq ?? 'FAQ', '/faq'),
      ],
    );
  }

  Widget _footerLink(BuildContext context, String text, String path) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => context.go(path),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(ContentProvider prov, AppLocalizations? l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n?.contactUs ?? 'Hubungi Kami',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (prov.siteAddress != null && prov.siteAddress!.isNotEmpty)
          _contactItem(Icons.location_on_outlined, prov.siteAddress!),
        if (prov.sitePhone != null && prov.sitePhone!.isNotEmpty)
          _contactItem(Icons.phone_outlined, prov.sitePhone!),
        if (prov.siteEmail != null && prov.siteEmail!.isNotEmpty)
          _contactItem(Icons.email_outlined, prov.siteEmail!),
      ],
    );
  }

  Widget _contactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF5EEAD4)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

