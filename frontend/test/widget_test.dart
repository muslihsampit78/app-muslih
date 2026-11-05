import 'package:flutter_test/flutter_test.dart';
import 'package:muslih_frontend/main.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    await tester.pumpWidget(const MuslihApp());
    expect(find.byType(MuslihApp), findsOneWidget);
  });
}
