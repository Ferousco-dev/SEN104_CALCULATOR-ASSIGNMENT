import 'package:flutter_test/flutter_test.dart';
import 'package:mycalculator/app.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MyCalcApp());
    expect(find.byType(MyCalcApp), findsOneWidget);
  });
}
