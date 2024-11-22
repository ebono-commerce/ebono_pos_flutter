import 'dart:convert';

import 'package:kpn_pos_application/api/api_constants.dart';
import 'package:kpn_pos_application/api/api_helper.dart';
import 'package:kpn_pos_application/ui/payment_summary/model/payment_summary_request.dart';
import 'package:kpn_pos_application/ui/payment_summary/model/payment_summary_response.dart';

class PaymentRepository {
  final ApiHelper _apiHelper;

  PaymentRepository(this._apiHelper);

  Future<PaymentSummaryResponse> fetchPaymentSummary(PaymentSummaryRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.fetchPaymentSummary,
        data: request.toJson(),
      );
      final paymentSummaryResponse = paymentSummaryResponseFromJson(jsonEncode(response));
      return paymentSummaryResponse;
    } catch (e) {
      throw Exception(e);
    }
  }
}