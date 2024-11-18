import 'package:get_storage/get_storage.dart';

class GetStorageHelper {
  static final GetStorage _storage = GetStorage();

  // Save a value
  static Future<void> save(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  // Retrieve a value
  static T? read<T>(String key) {
    return _storage.read<T>(key);
  }

  // Check if a key exists
  static bool has(String key) {
    return _storage.hasData(key);
  }

  // Remove a specific key
  static Future<void> remove(String key) async {
    await _storage.remove(key);
  }

  // Clear all data
  static Future<void> clear() async {
    await _storage.erase();
  }
}
