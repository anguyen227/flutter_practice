import 'package:flutter/material.dart';

import '../buttons/basic_button.dart';

const List<List<Map<String, dynamic>>> rows = [
  [
    {'label': Text('AC'), 'type': 'function', 'value': 'clear'},
    {'label': Text('+/-'), 'type': 'function', 'value': 'negative'},
    {'label': Text('%'), 'type': 'function', 'value': 'percent'},
    {'label': Icon(Icons.backspace), 'type': 'function', 'value': 'backspace'},
  ],
  [
    {'label': Text('7'), 'type': 'value', 'value': '7'},
    {'label': Text('8'), 'type': 'value', 'value': '8'},
    {'label': Text('9'), 'type': 'value', 'value': '9'},
    {'label': Text('/'), 'type': 'operator', 'value': '/'},
  ],
  [
    {'label': Text('4'), 'type': 'value', 'value': '4'},
    {'label': Text('5'), 'type': 'value', 'value': '5'},
    {'label': Text('6'), 'type': 'value', 'value': '6'},
    {'label': Text('x'), 'type': 'operator', 'value': 'x'},
  ],
  [
    {'label': Text('1'), 'type': 'value', 'value': '1'},
    {'label': Text('2'), 'type': 'value', 'value': '2'},
    {'label': Text('3'), 'type': 'value', 'value': '3'},
    {'label': Text('-'), 'type': 'operator', 'value': '-'},
  ],
  [
    {'label': Text('0'), 'type': 'value', 'value': '0'},
    {'label': Text('.'), 'type': 'value', 'value': '.'},
    {'label': Text('='), 'type': 'function', 'value': 'calculate'},
    {'label': Text('+'), 'type': 'operator', 'value': '+'},
  ],
];

class ControlCalculator extends StatelessWidget {
  final Function(dynamic value, String type)? onPressed;

  const ControlCalculator({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
        children: rows.map((buttons) {
      return TableRow(
          children: buttons.map((button) {
        return BasicButton.of(
          label: button['label'],
          type: button['type'],
          value: button['value'],
          onPressed: onPressed,
        );
      }).toList());
    }).toList());
  }
}
