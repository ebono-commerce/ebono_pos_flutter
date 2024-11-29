import 'package:flutter/foundation.dart';

@immutable
abstract class DigitalWeighingScaleImplementation {
  ///initialise port
  void initializePort();

  /// open Serial Port
  bool open();

  /// configure Serial Port
  config();

  /// write in serial port the enq byte
  writeInPort(String value);

  /// read the port
  readPort();

  /// create the listener, get the weight and return in double format.
  Future<void> getWeight();

  ///handle error in port
  void handlePortError(Object? error, String message);

  ///monitor port connection
  void monitorConnection();

  /// dispose port connection
  void dispose();

}