import 'dart:convert';
import 'dart:io';

import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:get/get.dart';

class Logger {
  static File? _logFile;
  static final homeController = Get.find<HomeController>();
  static final sharedPrefsHelper = Get.find<SharedPreferenceHelper>();

  /// Initialize the log file with a custom path
  static Future<void> init() async {
    // logs/ in home directory
    String logDirPath = '${Platform.environment['HOME']}/logs';

    // Ensure the logs directory exists
    final logDir = Directory(logDirPath);

    if (!await logDir.exists()) {
      await logDir.create(recursive: true);
    }

    // Define the log file path
    // Create log file if it doesn't exist
    _logFile = File('$logDirPath/ebono_pos_logs.txt');
    print('PATH=>${_logFile?.path}');
    if (!await _logFile!.exists()) {
      await _logFile!.create();
    }
  }

  /// Helper function to read the existing log data
  static Future<List<dynamic>> _readLogData() async {
    if (_logFile == null || !await _logFile!.exists()) {
      return [];
    }

    String fileContent = await _logFile!.readAsString();

    if (fileContent.isEmpty) {
      return [];
    }

    try {
      return jsonDecode(fileContent) as List<dynamic>;
    } catch (e) {
      print('Error parsing log file: $e');
      return [];
    }
  }

  /// Helper function to save the log data back to the file
  static Future<void> _saveLogData(List<dynamic> logData) async {
    try {
      String jsonContent = jsonEncode(logData);
      await _logFile!.writeAsString('$jsonContent\n', mode: FileMode.writeOnly);
    } catch (e) {
      Get.snackbar('Unable To Write Log', 'not able to log a file');
    }
  }

  static Future<void> logButtonPress({
    String? button,
  }) async {
    if (_logFile == null) await init(); // Ensure file is initialized

    final logEntry = <String, dynamic>{
      "time_stamp": DateTime.now().toIso8601String(),
      "app_id": '',
      "event_type": '',
      "cashier": "",
      "store_id": '',
      "store_name": "",
      "button": ""
    };

    logEntry['app_id'] = await sharedPrefsHelper.getAppUUID();
    logEntry['cashier'] = homeController.userDetails.value.fullName;
    logEntry['store_id'] = homeController.selectedTerminalId;
    logEntry['store_name'] = homeController.selectedOutletId;

    if (button != null) logEntry['button'] = button;

    List<dynamic> logData = await _readLogData();
    logData.add(logEntry); // Append new log entry
    await _saveLogData(logData); // Save back the updated data
  }

  static Future<void> logView({
    String? view,
  }) async {
    if (_logFile == null) await init(); // Ensure file is initialized

    final logEntry = <String, dynamic>{
      "time_stamp": DateTime.now().toIso8601String(),
      "app_id": '',
      "event_type": 'VIEW',
      "cashier": "",
      "store_id": '',
      "store_name": "",
      "view": ""
    };

    logEntry['app_id'] = await sharedPrefsHelper.getAppUUID();
    logEntry['cashier'] = homeController.userDetails.value.fullName;
    logEntry['store_id'] = homeController.selectedTerminalId;
    logEntry['store_name'] = homeController.selectedOutletId;

    if (view != null) logEntry['view'] = view;

    List<dynamic> logData = await _readLogData();
    logData.add(logEntry); // Append new log entry
    await _saveLogData(logData); // Save back the updated data
  }

  static Future<void> logApi({
    String? url,
    Map<String, dynamic>? request,
    Map<String, dynamic>? response,
    Map<String, dynamic>? error,
  }) async {
    if (_logFile == null) await init(); // Ensure file is initialized

    final logEntry = <String, dynamic>{
      "time_stamp": DateTime.now().toIso8601String(),
      "app_id": '',
      "event_type": 'API',
      "cashier": "",
      "store_id": '',
      "store_name": "",
      "url": "",
      "request": "{}",
      "response": "{}",
      "error": "{}",
    };

    logEntry['app_id'] = await sharedPrefsHelper.getAppUUID();
    logEntry['cashier'] = homeController.userDetails.value.fullName;
    logEntry['store_id'] = homeController.selectedTerminalId;
    logEntry['store_name'] = homeController.selectedOutletId;

    if (url != null) logEntry['url'] = url;
    if (request != null) logEntry['request'] = request;
    if (response != null) logEntry['response'] = response;
    if (error != null) logEntry['error'] = error;

    List<dynamic> logData = await _readLogData();
    logData.add(logEntry); // Append new log entry
    await _saveLogData(logData); // Save back the updated data
  }
}
