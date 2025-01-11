part of 'returns_bloc.dart';

@immutable
sealed class ReturnsEvent {}

final class FetchCustomerOrdersData extends ReturnsEvent {
  FetchCustomerOrdersData(this.customerMobileNumber);

  final String customerMobileNumber;
}

final class FetchOrderDataBasedOnOrderId extends ReturnsEvent {
  FetchOrderDataBasedOnOrderId({required this.orderId});

  final String orderId;
}

final class UpdateSelectedItem extends ReturnsEvent {
  UpdateSelectedItem({required this.id, required this.orderItems});

  final String id;
  final OrderItemsModel orderItems;
}
