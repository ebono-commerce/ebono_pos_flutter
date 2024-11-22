import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import 'package:kpn_pos_application/ui/home/model/general_success_response.dart';
import 'package:kpn_pos_application/ui/home/model/phone_number_request.dart';
import 'package:kpn_pos_application/ui/home/model/update_cart.dart';
import 'package:kpn_pos_application/ui/home/repository/home_repository.dart';
import 'package:kpn_pos_application/ui/login/model/login_response.dart';
import 'package:kpn_pos_application/utils/digital_weighing_scale.dart';

class HomeController extends GetxController {
  late final HomeRepository _homeRepository;
  final SharedPreferenceHelper sharedPreferenceHelper;

  HomeController(this._homeRepository, this.sharedPreferenceHelper);

  var isLoading = false.obs;

  var phoneNumber = ''.obs;
  var customerName = ''.obs;
  var scanCode = ''.obs;
  var cartId = ''.obs;
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

      // Note Please clear when order success
      GetStorageHelper.save(SharedPreferenceConstants.cartId, cartId.value);
      GetStorageHelper.save(SharedPreferenceConstants.sessionCustomerNumber,
          "${customerResponse.value.phoneNumber?.countryCode}${customerResponse.value.phoneNumber?.number}");
      GetStorageHelper.save(SharedPreferenceConstants.sessionCustomerName,
          customerResponse.value.customerName);

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

  Future<void> clearFullCart() async {
    print("API clearFullCart: ${cartId.value} ");
    try {
      var response = await _homeRepository.clearFullCart(cartId.value);
      cartResponse.value = response;
      fetchCartDetails();
    } catch (e) {
      print("Error $e");
    } finally {
      print("Error");
    }
  }

  Future<void> holdCartApiCall() async {
    print("API holdCartApiCall: ");
    try {
      var response = await _homeRepository.holdCart(
          cartId.value, PhoneNumberRequest(phoneNumber: phoneNumber.value));
      generalSuccessResponse.value = response;
      fetchCartDetails();
    } catch (e) {
      print("Error $e");
    } finally {
      print("Error");
    }
  }

  Future<void> resumeHoldCartApiCall() async {
    print("API resumeHoldCartApiCall: ");
    try {
      var response = await _homeRepository.resumeHoldCart(
          cartId.value, ResumeHoldCartRequest(terminalId: "", holdCartId: ""));
      generalSuccessResponse.value = response;
    } catch (e) {
      print("Error $e");
    } finally {
      print("Error");
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
