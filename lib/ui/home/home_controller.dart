import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ebono_pos/constants/shared_preference_constants.dart';
import 'package:ebono_pos/data_store/get_storage_helper.dart';
import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/models/cart_response.dart';
import 'package:ebono_pos/models/customer_response.dart';
import 'package:ebono_pos/models/scan_products_response.dart';
import 'package:ebono_pos/navigation/page_routes.dart';
import 'package:ebono_pos/ui/home/model/add_to_cart.dart';
import 'package:ebono_pos/ui/home/model/cart_request.dart';
import 'package:ebono_pos/ui/home/model/customer_details_response.dart';
import 'package:ebono_pos/ui/home/model/customer_request.dart';
import 'package:ebono_pos/ui/home/model/delete_cart.dart';
import 'package:ebono_pos/ui/home/model/general_success_response.dart';
import 'package:ebono_pos/ui/home/model/open_register_response.dart';
import 'package:ebono_pos/ui/home/model/orders_on_hold.dart';
import 'package:ebono_pos/ui/home/model/orders_onhold_request.dart';
import 'package:ebono_pos/ui/home/model/phone_number_request.dart';
import 'package:ebono_pos/ui/home/model/register_close_request.dart';
import 'package:ebono_pos/ui/home/model/register_open_request.dart';
import 'package:ebono_pos/ui/home/model/resume_hold_cart_request.dart';
import 'package:ebono_pos/ui/home/model/update_cart.dart';
import 'package:ebono_pos/ui/home/repository/home_repository.dart';
import 'package:ebono_pos/ui/login/model/login_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/health_check_response.dart';
import 'package:ebono_pos/utils/digital_weighing_scale.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  var ordersOnHold = <OnHoldItems>[].obs;

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
  String selectedTerminalId = '';
  RxString customerProxyNumber = ''.obs;
  RxDouble weight = 0.0.obs; // Observable weight value
  late DigitalWeighingScale digitalWeighingScale;
  final int rate = 9600;
  final int timeout = 1000;
  var generalSuccessResponse = GeneralSuccessResponse().obs;
  var healthCheckResponse = HealthCheckResponse().obs;

  var openRegisterResponse = OpenRegisterResponse().obs;
  var closeRegisterResponse = GeneralSuccessResponse().obs;
  var ordersOnHoldResponse = OrdersOnHoldResponse().obs;

  final RxString _connectionStatus = 'Unknown'.obs;
  var isOnline = false.obs;
  final Connectivity _connectivity = Connectivity();
  var isQuantityEditEnabled = ''.obs;
  var isLineDeleteEnabled = ''.obs;
  var isEnableHoldCartEnabled = ''.obs;
  var isPriceEditEnabled = ''.obs;
  var isSalesAssociateLinkEnabled = ''.obs;
  bool isApiCallInProgress = false;
  var selectedItemData = CartLine().obs;
  var lastRoute = PageRoutes.paymentSummary.obs;
  var isCustomerProxySelected = false.obs;

  @override
  void onInit() async {
    _checkConnectivity();
    await readStorageData();
    if (Platform.isLinux) {
      initializeWeighingScale();
    }
    initialResponse();
    super.onInit();
  }

  Future<void> readStorageData() async {
    portName.value = await sharedPreferenceHelper.getPortName() ?? '';
    selectedOutlet.value =
        GetStorageHelper.read(SharedPreferenceConstants.selectedOutletName);
    selectedOutletId =
        GetStorageHelper.read(SharedPreferenceConstants.selectedOutletId);
    selectedTerminalId =
        GetStorageHelper.read(SharedPreferenceConstants.selectedTerminalId);
    selectedTerminal.value =
        GetStorageHelper.read(SharedPreferenceConstants.selectedTerminalName);
    selectedPosMode.value =
        GetStorageHelper.read(SharedPreferenceConstants.selectedPosMode);
    customerProxyNumber.value =
        GetStorageHelper.read(SharedPreferenceConstants.customerProxyNumber);

    registerId.value =
        GetStorageHelper.read(SharedPreferenceConstants.registerId);

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
  }

  void initializeWeighingScale() {
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
  }

  Future<void> _checkConnectivity() async {
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
        healthCheckApiCall();
        _connectionStatus.value = 'Connected to WiFi';
        break;
      case ConnectivityResult.ethernet:
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
      weightController: TextEditingController(
          text: cartLine.quantity?.quantityNumber.toString()),
      weightFocusNode: FocusNode(),
      quantityTextController: TextEditingController(
          text: cartLine.quantity?.quantityNumber.toString()),
      quantityFocusNode: FocusNode(),
      priceTextController: TextEditingController(
          text: cartLine.quantity?.quantityNumber.toString()),
      priceFocusNode: FocusNode(),
    );
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
      skuCode: '',
      skuTitle: '-',
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
    customerName.value = '';
    generalSuccessResponse.value = GeneralSuccessResponse(success: false);
    ordersOnHoldResponse.value = OrdersOnHoldResponse(data: [], meta: null);
  }

  Future<void> clearScanData() async {
    scanProductsResponse.value = ScanProductsResponse(
      skuCode: '',
      skuTitle: '-',
      isWeighedItem: false,
      mediaUrl: '',
      isActive: false,
    );
  }

  Future<void> clearCart() async {
    cartResponse.value = CartResponse(cartId: '', cartType: '');
  }

  Future<void> clearHoldCartOrders() async {
    ordersOnHoldResponse.value = OrdersOnHoldResponse(data: [], meta: null);
  }

  Future<void> scanApiCall(String code) async {
    try {
      if (isApiCallInProgress) return;
      isApiCallInProgress = true;
      var response = await _homeRepository.getScanProduct(
          code: code, outletId: selectedOutletId);
      scanProductsResponse.value = response;
      if (cartId.value != "" && (response.priceList?.length ?? 0) <= 1) {
        addToCartApiCall(
            scanProductsResponse.value.skuCode,
            1,
            scanProductsResponse.value.priceList!.first.mrpId,
            scanProductsResponse.value.salesUom,
            cartId.value);
      }
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      isApiCallInProgress = false;
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
    try {
      var response = await _homeRepository.fetchCustomer(CustomerRequest(
          phoneNumber: phoneNumber.value,
          customerName: customerName.value,
          cartType: selectedPosMode.value.isNotEmpty == true
              ? selectedPosMode.value
              : 'POS',
          terminalId: selectedTerminalId,
          outletId: selectedOutletId));
      customerResponse.value = response;

      GetStorageHelper.save(SharedPreferenceConstants.sessionCustomerNumber,
          "${customerResponse.value.phoneNumber?.countryCode}${customerResponse.value.phoneNumber?.number}");
      GetStorageHelper.save(SharedPreferenceConstants.sessionCustomerName,
          customerResponse.value.customerName);

      if (cartId.value.isNotEmpty && isCustomerProxySelected.value) {
        mergeCart(phoneNumber.value);
        isCustomerProxySelected.value = false;
      } else {
        cartId.value = customerResponse.value.cartId.toString();
        GetStorageHelper.save(SharedPreferenceConstants.cartId, cartId.value);
        fetchCartDetails();
      }
    } catch (e) {
      print("Error $e");
    }
  }

  Future<void> fetchCartDetails() async {
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

  Future<void> mergeCart(String phoneNumber) async {
    cartLines.clear();
    try {
      clearCart();
      print('merge cart');
      var response = await _homeRepository.mergeCart(
          CartRequest(cartId: cartId.value, phoneNumber: phoneNumber));
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
    String? skuCode,
    int? qty,
    String? mrpId,
    String? qtyUom,
    String? cartId,
  ) async {
    try {
      var response = await _homeRepository.addToCart(
          AddToCartRequest(cartLines: [
            AddToCartCartLine(
                skuCode: skuCode,
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
    try {
      if (isApiCallInProgress) return;
      isApiCallInProgress = true;
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
      isApiCallInProgress = false;
    }
  }

  Future<void> clearFullCart() async {
    try {
      var response = await _homeRepository.clearFullCart(cartId.value);
      cartResponse.value = response;
      cartId.value = '';
      getCustomerDetailsResponse.value = CustomerDetailsResponse();
      customerResponse.value = CustomerResponse();
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
      customerResponse.value = CustomerResponse();
      customerName.value = '';
      phoneNumber.value = '';
      cartLines.value = [];
      cartResponse.value = CartResponse();
      Get.snackbar('Cart held successfully', 'Cart saved for later!');
    } catch (e) {
      print("Error $e");
    }
  }

  Future<void> resumeHoldCartApiCall(String? id) async {
    try {
      var response = await _homeRepository.resumeHoldCart(
          cartId.value,
          ResumeHoldCartRequest(
              terminalId:
                  "${GetStorageHelper.read(SharedPreferenceConstants.selectedTerminalId)}",
              holdCartId: id));
      generalSuccessResponse.value = response;
      if (generalSuccessResponse.value == true) {
        clearHoldCartOrders();
        selectedTabButton.value = 2;
      }
    } catch (e) {
      print("Error $e");
    }
  }

  Future<void> healthCheckApiCall() async {
    _statusCheckTimer = Timer.periodic(
      const Duration(seconds: 120),
      (timer) async {
        try {
          final loginStatus = await sharedPreferenceHelper.getLoginStatus();
          if (loginStatus != true) {
            isOnline.value = false;
            timer.cancel();
            return;
          }
          final response = await _homeRepository.healthCheckApiCall();
          healthCheckResponse.value = response;

          if (response.statusCode == 200) {
            isOnline.value = true;
          } else {
            isOnline.value = false;
            timer.cancel();
          }
        } catch (e) {
          print("Health check error: $e");
          isOnline.value = false;
          timer.cancel();
        }
      },
    );
  }

  Future<void> openRegisterApiCall() async {
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
      registerId.value = openRegisterResponse.value.registerId ?? "";
      openFloatPayment.value = '';
      selectedTabButton.value = 2;
      isLoading.value = false;
    } catch (e) {
      print("Error $e");
      isLoading.value = false;
    }
  }

  Future<void> closeRegisterApiCall() async {
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
        registerId.value = "";
        upiPayment.value = '';
        upiPaymentCount.value = '';
        cardPayment.value = '';
        cardPaymentCount.value = '';
        cashPayment.value = '';
        selectedTabButton.value = 2;
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print("Error $e");
    }
  }

  void addOrdersOnHoldItems(OnHoldItems onHoldItems) {
    var item = OnHoldItems(
        customer:
            HoldOrderCustomer(customerName: onHoldItems.customer?.customerName),
        holdCartId: onHoldItems.holdCartId,
        createdAt: onHoldItems.createdAt,
        cashierDetails: CashierDetails(
            cashierId: onHoldItems.cashierDetails?.cashierId,
            cashierName: onHoldItems.cashierDetails?.cashierName),
        phoneNumber: HoldOrderPhoneNumber(
            countryCode: onHoldItems.phoneNumber?.countryCode,
            number: onHoldItems.phoneNumber?.number));
    ordersOnHold.add(item);
  }

  void removeOrdersOnHoldItems(OnHoldItems onHoldItems) {
    ordersOnHold.remove(onHoldItems);
  }

  Future<void> ordersOnHoldApiCall() async {
    isLoading.value = true;
    try {
      var response = await _homeRepository.ordersOnHold(OrdersOnHoldRequest(
          outletId:
              "${GetStorageHelper.read(SharedPreferenceConstants.selectedOutletId)}"));
      ordersOnHoldResponse.value = response;
      if (ordersOnHoldResponse.value.data != null) {
        ordersOnHold.clear();
        for (var element in ordersOnHoldResponse.value.data!) {
          addOrdersOnHoldItems(element);
        }
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
    digitalWeighingScale.dispose();
    super.onClose();
  }
}
