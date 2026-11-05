import 'package:flutter/material.dart';

class RichContentView extends StatelessWidget {
  final String html;
  final TextStyle? baseStyle;

  const RichContentView({
    super.key,
    required this.html,
    this.baseStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (html.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final defaultStyle = baseStyle ??
        theme.textTheme.bodyLarge?.copyWith(
          height: 1.7,
          color: Colors.black87,
        ) ??
        const TextStyle(fontSize: 16, height: 1.7, color: Colors.black87);

    // Parse simple HTML blocks: <p>, <h1>..<h6>, <li>, <blockquote>, <img>, etc.
    final blocks = _parseBlocks(html);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks.map((block) {
        return Padding(
          padding: EdgeInsets.only(bottom: block.bottomPadding),
          child: _renderBlock(context, block, defaultStyle),
        );
      }).toList(),
    );
  }

  Widget _renderBlock(BuildContext context, _HtmlBlock block, TextStyle defaultStyle) {
    final theme = Theme.of(context);

    switch (block.type) {
      case _BlockType.h1:
        return Text(
          block.text,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        );
      case _BlockType.h2:
        return Text(
          block.text,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        );
      case _BlockType.h3:
        return Text(
          block.text,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        );
      case _BlockType.quote:
        return Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: theme.primaryColor,
                width: 4,
              ),
            ),
            color: theme.primaryColor.withValues(alpha: 0.05),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            block.text,
            style: defaultStyle.copyWith(
              fontStyle: FontStyle.italic,
              color: Colors.black87,
            ),
          ),
        );
      case _BlockType.listItem:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, right: 10),
              child: Icon(Icons.circle, size: 8, color: Colors.teal),
            ),
            Expanded(
              child: Text(
                block.text,
                style: defaultStyle,
              ),
            ),
          ],
        );
      case _BlockType.paragraph:
        return Text(
          block.text,
          style: defaultStyle,
        );
    }
  }

  List<_HtmlBlock> _parseBlocks(String raw) {
    final List<_HtmlBlock> list = [];

    // Normalize breaks
    var clean = raw.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');

    // Split on paragraph or block-level tags
    final tagRegex = RegExp(
      r'<(p|h1|h2|h3|h4|blockquote|li)[^>]*>(.*?)</\1>',
      caseSensitive: false,
      dotAll: true,
    );

    final matches = tagRegex.allMatches(clean);

    if (matches.isEmpty) {
      // Just strip tags and output paragraphs
      final plain = _stripHtml(clean);
      final parts = plain.split('\n\n');
      for (var p in parts) {
        final t = p.trim();
        if (t.isNotEmpty) {
          list.add(_HtmlBlock(_BlockType.paragraph, t, 16));
        }
      }
      return list;
    }

    for (final match in matches) {
      final tag = match.group(1)!.toLowerCase();
      final inner = _stripHtml(match.group(2)!).trim();

      if (inner.isEmpty) continue;

      switch (tag) {
        case 'h1':
          list.add(_HtmlBlock(_BlockType.h1, inner, 18));
          break;
        case 'h2':
          list.add(_HtmlBlock(_BlockType.h2, inner, 16));
          break;
        case 'h3':
        case 'h4':
          list.add(_HtmlBlock(_BlockType.h3, inner, 14));
          break;
        case 'blockquote':
          list.add(_HtmlBlock(_BlockType.quote, inner, 16));
          break;
        case 'li':
          list.add(_HtmlBlock(_BlockType.listItem, inner, 8));
          break;
        case 'p':
        default:
          list.add(_HtmlBlock(_BlockType.paragraph, inner, 16));
          break;
      }
    }

    return list;
  }

  static String _stripHtml(String htmlString) {
    return htmlString
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();
  }
}

enum _BlockType { paragraph, h1, h2, h3, quote, listItem }

class _HtmlBlock {
  final _BlockType type;
  final String text;
  final double bottomPadding;

  _HtmlBlock(this.type, this.text, this.bottomPadding);
}

