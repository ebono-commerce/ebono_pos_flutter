import 'dart:io';
import 'dart:convert';

import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:get/get.dart';

import '../api/environment_config.dart';

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
    _logFile = File(
        '$logDirPath/ebono_pos_logs.txt'); // Create log file if it doesn't exist
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
    await _logFile!.writeAsString('$logEntry\n', mode: FileMode.append);
  }

  static Future<void> logView({
    String? view,
  }) async {
    if (_logFile == null) await init(); // Ensure file is initialized

    final logEntry = <String, dynamic>{
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
    await _logFile!.writeAsString('$logEntry\n', mode: FileMode.append);
  }

  static Future<void> logApi({
    String? url,
    Map<String, dynamic>? request,
    Map<String, dynamic>? response,
  }) async {
    if (_logFile == null) await init(); // Ensure file is initialized

    final logEntry = <String, dynamic>{
      "app_id": '',
      "event_type": 'API',
      "cashier": "",
      "store_id": '',
      "store_name": "",
      "url": "",
      "request": "{}",
      "response": "{}"
    };

    logEntry['app_id'] = await sharedPrefsHelper.getAppUUID();
    logEntry['cashier'] = homeController.userDetails.value.fullName;
    logEntry['store_id'] = homeController.selectedTerminalId;
    logEntry['store_name'] = homeController.selectedOutletId;

    if (url != null) logEntry['url'] = url;
    if (request != null) logEntry['request'] = request;
    if (response != null) logEntry['response'] = response;

    await _logFile!.writeAsString('$logEntry\n', mode: FileMode.append);
  }
}
