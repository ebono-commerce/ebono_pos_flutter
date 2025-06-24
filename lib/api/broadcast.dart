import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// UDP Broadcast Manager
///
/// This class handles UDP broadcast operations for discovering and communicating
/// with devices on the local network. It supports both Linux and macOS platforms.
class UdpBroadcastManager {
  // Private static instance
  static final UdpBroadcastManager _instance = UdpBroadcastManager._internal();

  /// Public accessor to the singleton instance
  static UdpBroadcastManager get instance => _instance;

  // Private constructor
  UdpBroadcastManager._internal();

  // Private variables for socket management
  static RawDatagramSocket? _udpSocket;
  static StreamSubscription<RawSocketEvent>? _socketSubscription;

  /// Get the primary MAC address based on the platform (Linux/macOS)
  Future<String?> getPrimaryMacAddress() async {
    try {
      if (Platform.isLinux) {
        return await _getLinuxMacAddress();
      } else if (Platform.isMacOS) {
        return await _getMacMacAddress();
      } else {
        throw UnsupportedError('Only Linux and macOS are supported.');
      }
    } catch (e) {
      print('❌ Failed to get MAC address: $e');
      return null;
    }
  }

  /// Get MAC address on Linux using `ip link`
  Future<String?> _getLinuxMacAddress() async {
    final result = await Process.run('ip', ['link']);
    if (result.exitCode != 0) return null;

    final output = result.stdout as String;
    final regex = RegExp(r'link/ether ([0-9a-f:]{17})');
    final match = regex.firstMatch(output);
    return match?.group(1);
  }

  /// Get MAC address on macOS using `ifconfig`
  Future<String?> _getMacMacAddress() async {
    final result = await Process.run('ifconfig', []);
    if (result.exitCode != 0) return null;

    final output = result.stdout as String;
    final regex = RegExp(r'ether\s+([0-9a-f:]{17})');
    final match = regex.firstMatch(output);
    return match?.group(1);
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
