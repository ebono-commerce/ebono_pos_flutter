import 'dart:async';
import 'dart:convert';

import 'package:ebono_pos/utils/digital_weighing_scale_implementation.dart';
import 'package:get/get.dart';
import 'package:libserialport/libserialport.dart';

class DigitalWeighingScale implements DigitalWeighingScaleImplementation {
  final String digitalScalePort;
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
        Get.snackbar('Error in port', '$e');
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
        Get.snackbar('Error in port', '$e');
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
      Get.snackbar('Error in port', '$e');
    }
  }

  /// read the port
  @override
  readPort() {
    try {
      serialPortReader = SerialPortReader(serialPort);
    } catch (e) {
      print('Error: $e');
      Get.snackbar('Error in port', '$e');
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
          weightController.value = weight;
          print('decoded weight $weight');
          decodedWeight = '';
        }
      });
    } catch (e) {
      print('digital scale error: $e');
      Get.snackbar('Error in port', '$e');
      serialPort.close();
      subscription?.cancel();
    }
  }


}
