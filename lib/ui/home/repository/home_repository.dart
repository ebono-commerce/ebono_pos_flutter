import 'dart:convert';

import 'package:ebono_pos/api/api_constants.dart';
import 'package:ebono_pos/api/api_exception.dart';
import 'package:ebono_pos/api/api_helper.dart';
import 'package:ebono_pos/constants/shared_preference_constants.dart';
import 'package:ebono_pos/data_store/hive_storage_helper.dart';
import 'package:ebono_pos/models/cart_response.dart';
import 'package:ebono_pos/models/coupon_details.dart';
import 'package:ebono_pos/models/customer_response.dart';
import 'package:ebono_pos/models/pos_metrics_payload.dart';
import 'package:ebono_pos/models/scan_products_response.dart';
import 'package:ebono_pos/ui/home/model/add_to_cart.dart';
import 'package:ebono_pos/ui/home/model/cart_request.dart';
import 'package:ebono_pos/ui/home/model/customer_details_response.dart';
import 'package:ebono_pos/ui/home/model/customer_request.dart';
import 'package:ebono_pos/ui/home/model/delete_cart.dart';
import 'package:ebono_pos/ui/home/model/general_success_response.dart';
import 'package:ebono_pos/ui/home/model/get_authorisation_response.dart';
import 'package:ebono_pos/ui/home/model/open_register_response.dart';
import 'package:ebono_pos/ui/home/model/orders_on_hold.dart';
import 'package:ebono_pos/ui/home/model/orders_onhold_request.dart';
import 'package:ebono_pos/ui/home/model/overide_price_request.dart';
import 'package:ebono_pos/ui/home/model/register_close_request.dart';
import 'package:ebono_pos/ui/home/model/register_open_request.dart';
import 'package:ebono_pos/ui/home/model/resume_hold_cart_request.dart';
import 'package:ebono_pos/ui/home/model/terminal_transaction_request.dart';
import 'package:ebono_pos/ui/home/model/update_cart.dart';
import 'package:ebono_pos/ui/login/model/login_request.dart';
import 'package:ebono_pos/ui/payment_summary/model/health_check_response.dart';

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
      throw ApiException('$e');
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
      throw ApiException('$e');
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
      throw ApiException('$e');
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
      throw ApiException('$e');
    }
  }

  Future<CartResponse> mergeCart(CartRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.mergeCart,
        data: request.toJson(),
      );
      final cartResponse = cartResponseFromJson(jsonEncode(response));
      return cartResponse;
    } catch (e) {
      throw ApiException('$e');
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
      print("err: $e");
      throw ApiException('$e');
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
      throw ApiException('$e');
    }
  }

  Future<CartResponse> updateCartItem(
      UpdateCartRequest request, String cartId, String cartLineId) async {
    try {
      print("chk - inside api");
      final response = await _apiHelper.post(
        '${ApiConstants.updateCart}$cartId/cart-line/$cartLineId',
        data: request.toJson(),
      );
      print("chk response- $response");
      final cartResponse = cartResponseFromJson(jsonEncode(response));
      return cartResponse;
    } catch (e) {
      throw ApiException('$e');
    }
  }

  Future<GeneralSuccessResponse> clearFullCart(String cartId) async {
    try {
      final response = await _apiHelper.delete(
        '${ApiConstants.clearFullCart}$cartId/clear',
        data: {},
      );
      final generalResponse =
          generalSuccessResponseFromJson(jsonEncode(response));
      return generalResponse;
    } catch (e) {
      throw ApiException('$e');
    }
  }

  Future<GeneralSuccessResponse> holdCart(
      {required String cartId,
      required CustomerRequest customerRequest}) async {
    try {
      final response = await _apiHelper.post(
        '${ApiConstants.holdCart}$cartId/hold',
        data: customerRequest.toHoldCartJson(),
      );
      final generalResponse =
          generalSuccessResponseFromJson(jsonEncode(response));
      return generalResponse;
    } catch (e) {
      throw ApiException('$e');
    }
  }

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
      throw ApiException('$e');
    }
  }

  Future<HealthCheckResponse> healthCheckApiCall() async {
    try {
      final response = await _apiHelper.get(ApiConstants.healthCheck);
      final healthCheckResponse =
          healthCheckResponseFromJson(jsonEncode(response));
      return healthCheckResponse;
    } catch (e) {
      throw ApiException('$e');
    }
  }

  Future<OpenRegisterResponse> openRegister(RegisterOpenRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.openRegister,
        data: request.toJson(),
      );
      final openRegisterResponse =
          openRegisterResponseFromJson(jsonEncode(response));
      return openRegisterResponse;
    } catch (e) {
      throw ApiException('$e');
    }
  }

  Future<GeneralSuccessResponse> closeRegister(
      RegisterCloseRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.closeRegister,
        data: request.toJson(),
      );
      final generalResponse =
          generalSuccessResponseFromJson(jsonEncode(response));
      return generalResponse;
    } catch (e) {
      throw ApiException('$e');
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
      throw ApiException('$e');
    }
  }

  Future<GetAuthorisationResponse> getAuthorisation(
      LoginRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.getAuthorisation,
        data: request.toJson(),
      );
      final getAuthorisationResponse =
          getAuthorisationResponseFromJson(jsonEncode(response));
      return getAuthorisationResponse;
    } catch (e) {
      throw ApiException('$e');
    }
  }

  Future<CartResponse> overridePrice(OverRidePriceRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.overridePrice,
        data: request.toJson(),
      );
      final cartResponse = cartResponseFromJson(jsonEncode(response));
      return cartResponse;
    } catch (e) {
      throw ApiException('$e');
    }
  }

  Future<CartResponse> applyORRemoveCoupon({
    required CouponDetails coupon,
    bool isRemoveCoupon = false,
  }) async {
    try {
      HiveStorageHelper helper = HiveStorageHelper();
      final cartId = helper.read(SharedPreferenceConstants.cartId);

      final response = await _apiHelper.post(
        isRemoveCoupon
            ? ApiConstants.removeCoupon(cartId)
            : ApiConstants.applyCoupon(cartId),
        data: coupon.toPostJson(),
      );

      final cartResponse = cartResponseFromJson(jsonEncode(response));
      return cartResponse;
    } catch (e) {
      throw ApiException('$e');
    }
  }

  Future<bool> generateORValidateOTP({
    required bool tiggerOTP,
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      await _apiHelper.post(
        ApiConstants.otp(tiggerOTP: tiggerOTP),
        data: {'phone_number': phoneNumber, if (otp.isNotEmpty) 'otp': otp},
      );

      return true;
    } catch (e) {
      throw ApiException('$e');
    }
  }

  Future<List<TransactionSummary>> fetchTerminalTransactions(
      {required TerminalTransactionRequest payload}) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.getTerminalTransactions,
        data: payload.toJson(),
      );

      List<dynamic> jsonData = response['terminal_transactions'];

      List<TransactionSummary> transactionSummaryList = jsonData
          .map((transaction) => TransactionSummary.fromJson(transaction))
          .toList();

      return transactionSummaryList;
    } catch (e) {
      throw ApiException('$e');
    }
  }

  Future<void> sendPosMetrics({
    required PosMetricsPayload payload,
  }) async {
    try {
      await _apiHelper.post(
        ApiConstants.sendPosMetrics,
        data: payload.toMap(),
      );
    } catch (e) {
      throw ApiException('$e');
    }
  }
}
