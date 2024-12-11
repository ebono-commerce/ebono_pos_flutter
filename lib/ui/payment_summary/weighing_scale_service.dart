import 'dart:io';

import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/utils/digital_weighing_scale.dart';
import 'package:get/get.dart';

class WeighingScaleService extends GetxService {
  late DigitalWeighingScale digitalWeighingScale;
  final SharedPreferenceHelper sharedPreferenceHelper;
  RxDouble weight = 0.0.obs;

  WeighingScaleService(this.sharedPreferenceHelper);

  @override
  Future<void> onInit() async {
   await initWeighingScale();
    super.onInit();
  }

  Future<WeighingScaleService> initWeighingScale() async {
    try {
      final portName = await sharedPreferenceHelper.getPortName() ?? '';

      if (Platform.isLinux && portName.isNotEmpty) {
        digitalWeighingScale = DigitalWeighingScale(
          digitalScalePort: portName,
          digitalScaleRate: 9600,
          weightController: weight,
        );
        digitalWeighingScale.getWeight();
      } else {
        print("Platform not supported or port name not found.");
      }
    } catch (e) {
      print("Error initializing weighing scale: $e");
    }
    return this;
  }

  void disposeWeighingScale() {
    try {
      digitalWeighingScale.dispose();
    } catch (e) {
      print("Error disposing weighing scale: $e");
    }
  }


  @override
  void onClose() {
    disposeWeighingScale();
    super.onClose();
  }
}