import 'package:ebono_pos/ui/home/model/orders_on_hold.dart';

class OrdersOnHoldInitial extends OrdersOnHoldState {}

class OrdersOnHoldState {
  final bool initialState;
  final bool isLoading;
  final bool isResumeOrderSuccess;
  final bool isFetchOrderOnHoldSuccess;
  final List<OnHoldItems> ordersOnHold;
  final String? errorMessage;

  const OrdersOnHoldState({
    this.initialState = false,
    this.isLoading = false,
    this.errorMessage,
    this.ordersOnHold = const [], // Default to an empty list
    this.isFetchOrderOnHoldSuccess = false,
    this.isResumeOrderSuccess = false,
  });

  OrdersOnHoldState copyWith({
    bool? initialState,
    bool? isLoading,
    List<OnHoldItems>? ordersOnHold,
    bool? isFetchOrderOnHoldSuccess,
    bool? isResumeOrderSuccess,
    String? errorMessage,
  }) {
    return OrdersOnHoldState(
      initialState: initialState ?? this.initialState,
      isLoading: isLoading ?? this.isLoading,
      isFetchOrderOnHoldSuccess:
          isFetchOrderOnHoldSuccess ?? this.isFetchOrderOnHoldSuccess,
      isResumeOrderSuccess: isResumeOrderSuccess ?? this.isResumeOrderSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      ordersOnHold: ordersOnHold ?? this.ordersOnHold,
    );
  }
}
