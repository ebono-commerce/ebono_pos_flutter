import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kpn_pos_application/constants/shared_preference_constants.dart';
import 'package:kpn_pos_application/data_store/get_storage_helper.dart';
import 'package:kpn_pos_application/data_store/shared_preference_helper.dart';
import 'package:kpn_pos_application/models/cart_response.dart';
import 'package:kpn_pos_application/models/customer_response.dart';
import 'package:kpn_pos_application/models/scan_products_response.dart';
import 'package:kpn_pos_application/ui/home/model/add_to_cart.dart';
import 'package:kpn_pos_application/ui/home/model/cart_request.dart';
import 'package:kpn_pos_application/ui/home/model/customer_details_response.dart';
import 'package:kpn_pos_application/ui/home/model/customer_request.dart';
import 'package:kpn_pos_application/ui/home/model/delete_cart.dart';
import 'package:kpn_pos_application/ui/home/model/update_cart.dart';
import 'package:kpn_pos_application/ui/home/repository/home_repository.dart';
import 'package:kpn_pos_application/ui/login/model/login_response.dart';
import 'package:kpn_pos_application/ui/payment_summary/model/payment_initiate_response.dart';
import 'package:kpn_pos_application/ui/payment_summary/model/payment_status_response.dart';
import 'package:kpn_pos_application/utils/digital_weighing_scale.dart';

class HomeController extends GetxController {
  late final HomeRepository _homeRepository;
  final SharedPreferenceHelper sharedPreferenceHelper;

  HomeController(this._homeRepository, this.sharedPreferenceHelper);

  var showPaymentDialog = false.obs;
  Timer? _statusCheckTimer;
  var phoneNumber = ''.obs;
  var customerName = ''.obs;
  var scanCode = ''.obs;
  var cartId = ''.obs;

  var isDisplayAddCustomerView = true.obs;
  RxString portName = ''.obs;
  var cartLines = <CartLine>[].obs;

  var scanProductsResponse = ScanProductsResponse().obs;

  var paymentInitiateResponse = PaymentInitiateResponse().obs;
  var p2pRequestId = ''.obs;
  var paymentStatusResponse = PaymentStatusResponse().obs;

  var customerResponse = CustomerResponse().obs;
  var getCustomerDetailsResponse = CustomerDetailsResponse().obs;
  var cartResponse = CartResponse().obs;
  Rx<UserDetails> userDetails =
      UserDetails(fullName: '', userType: '', userId: '').obs;
  RxString selectedOutlet = ''.obs;
  RxString selectedTerminal = ''.obs;
  RxString selectedPosMode = ''.obs;
  String selectedOutletId = '';
  RxString customerProxyNumber = ''.obs;
  RxDouble weight = 0.0.obs; // Observable weight value
  late DigitalWeighingScale digitalWeighingScale;
  final int rate = 9600;
  final int timeout = 1000;

  @override
  void onInit() async {
    portName.value = await sharedPreferenceHelper.getPortName() ?? '';
    selectedOutlet.value =
        GetStorageHelper.read(SharedPreferenceConstants.selectedOutletName);
    selectedOutletId =
        GetStorageHelper.read(SharedPreferenceConstants.selectedOutletId);
    selectedTerminal.value =
        GetStorageHelper.read(SharedPreferenceConstants.selectedTerminalName);
    selectedPosMode.value =
        GetStorageHelper.read(SharedPreferenceConstants.selectedPosMode);
    customerProxyNumber.value =
        GetStorageHelper.read(SharedPreferenceConstants.customerProxyNumber);
    print('selectedTerminal  $selectedTerminal');
    print('selectedOutlet  $selectedOutlet');
    final userDetailsData =
        GetStorageHelper.read(SharedPreferenceConstants.userDetails);
    if (userDetailsData != null && userDetailsData is Map<String, dynamic>) {
      userDetails.value = UserDetails.fromJson(userDetailsData);
      print(userDetails.value.toJson());
    } else {
      userDetails.value = userDetailsData;
      print(userDetails.value.toJson());
    }

    try {
      digitalWeighingScale = DigitalWeighingScale(
        digitalScalePort: portName.value,
        digitalScaleRate: rate,
        digitalScaleTimeout: timeout,
        weightController: weight,
      );
      digitalWeighingScale.getWeight();
    } on Exception catch (e) {
      print(e);
    }
    initialResponse();
    super.onInit();
  }

  @override
  void onClose() {
    _statusCheckTimer?.cancel();
    super.onClose();
  }

  void addCartLine(CartLine cartLine) {
    var cart = CartLine(
        cartLineId: cartLine.cartLineId,
        item: cartLine.item,
        quantity: cartLine.quantity,
        unitPrice: cartLine.unitPrice,
        isWeighedItem: cartLine.isWeighedItem,
        mrp: cartLine.mrp,
        lineTotal: cartLine.lineTotal,
        applicableCartAdjustments: cartLine.applicableCartAdjustments,
        audit: cartLine.audit,
        controller: TextEditingController(
            text: cartLine.quantity?.quantityNumber.toString()),
        focusNode: FocusNode());
    cartLines.add(cart);
  }

  void removeCartLine(CartLine cartLine) {
    cartLines.remove(cartLine);
  }

  Future<void> initialCustomerDetails() async {
    customerResponse.value = CustomerResponse(
      cartId: '',
    );
    phoneNumber.value = '';
    cartId.value = '';
  }

  Future<void> initialResponse() async {
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
    print("API scanApiCall: $code");
    try {
      var response = await _homeRepository.getScanProduct(
          code: code, outletId: selectedOutletId);
      scanProductsResponse.value = response;
      if (cartId.value != "") {
        addToCartApiCall(
            scanProductsResponse.value.esin,
            1,
            scanProductsResponse.value.priceList!.first.mrpId,
            scanProductsResponse.value.salesUom,
            cartId.value);
      }
    } catch (e) {
      print("Error $e");
    } finally {
      print("Error");
    }
  }

  getCustomerDetails() async {
    try {
      var response =
          await _homeRepository.getCustomerDetails(phoneNumber.value);
      getCustomerDetailsResponse.value = response;
      if (getCustomerDetailsResponse.value.customerName?.isNotEmpty == true) {
        customerName.value =
            getCustomerDetailsResponse.value.customerName.toString();
      }
      // fetchCartDetails();
    } catch (e) {
      print("Error $e");
    } finally {
      print("Error");
    }
  }

  fetchCustomer() async {
    print("API fetchCustomer: ${phoneNumber.value}");
    try {
      var response = await _homeRepository.fetchCustomer(CustomerRequest(
          phoneNumber: phoneNumber.value,
          customerName: customerName.value,
          cartType: selectedPosMode.value.isNotEmpty == true
              ? selectedPosMode.value
              : 'POS',
          terminalId: selectedTerminal.value,
          outletId: selectedOutlet.value));
      customerResponse.value = response;
      cartId.value = customerResponse.value.cartId.toString();
      fetchCartDetails();
    } catch (e) {
      print("Error $e");
    } finally {
      print("Error");
    }
  }

  Future<void> fetchCartDetails() async {
    print("API fetchCartCall: ${cartId.value}");

    cartLines.clear();
    try {
      clearCart();
      var response =
          await _homeRepository.getCart(CartRequest(cartId: cartId.value));
      cartResponse.value = response;
      if (cartResponse.value.cartLines != null) {
        for (var element in cartResponse.value.cartLines!) {
          addCartLine(element);
        }
      }
    } catch (e) {
      print("Error $e");
    } finally {
      print("Error");
    }
  }

  Future<void> addToCartApiCall(
    String? esin,
    int? qty,
    String? mrpId,
    String? qtyUom,
    String? cartId,
  ) async {
    print("API addToCartApiCall: $esin | $mrpId | $qty | $cartId");

    try {
      var response = await _homeRepository.addToCart(
          AddToCartRequest(cartLines: [
            AddToCartCartLine(
                esin: esin,
                quantity:
                    AddToCartQuantity(quantityNumber: qty, quantityUom: qtyUom),
                mrpId: mrpId)
          ]),
          cartId);
      cartResponse.value = response;
      fetchCartDetails();
    } catch (e) {
      print("Error $e");
    } finally {
      print("Error");
    }
  }

  Future<void> deleteCartItemApiCall(String? cartLineId) async {
    print("API deleteCartItemApiCall: $cartLineId");

    try {
      var response = await _homeRepository.deleteCartItem(
          DeleteCartRequest(), cartId.value, cartLineId!);
      cartResponse.value = response;
      fetchCartDetails();
    } catch (e) {
      print("Error $e");
    } finally {
      print("Error");
    }
  }

  Future<void> updateCartItemApiCall(
      String? cartLineId, String? qUom, double? qty) async {
    print("API updateCartItemApiCall: $qty | $cartLineId");
    try {
      var response = await _homeRepository.updateCartItem(
          UpdateCartRequest(
              quantity: UpdateQuantity(quantityNumber: qty, quantityUom: qUom)),
          cartId.value,
          cartLineId!);
      cartResponse.value = response;
      fetchCartDetails();
    } catch (e) {
      print("Error $e");
    } finally {
      print("Error");
    }
  }

// For Payment

  Future<void> paymentStatusCheckCall(bool fromPopup) async {
    if (fromPopup == true) {
      _statusCheckTimer?.cancel();
    }
    _statusCheckTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
      try {
        final reqBody = {
          "username": "2211202100",
          "appKey": "eaa762ba-08ac-41d6-b6d3-38f754ed1572",
          "origP2pRequestId": p2pRequestId.value
          //"origP2pRequestId": "241122060944906E020075684",
        };

        var response = await http.post(
          Uri.parse('https://demo.ezetap.com/api/3.0/p2p/status'),
          body: jsonEncode(reqBody),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json, text/plain, */*',
          },
        );
        if (response.statusCode == 200) {
          paymentStatusResponse.value =
              PaymentStatusResponse.fromJson(json.decode(response.body));
          print("Success payment --> : ${response.body}");
          print(
              "Success payment status --> : ${paymentStatusResponse.value.abstractPaymentStatus}");
          switch (paymentStatusResponse.value.messageCode) {
            case "P2P_DEVICE_RECEIVED":
              break;
            case "P2P_STATUS_QUEUED":
              break;
            case "P2P_STATUS_IN_EXPIRED":
              break;
            case "P2P_DEVICE_TXN_DONE":
              p2pRequestId.value = '';
              timer.cancel();
              Get.back();
              break;
            case "P2P_STATUS_UNKNOWN":
              break;
            case "P2P_DEVICE_CANCELED":
              p2pRequestId.value = '';
              timer.cancel();
              Get.back();
              break;
            //"P2P_ORIGINAL_P2P_REQUEST_IS_MISSING"
            case "P2P_STATUS_IN_CANCELED_FROM_EXTERNAL_SYSTEM":
              p2pRequestId.value = '';
              timer.cancel();
              Get.back();
              break;
            case "P2P_ORIGINAL_P2P_REQUEST_IS_MISSING":
              p2pRequestId.value = '';
              timer.cancel();
              Get.back();
              break;
            default:
              timer.cancel();
              Get.back();
              break;
          }
          Get.snackbar('Message', '${paymentStatusResponse.value.message}');
        } else {
          timer.cancel();
          Get.snackbar('Error', 'Failed to check payment status');
        }
      } catch (e) {
        print("Error $e");
        Get.snackbar(
            'Error', 'An error occurred while checking payment status');
      } finally {
        print("Error $e");
      }
    });
  }

  Future<void> paymentInitiateCall() async {
    final random = Random();
    final reqBody = {
      "amount": "1",
      "externalRefNumber": "${random.nextInt(10)}",
      "customerName": "Shankar Lonare",
      "customerEmail": "",
      "customerMobileNumber": "8871722186",
      "is_emi": false,
      "terminal_id": "10120",
      "username": "2211202100",
      "appKey": "eaa762ba-08ac-41d6-b6d3-38f754ed1572",
      "pushTo": {"deviceId": "0821387918|ezetap_android"}
    };
    try {
      final response = await http.post(
        Uri.parse('https://demo.ezetap.com/api/3.0/p2p/start'),
        body: jsonEncode(reqBody),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json, text/plain, */*',
        },
      );
      if (response.statusCode == 200) {
        paymentInitiateResponse.value =
            PaymentInitiateResponse.fromJson(json.decode(response.body));
        print("Success payment --> : ${response.body}");
        if (paymentInitiateResponse.value.success == true) {
          print(
              "Success p2pRequestId --> : ${paymentInitiateResponse.value.p2PRequestId}");
          if (paymentInitiateResponse.value.p2PRequestId != "") {
            paymentStatusCheckCall(false);
            p2pRequestId.value =
                "${paymentInitiateResponse.value.p2PRequestId}";
          } else {
            p2pRequestId.value = '';
          }
        } else {
          Get.snackbar('Error', '${paymentInitiateResponse.value.message}');
        }
      } else {
        Get.snackbar('Error', 'An error occurred while initiating payment');
        print("Error");
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while initiating payment');

      print("Error $e");
    } finally {
      print("Error $e");
    }
  }

  Future<void> paymentCancelCall() async {
    try {
      final reqBody = {
        "username": "2211202100",
        "appKey": "eaa762ba-08ac-41d6-b6d3-38f754ed1572",
        //"origP2pRequestId": "241122060944906E020075684",
        "origP2pRequestId": p2pRequestId.value,
        "pushTo": {"deviceId": "0821387918|ezetap_android"}
      };
      final response = await http.post(
        Uri.parse('https://demo.ezetap.com/api/3.0/p2p/cancel'),
        body: jsonEncode(reqBody),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json, text/plain, */*',
        },
      );
      if (response.statusCode == 200) {
        paymentInitiateResponse.value =
            PaymentInitiateResponse.fromJson(json.decode(response.body));
        print("Success payment --> : ${response.body}");
        if (paymentInitiateResponse.value.success == true) {
          Get.back();
          print(
              "Success p2pRequestId --> : ${paymentInitiateResponse.value.p2PRequestId}");
        } else {
          if (paymentInitiateResponse.value.realCode ==
              "P2P_DUPLICATE_CANCEL_REQUEST") {
            Get.back();
          }
          Get.snackbar('Error', '${paymentInitiateResponse.value.message}');
        }
      } else {
        Get.snackbar('Error', 'An error occurred');
        print("Error");
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred');
      print("Error $e");
    } finally {
      print("Error $e");
    }
  }

/*
  Login:
9999912343
9999912342
9999912341

10000139
10000004
10000027
10001394
10007352
10000071
10004726
  */
}
