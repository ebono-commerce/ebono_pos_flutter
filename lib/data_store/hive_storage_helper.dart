import 'package:hive_flutter/hive_flutter.dart';

class HiveStorageHelper {
  // Private constructor to prevent external instantiation
  HiveStorageHelper._internal();

  // Static instance for the singleton
  static final HiveStorageHelper _instance = HiveStorageHelper._internal();

  // Factory constructor to return the singleton instance
  factory HiveStorageHelper() {
    return _instance;
  }

  // Box name (customize as needed)
  static const String _boxName = 'ebono_pos';

  // The Hive box instance
  late Box<dynamic> _box;

  // Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<dynamic>(_boxName);
  }

  // Access the Hive box
  Box<dynamic> get box => Hive.box<dynamic>(_boxName);

  // Save a value
  Future<void> save(String key, dynamic value) async {
    await box.put(key, value);
  }

  // Retrieve a value
  T? read<T>(String key) {
    return box.get(key) as T?;
  }

  // Check if a key exists
  bool has(String key) {
    return box.containsKey(key);
  }

  // Remove a specific key
  Future<void> remove(String key) async {
    await box.delete(key);
  }

  // Clear all data
  Future<void> clear() async {
    await box.clear();
  }
}
