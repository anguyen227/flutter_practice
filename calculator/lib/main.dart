import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/platform_switch.dart';

import 'screens/calculator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Widget _appBarTitle = const Text('Converter');
  IconData _themeMode = Icons.dark_mode;
  Brightness _brightness = Brightness.light;
  ThemeData _themeData = ThemeData.light();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const pageBody = SafeArea(child: Calculator());
    return MaterialApp(
        theme: ThemeData(
          brightness: _brightness,
          primarySwatch: Colors.teal,
          textTheme: _themeData.textTheme.copyWith(
            bodyText2: const TextStyle(fontSize: 18),
            button: const TextStyle(fontSize: 30, color: Colors.white),
          ),
          appBarTheme: const AppBarTheme(
              titleTextStyle:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        home: PlatformSwitch(
          android: Scaffold(
            appBar: AppBar(
              title: _appBarTitle,
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (_brightness == Brightness.light) {
                          _brightness = Brightness.dark;
                          _themeMode = Icons.light_mode;
                          _themeData = ThemeData.dark();
                        } else {
                          _brightness = Brightness.light;
                          _themeMode = Icons.dark_mode;
                          _themeData = ThemeData.light();
                        }
                      });
                    },
                    icon: Icon(_themeMode))
              ],
            ),
            body: pageBody,
            // bottomNavigationBar: BottomNavigationBar(
            //   items: const [
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.calculate),
            //       label: 'Basic',
            //     ),
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.paid),
            //       label: 'Currency',
            //     )
            //   ],
            //   showUnselectedLabels: false,
            // ),
          ),
          ios: CupertinoPageScaffold(
            child: pageBody,
            navigationBar: CupertinoNavigationBar(
              middle: _appBarTitle,
            ),
          ),
        ));
  }
}
