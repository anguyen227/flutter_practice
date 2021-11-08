import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

import '../widgets/controls/control_calculator.dart';
import '../widgets/platform_switch.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String equation = '';
  String result = '';
  bool _afterOperator = false;
  bool _calculated = false;

  int get resultDigitLength {
    assert(result is String);
    int resultDigitLength = result.replaceAll(RegExp(r"\D"), '').length;
    assert(resultDigitLength is int);
    return resultDigitLength;
  }

  String sanitizeNumber(dynamic number) {
    dynamic result = number;
    if (number is String) {
      if (number == '.') {
        result = 0;
      } else if (number.endsWith('.')) {
        result = number.replaceAll('.', '');
      }
      result = double.tryParse(result) ?? 0;
    }

    return NumberFormat('#########.########').format(result);
  }

  String get displayResult {
    if (result.isNotEmpty) {
      int dot = result.indexOf('.');
      dot = dot > -1 ? dot : result.length;
      String integer = NumberFormat("###,###,###")
          .format(double.tryParse(result.substring(0, dot)));
      String decimal = result.substring(dot);
      return integer + decimal;
    }
    return '0';
  }

  void handlePress(dynamic value, String type) {
    assert(value is String);
    assert(type is String);
    assert(result is String);

    double resultDouble = double.tryParse(result) ?? 0;

    if (type == 'operator') {
      if (_calculated) {
        setState(() {
          equation = '$result $value';
          _afterOperator = true;
          _calculated = false;
        });
      } else if (resultDouble.abs() > 0 && !_afterOperator) {
        setState(() {
          equation += equation.isEmpty ? '$result $value' : ' $result $value';
          _afterOperator = true;
        });
      }
    } else {
      if (type == 'value') {
        if (resultDigitLength < 9 || _afterOperator || _calculated) {
          setState(() {
            if (_calculated ||
                _afterOperator ||
                result.isEmpty ||
                result == '0') {
              result = value == '.' ? '0.' : value;
            } else {
              if (value == '.') {
                if (!result.contains('.')) {
                  result = '$result$value';
                }
              } else {
                result = '$result$value';
              }
            }
            if (_calculated) {
              equation = '';
            }
            _calculated = false;
          });
        }
      } else if (type == 'function') {
        switch (value) {
          case 'backspace':
            setState(() {
              if (resultDigitLength > 1) {
                result = result.substring(0, result.length - 1);
                if (result.endsWith('.')) {
                  result = result.substring(0, result.length - 1);
                }
              } else {
                result = '';
              }
            });
            break;
          case 'clear':
            setState(() {
              result = '';
              equation = '';
              _afterOperator = false;
              _calculated = false;
            });
            break;
          case 'percent':
            if (_afterOperator) return;
            if (resultDouble.abs() > 0 && resultDigitLength < 8) {
              setState(() {
                result = sanitizeNumber(resultDouble / 100);
              });
            }
            break;
          case 'negative':
            if (_afterOperator) return;
            if (resultDouble.abs() > 0) {
              setState(() {
                if (result.startsWith('-')) {
                  result = result.replaceAll('-', '');
                } else {
                  result = '-$result';
                }
              });
            }
            break;
          case 'calculate':
            String finalInput = equation +
                (result.isEmpty ? ' $result' : ' ${sanitizeNumber(result)}');
            finalInput = finalInput.replaceAll('x', '*');

            Parser p = Parser();
            Expression exp = p.parse(finalInput);
            ContextModel cm = ContextModel();
            double eval = exp.evaluate(EvaluationType.REAL, cm);

            setState(() {
              equation = finalInput;
              result = sanitizeNumber(eval.toString());
              _calculated = true;
            });

            break;
          default:
        }
      }
      _afterOperator = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return PlatformSwitch(
        android: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(equation))),
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          height: max((mediaQuery.size.width / 8).round().toDouble(), 56),
          width: double.infinity,
          child: Text(
            displayResult,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        ControlCalculator(
          onPressed: handlePress,
        )
      ],
    ));
  }
}
