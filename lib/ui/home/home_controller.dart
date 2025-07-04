import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ebono_pos/api/api_helper.dart';
import 'package:ebono_pos/api/broadcast.dart';
import 'package:ebono_pos/constants/shared_preference_constants.dart';
import 'package:ebono_pos/data_store/hive_storage_helper.dart';
import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/models/cart_response.dart';
import 'package:ebono_pos/models/coupon_details.dart';
import 'package:ebono_pos/models/customer_response.dart';
import 'package:ebono_pos/models/pos_metrics_payload.dart';
import 'package:ebono_pos/models/scan_products_response.dart';
import 'package:ebono_pos/models/udp_response.dart';
import 'package:ebono_pos/navigation/page_routes.dart';
import 'package:ebono_pos/ui/common_widgets/show_stopper_widget.dart';
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
import 'package:ebono_pos/ui/home/model/register_close_request.dart';
import 'package:ebono_pos/ui/home/model/register_open_request.dart';
import 'package:ebono_pos/ui/home/model/resume_hold_cart_request.dart';
import 'package:ebono_pos/ui/home/model/terminal_transaction_request.dart';
import 'package:ebono_pos/ui/home/model/update_cart.dart';
import 'package:ebono_pos/ui/home/repository/home_repository.dart';
import 'package:ebono_pos/ui/login/model/login_request.dart';
import 'package:ebono_pos/ui/login/model/login_response.dart';
import 'package:ebono_pos/ui/login/model/terminal_details_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/health_check_response.dart';
import 'package:ebono_pos/widgets/error_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../utils/logger.dart';
import '../payment_summary/weighing_scale_service.dart';

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
  var registerTransactionId = ''.obs;
  var clearWeightOnSuccess = false.obs;

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
  RxString customerProxyName = ''.obs;
  RxString otpNumber = ''.obs;

  /* OTP Related */
  var displayOTPScreen = false.obs;
  var resendOTPBtnEnabled = false.obs;
  var isResendOTPRequested = false.obs;
  var isOTPVerified = false.obs;
  var isOTPResendingOrVerifying = false.obs;
  var otpErrorMessage = ''.obs;
  var triggerCustomOTPValidation = false.obs;
  var isOTPTriggering = false.obs;
  var resendOTPCount = 0.obs;

  var isScanApiError = false.obs;
  var isAutoWeighDetection = false.obs;
  var isReturnViewReset = false.obs;

  /* wallet redeem */
  var isOTPError = false.obs;

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
  var isOnline = true.obs;
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
  var couponDetails = ''.obs;
  var pointedTo = 'LOCAL'.obs;
  var isHealthChkDialogOpen = false.obs;

  /* Loaders */
  var isRegisterApiLoading = false.obs;
  var isContinueWithOutCustomerBtnLoading = false.obs;
  var isSearchCustomerBtnLoading = false.obs;
  var isSelectOrAddCustomerBtnLoading = false.obs;

  RxList<AllowedPaymentMode> allowedPaymentModes = [AllowedPaymentMode()].obs;
  List<TransactionSummary> transactionSummaryList = [];

  // payment
  var orderNumber = ''.obs;

  final _logoutDialogController = StreamController<bool>.broadcast();

  Stream<bool> get logoutDialogStream => _logoutDialogController.stream;

  var pointingTo = 'LOCAl'.obs;

  // completer to track if we're in the process of showing a dialog
  Completer<void>? _healthCheckDialogCompleter;

  RxInt healthCheckFailCount = 0.obs;
  var paymentProvider = ''.obs;

  void notifyDialogClosed() {
    _logoutDialogController.add(true);
  }

  @override
  void onInit() async {
    _checkConnectivity();
    await readStorageData();
    if (pointedTo.value == 'LOCAL') await _setupUdpBroadcastListener();
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
    customerProxyName.value =
        hiveStorageHelper.read(SharedPreferenceConstants.customerProxyName);

    registerId.value =
        hiveStorageHelper.read(SharedPreferenceConstants.registerId);
    registerTransactionId.value =
        hiveStorageHelper.read(SharedPreferenceConstants.registerTransactionId);

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
    pointingTo.value = await sharedPreferenceHelper.pointingTo();

    final userData =
        hiveStorageHelper.read(SharedPreferenceConstants.userDetails);

    paymentProvider.value = hiveStorageHelper.read(
          SharedPreferenceConstants.paymentProvider,
        ) ??
        '';

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

  /// Set up UDP broadcast listener for network communication
  ///
  /// This method:
  /// 1. Gets available broadcast addresses
  /// 2. Starts listening on the first available broadcast address
  /// 3. Sets up message handling for incoming broadcasts
  Future<void> _setupUdpBroadcastListener() async {
    if (pointedTo.value != 'LOCAL') return;
    try {
      await UdpBroadcastManager.listenForUdpBroadcast(
        port: 9999,
        onMessage: _handleIncomingBroadcast,
      );
    } catch (e, stack) {
      print('❌ Failed to setup UDP broadcast listener: $e');

      // Optionally show user-friendly error
      if (e is UnsupportedError) {
        print('💡 This platform is not supported for UDP broadcasting');
      } else {
        print('💡 Check network connectivity and permissions');
      }

      Logger.logException(
        eventType: 'EXCEPTION : BROADCAST',
        error: e.toString(),
        stackTrace: stack.toString(),
      );
    }
  }

  /// Handle incoming UDP broadcast messages
  ///
  /// This is called whenever a UDP broadcast is received
  /// Add your business logic here based on the message content
  void _handleIncomingBroadcast(String message, InternetAddress sender) async {
    if (pointedTo.value != 'LOCAL') return;
    // Ensure controller is still active
    if (isClosed) {
      print('⚠️ Controller disposed, ignoring broadcast message');
      return;
    }

    print('📥 Processing broadcast: "$message" from ${sender.address}');

    try {
      // Decode JSON message into a Map
      final decoded = jsonDecode(message);

      // Create UDPBroadCaseResponse from decoded map
      UDPBroadCaseResponse udpBroadCaseResponse = UDPBroadCaseResponse.fromMap(
        decoded,
      );

      final weighingScaleService = Get.find<WeighingScaleService>();

      if (udpBroadCaseResponse.event == 'SEND_POS_APP_METRICS') {
        print('✅ Decoded event: ${udpBroadCaseResponse.event}');
        print('📦 Payload: ${udpBroadCaseResponse.payload.toMap()}');

        final info = await PackageInfo.fromPlatform();
        final appVersion = info.version;

        _homeRepository.sendPosMetrics(
            payload: PosMetricsPayload(
          appVersion: appVersion,
          currentCartId: cartResponse.value.cartId ?? '',
          dmsId: udpBroadCaseResponse.payload.dmsId,
          edcType: paymentProvider.value,
          lastOrderAt: hiveStorageHelper.read(
                SharedPreferenceConstants.lastOrderAt,
              ) ??
              '',
          macAddress:
              await UdpBroadcastManager.instance.getPrimaryMacAddress() ?? '',
          outletId: udpBroadCaseResponse.payload.outletId,
          triggerType: udpBroadCaseResponse.payload.triggerType,
          registerId: registerId.value,
          terminalId: selectedTerminal.value,
          type: 'CLIENT',
          upstreamType: pointedTo.value,
          userId: userDetails.value.userId,
          weighingScaleStatus: await weighingScaleService.isScaleConnected()
              ? 'Available'
              : 'Not Available',
        ));
      }
    } catch (e, stack) {
      print('❌ Failed to decode UDP broadcast message: $e $stack');

      Logger.logException(
        eventType: 'EXCEPTION: Failed to decode UDP broadcast message',
        error: e.toString(),
        stackTrace: stack.toString(),
      );
    }
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
      pointedTo.value = await sharedPreferenceHelper.pointingTo();

      if (pointedTo.value == 'LOCAL') _updateConnectionStatus(result);
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
    await hiveStorageHelper.remove(SharedPreferenceConstants.cartId);
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
    await hiveStorageHelper.remove(SharedPreferenceConstants.cartId);
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
        code: code.split("W").first.trim(),
        outletId: selectedOutletId,
      );

      if (code.contains("W")) {
        var parts = code.split("W");
        if (parts.length == 2) {
          var partA = parts[0]; // SKU code
          var partB = parts[1]; // Weight or quantity

          scanProductsResponse.value = response;
          scanProductsResponse.value.isWeighedItem = false;
          await addToCartApiCall(
            partA,
            partB,
            scanProductsResponse.value.priceList!.first.mrpId,
            scanProductsResponse.value.salesUom,
            cartId.value,
            isWeightedItem: true,
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
        skuTitle: "Invalid Code",
        isError: true,
      );
      selectedItemData.value = CartLine();
      if (error.toString().contains("SHOW_STOPPER")) {
        await showStopperError(errorMessage: error.toString().split('::').last);
      } else {
        Get.snackbar("Error While Scanning", '$error');
      }
    } finally {
      isApiCallInProgress = false;
    }
  }

  Future getCustomerDetails({
    bool isFromCustomerScreen = false,
  }) async {
    try {
      /* handling loader in customer dialog */
      isSearchCustomerBtnLoading.value = isFromCustomerScreen == true;

      var response =
          await _homeRepository.getCustomerDetails(phoneNumber.value);
      getCustomerDetailsResponse.value = response;
      if (getCustomerDetailsResponse.value.customerName?.isNotEmpty == true) {
        customerName.value = '';
        customerName.value =
            getCustomerDetailsResponse.value.customerName.toString();
      }
      // fetchCartDetails();
    } catch (e) {
      Get.snackbar('Error while fetching customer details', '$e');
    } finally {
      isSearchCustomerBtnLoading.value = false;
    }
  }

  fetchCustomer({
    bool showOTPScreen = false,
    bool isFromReturns = false,
    bool isContinueWithOutCustomer = false,
    bool isSelectOrAddCustomer = false,
    bool isFromResumeHoldCart = false,
  }) async {
    try {
      /* adding loader if cashier clicks on continue with out customer btn*/
      isContinueWithOutCustomerBtnLoading.value =
          isContinueWithOutCustomer == true;
      isSelectOrAddCustomerBtnLoading.value = isSelectOrAddCustomer == true;

      final skipMergeCart =
          customerResponse.value.phoneNumber?.number == phoneNumber.value;
      var response = await _homeRepository.fetchCustomer(CustomerRequest(
          phoneNumber: phoneNumber.value,
          customerName: isFromResumeHoldCart ? null : customerName.value,
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
      customerName.value = customerResponse.value.customerName ?? '';

      if (showOTPScreen) {
        displayOTPScreen.value = true;
      }
      if (!isFromReturns) {
        if (cartId.value.isNotEmpty &&
            isCustomerProxySelected.value &&
            !skipMergeCart) {
          mergeCart(phoneNumber.value);
          isCustomerProxySelected.value = false;
        } else {
          cartId.value = customerResponse.value.cartId.toString();
          await hiveStorageHelper.remove(SharedPreferenceConstants.cartId);
          await hiveStorageHelper.save(
              SharedPreferenceConstants.cartId, response.cartId);
          fetchCartDetails();
        }
      }
    } catch (e) {
      Get.snackbar('Error while fetching customer data', '$e');
    } finally {
      isContinueWithOutCustomerBtnLoading.value = false;
      isSelectOrAddCustomerBtnLoading.value = false;
    }
  }

  Future<void> fetchCartDetails() async {
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
        }
      } else {
        selectedItemData.value = CartLine();
        isQuantitySelected.value = false;
      }
    } catch (e) {
      Get.snackbar('Error while fetching cart details', '$e');
    } finally {
      isApiCallInProgress = false;
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
    dynamic qty,
    String? mrpId,
    String? qtyUom,
    String? cartId, {
    bool isWeightedItem = false,
  }) async {
    try {
      var response = await _homeRepository.addToCart(
        AddToCartRequest(cartLines: [
          AddToCartCartLine(
            skuCode: skuCode,
            quantity: AddToCartQuantity(
              quantityNumber: qty,
              quantityUom: qtyUom,
              isWeighedItem: isWeightedItem,
            ),
            mrpId: mrpId,
          )
        ]),
        cartId,
      );

      cartResponse.value = response;

      /* checking for cart line errors */
      if (response.cartAlerts.isNotEmpty &&
          response.cartAlerts.first.errorCode == "SHOW_STOPPER") {
        await showStopperError(
          errorMessage: response.cartAlerts.first.message,
          isScanApiError: false,
        );

        return;
      }

      isApiCallInProgress = false;

      await fetchCartDetails();
    } catch (e) {
      Get.snackbar('Error while adding to cart', '$e');
    } finally {
      isApiCallInProgress = false;
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

      /* checking for cart line errors */
      if (response.cartAlerts.isNotEmpty &&
          response.cartAlerts.first.errorCode == "SHOW_STOPPER") {
        await showStopperError(
          errorMessage: response.cartAlerts.first.message,
          isScanApiError: false,
        );

        return;
      }

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
      await hiveStorageHelper.remove(SharedPreferenceConstants.cartId);
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
        cartId: cartId.value,
        customerRequest: CustomerRequest(
          customerName: customerResponse.value.customerName,
          phoneNumber: customerResponse.value.phoneNumber!.number,
        ),
      );
      generalSuccessResponse.value = response;
      cartId.value = '';
      await hiveStorageHelper.remove(SharedPreferenceConstants.cartId);
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

  Future<void> resumeHoldCartApiCall({String? id, String? mobileNumber}) async {
    try {
      var response = await _homeRepository.resumeHoldCart(
          id!,
          ResumeHoldCartRequest(
              terminalId:
                  "${hiveStorageHelper.read(SharedPreferenceConstants.selectedTerminalId)}",
              holdCartId: id));
      /* resetting the existing state */
      cartId.value = response.cartId ?? '';
      await hiveStorageHelper.remove(SharedPreferenceConstants.cartId);
      await hiveStorageHelper.save(
          SharedPreferenceConstants.cartId, response.cartId);
      phoneNumber.value = mobileNumber ?? '';
      selectedTabButton.value = 2;
      getCustomerDetails();
      fetchCustomer(isFromResumeHoldCart: true);
      clearHoldCartOrders();
    } catch (e) {
      Get.snackbar('Error while resuming cart', '$e');
    }
  }

  Future<void> healthCheckApiCall() async {
    _statusCheckTimer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) async {
        // Skip this cycle if we're already processing a health check failure
        if (_healthCheckDialogCompleter != null) {
          return;
        }

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
            healthCheckFailCount.value = 0;
          } else {
            ++healthCheckFailCount.value;
            isOnline.value = false;
          }
        } catch (e) {
          ++healthCheckFailCount.value;
          isOnline.value = false;
        }

        if (healthCheckFailCount.value > 3) {
          isOnline.value = false;
          // Show dialog exactly once
          showHealthCheckDialog();
          // Cancel timer immediately to prevent further checks
          timer.cancel();
        }
      },
    );
  }

  void showHealthCheckDialog() {
    // Ensure we don't show dialog if already showing or in process
    if (_healthCheckDialogCompleter != null ||
        Get.currentRoute == PageRoutes.login ||
        isHealthChkDialogOpen.value) {
      return;
    }

    // Create new completer to track this dialog session
    _healthCheckDialogCompleter = Completer<void>();
    isHealthChkDialogOpen.value = true;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ErrorDialogWidget(
          height: 0.41,
          onPressed: () {
            // Cleanup and logout
            final apiHelper = Get.find<ApiHelper>();
            apiHelper.cancelAllRequests();
            _statusCheckTimer?.cancel();
            isHealthChkDialogOpen.value = false;
            _healthCheckDialogCompleter?.complete();
            _healthCheckDialogCompleter = null;
            clearDataAndLogout();
          },
          errorMessage: 'Local service is down please press OK to login again',
          iconWidget: const Icon(
            Icons.warning_rounded,
            color: Colors.amber,
            size: 120,
          ),
        ),
      ),
      barrierDismissible: false,
      useSafeArea: false,
    );
  }

  Future<void> openRegisterApiCall() async {
    var userId = await sharedPreferenceHelper.getUserID();

    isRegisterApiLoading.value = true;
    try {
      var response = await _homeRepository.openRegister(RegisterOpenRequest(
          outletId:
              "${hiveStorageHelper.read(SharedPreferenceConstants.selectedOutletId)}",
          terminalId:
              "${hiveStorageHelper.read(SharedPreferenceConstants.selectedTerminalId)}",
          userId: userId,
          floatCash: int.tryParse(openFloatPayment.value)));
      print("openRegisterResponse: ${response.toJson()}");
      openRegisterResponse.value = response;
      hiveStorageHelper.save(SharedPreferenceConstants.registerId,
          openRegisterResponse.value.registerId ?? "");
      hiveStorageHelper.save(SharedPreferenceConstants.registerTransactionId,
          openRegisterResponse.value.registerTransactionId ?? "");
      registerId.value = openRegisterResponse.value.registerId ?? "";
      registerTransactionId.value =
          openRegisterResponse.value.registerTransactionId ?? "";
      openFloatPayment.value = '';
      selectedTabButton.value = 2;
    } catch (e, stack) {
      print("error: $e $stack");
      Get.snackbar('Error while opening register', '$e');
    } finally {
      isRegisterApiLoading.value = false;
    }
  }

  Future<void> closeRegisterApiCall() async {
    var userId = await sharedPreferenceHelper.getUserID();
    isRegisterApiLoading.value = true;
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
                case 'STATIC_QR_CODE':
                  if (transactionSummaryList.isNotEmpty &&
                      transactionSummaryList.first.pspId != null) {
                    return TransactionSummary(
                      paymentOptionId: mode.paymentOptionId,
                      paymentOptionCode: mode.paymentOptionCode,
                      pspId: mode.pspId,
                      pspName: mode.pspName,
                      chargeSlipCount: int.tryParse(transactionSummaryList
                              .first.chargeSlipCount
                              .toString()) ??
                          0,
                      totalTransactionAmount:
                          transactionSummaryList.first.totalTransactionAmount,
                    );
                  }
                  return null;
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
        hiveStorageHelper.save(
            SharedPreferenceConstants.registerTransactionId, "");
        registerId.value = "";
        registerTransactionId.value = "";
        upiPayment.value = '';
        upiPaymentCount.value = '';
        cardPayment.value = '';
        cardPaymentCount.value = '';
        cashPayment.value = '';
        selectedTabButton.value = 2;
        transactionSummaryList.clear();
      }
    } catch (e, stack) {
      print("error: $e $stack");
      Get.snackbar('Error while closing register', '$e');
    } finally {
      isRegisterApiLoading.value = false;
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

  Future<CartResponse?> addOrRemoveCoupon({
    required String coupon,
    required bool isRemoveCoupon,
  }) async {
    late CartResponse? response;
    try {
      response = await _homeRepository.applyORRemoveCoupon(
        isRemoveCoupon: isRemoveCoupon,
        coupon: CouponDetails(couponCode: coupon),
      );

      cartResponse.value = response;
      overideApproverUserId.value = '';
      fetchCartDetails();
    } catch (e) {
      response = null;
      print("error: $e");
      if (e.toString().contains('SHOW_STOPPER')) {
        await showStopperError(errorMessage: e.toString().split('::').last);
      } else {
        Get.snackbar(
          'Error while ${isRemoveCoupon ? 'removing' : 'applying'} coupon',
          '$e',
        );
      }
    }
    return response;
  }

  Future<void> generateORValidateOTP({
    required bool tiggerOTP,
    required String phoneNumber,
    required String otp,
    required bool isResendOTP,
    bool disableLoading = false,
  }) async {
    try {
      /* check to count otp's resent and restrict */
      if (isResendOTP) resendOTPCount.value++;

      otpErrorMessage.value = '';
      isOTPVerified.value = false;
      triggerCustomOTPValidation.value = false;

      if (resendOTPCount.value > 2 &&
          (isResendOTP == true || tiggerOTP == true)) {
        return;
      }

      /* to show loader when resend otp is triggered */
      isOTPResendingOrVerifying.value = !disableLoading;
      /* to show loader while manually triggering otp */
      isOTPTriggering.value = true;

      final result = await _homeRepository.generateORValidateOTP(
        tiggerOTP: tiggerOTP,
        phoneNumber: phoneNumber,
        otp: otp,
      );

      if (isResendOTP == false && tiggerOTP == false) {
        isOTPVerified.value = result;
      }
    } catch (error) {
      isOTPVerified.value = false;
      otpErrorMessage.value =
          error.toString().split('|').lastOrNull ?? error.toString();
      triggerCustomOTPValidation.value = true;
    } finally {
      isOTPResendingOrVerifying.value = false;
      isOTPTriggering.value = false;
      isOTPVerified.value = false;
    }
  }

  Future<List<TransactionSummary>> getTerminalTransactions() async {
    try {
      AllowedPaymentMode staticQrPaymentMode = allowedPaymentModes.firstWhere(
        (mode) => mode.paymentOptionCode == 'STATIC_QR_CODE',
        orElse: () => AllowedPaymentMode(),
      );

      final result = await _homeRepository.fetchTerminalTransactions(
          payload: TerminalTransactionRequest(
        outletId: selectedOutletId,
        paymentMethods: [staticQrPaymentMode.paymentOptionId.toString()],
        registerId: registerId.value,
        registerTransactionId: registerTransactionId.value,
        terminalId: selectedTerminalId,
      ));

      transactionSummaryList = result;

      return result;
    } catch (error) {
      Get.snackbar('Error while fetching terminal transactions', '$error');
      return [];
    }
  }

  @override
  void onClose() {
    _statusCheckTimer?.cancel();
    _logoutDialogController.close();
    closeUdpSocketConnection();
    // digitalWeighingScale.dispose();
    super.onClose();
  }

  void clearDataAndLogout() {
    // Cancel ongoing operations first
    final apiHelper = Get.find<ApiHelper>();
    _statusCheckTimer?.cancel();
    apiHelper.cancelAllRequests();

    // Close snack bars
    Get.closeAllSnackbars();

    // Force close ALL overlays including dialogs by using a more reliable approach
    if (Get.overlayContext != null) {
      // This will pop everything until we reach the first route
      Navigator.of(Get.overlayContext!, rootNavigator: true)
          .popUntil((route) => route.isFirst);
    }

    // Add a small delay to ensure UI has updated before proceeding
    Future.delayed(Duration(milliseconds: 100), () {
      // Clear data
      sharedPreferenceHelper.clearAll();
      hiveStorageHelper.clear();

      // Navigate to login with replacement
      Get.offAllNamed(PageRoutes.login);
    });
  }

  void closeUdpSocketConnection() async {
    await closeUdpSocket();
  }

  @override
  void dispose() {
    _statusCheckTimer?.cancel();
    closeUdpSocketConnection();
    clearDataAndLogout();
    super.dispose();
  }
}
