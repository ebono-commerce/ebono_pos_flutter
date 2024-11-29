import 'dart:async';
import 'dart:convert';

import 'package:ebono_pos/utils/digital_weighing_scale_implementation.dart';
import 'package:get/get.dart';
import 'package:libserialport/libserialport.dart';

class DigitalWeighingScale implements DigitalWeighingScaleImplementation {
  static DigitalWeighingScale? _instance;

  final String digitalScalePort;
  final int digitalScaleRate;
  final int digitalScaleTimeout;
  final RxDouble weightController;

  late SerialPort serialPort;
  SerialPortReader? serialPortReader;
  StreamSubscription? subscription;

  static String initString = String.fromCharCode(5) +
      String.fromCharCode(10) +
      String.fromCharCode(13);

  /// initialize the serial port and call methods
  DigitalWeighingScale._({
    required this.digitalScalePort,
    required this.digitalScaleRate,
    required this.digitalScaleTimeout,
    required this.weightController,
  }) {
    serialPort = SerialPort(digitalScalePort);
    initializeScale();
  }

  /// Factory constructor to return the singleton instance
  factory DigitalWeighingScale({
    required String digitalScalePort,
    required int digitalScaleRate,
    required int digitalScaleTimeout,
    required RxDouble weightController,
  }) {
    return _instance ??= DigitalWeighingScale._(
      digitalScalePort: digitalScalePort,
      digitalScaleRate: digitalScaleRate,
      digitalScaleTimeout: digitalScaleTimeout,
      weightController: weightController,
    );
  }

  /// Initialize the scale
  void initializeScale() {
    bool resp =  open();
    if (resp) {
      try {
        config();
        writeInPort(initString);
        readPort();
      } catch (e) {
        _handleError(e, 'Error initializing port');
      }
    }
    monitorConnection(); // Start monitoring connection
  }

  /// Open the port for Read and Write
  @override
  bool open() {
    if (serialPort.isOpen) {
      try {
        serialPort.close();
      } catch (e) {
        _handleError(e, 'Error closing port');
      }
    }

    if (!serialPort.isOpen) {
      if (!serialPort.openReadWrite()) {
        _handleError(null, 'Failed to open port');
        return false;
      }
    }

    return true;
  }

  /// Configure the port with arguments
  @override
  config() {
    SerialPortConfig config = serialPort.config;
    config.baudRate = digitalScaleRate;
    config.stopBits = 1;
    config.bits = 8;
    config.parity = SerialPortParity.none;
    serialPort.config = config;
  }

  /// write enq in port
  @override
  writeInPort(String value) {
    try {
      serialPort.write(utf8.encoder.convert(value));
    } catch (e) {
      _handleError(e, 'Error writing to port');
    }
  }

  /// read the port
  @override
  readPort() {
    try {
      serialPortReader = SerialPortReader(serialPort);
      getWeight();
    } catch (e) {
      _handleError(e, 'Error creating serial port reader');
    }
  }

  /// create the listener and return the weight
  @override
  Future<void> getWeight() async {
    if (subscription != null) {
      subscription?.cancel(); // Cancel any existing subscription
    }

    if (serialPortReader == null) {
      _handleError(null, 'SerialPortReader is not initialized');
      return;
    }

    String decodedWeight = '';
   // StreamSubscription? subscription;

    try {
      double weight = 0.00;
      subscription = serialPortReader!.stream.listen((data) async {
        decodedWeight += utf8.decode(data);
        if(decodedWeight.length >= 9){
          try {
            weight = double.parse(decodedWeight);
            weightController.value = weight;
            print('decoded weight $weight');
            decodedWeight = '';
          } on Exception catch (e) {
            print('Error parsing weight: $e');
            Get.snackbar('Error in port', " error parsing weight");
          }
        }
      });
    } catch (e) {
      _handleError(e, 'Error listening to stream');
    }
  }

  void _handleError(Object? error, String message) {
    print('$message in port: ${error ?? 'Unknown error'}');
    Get.snackbar('Error in port', message);

    // Attempt recovery
    if (!serialPort.isOpen) {
      open();
      config();
      readPort();
    }
  }


  /// Monitor the connection and reconnect if needed
  void monitorConnection() {
    Timer.periodic(Duration(seconds: 30), (timer) {
      if (!serialPort.isOpen) {
        print('Scale disconnected. Attempting to reconnect...');
        open();
        config();
        readPort();
      }
    });
  }

  void dispose() {
    try {
      subscription?.cancel(); // Cancel the subscription
      if (serialPort.isOpen) {
        serialPort.close();
      }
    } catch (e) {
      _handleError(e, 'Error disposing port resources');
    }
  }

}
