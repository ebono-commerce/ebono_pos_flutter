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

  const ReturnsState({
    this.isLoading = false,
    this.isError = false,
    this.errorMessage = '',
    this.customerOrdersList = const [],
    this.orderItemsData = const OrderItemsModel(),
    this.isCustomerOrdersDataFetched = false,
    this.isOrderItemsFetched = false,
    this.isOrderDetailsFetching = false,
  });

  ReturnsState copyWith({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    List<CustomerOrderDetails>? customerOrdersList,
    OrderItemsModel? orderItemsData,
    bool? isCustomerOrdersDataFetched,
    bool? isOrderItemsFetched,
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
    );
  }

  ReturnsState updateSelectedParameters({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    List<CustomerOrderDetails>? customerOrdersList,
    OrderItemsModel? orderItemsData,
    bool? isCustomerOrdersDataFetched,
    bool? isOrderItemsFetched,
  }) {
    return ReturnsState(
      isLoading: isLoading ?? false,
      isError: isError ?? false,
      errorMessage: errorMessage ?? '',
      customerOrdersList: customerOrdersList ?? const [],
      orderItemsData: orderItemsData ?? const OrderItemsModel(),
      isCustomerOrdersDataFetched: isCustomerOrdersDataFetched ?? false,
      isOrderItemsFetched: isOrderItemsFetched ?? false,
    );
  }
}
