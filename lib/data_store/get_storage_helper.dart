import 'package:get_storage/get_storage.dart';

class GetStorageHelper {
  // Private constructor to prevent external instantiation
  GetStorageHelper._internal();

  // Static instance for the singleton
  static final GetStorageHelper _instance = GetStorageHelper._internal();

  // Factory constructor to return the singleton instance
  factory GetStorageHelper() {
    return _instance;
  }

  // The GetStorage instance
  final GetStorage _storage = GetStorage();

  // Save a value
  Future<void> save(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  // Retrieve a value
  T? read<T>(String key) {
    return _storage.read<T>(key);
  }

  // Check if a key exists
  bool has(String key) {
    return _storage.hasData(key);
  }

  // Remove a specific key
  Future<void> remove(String key) async {
    await _storage.remove(key);
  }

  // Clear all data
  Future<void> clear() async {
    await _storage.erase();
  }
}
