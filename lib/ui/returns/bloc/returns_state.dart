part of 'returns_bloc.dart';

@immutable
class ReturnsState {
  final bool isLoading;
  final bool isError;
  final String errorMessage;
  final bool isCustomerOrdersDataFetched;
  final bool isOrderItemsFetched;

  const ReturnsState({
    this.isLoading = false,
    this.isError = false,
    this.errorMessage = '',
    this.isCustomerOrdersDataFetched = false,
    this.isOrderItemsFetched = false,
  });

  ReturnsState copyWith({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    bool? isCustomerOrdersDataFetched,
    bool? isOrderItemsFetched,
  }) {
    return ReturnsState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      isCustomerOrdersDataFetched:
          isCustomerOrdersDataFetched ?? this.isCustomerOrdersDataFetched,
      isOrderItemsFetched: isOrderItemsFetched ?? this.isOrderItemsFetched,
    );
  }

  ReturnsState updateSingleParameter({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    bool? isCustomerOrdersDataFetched,
    bool? isOrderItemsFetched,
  }) {
    return ReturnsState(
      isLoading: isLoading ?? false,
      isError: isError ?? false,
      errorMessage: errorMessage ?? '',
      isCustomerOrdersDataFetched: isCustomerOrdersDataFetched ?? false,
      isOrderItemsFetched: isOrderItemsFetched ?? false,
    );
  }
}
