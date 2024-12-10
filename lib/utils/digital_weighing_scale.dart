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
  late bool isRecoveryInProgress = false;
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
    print('selected port: $digitalScalePort');
    serialPort = SerialPort(digitalScalePort);
    initializePort();
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

  /// Initialize the port
  @override
  void initializePort() {
    bool resp =  open();
    if (resp) {
      try {
        config();
        writeInPort(initString);
        readPort();
      } catch (e) {
        handlePortError(e, 'Error initializing port');
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
        handlePortError(e, 'Error closing port');
      }
    }

    if (!serialPort.isOpen) {
      if (!serialPort.openReadWrite()) {
        handlePortError(null, 'Failed to open port');
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
      handlePortError(e, 'Error writing to port');
    }
  }

  /// read the port
  @override
  readPort() {
    try {
      serialPortReader = SerialPortReader(serialPort);
    } catch (e) {
      handlePortError(e, 'Error creating serial port reader');
    }
  }

  /// create the listener and return the weight
  @override
  Future<void> getWeight() async {
    if (subscription != null) {
      subscription?.cancel();
    }

    if (serialPortReader == null) {
      handlePortError(null, 'SerialPortReader is not initialized');
      return;
    }

    String decodedWeight = '';
   // StreamSubscription? subscription;

    try {
      double weight = 0.00;
      if(subscription == null || subscription?.isPaused ==true || subscription?.isBlank == true){
        print('subscription not listenening');
        subscription = serialPortReader!.stream.listen((data) async {
          decodedWeight += utf8.decode(data);
          if(decodedWeight.length >= 9){
            print('decoded weight $decodedWeight');
            try {
              weight = double.parse(decodedWeight.trim());
            } on Exception catch (e) {
              // TODO
            }
            weightController.value = weight;
            print('parsed weight $weight');
            Get.snackbar('Reading from port $digitalScalePort', 'detected weight $weight');
            decodedWeight = '';
          }
        });
      }

    } catch (e) {
      handlePortError(e, 'Error listening to stream');
    }
  }

  @override
  void handlePortError(Object? error, String message) {
    print('$message in $digitalScalePort: ${error ?? 'Unknown error'}');
    Get.snackbar('Error in port $digitalScalePort', message);
    if(isRecoveryInProgress) return;
    isRecoveryInProgress = true;
    Future.delayed(Duration(seconds: 5)).then((_){
      if (!serialPort.isOpen) {
        open();
        config();
        readPort();
      }
      isRecoveryInProgress = false;
    });
    // Attempt recovery

  }


  /// Monitor the connection and reconnect if needed
  @override
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

  @override
  void dispose() {
    try {
      subscription?.cancel(); // Cancel the subscription
      if (serialPort.isOpen) {
        serialPort.close();
      }
    } catch (e) {
      handlePortError(e, 'Error disposing port resources');
    }
  }

}
