import 'package:flutter/material.dart';

import 'app_drawer.dart';
import 'app_footer.dart';
import 'app_header.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      endDrawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            child,
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}

