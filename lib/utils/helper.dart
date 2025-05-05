import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

Future<String> detectWeighingPort() async {
  try {
    // Check ttyS, ttyUSB, and ttyACM ports
    final directory = Directory('/dev');
    final ports = directory
        .listSync()
        .where((entity) {
          final path = entity.path;
          return path.contains('ttyS') ||
              path.contains('ttyUSB') ||
              path.contains('ttyACM');
        })
        .map((entity) => entity.path)
        .toList();

    Get.snackbar(
        "PORT CHK", "Found ${ports.length} potential serial ports: $ports");

    if (ports.isEmpty) {
      return 'No serial ports found. Please check USB connection.';
    }

    // Check each port
    for (final port in ports) {
      try {
        Get.snackbar("PORT CHK", "Testing port: $port");

        // Try to open the port with basic settings (common for scales: 9600 baud)
        final process = await Process.start('stty', ['-F', port, '9600', 'raw'],
            runInShell: true);
        final exitCode = await process.exitCode;

        if (exitCode == 0) {
          Get.snackbar("PORT CHK",
              "Port $port opened successfully, checking for data...");

          // Try to read some data
          final readProcess = await Process.start('timeout', ['3', 'cat', port],
              runInShell: true);
          final output =
              await readProcess.stdout.transform(utf8.decoder).join();

          // If we get any data, assume it's the scale
          if (output.isNotEmpty) {
            Get.snackbar("PORT CHK",
                "Received data from $port: ${output.substring(0, output.length > 20 ? 20 : output.length)}...");

            // Set permissions for the port
            try {
              Get.snackbar("PORT CHK", "Setting permissions for $port");
              final chmodProcess =
                  await Process.run('sudo', ['chmod', '777', port]);
              if (chmodProcess.exitCode != 0) {
                Get.snackbar(
                    "PORT CHK", "chmod failed: ${chmodProcess.stderr}");
                return '$port (chmod failed: ${chmodProcess.stderr})';
              }
              Get.snackbar("PORT CHK", "Permissions set successfully");
            } catch (e) {
              Get.snackbar("PORT CHK", "chmod error: $e");
              return '$port (chmod error: $e)';
            }

            return port;
          } else {
            Get.snackbar("PORT CHK", "No data received from $port");
          }
        } else {
          Get.snackbar("PORT CHK", "Failed to open $port");
        }
      } catch (e) {
        Get.snackbar("PORT CHK", "Error testing $port: $e");
        // Skip to next port if there's an error
        continue;
      }
    }

    return 'No weighing scale detected. Checked ${ports.length} ports.';
  } catch (e) {
    Get.snackbar("PORT CHK", "Port detection error: $e");
    return 'Port detection error: $e';
  }
}
