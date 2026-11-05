import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/category_detail_screen.dart';
import 'screens/category_list_screen.dart';
import 'screens/faq_screen.dart';
import 'screens/home_screen.dart';
import 'screens/not_found_screen.dart';
import 'screens/page_detail_screen.dart';
import 'screens/post_detail_screen.dart';
import 'screens/post_list_screen.dart';
import 'screens/question_detail_screen.dart';
import 'screens/question_screen.dart';
import 'widgets/app_scaffold.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  errorBuilder: (context, state) => const AppScaffold(child: NotFoundScreen()),
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/posts',
          name: 'posts',
          builder: (context, state) {
            final search = state.uri.queryParameters['search'];
            final category = state.uri.queryParameters['category'];
            return PostListScreen(
              initialSearch: search,
              initialCategory: category,
            );
          },
          routes: [
            GoRoute(
              path: ':slug',
              name: 'post_detail',
              builder: (context, state) {
                final slug = state.pathParameters['slug'] ?? '';
                return PostDetailScreen(slug: slug);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/categories',
          name: 'categories',
          builder: (context, state) => const CategoryListScreen(),
          routes: [
            GoRoute(
              path: ':slug',
              name: 'category_detail',
              builder: (context, state) {
                final slug = state.pathParameters['slug'] ?? '';
                return CategoryDetailScreen(slug: slug);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/pages/:slug',
          name: 'page_detail',
          builder: (context, state) {
            final slug = state.pathParameters['slug'] ?? '';
            return PageDetailScreen(slug: slug);
          },
        ),
        GoRoute(
          path: '/questions',
          name: 'questions',
          builder: (context, state) => const QuestionScreen(),
          routes: [
            GoRoute(
              path: ':id',
              name: 'question_detail',
              builder: (context, state) {
                final idStr = state.pathParameters['id'] ?? '0';
                final id = int.tryParse(idStr) ?? 0;
                return QuestionDetailScreen(id: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/faq',
          name: 'faq',
          builder: (context, state) => const FaqScreen(),
        ),
      ],
    ),
  ],
);

