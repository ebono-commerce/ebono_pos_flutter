import 'package:get/get.dart';
import 'package:kpn_pos_application/utils/digital_weighing_scale.dart';

class WeightController extends GetxController {
  RxDouble weight = 0.0.obs; // Observable weight value
  late DigitalWeighingScale digitalWeighingScale;

  WeightController(String port, String model, int rate, int timeout) {
    try {
      digitalWeighingScale = DigitalWeighingScale(
        digitalScalePort: port,
        digitalScaleModel: model,
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
