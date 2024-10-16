import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kpn_pos_application/blocs/models/ScanProductsResponse.dart';
import 'package:kpn_pos_application/utils/digital_weighing_scale.dart';

class WeightController extends GetxController {
  RxDouble weight = 0.0.obs; // Observable weight value
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

  //late ScanProductsResponse scanProductsResponse;
  var scanProductsResponse = ScanProductsResponse().obs;

  @override
  void onInit() {
    fetchData("10004858");
    super.onInit();
  }

  Future<void> fetchData(String code) async {
    isLoading(true);
    print("API");
    try {
      final response = await http.get(Uri.parse(
          'https://558c-2401-4900-1cb1-f936-2921-48bb-51cb-375e.ngrok-free.app/catalog/v1/products/scan?code=$code'));
      if (response.statusCode == 200) {
        scanProductsResponse.value =
            ScanProductsResponse.fromJson(json.decode(response.body));
        print("Success : ${response.body}");
      } else {
        // Handle error
        print("Error");
      }
    } catch (e) {
      // Handle error
      print("Error $e");
    } finally {
      isLoading(false);
    }
  }

/*
  Future<void> fetchData(String code) async {
    isLoading(true);
    print("API");
    try {
      final String response =
          await rootBundle.loadString('assets/data/scan_response.json');
      final data = json.decode(response);
      //scanProductsResponse = ScanProductsResponse.fromJson(data);
      scanProductsResponse.value = ScanProductsResponse.fromJson(data);
    } catch (e) {
      // Handle error
      print("Error $e");
    } finally {
      isLoading(false);
    }
  }
  */
}
