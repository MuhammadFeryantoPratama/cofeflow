import 'package:flutter_test/flutter_test.dart';
import 'package:coffeeflow/main.dart';

void main() {
  testWidgets('CoffeeFlow app loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CoffeeFlowApp());

    // Allow mock async timers (Future.delayed 300ms) to settle
    await tester.pumpAndSettle();

    // Verify that the app title or header is present.
    expect(find.text('CoffeeFlow'), findsWidgets);
  });
}
