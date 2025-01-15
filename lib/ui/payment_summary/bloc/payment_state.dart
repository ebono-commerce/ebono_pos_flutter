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
  final bool isPlaceOrderError;
  final String? orderStatus;
  final bool isPaymentSummaryError;
  final String? errorMessage;
  final double? balancePayableAmount;
  final bool isOnlinePaymentSuccess;
  final bool allowPlaceOrder;
  final bool allowPrintInvoice;
  final bool isWalletAuthenticationSuccess;
  final bool isWalletAuthenticationError;
  final bool isWalletChargeSuccess;
  final bool isWalletChargeError;

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
    this.isPlaceOrderError = false,
    this.isPaymentSummaryError = false,
    this.errorMessage,
    this.orderStatus,
    this.balancePayableAmount,
    this.isOnlinePaymentSuccess = false,
    this.allowPlaceOrder = false,
    this.allowPrintInvoice = false,
    this.isWalletAuthenticationSuccess = false,
    this.isWalletAuthenticationError = false,
    this.isWalletChargeSuccess = false,
    this.isWalletChargeError = false,
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
    bool? isPlaceOrderError,
    String? errorMessage,
    String? orderStatus,
    double? balancePayableAmount,
    bool? isOnlinePaymentSuccess,
    bool? allowPlaceOrder,
    bool? allowPrintInvoice,
    bool? isWalletAuthenticationSuccess,
    bool? isWalletAuthenticationError,
    bool? isWalletChargeSuccess,
    bool? isWalletChargeError,
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
      isPlaceOrderError:
      isPlaceOrderError ?? this.isPlaceOrderError,
      isPaymentSummaryError:
          isPaymentSummaryError ?? this.isPaymentSummaryError,
      errorMessage: errorMessage ?? this.errorMessage,
      orderStatus: orderStatus ?? this.orderStatus,
      balancePayableAmount: balancePayableAmount ?? this.balancePayableAmount,
      isOnlinePaymentSuccess:
          isOnlinePaymentSuccess ?? this.isOnlinePaymentSuccess,
      allowPlaceOrder:
      allowPlaceOrder ?? this.allowPlaceOrder,
      allowPrintInvoice:
      allowPrintInvoice ?? this.allowPrintInvoice,
      isWalletAuthenticationSuccess:
      isWalletAuthenticationSuccess ?? this.isWalletAuthenticationSuccess,
      isWalletAuthenticationError: isWalletAuthenticationError ?? this.isWalletAuthenticationError,
      isWalletChargeSuccess:
      isWalletChargeSuccess ?? this.isWalletChargeSuccess,
      isWalletChargeError: isWalletChargeError ?? this.isWalletChargeError,
    );
  }
}
