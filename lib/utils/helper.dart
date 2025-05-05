import 'dart:convert';
import 'dart:io';

Future<String> detectWeighingPort() async {
  try {
    // Get only ttyS ports
    final directory = Directory('/dev');
    final ports = directory
        .listSync()
        .where((entity) =>
            /* ttyUSB is only for testing purpose */
            entity.path.contains('ttyS') || entity.path.contains('ttyUSB'))
        .map((entity) => entity.path)
        .toList();

    // Check each port
    for (final port in ports) {
      try {
        // Try to open the port with basic settings
        final process = await Process.start('stty', ['-F', port, '9600', 'raw'],
            runInShell: true);
        final exitCode = await process.exitCode;

        if (exitCode == 0) {
          // Try to read some data
          final readProcess = await Process.start('timeout', ['2', 'cat', port],
              runInShell: true);
          final output =
              await readProcess.stdout.transform(utf8.decoder).join();

          // If we get any data, assume it's the scale
          if (output.isNotEmpty) {
            // Set permissions for the port
            try {
              final chmodProcess =
                  await Process.run('sudo', ['chmod', '777', port]);
              if (chmodProcess.exitCode != 0) {
                return '$port (chmod failed: ${chmodProcess.stderr})';
              }
            } catch (e) {
              return '$port (chmod error: $e)';
            }

            return port;
          }
        }
      } catch (e) {
        // Skip to next port if there's an error
        continue;
      }
    }

    return 'No weighing scale detected on ttyS ports';
  } catch (e) {
    return 'Port detection error: $e';
  }
}
