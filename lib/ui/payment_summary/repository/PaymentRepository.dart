import 'dart:convert';

import 'package:ebono_pos/api/api_constants.dart';
import 'package:ebono_pos/api/api_helper.dart';
import 'package:ebono_pos/ui/payment_summary/model/order_summary_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_cancel_request.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_initiate_request.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_initiate_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_status_request.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_status_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_summary_request.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_summary_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/place_order_request.dart';

class PaymentRepository {
  final ApiHelper _apiHelper;

  PaymentRepository(this._apiHelper);

  Future<PaymentSummaryResponse> fetchPaymentSummary(
      PaymentSummaryRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.fetchPaymentSummary,
        data: request.toJson(),
      );
      final paymentSummaryResponse =
          paymentSummaryResponseFromJson(jsonEncode(response));
      return paymentSummaryResponse;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<PaymentInitiateResponse> paymentInitiateApiCall(
      PaymentRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.paymentApiInitiate,
        data: request.toJson(),
      );
      final paymentInitiateResponse =
          paymentInitiateResponseFromJson(jsonEncode(response));
      return paymentInitiateResponse;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<PaymentStatusResponse> paymentStatusApiCall(
      PaymentStatusRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.paymentApiStatus,
        data: request.toJson(),
      );
      final paymentStatusResponse =
          paymentStatusResponseFromJson(jsonEncode(response));
      return paymentStatusResponse;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<PaymentStatusResponse> paymentCancelApiCall(
      PaymentCancelRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.paymentApiCancel,
        data: request.toJson(),
      );
      final paymentStatusResponse =
          paymentStatusResponseFromJson(jsonEncode(response));
      return paymentStatusResponse;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<OrderSummaryResponse> placeOrder(PlaceOrderRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.placeOrder,
        data: request.toJson(),
      );
      final orderSummaryResponse = orderSummaryResponseFromJson(jsonEncode(response));
      return orderSummaryResponse;
    } catch (e) {
      throw Exception(e);
    }
  }
}
