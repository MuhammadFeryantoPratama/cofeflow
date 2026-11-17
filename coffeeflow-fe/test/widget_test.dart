import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:coffeeflow/main.dart';

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('CoffeeFlow app loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CoffeeFlowApp());

    await tester.pumpAndSettle();

    // Verify that the app title or header is present.
    expect(find.text('CoffeeFlow'), findsWidgets);
  });
}
