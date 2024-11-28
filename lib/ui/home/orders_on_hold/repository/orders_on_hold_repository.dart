import 'dart:convert';

import 'package:ebono_pos/api/api_constants.dart';
import 'package:ebono_pos/api/api_helper.dart';
import 'package:ebono_pos/models/cart_response.dart';
import 'package:ebono_pos/ui/home/model/orders_on_hold.dart';
import 'package:ebono_pos/ui/home/model/orders_onhold_request.dart';
import 'package:ebono_pos/ui/home/model/resume_hold_cart_request.dart';

class OrdersOnHoldRepository {
  final ApiHelper _apiHelper;

  OrdersOnHoldRepository(this._apiHelper);

  Future<CartResponse> resumeHoldCart(
      String cartId, ResumeHoldCartRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.resumeHoldCart,
        data: request.toJson(),
      );
      final cartResponse = cartResponseFromJson(jsonEncode(response));
      return cartResponse;
    } catch (e) {
      throw Exception('Failed to parse data');
    }
  }

  Future<OrdersOnHoldResponse> ordersOnHold(OrdersOnHoldRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.ordersOnHold,
        data: request.toJson(),
      );
      final ordersOnHoldResponse =
          ordersOnHoldResponseFromJson(jsonEncode(response));
      return ordersOnHoldResponse;
    } catch (e) {
      throw Exception('Failed to parse data');
    }
  }
}
