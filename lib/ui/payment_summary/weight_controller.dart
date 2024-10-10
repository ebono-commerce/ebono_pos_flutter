import 'package:get/get.dart';
import 'package:kpn_pos_application/utils/digital_weighing_scale.dart';

class WeightController extends GetxController {
  var weight = 0.0.obs;  // Observable weight value
  late DigitalWeighingScale digitalWeighingScale;

  WeightController(String port, String model, int rate, int timeout) {
    digitalWeighingScale = DigitalWeighingScale(
      digitalScalePort: port,
      digitalScaleModel: model,
      digitalScaleRate: rate,
      digitalScaleTimeout: timeout,
    );

    listenToWeightStream();
  }

  void listenToWeightStream() {
    digitalWeighingScale.getWeightAsStream().listen((newWeight) {
      weight.value = newWeight;
    });
  }
}
