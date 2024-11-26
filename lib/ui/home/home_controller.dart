import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kpn_pos_application/constants/shared_preference_constants.dart';
import 'package:kpn_pos_application/data_store/get_storage_helper.dart';
import 'package:kpn_pos_application/data_store/shared_preference_helper.dart';
import 'package:kpn_pos_application/models/cart_response.dart';
import 'package:kpn_pos_application/models/customer_response.dart';
import 'package:kpn_pos_application/models/scan_products_response.dart';
import 'package:kpn_pos_application/navigation/page_routes.dart';
import 'package:kpn_pos_application/ui/home/model/add_to_cart.dart';
import 'package:kpn_pos_application/ui/home/model/cart_request.dart';
import 'package:kpn_pos_application/ui/home/model/customer_details_response.dart';
import 'package:kpn_pos_application/ui/home/model/customer_request.dart';
import 'package:kpn_pos_application/ui/home/model/delete_cart.dart';
import 'package:kpn_pos_application/ui/home/model/general_success_response.dart';
import 'package:kpn_pos_application/ui/home/model/open_register_response.dart';
import 'package:kpn_pos_application/ui/home/model/phone_number_request.dart';
import 'package:kpn_pos_application/ui/home/model/register_close_request.dart';
import 'package:kpn_pos_application/ui/home/model/register_open_request.dart';
import 'package:kpn_pos_application/ui/home/model/resume_hold_cart_request.dart';
import 'package:kpn_pos_application/ui/home/model/update_cart.dart';
import 'package:kpn_pos_application/ui/home/repository/home_repository.dart';
import 'package:kpn_pos_application/ui/login/model/login_response.dart';
import 'package:kpn_pos_application/ui/payment_summary/model/health_check_response.dart';
import 'package:kpn_pos_application/utils/digital_weighing_scale.dart';

class HomeController extends GetxController {
  late final HomeRepository _homeRepository;
  final SharedPreferenceHelper sharedPreferenceHelper;

  HomeController(this._homeRepository, this.sharedPreferenceHelper);

  Timer? _statusCheckTimer;

  var isLoading = false.obs;

  // for register || Orders || Orders on hold
  RxInt selectedTabButton = 2.obs;
  var phoneNumber = ''.obs;
  var customerName = ''.obs;
  var scanCode = ''.obs;
  var cartId = ''.obs;
  var registerId = ''.obs;

  // for register section
  var cashPayment = ''.obs;
  var openFloatPayment = ''.obs;
  var upiPayment = ''.obs;
  var cardPayment = ''.obs;
  var cardPaymentCount = ''.obs;
  var upiPaymentCount = ''.obs;

  var isDisplayAddCustomerView = true.obs;
  RxString portName = ''.obs;
  var cartLines = <CartLine>[].obs;

  var scanProductsResponse = ScanProductsResponse().obs;
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
  var generalSuccessResponse = GeneralSuccessResponse().obs;
  var healthCheckResponse = HealthCheckResponse().obs;

  var openRegisterResponse = OpenRegisterResponse().obs;
  var closeRegisterResponse = GeneralSuccessResponse().obs;
  RxString _connectionStatus = 'Unknown'.obs;
  var isOnline = false.obs;
  final Connectivity _connectivity = Connectivity();
  var isQuantityEditEnabled = ''.obs;
  var isLineDeleteEnabled = ''.obs;
  var isEnableHoldCartEnabled = ''.obs;
  var isPriceEditEnabled = ''.obs;
  var isSalesAssociateLinkEnabled = ''.obs;

  @override
  void onInit() async {
    _checkConnectivity();
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

    registerId.value =
        GetStorageHelper.read(SharedPreferenceConstants.registerId);

    print('selectedTerminal  $selectedTerminal');
    print('selectedOutlet  $selectedOutlet');

    isQuantityEditEnabled.value =
        GetStorageHelper.read(SharedPreferenceConstants.isQuantityEditEnabled);
    isLineDeleteEnabled.value =
        GetStorageHelper.read(SharedPreferenceConstants.isLineDeleteEnabled);
    isEnableHoldCartEnabled.value = GetStorageHelper.read(
        SharedPreferenceConstants.isEnableHoldCartEnabled);
    isPriceEditEnabled.value =
        GetStorageHelper.read(SharedPreferenceConstants.isPriceEditEnabled);
    isSalesAssociateLinkEnabled.value = GetStorageHelper.read(
        SharedPreferenceConstants.isSalesAssociateLinkEnabled);
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

  Future<void> _checkConnectivity() async {
    print('_checkConnectivity  ${isOnline.value}');
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      _statusCheckTimer?.cancel();
      isOnline.value = false;
      _connectionStatus.value = 'Failed to get connectivity.';
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        print('ConnectivityResult.wifi  ${isOnline.value}');
        healthCheckApiCall();
        _connectionStatus.value = 'Connected to WiFi';
        break;
      case ConnectivityResult.ethernet:
        print('ConnectivityResult.ethernet  ${isOnline.value}');
        healthCheckApiCall();
        _connectionStatus.value = 'Connected to Ethernet';
        break;
      case ConnectivityResult.mobile:
        _connectionStatus.value = 'Connected to Mobile Network';
        break;
      case ConnectivityResult.none:
        _connectionStatus.value = 'No Network Connection';
        break;
      default:
        _connectionStatus.value = 'Unknown Network Connection';
        break;
    }
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

    generalSuccessResponse.value = GeneralSuccessResponse(success: false);
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
      if (cartId.value != "" && (response.priceList?.length ?? 0) <= 1) {
        addToCartApiCall(
            scanProductsResponse.value.esin,
            1,
            scanProductsResponse.value.priceList!.first.mrpId,
            scanProductsResponse.value.salesUom,
            cartId.value);
      }
    } catch (e) {
      print("Error $e");
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

      // Note Please clear when order success
      GetStorageHelper.save(SharedPreferenceConstants.cartId, cartId.value);
      GetStorageHelper.save(SharedPreferenceConstants.sessionCustomerNumber,
          "${customerResponse.value.phoneNumber?.countryCode}${customerResponse.value.phoneNumber?.number}");
      GetStorageHelper.save(SharedPreferenceConstants.sessionCustomerName,
          customerResponse.value.customerName);

      fetchCartDetails();
    } catch (e) {
      print("Error $e");
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
    }
  }

  Future<void> clearFullCart() async {
    print("API clearFullCart: ${cartId.value} ");
    try {
      var response = await _homeRepository.clearFullCart(cartId.value);
      cartResponse.value = response;
      cartId.value = '';
      getCustomerDetailsResponse.value = CustomerDetailsResponse();
      customerName.value = '';
      phoneNumber.value = '';
      cartLines.value = [];
      Get.snackbar('Cart cleared successfully', 'All items removed');
    } catch (e) {
      print("Error $e");
    }
  }

  Future<void> holdCartApiCall() async {
    try {
      var response = await _homeRepository.holdCart(
          cartId.value, PhoneNumberRequest(phoneNumber: phoneNumber.value));
      generalSuccessResponse.value = response;
      cartId.value = '';
      getCustomerDetailsResponse.value = CustomerDetailsResponse();
      customerName.value = '';
      phoneNumber.value = '';
      cartLines.value = [];
      cartResponse.value = CartResponse();
      Get.snackbar('Cart held successfully', 'Cart saved for later!');
    } catch (e) {
      print("Error $e");
    }
  }

  Future<void> resumeHoldCartApiCall() async {
    try {
      var response = await _homeRepository.resumeHoldCart(
          cartId.value, ResumeHoldCartRequest(terminalId: "", holdCartId: ""));
      generalSuccessResponse.value = response;
    } catch (e) {
      print("Error $e");
    }
  }

  Future<void> healthCheckApiCall() async {
    print("API healthCheckApiCall: ");
    _statusCheckTimer = Timer.periodic(Duration(seconds: 60), (timer) async {

      try {
        var loginStatus = await sharedPreferenceHelper.getLoginStatus();
        if (loginStatus == true) {
          var response = await _homeRepository.healthCheckApiCall();
          healthCheckResponse.value = response;
          if (healthCheckResponse.value.statusCode != 200) {
            timer.cancel();
            isOnline.value = false;
            print("API healthCheckApiCall:  ${isOnline.value}");
          } else {
            print(
                "API healthCheckApiCall: ${healthCheckResponse.value.statusCode}");
            healthCheckApiCall();
            isOnline.value = true;
            print("API healthCheckApiCall:  ${isOnline.value}");
          }
        }
      } catch (e) {
        print("Error $e");
        isOnline.value = false;
        timer.cancel();
      }
    });
  }

  Future<void> openRegisterApiCall() async {
    print("API openRegisterApiCall: ");
    var userId = await sharedPreferenceHelper.getUserID();

    isLoading.value = true;
    try {
      var response = await _homeRepository.openRegister(RegisterOpenRequest(
          outletId:
              "${GetStorageHelper.read(SharedPreferenceConstants.selectedOutletId)}",
          terminalId:
              "${GetStorageHelper.read(SharedPreferenceConstants.selectedTerminalId)}",
          userId: userId,
          floatCash: int.tryParse(openFloatPayment.value)));
      openRegisterResponse.value = response;
      GetStorageHelper.save(SharedPreferenceConstants.registerId,
          openRegisterResponse.value.registerId ?? "");
      openFloatPayment.value = '';
      Get.offAllNamed(PageRoutes.home);
      isLoading.value = false;
    } catch (e) {
      print("Error $e");
      isLoading.value = false;
    }
  }

  Future<void> closeRegisterApiCall() async {
    print("API closeRegisterApiCall: ");
    var userId = await sharedPreferenceHelper.getUserID();

    isLoading.value = true;
    try {
      var response = await _homeRepository.closeRegister(RegisterCloseRequest(
        outletId:
            "${GetStorageHelper.read(SharedPreferenceConstants.selectedOutletId)}",
        registerId:
            "${GetStorageHelper.read(SharedPreferenceConstants.registerId)}",
        terminalId:
            "${GetStorageHelper.read(SharedPreferenceConstants.selectedTerminalId)}",
        userId: userId,
        cardTransactionSummary: TransactionSummary(
            chargeSlipCount: int.tryParse(cardPaymentCount.value),
            amount: Amount(
                centAmount: int.tryParse(cardPayment.value),
                fraction: 1000,
                currency: "INR")),
        cashTransactionSummary: CashTransactionSummary(
            amount: Amount(
                centAmount: int.tryParse(cashPayment.value),
                fraction: 1000,
                currency: "INR")),
        upiTransactionSummary: TransactionSummary(
            chargeSlipCount: int.tryParse(upiPaymentCount.value),
            amount: Amount(
                centAmount: int.tryParse(upiPayment.value),
                fraction: 1000,
                currency: "INR")),
      ));
      closeRegisterResponse.value = response;
      if (closeRegisterResponse.value.success == true) {
        GetStorageHelper.save(SharedPreferenceConstants.registerId, "");
        upiPayment.value = '';
        upiPaymentCount.value = '';
        cardPayment.value = '';
        cardPaymentCount.value = '';
        cashPayment.value = '';
        Get.offAllNamed(PageRoutes.home);
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print("Error $e");
    }
  }

  @override
  void onClose() {
    _statusCheckTimer?.cancel();
    super.onClose();
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
