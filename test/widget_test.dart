import 'package:flutter_test/flutter_test.dart';

import 'package:sebha_app/main.dart';

void main() {
  testWidgets('Tasbih app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const SebhaApp());
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('السبحة الرقمية'), findsOneWidget);
    expect(find.text('سبح'), findsOneWidget);
  });
}