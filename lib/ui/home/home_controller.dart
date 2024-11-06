import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kpn_pos_application/ui/home/model/cart_response.dart';
import 'package:kpn_pos_application/ui/home/model/customer_response.dart';
import 'package:kpn_pos_application/ui/home/model/scan_products_response.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var phoneNumber = ''.obs;
  var customerName = ''.obs;

  //late ScanProductsResponse scanProductsResponse;

  var scanProductsResponse = ScanProductsResponse().obs;
  var customerResponse = CustomerResponse().obs;
  var cartResponse = CartResponse().obs;

  //var addToCart = CartResponse().obs;

  @override
  void onInit() {
    super.onInit();
    intializationResponse();
    print("HomeController initialized");
  }

  Future<void> intializationResponse() async {
    scanProductsResponse.value = ScanProductsResponse(
      esin: '',
      ebonoTitle: '-',
      isWeighedItem: false,
      mediaUrl: '',
      isActive: false,
    );

    customerResponse.value = CustomerResponse(
      cartId: '',
    );

    cartResponse.value = CartResponse(cartId: '', cartType: '');
    phoneNumber.value = '';
  }

  Future<void> clearScanData() async {
    scanProductsResponse.value = ScanProductsResponse(
      esin: '',
      ebonoTitle: '-',
      isWeighedItem: false,
      mediaUrl: '',
      isActive: false,
    );
  }

/*
  Future<void> scanApiCall(String code) async {
    isLoading(true);
    try {
      final response = await http.get(Uri.parse(
          '${AppConstants.baseUrl}/catalog/v1/products/scan?code=$code'));
      if (response.statusCode == 200) {
        scanProductsResponse.value =
            ScanProductsResponse.fromJson(json.decode(response.body));
        print("Success : ${response.body}");
      } else {
        print("Error");
      }
    } catch (e) {
      print("Error $e");
    } finally {
      isLoading(false);
    }
  }
*/
/*
  Future<void> fetchCustomer() async {
    isLoading(true);
    try {
      final reqBody = {
        "phone_number": "8871722186",
        "cart_type": "POS",
        "outlet_id": "OCHNMYL01"
      };
      final response = await http.post(
          Uri.parse(
              '${AppConstants.baseUrl}/account/v1/customer/fetch'),
          body: reqBody);
      if (response.statusCode == 200) {
        customerResponse.value =
            CustomerResponse.fromJson(json.decode(response.body));
        print("Success : ${response.body}");
      } else {
        print("Error");
      }
    } catch (e) {
      print("Error $e");
    } finally {
      isLoading(false);
    }
  }
*/

/*
  Future<void> fetchCartCall() async {
    isLoading(true);
    try {
      final reqBody = {
  "cart_id": "36c9e954-26af-4a96-9326-10207922d0b8"
};
      final response = await http.post(
          Uri.parse(
              '${AppConstants.baseUrl}/checkout/v1/cart/fetch?schema=DETAIL'),
          body: reqBody);
      if (response.statusCode == 200) {
        cartResponse.value =
            CartResponse.fromJson(json.decode(response.body));
        print("Success : ${response.body}");
      } else {
        print("Error");
      }
    } catch (e) {
      print("Error $e");
    } finally {
      isLoading(false);
    }
  }

*/
/*
  Future<void> addToCartApiCall(String esin,String qty, String mrpId,String qtyUom,String cartId,) async {
    isLoading(true);
    try {
      final reqBody = {
    "cart_lines": [
        {
            "esin": "$esin",
            "quantity": {
                "quantity_number": "$qty",
                "quantity_uom": "$qtyUom"
            },
            "mrp_id": "$mrpId"
        }
    ]
};
      final response = await http.post(
          Uri.parse(
              '${AppConstants.baseUrl}/checkout/v1/cart/${cartId}/items'),
          body: reqBody);
      if (response.statusCode == 200) {
        cartResponse.value =
            CartResponse.fromJson(json.decode(response.body));
        print("Success : ${response.body}");
      } else {
        print("Error");
      }
    } catch (e) {
      print("Error $e");
    } finally {
      isLoading(false);
    }
  }
*/

  /// for local data from json

  Future<void> fetchCustomer() async {
    isLoading(true);
    try {
      final String response =
          await rootBundle.loadString('assets/data/fetch_customer.json');
      final data = json.decode(response);
      customerResponse.value = CustomerResponse.fromJson(data);
      print("Success : $response");
      // fetch cart api
      fetchCartCall("36c9e954-26af-4a96-9326-10207922d0b8");
    } catch (e) {
      print("Error $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> scanApiCall(String code) async {
    isLoading(true);
    print("API");
    try {
      final String response =
          await rootBundle.loadString('assets/data/scan_response.json');
      final data = json.decode(response);
      //scanProductsResponse = ScanProductsResponse.fromJson(data);
      scanProductsResponse.value = ScanProductsResponse.fromJson(data);
      print("Success : $response");
      //temp api call of fetch cart need to call addto cart  api
      // fetchCartCall("36c9e954-26af-4a96-9326-10207922d0b8");
      if (scanProductsResponse.value.isWeighedItem == false) {
        addToCartApiCall("10004858", "1", "iMwk8mWM", "gm");
      }
    } catch (e) {
      // Handle error
      print("Error $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCartCall(String cartId) async {
    isLoading(true);
    print("API");
    try {
      final String response =
          await rootBundle.loadString('assets/data/fetch_cart.json');
      final data = json.decode(response);
      cartResponse.value = CartResponse.fromJson(data);
      print("Success : $response");
    } catch (e) {
      // Handle error
      print("Error $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> addToCartApiCall(
      String esin, String qty, String mrpId, String qtyUom) async {
    isLoading(true);
    print("API");
    try {
      final String response =
          await rootBundle.loadString('assets/data/fetch_cart.json');
      final data = json.decode(response);
      cartResponse.value = CartResponse.fromJson(data);
      print("Success : $response");
      fetchCartCall("36c9e954-26af-4a96-9326-10207922d0b8");
    } catch (e) {
      // Handle error
      print("Error $e");
    } finally {
      isLoading(false);
    }
  }
}
