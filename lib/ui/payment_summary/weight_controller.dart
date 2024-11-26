import 'package:get/get.dart';
import 'package:ebono_pos/utils/digital_weighing_scale.dart';

class WeightController extends GetxController {
  RxDouble weight = 0.0.obs; // Observable weight value
  late DigitalWeighingScale digitalWeighingScale;

  WeightController(String port, String model, int rate, int timeout) {
    try {
      digitalWeighingScale = DigitalWeighingScale(
        digitalScalePort: port,
        digitalScaleRate: rate,
        digitalScaleTimeout: timeout,
        weightController: weight,
      );
      digitalWeighingScale.getWeight();
    } on Exception catch (e) {
      print(e);
    }
  }
}
