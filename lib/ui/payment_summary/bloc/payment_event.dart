import 'package:ebono_pos/ui/payment_summary/model/payment_summary_request.dart';

abstract class PaymentEvent {}

class PaymentInitialEvent extends PaymentEvent {
  final PaymentSummaryRequest request;
  PaymentInitialEvent(this.request);
}

class FetchPaymentSummary extends PaymentEvent {}

// For Payment EDC api
class PaymentStartEvent extends PaymentEvent {}

class PaymentStatusEvent extends PaymentEvent {}

class PaymentCancelEvent extends PaymentEvent {}

class CheckPaymentStatusBasedOnTimer extends PaymentEvent {}

class PlaceOrderEvent extends PaymentEvent {}

class GetBalancePayableAmountEvent extends PaymentEvent {
   final String cash;
   final String online;
   final String wallet;

   GetBalancePayableAmountEvent(this.cash, this.online, this.wallet);
}

class PaymentIdealEvent extends PaymentEvent {}


