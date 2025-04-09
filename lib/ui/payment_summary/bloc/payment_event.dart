import 'package:ebono_pos/ui/payment_summary/model/payment_summary_request.dart';

abstract class PaymentEvent {}

class PaymentInitialEvent extends PaymentEvent {
  final PaymentSummaryRequest request;
  PaymentInitialEvent(this.request);
}

class FetchPaymentSummary extends PaymentEvent {}

// For Payment EDC api
class PaymentStartEvent extends PaymentEvent {}

class PaymentStatusEvent extends PaymentEvent {
  final bool isFromDialogue;
  PaymentStatusEvent({required this.isFromDialogue});
}

class PaymentCancelEvent extends PaymentEvent {}

class CheckPaymentStatusBasedOnTimer extends PaymentEvent {}

class PlaceOrderEvent extends PaymentEvent {}

class GetInvoiceEvent extends PaymentEvent {}

class GetBalancePayableAmountEvent extends PaymentEvent {
  final String cash;
  final String online;
  final String wallet;

  GetBalancePayableAmountEvent(this.cash, this.online, this.wallet);
}

class WalletAuthenticationEvent extends PaymentEvent {
  WalletAuthenticationEvent({this.isResendOTP = false});

  final bool isResendOTP;
}

class WalletChargeEvent extends PaymentEvent {
  final String otp;
  WalletChargeEvent(this.otp);
}

class WalletIdealEvent extends PaymentEvent {}

class PaymentIdealEvent extends PaymentEvent {}
