import 'package:flutter/material.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel(
      {Key? key, required this.controls, required this.buttonBuilder})
      : super(key: key);
  final Widget Function(BuildContext context, Map<String, dynamic> button)
      buttonBuilder;
  final List<List<Map<String, dynamic>>> controls;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: controls.map((rows) {
        return Flexible(
          fit: FlexFit.tight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: rows.map((button) {
              return Flexible(
                flex: button['span'] is int ? button['span'] : 1,
                fit: FlexFit.tight,
                child: Center(child: buttonBuilder(context, button)),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
