import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kpn_pos_application/models/cart_response.dart';
import 'package:kpn_pos_application/models/customer_response.dart';
import 'package:kpn_pos_application/models/scan_products_response.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var phoneNumber = ''.obs;
  var customerName = ''.obs;

  var scanCode = ''.obs;

  var cartId = ''.obs;
  var cartLines = <CartLine>[].obs;

  // Example method to add a new cart line void
  addCartLine(CartLine cartLine) {
    var cart = CartLine(
        cartLineId: cartLine.cartLineId,
        item: cartLine.item,
        quantity: cartLine.quantity,
        unitPrice: cartLine.unitPrice,
        mrp: cartLine.mrp,
        lineTotal: cartLine.lineTotal,
        applicableCartAdjustments: cartLine.applicableCartAdjustments,
        audit: cartLine.audit,
        controller: TextEditingController(
            text: cartLine.quantity?.quantityNumber.toString()),
        focusNode: cartLine.focusNode);
    cartLines.add(cart);
    print('cart List: ${cartLines.toList()}');
  }

  // Example method to remove a cart line void
  void removeCartLine(CartLine cartLine) {
    cartLines.remove(cartLine);
  }

  var scanProductsResponse = ScanProductsResponse().obs;
  var customerResponse = CustomerResponse().obs;
  var cartResponse = CartResponse().obs;

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
    cartId.value = '';
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

  Future<void> clearCart() async {
    cartResponse.value = CartResponse(cartId: '', cartType: '');
  }

  Future<void> scanApiCall(String code) async {
    print(" scanApiCall: $code");

    isLoading(true);
    try {
      final response = await http.get(
          Uri.parse(
              'https://services-staging.kpnfresh.com/store/catalog/v1/products/scan?code=$code'),
          headers: {
            'Content-Type': 'application/json',
            'x-app-id': '8521954d-6746-49c2-b50c-1593cf0adb42',
            'x-channel': 'POS'
          });
      if (response.statusCode == 200) {
        scanProductsResponse.value =
            ScanProductsResponse.fromJson(json.decode(response.body));
        print("Success : ${response.body}");
        addToCartApiCall(
            scanProductsResponse.value.esin,
            1,
            scanProductsResponse.value.priceList!.first.mrpId,
            scanProductsResponse.value.salesUom,
            "$cartId");
      } else {
        print("Error");
      }
    } catch (e) {
      print("Error $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCustomer() async {
    print("fetchCustomer ");
    isLoading(true);
    try {
      final reqBody = {
        "phone_number": phoneNumber.value,
        "cart_type": "POS",
        "outlet_id": "OCHNMYL01"
      };
      final response = await http.post(
        Uri.parse(
            'https://services-staging.kpnfresh.com/store/account/v1/customer/fetch'),
        headers: {
          'Content-Type': 'application/json',
          'x-app-id': '8521954d-6746-49c2-b50c-1593cf0adb42',
          'x-channel': 'POS'
        },
        body: jsonEncode(reqBody),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        clearCart();
        customerResponse.value =
            CustomerResponse.fromJson(json.decode(response.body));
        print("Success : ${response.body}");
        cartId.value = customerResponse.value.cartId.toString();
        fetchCartCall();
      } else {
        Get.snackbar("", "Something went wrong");
      }
    } catch (e) {
      print("Error $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCartCall() async {
    isLoading(true);
    cartLines.value.clear();
    try {
      final reqBody = {"cart_id": cartId.value};
      final response = await http.post(
        Uri.parse(
            'https://services-staging.kpnfresh.com/store/checkout/v1/cart/fetch?schema=DETAIL'),
        headers: {
          'Content-Type': 'application/json',
          'x-app-id': '8521954d-6746-49c2-b50c-1593cf0adb42',
          'x-channel': 'POS'
        },
        body: jsonEncode(reqBody),
      );
      if (response.statusCode == 200) {
        clearCart();
        cartResponse.value = CartResponse.fromJson(json.decode(response.body));
        print("Success : ${response.body}");
        cartLines.value.clear();
        if (cartResponse.value.cartLines != null) {
          for (var element in cartResponse.value.cartLines!) {
            addCartLine(element);
          }
        }
      } else {
        Get.snackbar("", "Something went wrong");
      }
    } catch (e) {
      print("Error $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> addToCartApiCall(
    String? esin,
    int? qty,
    String? mrpId,
    String? qtyUom,
    String? cartId,
  ) async {
    isLoading(true);
    try {
      final reqBody = {
        "cart_lines": [
          {
            "esin": "$esin",
            "quantity": {"quantity_number": qty, "quantity_uom": "$qtyUom"},
            "mrp_id": "$mrpId"
          }
        ]
      };
      final response = await http.post(
        Uri.parse(
            'https://services-staging.kpnfresh.com/store/checkout/v1/cart/$cartId/items'),
        headers: {
          'Content-Type': 'application/json',
          'x-app-id': '8521954d-6746-49c2-b50c-1593cf0adb42',
          'x-channel': 'POS'
        },
        body: jsonEncode(reqBody),
      );
      if (response.statusCode == 200) {
        clearCart();
        cartResponse.value = CartResponse.fromJson(json.decode(response.body));
        print("Success : ${response.body}");
        fetchCartCall();
      } else {
        Get.snackbar("", "Something went wrong");
      }
    } catch (e) {
      print("Error $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteCartItemApiCall(String? cartLineId) async {
    final reqBody = {};
    isLoading(true);

    try {
      final response = await http.delete(
        Uri.parse(
            'https://services-staging.kpnfresh.com/store/checkout/v1/cart/$cartId/cart-line/$cartLineId'),
        headers: {
          'Content-Type': 'application/json',
          'x-app-id': '8521954d-6746-49c2-b50c-1593cf0adb42',
          'x-channel': 'POS'
        },
        body: jsonEncode(reqBody),
      );
      if (response.statusCode == 200) {
        clearCart();
        cartResponse.value = CartResponse.fromJson(json.decode(response.body));
        print("Success : ${response.body}");
        fetchCartCall();
      } else {
        Get.snackbar("", "Something went wrong");
      }
    } catch (e) {
      print("Error $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateCartItemApiCall(
      String? cartLineId, String? quantityUom, double? quantity) async {
    final reqBody = {
      "quantity": {"quantity_number": quantity, "quantity_uom": "$quantityUom"}
    };
    isLoading(true);
    try {
      final response = await http.post(
        Uri.parse(
            'https://services-staging.kpnfresh.com/store/checkout/v1/cart/$cartId/cart-line/$cartLineId'),
        headers: {
          'Content-Type': 'application/json',
          'x-app-id': '8521954d-6746-49c2-b50c-1593cf0adb42',
          'x-channel': 'POS'
        },
        body: jsonEncode(reqBody),
      );
      if (response.statusCode == 200) {
        clearCart();
        cartResponse.value = CartResponse.fromJson(json.decode(response.body));
        print("Success : ${response.body}");
        fetchCartCall();
      } else {
        Get.snackbar("", "Something went wrong");
      }
    } catch (e) {
      print("Error $e");
    } finally {
      isLoading(false);
    }
  }

/*
  /// for local data from json
  
  Future<void> fetchCartCall() async {
    isLoading(true);
    print("API");
    try {
      final String response =
          await rootBundle.loadString('assets/data/fetch_cart.json');
      final data = json.decode(response);
      cartResponse.value = CartResponse.fromJson(data);
      print("Success : $response");

      if (cartResponse.value.cartLines != null) {
        for (var element in cartResponse.value.cartLines!) {
          if (element != null) {
            addCartLine(element);
          }
        }
      }
    } catch (e) {
      // Handle error
      print("Error $e");
    } finally {
      isLoading(false);
    }
  }

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

*/
}
