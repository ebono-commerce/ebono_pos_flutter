import 'dart:convert';

import 'package:ebono_pos/api/api_constants.dart';
import 'package:ebono_pos/api/api_helper.dart';
import 'package:ebono_pos/ui/home/model/general_success_response.dart';
import 'package:ebono_pos/ui/home/model/phone_number_request.dart';
import 'package:ebono_pos/ui/payment_summary/model/order_summary_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_cancel_request.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_initiate_request.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_initiate_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_status_request.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_status_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_summary_request.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_summary_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/paytm_initiate_checksum_request.dart';
import 'package:ebono_pos/ui/payment_summary/model/paytm_initiate_checksum_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/paytm_payment_inititate_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/paytm_payment_status_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/paytm_status_checksum_request.dart';
import 'package:ebono_pos/ui/payment_summary/model/paytm_status_checksum_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/place_order_request.dart';
import 'package:ebono_pos/ui/payment_summary/model/wallet_charge_request.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';

import '../../../api/api_exception.dart';

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
      throw ApiException(e.toString());
    }
  }

  Future<PaymentInitiateResponse> paymentInitiateApiCall(
      PaymentRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.ezetapInitiateApi,
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
        ApiConstants.ezetapStatusApi,
        data: request.toJson(),
      );
      final paymentStatusResponse =
          paymentStatusResponseFromJson(jsonEncode(response));
      return paymentStatusResponse;
    } catch (e) {
      print('payment status api error $e');
      throw Exception(e);
    }
  }

  Future<PaymentStatusResponse> paymentCancelApiCall(
      PaymentCancelRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.ezetapCancelApi,
        data: request.toJson(),
      );
      final paymentStatusResponse =
          paymentStatusResponseFromJson(jsonEncode(response));
      return paymentStatusResponse;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<PaytmInitiateChecksumResponse> fetchPaytmInitiateChecksumApi(
      PaytmInitiateChecksumRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.fetchPaytmInitiateChecksum,
        data: request.toJson(),
      );
      final paytmChecksumResponse =
          paytmInitiateChecksumResponseFromJson(jsonEncode(response));
      return paytmChecksumResponse;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<PaytmPaymentInitiateResponse> paytmPaymentInitiateApi(
      PaytmInitiatePayload request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.paytmInitiateApi,
        data: request.toJson(),
      );
      final paytmPaymentInitiateResponse =
          paytmPaymentInitiateResponseFromJson(jsonEncode(response));
      return paytmPaymentInitiateResponse;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<PaytmStatusChecksumResponse> fetchPaytmStatusChecksumApi(
      PaytmStatusChecksumRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.fetchPaytmStatusChecksum,
        data: request.toJson(),
      );
      final paytmChecksumResponse =
          paytmStatusChecksumResponseFromJson(jsonEncode(response));
      return paytmChecksumResponse;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<PaytmPaymentStatusResponse> paytmPaymentStatusApi(
      PaytmStatusPayload request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.paytmStatusApi,
        data: request.toJson(),
      );
      final paytmPaymentStatusResponse =
          paytmPaymentStatusResponseFromJson(jsonEncode(response));
      return paytmPaymentStatusResponse;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<PaytmInitiateChecksumResponse> fetchPaytmCancelChecksumApi(
      PaytmStatusChecksumRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.fetchPaytmCancelChecksum,
        data: request.toJson(),
      );
      final paytmChecksumResponse =
          paytmInitiateChecksumResponseFromJson(jsonEncode(response));
      return paytmChecksumResponse;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<PaytmPaymentInitiateResponse> paytmPaymentCancelApi(
      PaytmStatusPayload request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.paytmCancelApi,
        data: request.toJson(),
      );
      final paytmPaymentInitiateResponse =
          paytmPaymentInitiateResponseFromJson(jsonEncode(response));
      return paytmPaymentInitiateResponse;
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
      final orderSummaryResponse =
          orderSummaryResponseFromJson(jsonEncode(response));
      return orderSummaryResponse;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Stream<SSEModel> listenToPaymentUpdates(String orderId) {
    final endpoint = '${ApiConstants.orderInvoiceSSE}?order_number=$orderId';
    return _apiHelper.subscribeToSSE(endpoint);
  }

  Future<OrderSummaryResponse> getInvoice(String orderId) async {
    try {
      final response = await _apiHelper.get(
        '${ApiConstants.getInvoice}?order_number=$orderId',
      );
      final orderSummaryResponse =
          orderSummaryResponseFromJson(jsonEncode(response));
      return orderSummaryResponse;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<GeneralSuccessResponse> walletAuthentication(
      PhoneNumberRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.walletAuthentication,
        data: request.toJson(),
      );
      final walletAuthenticationResponse =
          generalSuccessResponseFromJson(jsonEncode(response));
      return walletAuthenticationResponse;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<PaymentSummaryResponse> walletCharge(
      WalletChargeRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.walletCharge,
        data: request.toJson(),
      );
      final paymentSummaryResponse =
          paymentSummaryResponseFromJson(jsonEncode(response));
      return paymentSummaryResponse;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<GeneralSuccessResponse> generateSmsInvoice(String number) async {
    try {
      final response = await _apiHelper.post(ApiConstants.generateSmsInvoice,
          data: {"order_number": number});
      return GeneralSuccessResponse.fromJson(response);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
