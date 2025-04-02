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
    String logDirPath =
        '${Platform.environment['HOME']}/logs'; // logs/ in home directory

    // Ensure the logs directory exists
    final logDir = Directory(logDirPath);
    if (!await logDir.exists()) {
      await logDir.create(recursive: true);
    }

    // Define the log file path
    _logFile = File('$logDirPath/ebono_pos_logs.txt');
    print('PATH=>${_logFile?.path}');
    if (!await _logFile!.exists()) {
      await _logFile!.create();
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
    if (button != null) logEntry['click'] = button;
    await saveLogs(logEntry);
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
      "screen": ""
    };

    logEntry['app_id'] = await sharedPrefsHelper.getAppUUID();
    logEntry['cashier'] = homeController.userDetails.value.fullName;
    logEntry['store_id'] = homeController.selectedTerminalId;
    logEntry['store_name'] = homeController.selectedOutletId;

    if (view != null) logEntry['screen'] = view;

    await saveLogs(logEntry);
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

    await saveLogs(logEntry);
  }

  static Future<void> saveLogs(Map<String, dynamic> logEntry) async {
    try {
      await _logFile!
          .writeAsString('${jsonEncode(logEntry)},', mode: FileMode.append);
    } catch (e) {
      print('err: $e');
    }
  }
}
