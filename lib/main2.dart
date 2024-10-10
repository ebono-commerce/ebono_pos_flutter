import 'dart:typed_data';

import 'package:libserialport/libserialport.dart';

class UsbPrinter {
  final String portName;

  UsbPrinter(this.portName);

  late SerialPort _serialPort;

  /// Initialize and open the USB port
  void initialize() {
    _serialPort = SerialPort(portName);

    if (!_serialPort.openReadWrite()) {
      print('Failed to open port');
      return;
    }

    // Configure the serial port settings (similar to configuring the baud rate etc.)
    SerialPortConfig config = _serialPort.config;
    config.baudRate = 9600;
    config.stopBits = 1;
    config.bits = 8;
    config.parity = SerialPortParity.none;
    _serialPort.config = config;
  }

  /// Send data to the printer
  void printData(Uint8List data) {
    try {
      _serialPort.write(data);
    } catch (e) {
      print('Failed to write to port: $e');
    }
  }

  /// Close the port after printing
  void close() {
    _serialPort.close();
  }

  /// Send the cut command to the printer
  void cutPaper() {
    // ESC/POS cut command: '\x1D\x56\x42\x10'
    final cutCommand = Uint8List.fromList([0x1D, 0x56, 0x42, 0x10]);
    printData(cutCommand);
  }
}

void main() async {
  final printer = UsbPrinter('COM3'); // Replace with the correct USB port for Windows, or `/dev/usb/lp0` for Linux/Ubuntu

  // Initialize the USB printer
  printer.initialize();

  // Example data to print (replace this with actual PDF or text data)
  final printData = Uint8List.fromList(
    [0x1B, 0x40, ...'Hello World!\n'.codeUnits, 0x0A], // ESC/POS commands + text
  );

  // Send data to print
  printer.printData(printData);

  // Send paper cut command
  printer.cutPaper();

  // Close the printer connection
  printer.close();
}
