import 'package:flutter_test/flutter_test.dart';
import 'package:food_ordering_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodieGoApp());
    expect(find.byType(FoodieGoApp), findsOneWidget);
  });
}
