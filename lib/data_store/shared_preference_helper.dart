import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {

  static SharedPreferenceHelper? _instance;

  // Private constructor for singleton pattern
  SharedPreferenceHelper._internal();

  // Public factory constructor to return the same instance
  factory SharedPreferenceHelper() {
    _instance ??= SharedPreferenceHelper._internal();
    return _instance!;
  }

  // Store the token
  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  // Retrieve the token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  // Clear the token
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }
}
