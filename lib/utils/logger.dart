import 'dart:convert';
import 'dart:io';

import 'package:ebono_pos/data_store/hive_storage_helper.dart';
import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../constants/shared_preference_constants.dart';

Future<void> _writeLogEntry(Map<String, dynamic> params) async {
  final String filePath = params['filePath'] as String;
  final Map<String, dynamic> logEntry =
      params['logEntry'] as Map<String, dynamic>;

  final file = File(filePath);
  final jsonContent = jsonEncode(logEntry);

  await file.writeAsString('$jsonContent\n,', mode: FileMode.append);
}

class Logger {
  static File? _logFile;
  static HiveStorageHelper hiveStorageHelper = Get.find<HiveStorageHelper>();
  static SharedPreferenceHelper sharedPrefsHelper =
      Get.find<SharedPreferenceHelper>();
  static bool isLoggerEnabled = true;

  /// Initialize the log file with a custom path
  static Future<void> init() async {
    if (!isLoggerEnabled) return;

    String logDirPath = '${Platform.environment['HOME']}/logs';

    final logDir = Directory(logDirPath);

    if (!await logDir.exists()) {
      await logDir.create(recursive: true);
    }

    _logFile = File('$logDirPath/ebono_pos_logs.txt');
    print('PATH=>${_logFile?.path}');
    if (!await _logFile!.exists()) {
      await _logFile!.create();
    }
  }

  /// Common method to fetch shared contextual data for logs
  static Future<Map<String, dynamic>> _getCommonLogData() async {
    final appId = await sharedPrefsHelper.getAppUUID();

    final userData =
        hiveStorageHelper.read(SharedPreferenceConstants.userDetails);

    String cashier = '';
    if (userData != null && userData is Map) {
      final userDetailsData = userData.map(
        (key, value) => MapEntry(key.toString(), value),
      );

      cashier = userDetailsData['full_name'] ?? '';
    }

    final storeId =
        hiveStorageHelper.read(SharedPreferenceConstants.selectedTerminalId) ??
            '';
    final storeName =
        hiveStorageHelper.read(SharedPreferenceConstants.selectedOutletId) ??
            '';
    final cartId =
        hiveStorageHelper.read(SharedPreferenceConstants.cartId) ?? '';

    return {
      "app_id": appId,
      "cashier": cashier,
      "store_id": storeId,
      "store_name": storeName,
      // "order_number": orderNumber,
      "cart_id": cartId,
      // "customer_number": customerNumber,
    };
  }

  static Future<void> _saveLogEntry(Map<String, dynamic> logEntry) async {
    if (_logFile == null) {
      await init();
    }

    if (_logFile == null) return;

    try {
      await compute(_writeLogEntry, {
        'filePath': _logFile!.path,
        'logEntry': logEntry,
      });
    } catch (e) {
      Get.snackbar('Unable To Write Log', 'Not able to log to a file');
    }
  }

  static Future<void> logButtonPress({
    String? button,
  }) async {
    if (!isLoggerEnabled) return;
    if (_logFile == null) await init();

    final commonData = await _getCommonLogData();

    final logEntry = {
      "time_stamp": DateTime.now().toIso8601String(),
      "event_type": "BUTTON",
      ...commonData,
      if (button != null) "button": button,
    };

    await _saveLogEntry(logEntry);
  }

  static Future<void> logView({
    String? view,
  }) async {
    if (!isLoggerEnabled) return;
    if (_logFile == null) await init();

    final commonData = await _getCommonLogData();

    final logEntry = {
      "time_stamp": DateTime.now().toIso8601String(),
      "event_type": "VIEW",
      ...commonData,
      if (view != null) "view": view,
    };

    await _saveLogEntry(logEntry);
  }

  static Future<void> logApi({
    String? url,
    Map<String, dynamic>? request,
    Map<String, dynamic>? response,
    Map<String, dynamic>? error,
  }) async {
    if (!isLoggerEnabled) return;
    if (_logFile == null) await init();

    final commonData = await _getCommonLogData();

    final logEntry = {
      "time_stamp": DateTime.now().toIso8601String(),
      "event_type": "API",
      ...commonData,
      "url": url ?? '',
      "request": request ?? {},
      "response": response ?? {},
      "error": error ?? {},
    };

    await _saveLogEntry(logEntry);
  }

  // Simplified methods without common data (if you want)
  static Future<void> logButtonSimple({
    required String button,
    String? description,
  }) async {
    if (!isLoggerEnabled) return;
    if (_logFile == null) await init();

    final logEntry = {
      "time_stamp": DateTime.now().toIso8601String(),
      "event_type": "BUTTON",
      "button": button,
      if (description != null) "description": description,
    };

    await _saveLogEntry(logEntry);
  }

  static Future<void> logViewSimple({
    required String view,
  }) async {
    if (!isLoggerEnabled) return;
    if (_logFile == null) await init();

    final logEntry = {
      "time_stamp": DateTime.now().toIso8601String(),
      "event_type": "VIEW",
      "view": view,
    };

    await _saveLogEntry(logEntry);
  }

  static Future<void> logApiSimple({
    required String url,
    Map<String, dynamic>? request,
    Map<String, dynamic>? response,
    Map<String, dynamic>? error,
  }) async {
    if (!isLoggerEnabled) return;
    if (_logFile == null) await init();

    final logEntry = {
      "time_stamp": DateTime.now().toIso8601String(),
      "event_type": "API",
      "url": url,
      "request": request ?? {},
      "response": response ?? {},
      "error": error ?? {},
    };

    await _saveLogEntry(logEntry);
  }

  static Future<void> logException({
    String eventType = 'EXCEPTION',
    required String error,
    required String stackTrace,
  }) async {
    if (!isLoggerEnabled) return;
    if (_logFile == null) await init();

    final logEntry = {
      "time_stamp": DateTime.now().toIso8601String(),
      "event_type": eventType,
      "error": error,
      "stack_trace": stackTrace,
    };

    await _saveLogEntry(logEntry);
  }
}
