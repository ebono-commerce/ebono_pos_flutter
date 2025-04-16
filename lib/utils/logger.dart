import 'dart:convert';
import 'dart:io';

import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:get/get.dart';

class Logger {
  static File? _logFile;
  static final homeController = Get.find<HomeController>();
  static final sharedPrefsHelper = Get.find<SharedPreferenceHelper>();
  static bool isLoggerEnabled = true;

  /// Initialize the log file with a custom path
  static Future<void> init() async {
    if (!isLoggerEnabled) return;

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

  /// Helper function to save the log data back to the file
  static Future<void> _saveLogEntry(Map<String, dynamic> logEntry) async {
    try {
      String jsonContent = jsonEncode(logEntry);
      await _logFile!.writeAsString('$jsonContent\n,', mode: FileMode.append);
    } catch (e) {
      Get.snackbar('Unable To Write Log', 'Not able to log to a file');
    }
  }

  static Future<void> logButtonPress({
    String? button,
  }) async {
    if (!isLoggerEnabled) return;

    if (_logFile == null) await init(); // Ensure file is initialized

    final logEntry = <String, dynamic>{
      "time_stamp": DateTime.now().toIso8601String(),
      "app_id": '',
      "order_number": '',
      "customer_number": '',
      "cart_id": '',
      "event_type": '',
      "cashier": "",
      "store_id": '',
      "store_name": "",
      "button": ""
    };

    logEntry['event_type'] = "BUTTON";
    logEntry['app_id'] = await sharedPrefsHelper.getAppUUID();
    logEntry['cashier'] = homeController.userDetails.value.fullName;
    logEntry['store_id'] = homeController.selectedTerminalId;
    logEntry['store_name'] = homeController.selectedOutletId;
    logEntry['order_number'] = homeController.orderNumber.value;
    logEntry['cart_id'] = homeController.cartId.value;
    logEntry['customer_number'] =
        homeController.customerResponse.value.phoneNumber?.number.toString();

    if (button != null) logEntry['button'] = button;

    await _saveLogEntry(logEntry); // Directly append the log entry to the file
  }

  static Future<void> logView({
    String? view,
  }) async {
    if (!isLoggerEnabled) return;

    if (_logFile == null) await init(); // Ensure file is initialized

    final logEntry = <String, dynamic>{
      "time_stamp": DateTime.now().toIso8601String(),
      "app_id": '',
      "order_number": '',
      "customer_number": '',
      "cart_id": '',
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
    logEntry['order_number'] = homeController.orderNumber.value;
    logEntry['cart_id'] = homeController.cartId.value;
    logEntry['customer_number'] =
        homeController.customerResponse.value.phoneNumber?.number.toString();

    if (view != null) logEntry['view'] = view;

    await _saveLogEntry(logEntry); // Directly append the log entry to the file
  }

  static Future<void> logApi({
    String? url,
    Map<String, dynamic>? request,
    Map<String, dynamic>? response,
    Map<String, dynamic>? error,
  }) async {
    if (!isLoggerEnabled) return;

    if (_logFile == null) await init(); // Ensure file is initialized

    final logEntry = <String, dynamic>{
      "time_stamp": DateTime.now().toIso8601String(),
      "app_id": '',
      "order_number": '',
      "customer_number": '',
      "cart_id": '',
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
    logEntry['order_number'] = homeController.orderNumber.value;
    logEntry['cart_id'] = homeController.cartId.value;
    logEntry['customer_number'] =
        homeController.customerResponse.value.phoneNumber?.number.toString();

    if (url != null) logEntry['url'] = url;
    if (request != null) logEntry['request'] = request;
    if (response != null) logEntry['response'] = response;
    if (error != null) logEntry['error'] = error;

    await _saveLogEntry(logEntry); // Directly append the log entry to the file
  }
}
