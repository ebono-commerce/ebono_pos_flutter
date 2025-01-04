part of 'returns_bloc.dart';

@immutable
sealed class ReturnsEvent {}

final class FetchCustomerOrdersData extends ReturnsEvent {
  FetchCustomerOrdersData(this.customerMobileNumber);

  final String customerMobileNumber;
}

final class FetchOrderDataBasedOnOrderId extends ReturnsEvent {
  FetchOrderDataBasedOnOrderId(this.orderId);

  final String orderId;
}
