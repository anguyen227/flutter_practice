import 'package:flutter/material.dart';

class Button {
  final Widget label;
  final String type;
  final String value;
  final Function(String value, String type)? onPressed;

  Button(this.label, this.type, this.value, this.onPressed);
}
