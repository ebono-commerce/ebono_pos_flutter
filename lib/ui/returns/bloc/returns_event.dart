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
  });

  final String orderId;
  final bool isRetrivingOrderItems;
}

final class UpdateSelectedItem extends ReturnsEvent {
  UpdateSelectedItem({
    required this.id,
    this.reason = '',
    required this.orderLine,
    this.updateCommonReason = false,
    this.isSelected = false,
  });

  final String id;
  final String reason;
  final bool updateCommonReason;
  final bool isSelected;
  final OrderLine orderLine;
}

final class ProceedToReturnItems extends ReturnsEvent {
  ProceedToReturnItems();
}

final class UpdateCommonReasonEvent extends ReturnsEvent {
  UpdateCommonReasonEvent(this.reason);

  final String reason;
}

final class OnSelectAllBtnEvent extends ReturnsEvent {
  OnSelectAllBtnEvent();
}

final class ResetValuesOnDialogCloseEvent extends ReturnsEvent {
  ResetValuesOnDialogCloseEvent();
}

class UpdateOrderLineQuantity extends ReturnsEvent {
  UpdateOrderLineQuantity({
    required this.id,
    required this.quantity,
  });

  final String id;
  final String quantity;
}

class UpdateOrderItemsInternalState extends ReturnsEvent {
  UpdateOrderItemsInternalState({
    required this.customerName,
    required this.customerNumber,
  });

  final String customerName;
  final String customerNumber;
}

class UpdateOrderType extends ReturnsEvent {
  final bool isStoreOrder;

  UpdateOrderType(this.isStoreOrder);
}
