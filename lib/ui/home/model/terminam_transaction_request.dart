class TerminalTransactionRequest {
  final String outletId;
  final String registerId;
  final String registerTransactionId;
  final String terminalId;
  final List<String> paymentMethods;

  const TerminalTransactionRequest({
    this.outletId = '',
    this.registerId = '',
    this.registerTransactionId = '',
    this.terminalId = '',
    this.paymentMethods = const <String>[],
  });

  Map<String, dynamic> toJson() {
    return {
      'outlet_id': outletId,
      'register_id': registerId,
      'register_transaction_id': registerTransactionId,
      'terminal_id': terminalId,
      'payment_methods': paymentMethods,
    };
  }

  factory TerminalTransactionRequest.fromJson(Map<String, dynamic> json) {
    return TerminalTransactionRequest(
      outletId: json['outlet_id'] ?? '',
      registerId: json['register_id'] ?? '',
      registerTransactionId: json['register_transaction_id'] ?? '',
      terminalId: json['terminal_id'] ?? '',
      paymentMethods: json['payment_methods'] != null
          ? List<String>.from(json['payment_methods'].map((x) => x))
          : <String>[],
    );
  }
}
