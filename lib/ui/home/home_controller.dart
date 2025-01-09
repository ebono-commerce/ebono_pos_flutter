import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ebono_pos/constants/shared_preference_constants.dart';
import 'package:ebono_pos/data_store/hive_storage_helper.dart';
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
import 'package:ebono_pos/ui/home/model/overide_price_request.dart';
import 'package:ebono_pos/ui/home/model/phone_number_request.dart';
import 'package:ebono_pos/ui/home/model/register_close_request.dart';
import 'package:ebono_pos/ui/home/model/register_open_request.dart';
import 'package:ebono_pos/ui/home/model/resume_hold_cart_request.dart';
import 'package:ebono_pos/ui/home/model/update_cart.dart';
import 'package:ebono_pos/ui/home/repository/home_repository.dart';
import 'package:ebono_pos/ui/login/model/login_request.dart';
import 'package:ebono_pos/ui/login/model/login_response.dart';
import 'package:ebono_pos/ui/login/model/terminal_details_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/health_check_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  late final HomeRepository _homeRepository;
  final SharedPreferenceHelper sharedPreferenceHelper;
  final HiveStorageHelper hiveStorageHelper;

  HomeController(this._homeRepository, this.sharedPreferenceHelper,
      this.hiveStorageHelper);

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
  var cartLines = <CartLine>{}.obs;
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
  var isScanApiError = false.obs;

  /* RxDouble weight = 0.0.obs; // Observable weight value
  late DigitalWeighingScale digitalWeighingScale;
  final int rate = 9600;
  final int timeout = 1000;*/
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
  var isContionueWithOutCustomer = false.obs;
  var isQuantityEmpty = false.obs;
  var isQuantitySelected = false.obs;
  var overideApproverUserId = ''.obs;
  RxList<AllowedPaymentMode> allowedPaymentModes = [AllowedPaymentMode()].obs;

  @override
  void onInit() async {
    _checkConnectivity();
    await readStorageData();
    if (Platform.isLinux) {
      // initializeWeighingScale();
    }
    //  initialResponse();
    super.onInit();
  }

  Future<void> readStorageData() async {
    portName.value = await sharedPreferenceHelper.getPortName() ?? '';
    selectedOutlet.value =
        hiveStorageHelper.read(SharedPreferenceConstants.selectedOutletName);
    selectedOutletId =
        hiveStorageHelper.read(SharedPreferenceConstants.selectedOutletId);
    selectedTerminalId =
        hiveStorageHelper.read(SharedPreferenceConstants.selectedTerminalId);
    selectedTerminal.value =
        hiveStorageHelper.read(SharedPreferenceConstants.selectedTerminalName);
    selectedPosMode.value =
        hiveStorageHelper.read(SharedPreferenceConstants.selectedPosMode);
    customerProxyNumber.value =
        hiveStorageHelper.read(SharedPreferenceConstants.customerProxyNumber);

    registerId.value =
        hiveStorageHelper.read(SharedPreferenceConstants.registerId);

    isQuantityEditEnabled.value =
        hiveStorageHelper.read(SharedPreferenceConstants.isQuantityEditEnabled);
    isLineDeleteEnabled.value =
        hiveStorageHelper.read(SharedPreferenceConstants.isLineDeleteEnabled);
    isEnableHoldCartEnabled.value = hiveStorageHelper
        .read(SharedPreferenceConstants.isEnableHoldCartEnabled);
    isPriceEditEnabled.value =
        hiveStorageHelper.read(SharedPreferenceConstants.isPriceEditEnabled);
    isSalesAssociateLinkEnabled.value = hiveStorageHelper
        .read(SharedPreferenceConstants.isSalesAssociateLinkEnabled);

    final userData =
        hiveStorageHelper.read(SharedPreferenceConstants.userDetails);

    if (userData != null && userData is Map) {
      // Convert Map<dynamic, dynamic> to Map<String, dynamic>
      final userDetailsData = userData.map(
        (key, value) => MapEntry(key.toString(), value),
      );

      userDetails.value = UserDetails.fromJson(
          userDetailsData); // Deserialize JSON to UserDetails
      print(userDetails.value.toJson());
    } else {
      userDetails.value = UserDetails(fullName: '', userType: '', userId: '');
      print('No user details found');
    }

    var allowedModes = hiveStorageHelper
        .read(SharedPreferenceConstants.allowedPaymentModes) as List;
    List<AllowedPaymentMode> allowedPayments = allowedModes.map((item) {
      if (item is Map<String, dynamic>) {
        return AllowedPaymentMode.fromJson(item);
      } else {
        return AllowedPaymentMode.fromJson(Map<String, dynamic>.from(item));
      }
    }).toList();

    allowedPaymentModes.value = allowedPayments;
  }

  /*void initializeWeighingScale() {
    try {
      digitalWeighingScale = DigitalWeighingScale(
        digitalScalePort: portName.value,
        digitalScaleRate: rate,
        weightController: weight,
      );
      digitalWeighingScale.getWeight();
    } on Exception catch (e) {
      print(e);
    }
  }*/

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
      isScanApiError.value = false;
      if (isApiCallInProgress) return;
      isApiCallInProgress = true;

      var response = await _homeRepository.getScanProduct(
        code: code.split("|").first,
        outletId: selectedOutletId,
      );

      if (code.contains("|")) {
        var parts = code.split("|");
        if (parts.length == 2) {
          var partA = parts[0]; // SKU code
          var partB = parts[1]; // Weight or quantity

          scanProductsResponse.value = response;
          scanProductsResponse.value.isWeighedItem = false;
          await addToCartApiCall(
            partA,
            scanProductsResponse.value.isWeighedItem == true ? 0 : 1,
            scanProductsResponse.value.priceList!.first.mrpId,
            scanProductsResponse.value.salesUom,
            cartId.value,
            isWeightedItem: true,
            weight: double.tryParse(partB),
          );
        }
      } else {
        scanProductsResponse.value = response;
        if (cartId.value != "" && (response.priceList?.length ?? 0) <= 1) {
          addToCartApiCall(
            scanProductsResponse.value.skuCode,
            scanProductsResponse.value.isWeighedItem == true ? 0 : 1,
            scanProductsResponse.value.priceList!.first.mrpId,
            scanProductsResponse.value.salesUom,
            cartId.value,
          );
        }
      }
    } catch (error) {
      isScanApiError.value = true;
      scanProductsResponse.value = ScanProductsResponse(
        skuTitle: "Invalid sku_code or code",
        isError: true,
      );
      selectedItemData.value = CartLine();
      Get.snackbar("Error While Scanning", '$error');
    } finally {
      isApiCallInProgress = false;
    }

    // New optimized implementation
    // if (isApiCallInProgress) return;

    // try {
    //   isApiCallInProgress = true;
    //   isScanApiError.value = false;

    //   final parts = code.split("|");
    //   final skuCode = parts[0];
    //   final weight = parts.length > 1
    //       ? double.parse(double.parse(parts[1]).toStringAsFixed(3))
    //       : null;

    //   final response = await _homeRepository.getScanProduct(
    //     code: skuCode,
    //     outletId: selectedOutletId,
    //   );

    //   scanProductsResponse.value = response;

    //   if (cartId.value.isEmpty || (response.priceList?.length ?? 0) > 1) return;

    //   final isWeighted = weight != null;
    //   if (isWeighted) {
    //     scanProductsResponse.value.isWeighedItem = false;
    //   }

    //   await addToCartApiCall(
    //     skuCode,
    //     response.isWeighedItem == true ? 0 : 1,
    //     response.priceList?.first.mrpId,
    //     response.salesUom,
    //     cartId.value,
    //     isWeightedItem: isWeighted,
    //     weight: weight,
    //   );
    // } catch (error) {
    //   isScanApiError.value = true;
    //   scanProductsResponse.value = ScanProductsResponse(
    //     skuTitle: "Invalid sku_code or code",
    //     isError: true,
    //   );
    //   selectedItemData.value = CartLine();
    //   Get.snackbar("Error While Scanning", '$error');
    // } finally {
    //   isApiCallInProgress = false;
    // }
  }

  Future getCustomerDetails() async {
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
      Get.snackbar('Error while fetching customer details', '$e');
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

      hiveStorageHelper.save(SharedPreferenceConstants.sessionCustomerNumber,
          "${customerResponse.value.phoneNumber?.countryCode}${customerResponse.value.phoneNumber?.number}");
      hiveStorageHelper.save(SharedPreferenceConstants.sessionCustomerName,
          customerResponse.value.customerName);

      if (cartId.value.isNotEmpty && isCustomerProxySelected.value) {
        mergeCart(phoneNumber.value);
        isCustomerProxySelected.value = false;
      } else {
        cartId.value = customerResponse.value.cartId.toString();
        hiveStorageHelper.save(SharedPreferenceConstants.cartId, cartId.value);
        fetchCartDetails();
      }
    } catch (e) {
      Get.snackbar('Error while fetching customer data', '$e');
    }
  }

  Future<void> fetchCartDetails({
    bool isWeightedItem = false,
    double? weight,
  }) async {
    cartLines.clear();
    try {
      clearCart();
      var response =
          await _homeRepository.getCart(CartRequest(cartId: cartId.value));
      cartResponse.value = response;
      if (cartResponse.value.cartLines != null &&
          cartResponse.value.cartLines?.isNotEmpty == true) {
        for (var element in cartResponse.value.cartLines!) {
          addCartLine(element);
        }

        isQuantityEmpty.value = cartLines.any((cart) =>
            cart.quantity?.quantityNumber == 0 ||
            cart.quantity?.quantityNumber == 0.0);

        if (response.cartLines?.first.item?.isWeighedItem == true) {
          if (response.cartLines?.first.quantity?.quantityNumber == 0) {
            isQuantitySelected.value = true;
          }
          selectedItemData.value = CartLine(
            cartLineId: response.cartLines?.first.cartLineId,
            item: response.cartLines?.first.item,
            quantity: response.cartLines?.first.quantity,
            unitPrice: response.cartLines?.first.unitPrice,
            mrp: response.cartLines?.first.mrp,
            lineTotal: response.cartLines?.first.lineTotal,
            applicableCartAdjustments:
                response.cartLines?.first.applicableCartAdjustments,
            audit: response.cartLines?.first.audit,
            weightController: TextEditingController(
                text: response.cartLines?.first.quantity?.quantityNumber
                    .toString()),
            weightFocusNode: FocusNode(),
            quantityTextController: TextEditingController(
                text: response.cartLines?.first.quantity?.quantityNumber
                    .toString()),
            quantityFocusNode: FocusNode(),
            priceTextController: TextEditingController(
                text: response.cartLines?.first.quantity?.quantityNumber
                    .toString()),
            priceFocusNode: FocusNode(),
          );

          isApiCallInProgress = false;

          if (isWeightedItem == true) {
            await updateCartItemApiCall(
              response.cartLines?.first.cartLineId,
              response.cartLines?.first.quantity?.quantityUom,
              weight,
            );
          }
        }
      } else {
        selectedItemData.value = CartLine();
        isQuantitySelected.value = false;
      }
    } catch (e) {
      Get.snackbar('Error while fetching cart details', '$e');
    }
  }

  Future<void> mergeCart(String phoneNumber) async {
    cartLines.clear();
    try {
      clearCart();
      var response = await _homeRepository.mergeCart(
          CartRequest(cartId: cartId.value, phoneNumber: phoneNumber));
      cartResponse.value = response;
      if (cartResponse.value.cartLines != null) {
        for (var element in cartResponse.value.cartLines!) {
          addCartLine(element);
        }
      }
    } catch (e) {
      Get.snackbar('Error while merging cart', '$e');
    }
  }

  Future<void> addToCartApiCall(
    String? skuCode,
    int? qty,
    String? mrpId,
    String? qtyUom,
    String? cartId, {
    bool isWeightedItem = false,
    double? weight,
  }) async {
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

      isApiCallInProgress = false;

      await fetchCartDetails(isWeightedItem: isWeightedItem, weight: weight);
    } catch (e) {
      Get.snackbar('Error while adding to cart', '$e');
    }
  }

  Future<void> deleteCartItemApiCall(String? cartLineId) async {
    try {
      var response = await _homeRepository.deleteCartItem(
          DeleteCartRequest(), cartId.value, cartLineId!);
      cartResponse.value = response;
      fetchCartDetails();
      isQuantitySelected.value = false;
      selectedItemData.value = CartLine();
      scanProductsResponse.value = ScanProductsResponse();
    } catch (e) {
      Get.snackbar('Error while deleting item from cart', '$e');
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
      Get.snackbar('Error while updating cart item', '$e');
    } finally {
      isApiCallInProgress = false;
    }
  }

  Future<void> clearFullCart() async {
    try {
      var response = await _homeRepository.clearFullCart(cartId.value);
      generalSuccessResponse.value = response;
      isQuantitySelected.value = false;
      cartId.value = '';
      getCustomerDetailsResponse.value = CustomerDetailsResponse();
      customerResponse.value = CustomerResponse();
      customerName.value = '';
      phoneNumber.value = '';
      cartLines.value = {};
      cartResponse.value = CartResponse();
      isQuantitySelected.value = false;
      selectedItemData.value = CartLine();
      scanProductsResponse.value = ScanProductsResponse();
      Get.snackbar('Cart cleared successfully', 'All items removed');
    } catch (e) {
      Get.snackbar('Error while clearing full cart', '$e');
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
      cartLines.value = {};
      cartResponse.value = CartResponse();
      selectedItemData.value = CartLine();
      scanProductsResponse.value = ScanProductsResponse();
      Get.snackbar('Cart held successfully', 'Cart saved for later!');
    } catch (e) {
      Get.snackbar('Error while holding cart', '$e');
    }
  }

  Future<void> resumeHoldCartApiCall(String? id) async {
    try {
      var response = await _homeRepository.resumeHoldCart(
          cartId.value,
          ResumeHoldCartRequest(
              terminalId:
                  "${hiveStorageHelper.read(SharedPreferenceConstants.selectedTerminalId)}",
              holdCartId: id));
      cartResponse.value = response;
      if (cartResponse.value != null) {
        /* resetting the exsisting state */
        isCustomerProxySelected.value = true;
        clearHoldCartOrders();
        selectedTabButton.value = 2;
      }
    } catch (e) {
      Get.snackbar('Error while resuming cart', '$e');
    }
  }

  Future<void> healthCheckApiCall() async {
    _statusCheckTimer = Timer.periodic(
      const Duration(seconds: 600),
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
          Get.snackbar('Error while checking health', '$e');

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
              "${hiveStorageHelper.read(SharedPreferenceConstants.selectedOutletId)}",
          terminalId:
              "${hiveStorageHelper.read(SharedPreferenceConstants.selectedTerminalId)}",
          userId: userId,
          floatCash: int.tryParse(openFloatPayment.value)));
      openRegisterResponse.value = response;
      hiveStorageHelper.save(SharedPreferenceConstants.registerId,
          openRegisterResponse.value.registerId ?? "");
      hiveStorageHelper.save(SharedPreferenceConstants.registerTransactionId,
          openRegisterResponse.value.registerTransactionId ?? "");
      registerId.value = openRegisterResponse.value.registerId ?? "";
      openFloatPayment.value = '';
      selectedTabButton.value = 2;
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Error while opening register', '$e');
      isLoading.value = false;
    }
  }

  Future<void> closeRegisterApiCall() async {
    var userId = await sharedPreferenceHelper.getUserID();
    isLoading.value = true;
    try {
      var response = await _homeRepository.closeRegister(RegisterCloseRequest(
        outletId:
            "${hiveStorageHelper.read(SharedPreferenceConstants.selectedOutletId)}",
        registerId:
            "${hiveStorageHelper.read(SharedPreferenceConstants.registerId)}",
        terminalId:
            "${hiveStorageHelper.read(SharedPreferenceConstants.selectedTerminalId)}",
        userId: userId,
        registerTransactionId: hiveStorageHelper
            .read(SharedPreferenceConstants.registerTransactionId),
        transactionSummary: allowedPaymentModes
            .map((mode) {
              switch (mode.paymentOptionCode) {
                case 'CASH':
                  return TransactionSummary(
                    paymentOptionId: mode.paymentOptionId,
                    paymentOptionCode: mode.paymentOptionCode,
                    pspId: mode.pspId,
                    pspName: mode.pspName,
                    chargeSlipCount: null,
                    totalTransactionAmount: TotalTransactionAmount(
                      centAmount: int.tryParse(cashPayment.value) ?? 0,
                      fraction: 1,
                      currency: "INR",
                    ),
                  );
                case 'CARD':
                  return TransactionSummary(
                    paymentOptionId: mode.paymentOptionId,
                    paymentOptionCode: mode.paymentOptionCode,
                    pspId: mode.pspId,
                    pspName: mode.pspName,
                    chargeSlipCount: int.tryParse(cardPaymentCount.value) ?? 0,
                    totalTransactionAmount: TotalTransactionAmount(
                      centAmount: int.tryParse(cardPayment.value) ?? 0,
                      fraction: 1,
                      currency: "INR",
                    ),
                  );
                case 'UPI':
                  return TransactionSummary(
                    paymentOptionId: mode.paymentOptionId,
                    paymentOptionCode: mode.paymentOptionCode,
                    pspId: mode.pspId,
                    pspName: mode.pspName,
                    chargeSlipCount: int.tryParse(upiPaymentCount.value) ?? 0,
                    totalTransactionAmount: TotalTransactionAmount(
                      centAmount: int.tryParse(upiPayment.value) ?? 0,
                      fraction: 1,
                      currency: "INR",
                    ),
                  );
                default:
                  return null; // Ignore unsupported payment modes
              }
            })
            .whereType<TransactionSummary>()
            .toList(),
      ));

      closeRegisterResponse.value = response;
      if (closeRegisterResponse.value.success == true) {
        hiveStorageHelper.save(SharedPreferenceConstants.registerId, "");
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
      Get.snackbar('Error while closing register', '$e');
    }
  }

  void addOrdersOnHoldItems(OnHoldItems onHoldItems) {
    var item = OnHoldItems(
      customer: HoldOrderCustomer(
        customerName: onHoldItems.customer?.customerName,
      ),
      holdCartId: onHoldItems.holdCartId,
      createdAt: onHoldItems.createdAt,
      cashierDetails: CashierDetails(
        cashierId: onHoldItems.cashierDetails?.cashierId,
        cashierName: onHoldItems.cashierDetails?.cashierName,
      ),
      phoneNumber: HoldOrderPhoneNumber(
        countryCode: onHoldItems.phoneNumber?.countryCode,
        number: onHoldItems.phoneNumber?.number,
      ),
    );
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
              "${hiveStorageHelper.read(SharedPreferenceConstants.selectedOutletId)}"));
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
      Get.snackbar('Error while fetching hold orders', '$e');
    }
  }

  Future<void> getAuthorisation(String username, String password) async {
    try {
      var response = await _homeRepository.getAuthorisation(
          LoginRequest(userName: username, password: password));
      if (response.userId != null && response.userId?.isNotEmpty == true) {
        overideApproverUserId.value = response.userId!;
      }
    } catch (e) {
      Get.snackbar('Error while authorizing', '$e');
    }
  }

  Future<CartResponse?> overridePrice(OverRidePriceRequest request) async {
    late CartResponse? response;
    try {
      response = await _homeRepository.overridePrice(request);
      cartResponse.value = response;
      overideApproverUserId.value = '';
      fetchCartDetails();
    } catch (e) {
      response = null;
      Get.snackbar('Error while overriding price', '$e');
    }
    return response;
  }

  @override
  void onClose() {
    _statusCheckTimer?.cancel();
    // digitalWeighingScale.dispose();
    super.onClose();
  }

  void clearDataAndLogout() {
    sharedPreferenceHelper.clearAll();
    hiveStorageHelper.clear();
    Get.offAllNamed(PageRoutes.login);
  }
}
