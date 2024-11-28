

abstract class OrdersOnHoldEvent {}

class OrdersOnHoldInitialEvent extends OrdersOnHoldEvent {}

class FetchHoldOrdersEvent extends OrdersOnHoldEvent {}

class ResumeOrdersEvent extends OrdersOnHoldEvent {
  final String id;

  ResumeOrdersEvent(this.id);
}
