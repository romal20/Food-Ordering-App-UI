import 'package:flutter_test/flutter_test.dart';
import 'package:food_ordering_app/core/theme/theme_controller.dart';
import 'package:food_ordering_app/main.dart';
import 'package:get/get.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('App smoke test', (WidgetTester tester) async {
    Get.put(ThemeController(), permanent: true);
    await tester.pumpWidget(const FoodieGoApp());
    await tester.pump();
    expect(find.byType(FoodieGoApp), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
