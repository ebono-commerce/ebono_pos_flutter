import 'package:ebono_pos/utils/price.dart';

class RefundSuccessModel {
  final String customerName;
  final String phoneNumber;
  final String totalItems;
  final String amountRefunded;
  final String refundMode;

  const RefundSuccessModel({
    this.customerName = '',
    this.phoneNumber = '',
    this.totalItems = '',
    this.amountRefunded = '',
    this.refundMode = '',
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'customer_name': customerName,
      'phone_number': phoneNumber,
      'totalItems': totalItems,
      'amountRefunded': amountRefunded,
      'refund_mode': refundMode,
    };
  }

  factory RefundSuccessModel.fromJson(Map<String, dynamic> map) {
    return RefundSuccessModel(
      customerName: map['customer_name'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      totalItems: map['total_items'] ?? '',
      amountRefunded: map['requested_refund_amount'] != null
          ? getActualPrice(
              (map['requested_refund_amount']['cent_amount'])?.toInt() ?? 0,
              (map['requested_refund_amount']['fraction'])?.toInt() ?? 0,
            )
          : '',
      refundMode: map['refund_mode'] ?? '',
    );
  }

  RefundSuccessModel copyWith({
    String? customerName,
    String? phoneNumber,
    String? totalItems,
    String? amountRefunded,
    String? refundMode,
  }) {
    return RefundSuccessModel(
      customerName: customerName ?? this.customerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      totalItems: totalItems ?? this.totalItems,
      amountRefunded: amountRefunded ?? this.amountRefunded,
      refundMode: refundMode ?? this.refundMode,
    );
  }
}
