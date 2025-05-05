import 'dart:convert';
import 'dart:io';

Future<String> detectWeighingPort() async {
  try {
    // First check specifically for ttyUSB0 since we know it exists
    final ttyUSB0 = '/dev/ttyUSB0';
    if (File(ttyUSB0).existsSync()) {
      print("Found FIDI USB Serial Device on $ttyUSB0");

      try {
        // Try to open the port with basic settings
        print("Setting permissions for $ttyUSB0");
        final chmodProcess =
            await Process.run('sudo', ['chmod', '777', ttyUSB0]);
        if (chmodProcess.exitCode != 0) {
          print("chmod failed: ${chmodProcess.stderr}");
          return '$ttyUSB0 (chmod failed: ${chmodProcess.stderr})';
        }
        print("Permissions set successfully");

        // Try different common baud rates for scales
        final baudRates = [9600, 4800, 2400, 19200];

        for (final baudRate in baudRates) {
          print("Trying $ttyUSB0 at $baudRate baud...");

          final process = await Process.start(
              'stty', ['-F', ttyUSB0, '$baudRate', 'raw'],
              runInShell: true);
          final exitCode = await process.exitCode;

          if (exitCode == 0) {
            print(
                "Port $ttyUSB0 opened successfully at $baudRate baud, checking for data...");

            // Try to read some data
            final readProcess = await Process.start(
                'timeout', ['3', 'cat', ttyUSB0],
                runInShell: true);
            final output =
                await readProcess.stdout.transform(utf8.decoder).join();

            // If we get any data, assume it's the scale
            if (output.isNotEmpty) {
              print(
                  "Received data from $ttyUSB0 at $baudRate baud: ${output.substring(0, output.length > 20 ? 20 : output.length)}...");
              return '$ttyUSB0 (FIDI USB Serial Device at $baudRate baud)';
            } else {
              print("No data received from $ttyUSB0 at $baudRate baud");
            }
          }
        }

        // If we couldn't get data with any baud rate, still return the port since we know it exists
        return '$ttyUSB0 (FIDI USB Serial Device, but no data received)';
      } catch (e) {
        print("Error testing $ttyUSB0: $e");
        return '$ttyUSB0 (Error: $e)';
      }
    }

    // Fallback: check all ttyUSB* devices
    final directory = Directory('/dev');
    final ports = directory
        .listSync()
        .where((entity) => entity.path.contains('ttyUSB'))
        .map((entity) => entity.path)
        .toList();

    print("Found ${ports.length} USB serial ports: $ports");

    if (ports.isEmpty) {
      return 'No USB serial ports found. Please check USB connection.';
    }

    // Check each port
    for (final port in ports) {
      try {
        print("Testing port: $port");

        // Set permissions for the port
        print("Setting permissions for $port");
        final chmodProcess = await Process.run('sudo', ['chmod', '777', port]);
        if (chmodProcess.exitCode != 0) {
          print("chmod failed: ${chmodProcess.stderr}");
          continue;
        }
        print("Permissions set successfully");

        // Try to open the port with basic settings
        final process = await Process.start('stty', ['-F', port, '9600', 'raw'],
            runInShell: true);
        final exitCode = await process.exitCode;

        if (exitCode == 0) {
          print("Port $port opened successfully, checking for data...");

          // Try to read some data
          final readProcess = await Process.start('timeout', ['3', 'cat', port],
              runInShell: true);
          final output =
              await readProcess.stdout.transform(utf8.decoder).join();

          // If we get any data, assume it's the scale
          if (output.isNotEmpty) {
            print(
                "Received data from $port: ${output.substring(0, output.length > 20 ? 20 : output.length)}...");
            return port;
          } else {
            print("No data received from $port");
          }
        } else {
          print("Failed to open $port");
        }
      } catch (e) {
        print("Error testing $port: $e");
        continue;
      }
    }

    // If we found ttyUSB0 but couldn't get data, still return it
    if (File('/dev/ttyUSB0').existsSync()) {
      return '/dev/ttyUSB0 (FIDI USB Serial Device detected, but no data received)';
    }

    return 'No weighing scale detected on USB ports.';
  } catch (e) {
    print("Port detection error: $e");
    return 'Port detection error: $e';
  }
}
