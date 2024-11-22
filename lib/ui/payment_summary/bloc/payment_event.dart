import 'package:kpn_pos_application/ui/payment_summary/model/payment_summary_request.dart';

abstract class PaymentEvent {}

class PaymentInitialEvent extends PaymentEvent {
  final PaymentSummaryRequest request;
  PaymentInitialEvent(this.request);
}

class FetchPaymentSummary extends PaymentEvent{}