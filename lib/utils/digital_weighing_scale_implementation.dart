import 'package:flutter/foundation.dart';

/// This method read from digital Scale a weight
@immutable
abstract class DigitalWeighingScaleImplementation {
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

  Stream<double> getWeightAsStream();

}