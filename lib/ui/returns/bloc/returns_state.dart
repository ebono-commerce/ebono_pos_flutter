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
  final RefundSuccessModel refundSuccessModel;
  final OrderLine lastSelectedItem;

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
    this.refundSuccessModel = const RefundSuccessModel(),
    this.lastSelectedItem = const OrderLine(),
  });

  ReturnsState copyWith({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    List<CustomerOrderDetails>? customerOrdersList,
    OrderItemsModel? orderItemsData,
    bool? isCustomerOrdersDataFetched,
    bool? isOrderItemsFetched,
    bool? isProceedBtnEnabled,
    bool? isOrderReturnedSuccessfully,
    bool? isReturningOrders,
    RefundSuccessModel? refundSuccessModel,
    bool? isConfirmReturnBtnEnabled,
    OrderLine? lastSelectedItem,
  }) {
    return ReturnsState(
        isLoading: isLoading ?? this.isLoading,
        isError: isError ?? this.isError,
        errorMessage: errorMessage ?? this.errorMessage,
        customerOrdersList: customerOrdersList ?? this.customerOrdersList,
        orderItemsData: orderItemsData ?? this.orderItemsData,
        isProceedBtnEnabled: isProceedBtnEnabled ?? this.isProceedBtnEnabled,
        isCustomerOrdersDataFetched:
            isCustomerOrdersDataFetched ?? this.isCustomerOrdersDataFetched,
        isOrderItemsFetched: isOrderItemsFetched ?? this.isOrderItemsFetched,
        isConfirmReturnBtnEnabled:
            isConfirmReturnBtnEnabled ?? this.isConfirmReturnBtnEnabled,
        isOrderReturnedSuccessfully:
            isOrderReturnedSuccessfully ?? this.isOrderReturnedSuccessfully,
        isReturningOrders: isReturningOrders ?? this.isReturningOrders,
        refundSuccessModel: refundSuccessModel ?? this.refundSuccessModel,
        lastSelectedItem: lastSelectedItem ?? this.lastSelectedItem);
  }

  ReturnsState updateSelectedParameters({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    List<CustomerOrderDetails>? customerOrdersList,
    OrderItemsModel? orderItemsData,
    bool? isCustomerOrdersDataFetched,
    bool? isOrderItemsFetched,
    bool? isProceedBtnEnabled,
    bool? isOrderReturnedSuccessfully,
    bool? isReturningOrders,
    bool? isConfirmReturnBtnEnabled,
    RefundSuccessModel? refundSuccessModel,
    OrderLine? lastSelectedItem,
  }) {
    return ReturnsState(
        isLoading: isLoading ?? false,
        isError: isError ?? false,
        errorMessage: errorMessage ?? '',
        isProceedBtnEnabled: isProceedBtnEnabled ?? false,
        customerOrdersList: customerOrdersList ?? const [],
        orderItemsData: orderItemsData ?? const OrderItemsModel(),
        isCustomerOrdersDataFetched: isCustomerOrdersDataFetched ?? false,
        isOrderItemsFetched: isOrderItemsFetched ?? false,
        isConfirmReturnBtnEnabled: isConfirmReturnBtnEnabled ?? false,
        isOrderReturnedSuccessfully: isOrderReturnedSuccessfully ?? false,
        isReturningOrders: isReturningOrders ?? false,
        refundSuccessModel: refundSuccessModel ?? const RefundSuccessModel(),
        lastSelectedItem: lastSelectedItem ?? this.lastSelectedItem);
  }
}
