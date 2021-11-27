import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:calculator/widgets/buttons/basic_button.dart';
import 'package:calculator/widgets/controls/control_panel.dart';

const List<List<Map<String, dynamic>>> buttons = [
  [
    {'label': Text('1'), 'type': 'value', 'value': '1'},
    {'label': Text('2'), 'type': 'value', 'value': '2'},
    {'label': Text('3'), 'type': 'value', 'value': '3'},
  ],
  [
    {'label': Text('4'), 'type': 'value', 'value': '4'},
    {'label': Text('5'), 'type': 'value', 'value': '5'},
    {'label': Text('6'), 'type': 'value', 'value': '6'},
  ],
  [
    {'label': Text('7'), 'type': 'value', 'value': '7'},
    {'label': Text('8'), 'type': 'value', 'value': '8'},
    {'label': Text('9'), 'type': 'value', 'value': '9'},
  ],
  [
    {'label': Text('.'), 'type': 'value', 'value': '.'},
    {'label': Text('0'), 'type': 'value', 'value': '0'},
    {'label': Icon(Icons.backspace), 'type': 'function', 'value': 'backspace'},
  ],
];

class CurrencyExchange extends StatefulWidget {
  const CurrencyExchange({Key? key}) : super(key: key);

  @override
  _CurrencyExchangeState createState() => _CurrencyExchangeState();
}

class _CurrencyExchangeState extends State<CurrencyExchange> {
  void handlePress(dynamic value, String type) {}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Expanded(
          flex: 6,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text('_equation.value')),
        ),
        Expanded(
          flex: 4,
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
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    loadCurrencies();
    super.initState();
  }

  Future<dynamic> loadCurrencies() async {
    dynamic curs = await rootBundle.loadString('data/currencies.json');
    print({curs is String});
    return 'aaa';
  }
}
