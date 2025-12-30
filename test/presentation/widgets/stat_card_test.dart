import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaspi_analyzer/presentation/widgets/stat_card.dart';

void main() {
  group('StatCard Widget', () {
    testWidgets('displays icon, value, and label', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCard(
              icon: Icons.people,
              value: '10',
              label: 'человек',
              color: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.people), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('человек'), findsOneWidget);
    });

    testWidgets('uses correct color for icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCard(
              icon: Icons.attach_money,
              value: '1000 ₸',
              label: 'отправлено',
              color: Colors.green,
            ),
          ),
        ),
      );

      final iconFinder = find.byIcon(Icons.attach_money);
      final Icon iconWidget = tester.widget(iconFinder);

      expect(iconWidget.color, Colors.green);
    });
  });
}
