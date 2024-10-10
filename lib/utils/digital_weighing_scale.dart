import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:kpn_pos_application/utils/digital_weighing_scale_implementation.dart';
import 'package:libserialport/libserialport.dart';

class DigitalWeighingScale implements DigitalWeighingScaleImplementation {
  final String digitalScalePort;
  final String digitalScaleModel;
  final int digitalScaleRate;
  final int digitalScaleTimeout;
  static late SerialPort serialPort;
  static late SerialPortReader serialPortReader;
  static int factor = 1;
  static String initString = '';
  final RxDouble weightController;

  /// initialize the serial port and call methods
  DigitalWeighingScale({
    required this.digitalScalePort,
    required this.digitalScaleModel,
    required this.digitalScaleRate,
    required this.digitalScaleTimeout,
    required this.weightController,
  }) {
    serialPort = SerialPort(digitalScalePort);

    bool resp = open();

    if (resp) {
      try {
        config();
        writeInPort(initString);
        readPort();
      } catch (e) {
        // Handle the exception
        print('Error: $e');
      }
    }
  }

  /// Open the port for Read and Write
  @override
  bool open() {
    if (serialPort.isOpen) {
      try {
        serialPort.close();
      } catch (e) {
        print('Error: $e');
      }
    }

    if (!serialPort.isOpen) {
      if (!serialPort.openReadWrite()) {
        return false;
      }
    }

    return true;
  }

  /// Configure the port with arguments
  @override
  config() {
    initString = String.fromCharCode(5) +
        String.fromCharCode(10) +
        String.fromCharCode(13);

    SerialPortConfig config = serialPort.config;
    config.baudRate = 9600;
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
      print('Error: $e');
    }
  }

  /// read the port
  @override
  readPort() {
    try {
      serialPortReader = SerialPortReader(serialPort);
    } catch (e) {
      print('Error: $e');
    }
  }

  /// create the listener and return the weight
  @override
  Future<void> getWeight() async {
    String decodedWeight = '';
    StreamSubscription? subscription;

    try {
      double weight = 0.00;
      subscription = serialPortReader.stream.listen((data) async {
        decodedWeight += utf8.decode(data);
        if(decodedWeight.length >= 9){
          weight = double.parse(decodedWeight);
          print('decoded weight $weight');
          decodedWeight = '';
        }
      });
    } catch (e) {
      print('digital scale error: $e');
      serialPort.close();
      subscription?.cancel();
    }
  }

  @override
  Stream<double> getWeightAsStream() async* {
    String decodedWeight = '';
    StreamSubscription? subscription;
    double weight = 0.00;

    try {
      while (true) {
        while (true) {
          final data = await serialPortReader.port.read(1024);
          decodedWeight += utf8.decode(data);
          if (decodedWeight.length >= 9) {
            final weight = double.parse(decodedWeight);
            print('decoded weight $weight');
            decodedWeight = '';
            yield weight;
          }
        }
        }
    } catch (e) {
      print('digital scale error: $e');
      serialPort.close();
      rethrow; // Propagate the error
    }
  }

  void listenToPort() {
    String decodedWeight = '';
    double weight = 0.00;

    serialPortReader.stream.listen((data) {
      decodedWeight += utf8.decode(data);
      if (decodedWeight.length >= 9) {
        weight = double.parse(decodedWeight);
        weightController.value = weight;  // Directly update the weight
        print('decoded weight: $weight');
        decodedWeight = '';
      }
    }, onError: (error) {
      print('Error reading port: $error');
    });
  }
}
