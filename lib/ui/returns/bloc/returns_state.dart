part of 'returns_bloc.dart';

@immutable
class ReturnsState {
  final bool isLoading;
  final bool isError;
  final String errorMessage;
  final List<CustomerOrderDetails> customerOrdersList;
  final OrderItemsModel orderItemsData;
  final bool isCustomerOrdersDataFetched;
  final bool isOrderItemsFetched;
  final bool isOrderDetailsFetching;
  final bool isProceedBtnEnabled;
  final bool isOrderReturnedSuccessfully;
  final bool isReturningOrders;
  final bool isConfirmReturnBtnEnabled;
  final bool isFetchingOrderItems;
  final RefundSuccessModel refundSuccessModel;
  final OrderLine lastSelectedItem;
  final String? commonSelectedReason;
  final bool? resetAllValues;

  const ReturnsState({
    this.isLoading = false,
    this.isError = false,
    this.errorMessage = '',
    this.customerOrdersList = const [],
    this.orderItemsData = const OrderItemsModel(),
    this.isCustomerOrdersDataFetched = false,
    this.isOrderItemsFetched = false,
    this.isOrderDetailsFetching = false,
    this.isProceedBtnEnabled = false,
    this.isOrderReturnedSuccessfully = false,
    this.isReturningOrders = false,
    this.isConfirmReturnBtnEnabled = false,
    this.isFetchingOrderItems = false,
    this.refundSuccessModel = const RefundSuccessModel(),
    this.lastSelectedItem = const OrderLine(),
    this.commonSelectedReason = '',
    this.resetAllValues = false,
  });

  /* it updates current provided value and does not distrub other variables */
  ReturnsState copyWith({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    List<CustomerOrderDetails>? customerOrdersList,
    OrderItemsModel? orderItemsData,
    bool? isCustomerOrdersDataFetched,
    bool? isOrderItemsFetched,
    bool? isOrderDetailsFetching,
    bool? isProceedBtnEnabled,
    bool? isOrderReturnedSuccessfully,
    bool? isReturningOrders,
    bool? isConfirmReturnBtnEnabled,
    bool? isFetchingOrderItems,
    RefundSuccessModel? refundSuccessModel,
    OrderLine? lastSelectedItem,
    String? commonSelectedReason,
    bool? resetAllValues,
  }) {
    return ReturnsState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      customerOrdersList: customerOrdersList ?? this.customerOrdersList,
      orderItemsData: orderItemsData ?? this.orderItemsData,
      isCustomerOrdersDataFetched:
          isCustomerOrdersDataFetched ?? this.isCustomerOrdersDataFetched,
      isOrderItemsFetched: isOrderItemsFetched ?? this.isOrderItemsFetched,
      isOrderDetailsFetching:
          isOrderDetailsFetching ?? this.isOrderDetailsFetching,
      isProceedBtnEnabled: isProceedBtnEnabled ?? this.isProceedBtnEnabled,
      isOrderReturnedSuccessfully:
          isOrderReturnedSuccessfully ?? this.isOrderReturnedSuccessfully,
      isReturningOrders: isReturningOrders ?? this.isReturningOrders,
      isConfirmReturnBtnEnabled:
          isConfirmReturnBtnEnabled ?? this.isConfirmReturnBtnEnabled,
      isFetchingOrderItems: isFetchingOrderItems ?? this.isFetchingOrderItems,
      refundSuccessModel: refundSuccessModel ?? this.refundSuccessModel,
      lastSelectedItem: lastSelectedItem ?? this.lastSelectedItem,
      commonSelectedReason: commonSelectedReason ?? this.commonSelectedReason,
      resetAllValues: resetAllValues ?? this.resetAllValues,
    );
  }

  /* FYI: what ever gives as input it will update and reset remaining to default values */
  ReturnsState updateInputValuesAndResetRemaining({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    List<CustomerOrderDetails>? customerOrdersList,
    OrderItemsModel? orderItemsData,
    bool? isCustomerOrdersDataFetched,
    bool? isOrderItemsFetched,
    bool? isOrderDetailsFetching,
    bool? isProceedBtnEnabled,
    bool? isOrderReturnedSuccessfully,
    bool? isReturningOrders,
    bool? isConfirmReturnBtnEnabled,
    bool? isFetchingOrderItems,
    RefundSuccessModel? refundSuccessModel,
    OrderLine? lastSelectedItem,
    String? commonSelectedReason,
    bool? resetAllValues,
  }) {
    return ReturnsState(
      isLoading: isLoading ?? false,
      isError: isError ?? false,
      errorMessage: errorMessage ?? '',
      isFetchingOrderItems: isFetchingOrderItems ?? false,
      isProceedBtnEnabled: isProceedBtnEnabled ?? false,
      customerOrdersList: customerOrdersList ?? const [],
      orderItemsData: orderItemsData ?? const OrderItemsModel(),
      isCustomerOrdersDataFetched: isCustomerOrdersDataFetched ?? false,
      isOrderItemsFetched: isOrderItemsFetched ?? false,
      isConfirmReturnBtnEnabled: isConfirmReturnBtnEnabled ?? false,
      isOrderReturnedSuccessfully: isOrderReturnedSuccessfully ?? false,
      isReturningOrders: isReturningOrders ?? false,
      refundSuccessModel: refundSuccessModel ?? const RefundSuccessModel(),
      lastSelectedItem: lastSelectedItem ?? this.lastSelectedItem,
      commonSelectedReason: commonSelectedReason ?? this.commonSelectedReason,
      resetAllValues: resetAllValues ?? false,
    );
  }
}
