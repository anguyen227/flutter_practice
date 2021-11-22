import 'package:flutter/material.dart';

class BasicButton extends StatelessWidget {
  final Widget label;
  final String type;
  final String value;
  final Function(String value, String type)? onPressed;
  final int? span;

  void handlePress() {
    if (onPressed != null) {
      onPressed!(value, type);
    }
  }

  const BasicButton(
      {Key? key,
      this.span,
      required this.label,
      required this.type,
      required this.value,
      required this.onPressed})
      : super(key: key);

  factory BasicButton.of(
      {Key? key,
      int? span,
      required Widget label,
      required String type,
      required String value,
      required Function(String value, String type)? onPressed}) {
    if (type == 'value') {
      return ValueButton(label: label, value: value, onPressed: onPressed);
    } else if (type == 'operator') {
      return OperatorButton(
          label: label, operator: value, onPressed: onPressed);
    } else if (type == 'function') {
      return FunctionButton(label: label, method: value, onPressed: onPressed);
    } else {
      throw Error();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: handlePress,
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Center(
            child: label,
          ),
        ));
  }
}

class ValueButton extends BasicButton {
  const ValueButton(
      {Key? key,
      required Widget label,
      required String value,
      required Function(String value, String type)? onPressed})
      : super(
            key: key,
            type: 'value',
            label: label,
            value: value,
            onPressed: onPressed);
}

class OperatorButton extends BasicButton {
  const OperatorButton(
      {Key? key,
      required Widget label,
      required String operator,
      required Function(String operator, String type)? onPressed})
      : super(
            key: key,
            type: 'operator',
            label: label,
            value: operator,
            onPressed: onPressed);
}

class FunctionButton extends BasicButton {
  const FunctionButton(
      {Key? key,
      required Widget label,
      required String method,
      required Function(String method, String type)? onPressed})
      : super(
            key: key,
            type: 'function',
            label: label,
            value: method,
            onPressed: onPressed);
}
