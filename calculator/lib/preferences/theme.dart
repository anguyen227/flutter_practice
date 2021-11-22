import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const darkThemeKey = "dark_theme_pref";

  Future<SharedPreferences> getInstance() async {
    return await SharedPreferences.getInstance();
  }

  setDarkTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(darkThemeKey, value);
  }

  getDarkTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(darkThemeKey) ?? false;
  }
}
