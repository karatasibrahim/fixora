import 'package:flutter_test/flutter_test.dart';
import 'package:fixora/app.dart';

void main() {
  testWidgets('App launches without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const FixoraApp());
    expect(find.text('Fixora'), findsOneWidget);
  });
}
