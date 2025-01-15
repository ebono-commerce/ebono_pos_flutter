part of 'returns_bloc.dart';

@immutable
sealed class ReturnsEvent {}

final class ReturnsResetEvent extends ReturnsEvent {}

final class FetchCustomerOrdersData extends ReturnsEvent {
  FetchCustomerOrdersData(this.customerMobileNumber);

  final String customerMobileNumber;
}

final class FetchOrderDataBasedOnOrderId extends ReturnsEvent {
  FetchOrderDataBasedOnOrderId({
    required this.orderId,
    this.isRetrivingOrderItems = false,
    this.customerOrderDetailsList = const [],
  });

  final String orderId;
  final bool isRetrivingOrderItems;
  final List<CustomerOrderDetails> customerOrderDetailsList;
}

final class UpdateSelectedItem extends ReturnsEvent {
  UpdateSelectedItem(
      {required this.id,
      required this.orderItems,
      this.reason = '',
      required this.orderLine});

  final String id;
  final String reason;
  final OrderItemsModel orderItems;
  final OrderLine orderLine;
}

final class UpdateCustomerData extends ReturnsEvent {
  UpdateCustomerData(this.customerName, this.customerNumber, this.orderItems);

  final String customerName;
  final String customerNumber;
  final OrderItemsModel orderItems;
}

final class UpdateReturnReasonBasedOnId extends ReturnsEvent {
  UpdateReturnReasonBasedOnId({
    required this.id,
    required this.reason,
    required this.orderItems,
  });

  final String id;
  final String reason;
  final OrderItemsModel orderItems;
}

final class ProceedToReturnItems extends ReturnsEvent {
  ProceedToReturnItems(this.orderItemsModel);

  final OrderItemsModel orderItemsModel;
}

final class AddReturnQuantityEvent extends ReturnsEvent {
  AddReturnQuantityEvent(this.quantity);

  final int quantity;
}
