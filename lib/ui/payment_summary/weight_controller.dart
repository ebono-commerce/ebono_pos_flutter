import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kpn_pos_application/blocs/models/ScanProductsResponse.dart';
import 'package:kpn_pos_application/utils/digital_weighing_scale.dart';

class WeightController extends GetxController {
  RxDouble weight = 0.0.obs;  // Observable weight value
  late DigitalWeighingScale digitalWeighingScale;

  WeightController(String port, String model, int rate, int timeout) {
    digitalWeighingScale = DigitalWeighingScale(
      digitalScalePort: port,
      digitalScaleModel: model,
      digitalScaleRate: rate,
      digitalScaleTimeout: timeout,
      weightController: weight,
    );
    digitalWeighingScale.getWeight();


  }

}

class HomeController extends GetxController {
  var isLoading = false.obs;
  var items = ScanProductsResponse(
      esin: '', ebonoTitle: '', isActive: true, priceList: []).obs;

  @override
  void onInit() {
    fetchData("10004858");
    super.onInit();
  }

  Future<void> fetchData(String code) async {
    isLoading(true);
    try {
      final response = await http.get(
          Uri.parse('192.186.0.187:4444/catalog/v1/products/scan?code=$code'));
      if (response.statusCode == 200) {
        items.value =
            json.decode(response.body); // Replace with your parsing logic
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    } finally {
      isLoading(false);
    }
  }
}
