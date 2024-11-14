import 'package:get/get.dart';
import 'package:kpn_pos_application/api/api_helper.dart';
import 'package:kpn_pos_application/models/cart_response.dart';
import 'package:kpn_pos_application/models/customer_response.dart';
import 'package:kpn_pos_application/models/scan_products_response.dart';
import 'package:kpn_pos_application/ui/home/model/add_to_cart.dart';
import 'package:kpn_pos_application/ui/home/model/cart_request.dart';
import 'package:kpn_pos_application/ui/home/model/customer_request.dart';
import 'package:kpn_pos_application/ui/home/model/delete_cart.dart';
import 'package:kpn_pos_application/ui/home/model/update_cart.dart';
import 'package:kpn_pos_application/ui/home/repository/home_repository.dart';

class HomeController extends GetxController {
  late final HomeRepository _homeRepository;
  late final ApiHelper _apiHelper;

  HomeController(this._homeRepository, this._apiHelper);

  var isLoading = false.obs;

  var phoneNumber = ''.obs;
  var customerName = ''.obs;
  var scanCode = ''.obs;
  var cartId = ''.obs;
  var isDisplayAddCustomerView = true.obs;

  var cartLines = <CartLine>[].obs;

  var scanProductsResponse = ScanProductsResponse().obs;
  var customerResponse = CustomerResponse().obs;
  var cartResponse = CartResponse().obs;

  @override
  void onInit() {
    super.onInit();
    initialResponse();
  }

  void addCartLine(CartLine cartLine) {
    cartLines.add(cartLine);
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
      var response = await _homeRepository.getScanProduct(code);
      scanProductsResponse.value = response;
      if (response != null) {
        if (cartId.value != "") {
          addToCartApiCall(
              scanProductsResponse.value.esin,
              1,
              scanProductsResponse.value.priceList!.first.mrpId,
              scanProductsResponse.value.salesUom,
              cartId.value);
        }
      }
    } catch (e) {
      print("Error $e");
    } finally {
      print("Error");
    }
  }

  Future<void> fetchCustomer() async {
    print("API fetchCustomer: ${phoneNumber.value}");
    try {
      var response = await _homeRepository.fetchCustomer(CustomerRequest(
          phoneNumber: phoneNumber.value,
          customerName: customerName.value,
          cartType: 'POS',
          outletId: "OCHNMYL01"));
      if (response != null) {
        customerResponse.value = response;
        cartId.value = customerResponse.value.cartId.toString();
        customerName.value = customerResponse.value.customerName.toString();
        fetchCartCall();
      }
    } catch (e) {
      print("Error $e");
    } finally {
      print("Error");
    }
  }

  Future<void> fetchCartCall() async {
    print("API fetchCartCall: ${cartId.value}");

    cartLines.value.clear();
    try {
      clearCart();
      var response =
          await _homeRepository.getCart(CartRequest(cartId: cartId.value));
      if (response != null) {
        cartResponse.value = response;
        if (cartResponse.value.cartLines != null) {
          for (var element in cartResponse.value.cartLines!) {
            addCartLine(element);
          }
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
      if (response != null) {
        cartResponse.value = response;
        fetchCartCall();
      }
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
      if (response != null) {
        cartResponse.value = response;
        fetchCartCall();
      }
    } catch (e) {
      print("Error $e");
    } finally {
      print("Error");
    }
  }

  Future<void> updateCartItemApiCall(String? cartLineId, String? qUom,
      double? qty) async {
    print("API updateCartItemApiCall: $qty | $cartLineId");
    try {
      var response = await _homeRepository.updateCartItem(
          UpdateCartRequest(
              quantity: UpdateQuantity(quantityNumber: qty, quantityUom: qUom)),
          cartId.value,
          cartLineId!);
      if (response != null) {
        cartResponse.value = response;
        fetchCartCall();
      }
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
