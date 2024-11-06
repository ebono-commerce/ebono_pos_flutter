import 'dart:convert';

import 'package:kpn_pos_application/api/api_constants.dart';
import 'package:kpn_pos_application/api/api_helper.dart';
import 'package:kpn_pos_application/ui/home/model/add_to_cart_request.dart';
import 'package:kpn_pos_application/ui/home/model/cart_request.dart';
import 'package:kpn_pos_application/ui/home/model/cart_response.dart';
import 'package:kpn_pos_application/ui/home/model/customer_request.dart';
import 'package:kpn_pos_application/ui/home/model/customer_response.dart';
import 'package:kpn_pos_application/ui/home/model/scan_products_response.dart';

class HomeRepository {
  final ApiHelper _apiHelper;

  HomeRepository(this._apiHelper);

  Future<CustomerResponse> fetchCustomer(CustomerRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.fetchCustomer,
        data: request.toJson(),
      );
      final customerResponse = customerResponseFromJson(jsonEncode(response));
      return customerResponse;
    } catch (e) {
      throw Exception('Failed to parse data');
    }
  }

  Future<ScanProductsResponse> getScanProduct(String code) async {
    try {
      final response = await _apiHelper.get(
        'catalog/v1/products/scan?code=$code',
      );
      final scanProductsResponse =
          scanProductsResponseFromJson(jsonEncode(response));
      return scanProductsResponse;
    } catch (e) {
      throw Exception('Failed to load data');
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
      AddToCartRequest request, String cartId) async {
    try {
      final response = await _apiHelper.post(
        'checkout/v1/cart/${cartId}/items',
        data: request.toJson(),
      );
      final cartResponse = cartResponseFromJson(jsonEncode(response));
      return cartResponse;
    } catch (e) {
      throw Exception('Failed to parse data');
    }
  }
}
