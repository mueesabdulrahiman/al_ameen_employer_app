import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServices {
  Future<void> setLoggedIn(String setName, String setPassword) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setStringList('isLoggedIn', [setName, setPassword]);
  }

  Future<List<String>?>? checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList('isLoggedIn');
  }

  Future<void> setLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
