import 'package:flutter_test/flutter_test.dart';

import 'package:calculator/preferences/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('dark theme preference should be false as default', () async {
    ThemePreferences _preferences = ThemePreferences();
    SharedPreferences prefs = await _preferences.getInstance();
    await prefs.clear();
    bool isDark = await _preferences.getDarkTheme();

    expect(isDark, false);
  });

  test('set dark theme', () async {
    ThemePreferences _preferences = ThemePreferences();

    _preferences.setDarkTheme(true);

    bool isDark = await _preferences.getDarkTheme();

    expect(isDark, true);
  });
}
