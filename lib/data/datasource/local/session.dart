import 'package:shared_preferences/shared_preferences.dart';

class LocalSession {
   static Future<void> saveSessionuser({required String userFlutter}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userClient', userFlutter);
  }

  static Future<void> saveSessiondevice({required String hwidqr}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('hwid', hwidqr);
  }

  static Future<String?> loadSessionuser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userClient'); 
  }

  static Future<String?> loadSessiondevice() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('hwid'); 
  }

  static Future<void> clearSessionuser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userClient');
  }

}