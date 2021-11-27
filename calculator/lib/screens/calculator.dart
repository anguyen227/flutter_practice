import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

import '../widgets/controls/control_panel.dart';
import '../widgets/platform_switch.dart';
import '../widgets/buttons/basic_button.dart';

const List<List<Map<String, dynamic>>> buttons = [
  [
    {'label': Text('AC'), 'type': 'function', 'value': 'clear'},
    {'label': Text('+/-'), 'type': 'function', 'value': 'negative'},
    {'label': Text('%'), 'type': 'function', 'value': 'percent'},
    // {'label': Icon(Icons.backspace), 'type': 'function', 'value': 'backspace'},
    {'label': Text('/'), 'type': 'operator', 'value': '/'},
  ],
  [
    {'label': Text('7'), 'type': 'value', 'value': '7'},
    {'label': Text('8'), 'type': 'value', 'value': '8'},
    {'label': Text('9'), 'type': 'value', 'value': '9'},
    {'label': Text('x'), 'type': 'operator', 'value': 'x'},
  ],
  [
    {'label': Text('4'), 'type': 'value', 'value': '4'},
    {'label': Text('5'), 'type': 'value', 'value': '5'},
    {'label': Text('6'), 'type': 'value', 'value': '6'},
    {'label': Text('-'), 'type': 'operator', 'value': '-'},
  ],
  [
    {'label': Text('1'), 'type': 'value', 'value': '1'},
    {'label': Text('2'), 'type': 'value', 'value': '2'},
    {'label': Text('3'), 'type': 'value', 'value': '3'},
    {'label': Text('+'), 'type': 'operator', 'value': '+'},
  ],
  [
    {'label': Text('0'), 'type': 'value', 'value': '0'},
    {'label': Text('.'), 'type': 'value', 'value': '.'},
    {'label': Text('='), 'type': 'function', 'value': 'calculate', 'span': 2},
  ],
];

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> with RestorationMixin {
  final RestorableString _equation = RestorableString('');
  final RestorableString _result = RestorableString('');
  final RestorableBool _afterOperator = RestorableBool(false);
  final RestorableBool _calculated = RestorableBool(false);

  int get resultDigitLength {
    assert(_result.value is String);
    int resultDigitLength = _result.value.replaceAll(RegExp(r"\D"), '').length;
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
    if (_result.value.isNotEmpty) {
      int dot = _result.value.indexOf('.');
      dot = dot > -1 ? dot : _result.value.length;
      String integer = NumberFormat("###,###,###")
          .format(double.tryParse(_result.value.substring(0, dot)));
      String decimal = _result.value.substring(dot);
      return integer + decimal;
    }
    return '0';
  }

  void handlePress(dynamic value, String type) {
    assert(value is String);
    assert(type is String);
    assert(_result.value is String);

    double resultDouble = double.tryParse(_result.value) ?? 0;

    if (type == 'operator') {
      if (_calculated.value) {
        setState(() {
          _equation.value = '${_result.value} $value';
          _afterOperator.value = true;
          _calculated.value = false;
        });
      } else if (resultDouble.abs() > 0 && !_afterOperator.value) {
        setState(() {
          _equation.value += _equation.value.isEmpty
              ? '${_result.value} $value'
              : ' ${_result.value} $value';
          _afterOperator.value = true;
        });
      }
    } else {
      if (type == 'value') {
        if (resultDigitLength < 9 ||
            _afterOperator.value ||
            _calculated.value) {
          setState(() {
            if (_calculated.value ||
                _afterOperator.value ||
                _result.value.isEmpty ||
                _result.value == '0') {
              _result.value = value == '.' ? '0.' : value;
            } else {
              if (value == '.') {
                if (!_result.value.contains('.')) {
                  _result.value = '${_result.value}$value';
                }
              } else {
                _result.value = '${_result.value}$value';
              }
            }
            if (_calculated.value) {
              _equation.value = '';
            }
            _calculated.value = false;
          });
        }
      } else if (type == 'function') {
        switch (value) {
          case 'backspace':
            setState(() {
              if (resultDigitLength > 1) {
                _result.value =
                    _result.value.substring(0, _result.value.length - 1);
                if (_result.value.endsWith('.')) {
                  _result.value =
                      _result.value.substring(0, _result.value.length - 1);
                }
              } else {
                _result.value = '';
              }
            });
            break;
          case 'clear':
            setState(() {
              _result.value = '';
              _equation.value = '';
              _afterOperator.value = false;
              _calculated.value = false;
            });
            break;
          case 'percent':
            if (_afterOperator.value) return;
            if (resultDouble.abs() > 0 && resultDigitLength < 8) {
              setState(() {
                _result.value = sanitizeNumber(resultDouble / 100);
              });
            }
            break;
          case 'negative':
            if (_afterOperator.value) return;
            if (resultDouble.abs() > 0) {
              setState(() {
                if (_result.value.startsWith('-')) {
                  _result.value = _result.value.replaceAll('-', '');
                } else {
                  _result.value = '-${_result.value}';
                }
              });
            }
            break;
          case 'calculate':
            String finalInput = _equation.value +
                (_result.value.isEmpty
                    ? ' ${_result.value}'
                    : ' ${sanitizeNumber(_result.value)}');
            finalInput = finalInput.replaceAll('x', '*');

            Parser p = Parser();
            Expression exp = p.parse(finalInput);
            ContextModel cm = ContextModel();
            double eval = exp.evaluate(EvaluationType.REAL, cm);

            setState(() {
              _equation.value = finalInput;
              _result.value = sanitizeNumber(eval.toString());
              _calculated.value = true;
            });

            break;
          default:
        }
      }
      _afterOperator.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformSwitch(
      android: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(_equation.value)),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              alignment: Alignment.centerRight,
              child: Text(
                displayResult,
                textAlign: TextAlign.right,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: ControlPanel(
              controls: buttons,
              buttonBuilder: (context, button) {
                return BasicButton.of(
                  label: button['label'],
                  type: button['type'],
                  value: button['value'],
                  onPressed: handlePress,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  String? get restorationId => 'screen_calculator';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_equation, 'calculator_equation');
    registerForRestoration(_result, 'calculator_input');
    registerForRestoration(_afterOperator, 'calculator_operator_flag');
    registerForRestoration(_calculated, 'calculator_calculated_flag');
  }

  @override
  void dispose() {
    _equation.dispose();
    _result.dispose();
    _afterOperator.dispose();
    _calculated.dispose();
    super.dispose();
  }
}
