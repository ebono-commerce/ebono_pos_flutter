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

  // Store the appUUID
  Future<void> storeAppUUID(String appUUID) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreferenceConstants.appUUID, appUUID);
  }

  // Retrieve the appUUID
  Future<String?> getAppUUID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceConstants.appUUID);
  }

  // Clear the appUUID
  Future<void> clearAppUUID() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPreferenceConstants.appUUID);
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
    await prefs.setString(SharedPreferenceConstants.selectedOutletId, selectedOutlet);
  }

  // Retrieve the selectedOutlet
  Future<String?> getSelectedOutlet() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceConstants.selectedOutletId);
  }

  // Clear the selectedOutlet
  Future<void> clearSelectedOutlet() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPreferenceConstants.selectedOutletId);
  }

  // Store the isLoggedIn
  Future<void> storeLoginStatus(bool selectedOutlet) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPreferenceConstants.isLoggedIn, selectedOutlet);
  }

  // Retrieve the isLoggedIn
  Future<bool?> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPreferenceConstants.isLoggedIn);
  }

  // Clear the isLoggedIn
  Future<void> clearLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPreferenceConstants.isLoggedIn);
  }

  // Store the userID
  Future<void> storeUserID(String appUUID) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreferenceConstants.userID, appUUID);
  }

  // Retrieve the userID
  Future<String?> getUserID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceConstants.userID);
  }

  // Clear the userID
  Future<void> clearUserID() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPreferenceConstants.userID);
  }

  // Store the PortName
  Future<void> storePortName(String portName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreferenceConstants.portName, portName);
  }

  // Retrieve the PortName
  Future<String?> getPortName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceConstants.portName);
  }

  // Clear the PortName
  Future<void> clearPortName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPreferenceConstants.portName);
  }

}
