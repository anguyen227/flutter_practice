import 'dart:io';

import 'package:flutter/material.dart';

class PlatformSwitch<T extends Widget> extends StatelessWidget {
  final T? android;
  final T? ios;
  final T? linux;
  final T? macos;
  final T? window;
  final T? fuchsia;
  const PlatformSwitch(
      {Key? key,
      this.android,
      this.ios,
      this.linux,
      this.macos,
      this.window,
      this.fuchsia})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return android as T;
    } else if (Platform.isIOS) {
      return ios as T;
    } else if (Platform.isLinux) {
      return linux as T;
    } else if (Platform.isMacOS) {
      return macos as T;
    } else if (Platform.isWindows) {
      return window as T;
    } else if (Platform.isFuchsia) {
      return fuchsia as T;
    }
    return Container();
  }
}
