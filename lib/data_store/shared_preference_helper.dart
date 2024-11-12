import 'package:kpn_pos_application/constants/shared_preference_constants.dart';
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

  // Clear all
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Store the token
  Future<void> storeAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreferenceConstants.authToken, token);
  }

  // Retrieve the token
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceConstants.authToken);
  }

  // Clear the token
  Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPreferenceConstants.authToken);
  }

  // Store the selectedOutlet
  Future<void> storeSelectedOutlet(String selectedOutlet) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreferenceConstants.selectedOutlet, selectedOutlet);
  }

  // Retrieve the selectedOutlet
  Future<String?> getSelectedOutlet() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceConstants.selectedOutlet);
  }

  // Clear the selectedOutlet
  Future<void> clearSelectedOutlet() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPreferenceConstants.selectedOutlet);
  }

}
