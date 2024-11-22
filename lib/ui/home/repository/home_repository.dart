import 'dart:convert';

import 'package:kpn_pos_application/api/api_constants.dart';
import 'package:kpn_pos_application/api/api_helper.dart';
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

class HomeRepository {
  final ApiHelper _apiHelper;

  HomeRepository(this._apiHelper);

  Future<CustomerDetailsResponse> getCustomerDetails(String phoneNumber) async {
    try {
      final response = await _apiHelper.get(
        ApiConstants.getCustomerDetails,
        queryParameters: {
          'phone_number': phoneNumber,
        },
      );
      final customerDetailsResponse =
          customerDetailsResponseFromJson(jsonEncode(response));
      return customerDetailsResponse;
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<CustomerResponse> fetchCustomer(CustomerRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.fetchCustomer,
        data: request.toJson(),
      );
      final customerResponse = customerResponseFromJson(jsonEncode(response));
      return customerResponse;
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<ScanProductsResponse> getScanProduct(
      {required String code, required String outletId}) async {
    try {
      final response = await _apiHelper.get(
        queryParameters: {
          'code': code,
          'outlet_id': outletId,
        },
        ApiConstants.scanProducts,
      );
      final scanProductsResponse =
          scanProductsResponseFromJson(jsonEncode(response));
      return scanProductsResponse;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<CartResponse> getCart(CartRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.fetchCart,
        data: request.toJson(),
      );
      final cartResponse = cartResponseFromJson(jsonEncode(response));
      return cartResponse;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future<CartResponse> addToCart(
      AddToCartRequest request, String? cartId) async {
    try {
      final response = await _apiHelper.post(
        '${ApiConstants.addToCart}$cartId/items',
        data: request.toJson(),
      );
      final cartResponse = cartResponseFromJson(jsonEncode(response));
      return cartResponse;
    } catch (e) {
      throw Exception('Failed to parse data');
    }
  }

  Future<CartResponse> deleteCartItem(
      DeleteCartRequest request, String cartId, String cartLineId) async {
    try {
      final response = await _apiHelper.delete(
        '${ApiConstants.deleteFromCart}$cartId/cart-line/$cartLineId',
        data: {},
      );
      final cartResponse = cartResponseFromJson(jsonEncode(response));
      return cartResponse;
    } catch (e) {
      throw Exception('Failed to parse data');
    }
  }

  Future<CartResponse> updateCartItem(
      UpdateCartRequest request, String cartId, String cartLineId) async {
    try {
      final response = await _apiHelper.post(
        '${ApiConstants.updateCart}$cartId/cart-line/$cartLineId',
        data: request.toJson(),
      );
      final cartResponse = cartResponseFromJson(jsonEncode(response));
      return cartResponse;
    } catch (e) {
      throw Exception('Failed to parse data');
    }
  }

  Future<CartResponse> clearFullCart(String cartId) async {
    try {
      final response = await _apiHelper.delete(
        '${ApiConstants.clearFullCart}$cartId/clear',
        data: {},
      );
      final cartResponse = cartResponseFromJson(jsonEncode(response));
      return cartResponse;
    } catch (e) {
      throw Exception('Failed to parse data');
    }
  }

  Future<GeneralSuccessResponse> holdCart(
      String cartId, PhoneNumberRequest phoneNumber) async {
    try {
      final response = await _apiHelper.post(
        '${ApiConstants.holdCart}$cartId/hold',
        data: phoneNumber.toJson(),
      );
      final generalResponse =
          generalSuccessResponseFromJson(jsonEncode(response));
      return generalResponse;
    } catch (e) {
      throw Exception('Failed to parse data');
    }
  }
}
