import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

/// UDP Broadcast Manager
///
/// This class handles UDP broadcast operations for discovering and communicating
/// with devices on the local network. It supports both Linux and macOS platforms.
class UdpBroadcastManager {
  // Private variables for socket management
  static RawDatagramSocket? _udpSocket;
  static StreamSubscription<RawSocketEvent>? _socketSubscription;

  /// Get all broadcast addresses for the current device
  ///
  /// Returns a list of broadcast IP addresses for all network interfaces
  /// excluding loopback addresses (127.x.x.x)
  ///
  /// Throws [UnsupportedError] if platform is not Linux or macOS
  static Future<List<String>> getBroadcastAddresses() async {
    if (Platform.isLinux) {
      return compute(_fetchLinuxBroadcasts, null);
    } else if (Platform.isMacOS) {
      return compute(_fetchMacBroadcasts, null);
    } else {
      throw UnsupportedError(
          'Platform ${Platform.operatingSystem} is not supported. Only Linux and macOS are supported.');
    }
  }

  /// Fetch broadcast addresses on Linux systems
  ///
  /// Uses 'ip addr' command to get network interface information
  /// and calculates broadcast addresses from IP/CIDR notation
  static Future<List<String>> _fetchLinuxBroadcasts(dynamic _) async {
    try {
      // Execute 'ip addr' command to get network interface info
      final result = await Process.run('ip', ['addr']);
      if (result.exitCode != 0) {
        print('⚠️ Failed to execute "ip addr" command');
        return [];
      }

      final output = result.stdout as String;
      // Regex to match IP addresses with CIDR notation (e.g., 192.168.1.100/24)
      final regex = RegExp(r'inet (\d+\.\d+\.\d+\.\d+)/(\d+)', multiLine: true);
      final matches = regex.allMatches(output);
      final List<String> broadcasts = [];

      for (final match in matches) {
        final ip = match.group(1)!;
        final cidr = int.parse(match.group(2)!);

        // Skip loopback addresses
        if (ip.startsWith('127.')) continue;

        final broadcast = _calculateBroadcast(ip, cidr);
        if (broadcast != null && !broadcasts.contains(broadcast)) {
          broadcasts.add(broadcast);
          print(
              '🌐 Found Linux broadcast address: $broadcast (from $ip/$cidr)');
        }
      }

      return broadcasts;
    } catch (e) {
      print('❌ Error fetching Linux broadcast addresses: $e');
      return [];
    }
  }

  /// Fetch broadcast addresses on macOS systems
  ///
  /// Uses 'ifconfig' command to get network interface information
  /// and extracts broadcast addresses directly from the output
  static Future<List<String>> _fetchMacBroadcasts(dynamic _) async {
    try {
      // Execute 'ifconfig' command to get network interface info
      final result = await Process.run('ifconfig', []);
      if (result.exitCode != 0) {
        print('⚠️ Failed to execute "ifconfig" command');
        return [];
      }

      final output = result.stdout as String;
      // Regex to match inet lines with broadcast addresses
      final regex = RegExp(
          r'inet (\d+\.\d+\.\d+\.\d+)\s+netmask 0x([a-fA-F0-9]+)\s+broadcast (\d+\.\d+\.\d+\.\d+)');
      final matches = regex.allMatches(output);
      final List<String> broadcasts = [];

      for (final match in matches) {
        final ip = match.group(1)!;
        final broadcast = match.group(3)!;

        // Skip loopback addresses
        if (ip.startsWith('127.')) continue;

        if (!broadcasts.contains(broadcast)) {
          broadcasts.add(broadcast);
          print('🌐 Found macOS broadcast address: $broadcast (from $ip)');
        }
      }

      return broadcasts;
    } catch (e) {
      print('❌ Error fetching macOS broadcast addresses: $e');
      return [];
    }
  }

  /// Calculate broadcast address from IP and CIDR prefix length
  ///
  /// Takes an IP address and CIDR prefix (e.g., "192.168.1.100" and 24)
  /// and calculates the corresponding broadcast address (e.g., "192.168.1.255")
  ///
  /// Returns null if calculation fails
  static String? _calculateBroadcast(String ip, int prefixLength) {
    try {
      // Validate prefix length
      if (prefixLength < 0 || prefixLength > 32) {
        print('⚠️ Invalid prefix length: $prefixLength');
        return null;
      }

      // Convert IP address to list of integers
      List<int> ipParts = ip.split('.').map(int.parse).toList();
      if (ipParts.length != 4) {
        print('⚠️ Invalid IP address format: $ip');
        return null;
      }

      // Validate IP parts
      for (int part in ipParts) {
        if (part < 0 || part > 255) {
          print('⚠️ Invalid IP address octet: $part in $ip');
          return null;
        }
      }

      // Convert IP to 32-bit integer
      int ipInt = ipParts.fold(0, (acc, part) => (acc << 8) + part);

      // Create subnet mask from prefix length
      int mask = (0xFFFFFFFF << (32 - prefixLength)) & 0xFFFFFFFF;

      // Calculate broadcast address by setting all host bits to 1
      int broadcastInt = ipInt | (~mask & 0xFFFFFFFF);

      // Convert back to dotted decimal notation
      return [
        (broadcastInt >> 24) & 0xFF,
        (broadcastInt >> 16) & 0xFF,
        (broadcastInt >> 8) & 0xFF,
        broadcastInt & 0xFF
      ].join('.');
    } catch (e) {
      print('❌ Error calculating broadcast address for $ip/$prefixLength: $e');
      return null;
    }
  }

  /// Start listening for UDP broadcasts on specified port
  ///
  /// [port] - The UDP port to listen on (e.g., 8888)
  /// [onMessage] - Callback function called when a message is received
  ///
  /// The callback receives the message string and sender's InternetAddress
  ///
  /// This method binds to 0.0.0.0 (any IPv4 address) to receive broadcasts
  /// from any network interface
  static Future<void> listenForUdpBroadcast({
    required int port,
    void Function(String message, InternetAddress sender)? onMessage,
  }) async {
    try {
      // Close any existing socket before creating a new one
      await closeUdpSocket();

      // Bind UDP socket to any IPv4 address (0.0.0.0) on the specified port
      // This allows receiving broadcasts from any network interface
      _udpSocket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        port,
        reuseAddress: true, // Allow multiple listeners on the same port
        reusePort: Platform.isLinux, // Enable port reuse on Linux
      );

      print('✅ UDP socket bound to 0.0.0.0:$port');
      print('🎧 Listening for UDP broadcasts on port $port...');

      // Set up listener for socket events
      _socketSubscription = _udpSocket!.listen(
        (RawSocketEvent event) {
          if (event == RawSocketEvent.read) {
            // Receive incoming datagram
            final datagram = _udpSocket!.receive();
            if (datagram == null) return;

            try {
              // Extract sender address and decode message
              final senderAddress = datagram.address.address;
              final message = utf8.decode(datagram.data);

              print(
                  '📨 UDP Broadcast received from $senderAddress: "$message"');

              // Call the provided callback if available
              if (onMessage != null) {
                onMessage(message, datagram.address);
              }
            } catch (e) {
              print('❌ Error processing received UDP message: $e');
            }
          }
        },
        onError: (error) {
          print('❌ UDP socket error: $error');
        },
        onDone: () {
          print('🔚 UDP socket stream closed');
        },
      );
    } catch (e) {
      print('❌ Failed to start UDP broadcast listener on port $port: $e');
      print('💡 Make sure the port is not already in use');
      rethrow;
    }
  }

  /// Send a UDP broadcast message to specified broadcast addresses
  ///
  /// [message] - The message to broadcast
  /// [port] - The destination port
  /// [broadcastAddresses] - List of broadcast IPs to send to (optional)
  ///
  /// If broadcastAddresses is not provided, it will get all available broadcast addresses
  static Future<void> sendUdpBroadcast({
    required String message,
    required int port,
    List<String>? broadcastAddresses,
  }) async {
    try {
      final broadcasts = broadcastAddresses ?? await getBroadcastAddresses();

      if (broadcasts.isEmpty) {
        print('⚠️ No broadcast addresses found');
        return;
      }

      print(
          '📤 Sending broadcast message: "$message" to ${broadcasts.length} addresses');

      for (String broadcastIp in broadcasts) {
        try {
          // Create a temporary socket for sending
          final socket =
              await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
          socket.broadcastEnabled = true;

          final data = utf8.encode(message);
          final address = InternetAddress(broadcastIp);

          final bytesSent = socket.send(data, address, port);
          if (bytesSent > 0) {
            print('✅ Broadcast sent to $broadcastIp:$port ($bytesSent bytes)');
          } else {
            print('⚠️ Failed to send broadcast to $broadcastIp:$port');
          }

          socket.close();
        } catch (e) {
          print('❌ Failed to send broadcast to $broadcastIp: $e');
        }
      }
    } catch (e) {
      print('❌ Error in sendUdpBroadcast: $e');
    }
  }

  /// Close the UDP socket and clean up resources
  ///
  /// This should be called when you no longer need to listen for broadcasts
  /// (e.g., when disposing a controller or closing the app)
  static Future<void> closeUdpSocket() async {
    try {
      // Cancel the socket subscription first
      if (_socketSubscription != null) {
        print('🛑 Cancelling UDP socket subscription');
        await _socketSubscription!.cancel();
        _socketSubscription = null;
      }

      // Close the socket
      if (_udpSocket != null) {
        print('🛑 Closing UDP socket');
        _udpSocket!.close();
        _udpSocket = null;
      }
    } catch (e) {
      print('❌ Error closing UDP socket: $e');
    }
  }

  /// Check if UDP listener is currently active
  static bool get isListening =>
      _udpSocket != null && _socketSubscription != null;

  /// Get current socket information (for debugging)
  static String get socketInfo {
    if (_udpSocket != null) {
      return 'Socket bound to ${_udpSocket!.address.address}:${_udpSocket!.port}';
    }
    return 'No active socket';
  }

  /// Get the current listening port (returns null if not listening)
  static int? get currentPort {
    return _udpSocket?.port;
  }
}

// Legacy functions for backward compatibility
// These are proper wrappers that delegate to the UdpBroadcastManager class

/// Get broadcast addresses (legacy function)
///
/// This is a wrapper around UdpBroadcastManager.getBroadcastAddresses()
/// for backward compatibility with existing code
Future<List<String>> getBroadcastAddresses() async {
  return UdpBroadcastManager.getBroadcastAddresses();
}

/// Listen for UDP broadcasts (legacy function)
///
/// This is a wrapper around UdpBroadcastManager.listenForUdpBroadcast()
/// for backward compatibility with existing code
///
/// Note: The broadCastIp parameter has been removed as the new implementation
/// automatically listens on all interfaces (0.0.0.0)
Future<void> listenForUdpBroadcast({
  required int port,
  void Function(String message, InternetAddress sender)? onMessage,
}) async {
  return UdpBroadcastManager.listenForUdpBroadcast(
    port: port,
    onMessage: onMessage,
  );
}

/// Send UDP broadcast (legacy function)
///
/// This is a wrapper around UdpBroadcastManager.sendUdpBroadcast()
/// for backward compatibility with existing code
Future<void> sendUdpBroadcast({
  required String message,
  required int port,
  List<String>? broadcastAddresses,
}) async {
  return UdpBroadcastManager.sendUdpBroadcast(
    message: message,
    port: port,
    broadcastAddresses: broadcastAddresses,
  );
}

/// Close UDP socket (legacy function)
///
/// This is a wrapper around UdpBroadcastManager.closeUdpSocket()
/// for backward compatibility with existing code
Future<void> closeUdpSocket() async {
  return UdpBroadcastManager.closeUdpSocket();
}

/// Check if currently listening for UDP broadcasts (legacy function)
///
/// This is a wrapper around UdpBroadcastManager.isListening
/// for backward compatibility with existing code
bool get isListeningForUdpBroadcast => UdpBroadcastManager.isListening;
