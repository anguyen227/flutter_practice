import 'package:calculator/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animations/animations.dart';
import 'package:provider/provider.dart';

import './widgets/platform_switch.dart';

import 'screens/calculator.dart';
import 'screens/currency_exchange.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer(
        builder: (context, ThemeModel themeNotifier, child) {
          return MaterialApp(
            title: 'Converter',
            theme: ThemeData(
              brightness:
                  themeNotifier.isDark ? Brightness.dark : Brightness.light,
              primarySwatch: Colors.teal,
              textTheme: Theme.of(context).textTheme.copyWith(
                    bodyText2: const TextStyle(fontSize: 18),
                    button: const TextStyle(fontSize: 30, color: Colors.white),
                  ),
              appBarTheme: const AppBarTheme(
                  titleTextStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            restorationScopeId: 'app',
            debugShowCheckedModeBanner: false,
            home: const AppBody(),
          );
        },
      ),
    );
  }
}

class AppBody extends StatefulWidget {
  const AppBody({
    Key? key,
  }) : super(key: key);

  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> with RestorationMixin {
  final Widget _appBarTitle = const Text('Converter');

  final RestorableInt _currentIndex = RestorableInt(0);

  @override
  Widget build(BuildContext context) {
    var screens = const [
      Calculator(),
      CurrencyExchange(),
    ];
    var pageBody = SafeArea(
      child: PageTransitionSwitcher(
        transitionBuilder: (child, animation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: screens[_currentIndex.value],
      ),
    );

    var bottomNavigationBarItems = const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.calculate),
        label: 'Calculator',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.price_change_outlined),
        label: 'Currency',
      )
    ];
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return PlatformSwitch(
        android: Scaffold(
          appBar: AppBar(
            title: _appBarTitle,
            actions: [
              IconButton(
                onPressed: () {
                  themeNotifier.isDark = !themeNotifier.isDark;
                },
                icon: Icon(
                    themeNotifier.isDark ? Icons.light_mode : Icons.dark_mode),
              )
            ],
          ),
          body: pageBody,
          bottomNavigationBar: BottomNavigationBar(
              items: bottomNavigationBarItems,
              currentIndex: _currentIndex.value,
              backgroundColor: colorScheme.brightness == Brightness.dark
                  ? colorScheme.background
                  : colorScheme.primary,
              selectedItemColor: colorScheme.onPrimary,
              unselectedItemColor: colorScheme.onPrimary.withOpacity(0.38),
              showUnselectedLabels: false,
              onTap: (index) {
                setState(() {
                  _currentIndex.value = index;
                });
              }),
        ),
        ios: CupertinoPageScaffold(
          child: pageBody,
          navigationBar: CupertinoNavigationBar(
            middle: _appBarTitle,
          ),
        ),
      );
    });
  }

  @override
  String? get restorationId => 'app_body';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_currentIndex, 'bottom_tab_index');
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }
}
