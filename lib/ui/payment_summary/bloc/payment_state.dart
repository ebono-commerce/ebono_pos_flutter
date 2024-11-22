class PaymentState {
  final bool initialState;
  final bool isLoading;
  final bool isPaymentSummarySuccess;
  final bool isPaymentSummaryError;
  final String? errorMessage;


  const PaymentState({
    this.initialState = false,
    this.isLoading = false,
    this.isPaymentSummarySuccess = false,
    this.isPaymentSummaryError = false,
    this.errorMessage,
  });

  PaymentState copyWith({
    bool? initialState,
    bool? isLoading,
    bool? isPaymentSummarySuccess,
    bool? isPaymentSummaryError,
    String? errorMessage,
  }) {
    return PaymentState(
      initialState: initialState ?? this.initialState,
      isLoading: isLoading ?? this.isLoading,
      isPaymentSummarySuccess: isPaymentSummarySuccess ?? this.isPaymentSummarySuccess,
      isPaymentSummaryError: isPaymentSummaryError ?? this.isPaymentSummaryError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
