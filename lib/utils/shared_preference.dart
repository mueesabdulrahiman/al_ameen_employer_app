import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServices {
  static Future<void> setLoggedIn(String setName, String setPassword) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setStringList('isLoggedIn', [setName, setPassword]);
    //prefs.setString('', );
  }

  static Future<List<String>?> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    
    return prefs.getStringList('isLoggedIn');
  }

  static Future<void> setLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
