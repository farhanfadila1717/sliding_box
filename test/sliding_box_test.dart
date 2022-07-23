import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sliding_box/sliding_box.dart';

void main() {
  Widget buildBox(String title, Color color) {
    return ColoredBox(
      key: Key(title),
      color: color,
    );
  }

  testWidgets('Sliding box test', (tester) async {
    Widget widget = MaterialApp(
      home: SlidingBox(
        height: 100,
        width: 100,
        children: [
          buildBox("First", Colors.blue),
          buildBox("Seconds", Colors.purple),
          buildBox("Third", Colors.green),
        ],
      ),
    );

    await tester.runAsync(() async {
      await tester.pumpWidget(widget);

      // Expect only first box widget show
      expect(find.byKey(const Key('First')), findsOneWidget);
      expect(find.byKey(const Key('Seconds')), findsNothing);
      expect(find.byKey(const Key('Third')), findsNothing);

      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Expect only seconds box widget show
      expect(find.byKey(const Key('First')), findsNothing);
      expect(find.byKey(const Key('Seconds')), findsOneWidget);
      expect(find.byKey(const Key('Third')), findsNothing);

      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Expect only third box widget show
      expect(find.byKey(const Key('First')), findsNothing);
      expect(find.byKey(const Key('Seconds')), findsNothing);
      expect(find.byKey(const Key('Third')), findsOneWidget);

      // Reversed animation 3-2-1
      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Expect only seconds box widget show
      expect(find.byKey(const Key('First')), findsNothing);
      expect(find.byKey(const Key('Seconds')), findsOneWidget);
      expect(find.byKey(const Key('Third')), findsNothing);

      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Expect only first box widget show
      expect(find.byKey(const Key('First')), findsOneWidget);
      expect(find.byKey(const Key('Seconds')), findsNothing);
      expect(find.byKey(const Key('Third')), findsNothing);

      await tester.pumpAndSettle();
    });
  });
}
