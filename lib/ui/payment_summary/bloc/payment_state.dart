class PaymentState {
  final bool initialState;
  final bool isLoading;
  final bool showPaymentPopup;
  final bool stopTimer;
  final bool isPaymentStartSuccess;
  final bool isPaymentStatusSuccess;
  final bool isPaymentCancelSuccess;
  final bool isPaymentSummarySuccess;
  final bool isPlaceOrderSuccess;
  final String? orderStatus;
  final bool isPaymentSummaryError;
  final String? errorMessage;
  final double? balancePayableAmount;
  final bool isOnlinePaymentSuccess;

  const PaymentState({
    this.initialState = false,
    this.isLoading = false,
    this.showPaymentPopup = false,
    this.stopTimer = false,
    this.isPaymentStatusSuccess = false,
    this.isPaymentCancelSuccess = false,
    this.isPaymentStartSuccess = false,
    this.isPaymentSummarySuccess = false,
    this.isPlaceOrderSuccess = false,
    this.isPaymentSummaryError = false,
    this.errorMessage,
    this.orderStatus,
    this.balancePayableAmount,
    this.isOnlinePaymentSuccess = false,
  });

  PaymentState copyWith({
    bool? initialState,
    bool? isLoading,
    bool? showPaymentPopup,
    bool? stopTimer,
    bool? isPaymentStatusSuccess,
    bool? isPaymentCancelSuccess,
    bool? isPaymentStartSuccess,
    bool? isPaymentSummarySuccess,
    bool? isPaymentSummaryError,
    bool? isPlaceOrderSuccess,
    String? errorMessage,
    String? orderStatus,
    double? balancePayableAmount,
    bool? isOnlinePaymentSuccess,
  }) {
    return PaymentState(
      initialState: initialState ?? this.initialState,
      isLoading: isLoading ?? this.isLoading,
      showPaymentPopup: showPaymentPopup ?? this.showPaymentPopup,
      stopTimer: stopTimer ?? this.stopTimer,
      isPaymentStatusSuccess:
          isPaymentStatusSuccess ?? this.isPaymentStatusSuccess,
      isPaymentCancelSuccess:
          isPaymentCancelSuccess ?? this.isPaymentCancelSuccess,
      isPaymentStartSuccess:
          isPaymentStartSuccess ?? this.isPaymentStartSuccess,
      isPaymentSummarySuccess:
          isPaymentSummarySuccess ?? this.isPaymentSummarySuccess,
      isPlaceOrderSuccess: isPlaceOrderSuccess ?? this.isPlaceOrderSuccess,
      isPaymentSummaryError:
          isPaymentSummaryError ?? this.isPaymentSummaryError,
      errorMessage: errorMessage ?? this.errorMessage,
      orderStatus: orderStatus ?? this.orderStatus,
      balancePayableAmount: balancePayableAmount ?? this.balancePayableAmount,
      isOnlinePaymentSuccess:
          isOnlinePaymentSuccess ?? this.isOnlinePaymentSuccess,
    );
  }
}
