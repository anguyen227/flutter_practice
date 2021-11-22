import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculator/widgets/buttons/basic_button.dart';

void main() {
  group('Basic button', () {
    testWidgets('creat button with onPress is null does not crash',
        (tester) async {
      // SET UP
      await tester.pumpWidget(MaterialApp(
        home: BasicButton.of(
            label: const Text('basic control'),
            type: 'value',
            value: 'control',
            onPressed: null),
      ));
      final labelFinder = find.text('basic control');

      final button = find.byType(TextButton);

      // ACT
      await tester.tap(button);

      // ASSERT
      expect(labelFinder, findsOneWidget);
    });

    test('creat value button', () async {
      // SET UP
      const button = ValueButton(
        label: Text('2'),
        value: '2',
        onPressed: null,
      );

      // ASSERT
      expect(button.type, 'value');
    });

    test('creat function button', () async {
      // SET UP
      const button = FunctionButton(
        label: Text('clear'),
        method: 'clear',
        onPressed: null,
      );

      // ASSERT
      expect(button.type, 'function');
    });

    test('creat operator button', () async {
      // SET UP
      const button = OperatorButton(
        label: Text('+'),
        operator: 'plus',
        onPressed: null,
      );

      // ASSERT
      expect(button.type, 'operator');
    });
  });
}
