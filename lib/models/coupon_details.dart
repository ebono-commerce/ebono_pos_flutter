class CouponDetails {
  final String? couponCode;
  final bool? isApplied;
  final String? message;
  final String? description;

  const CouponDetails({
    this.couponCode,
    this.isApplied,
    this.message,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'coupon_code': couponCode,
      'is_applied': isApplied,
      'message': message,
      'description': description,
    };
  }

  Map<String, dynamic> toPostJson() =>
      <String, dynamic>{'coupon_code': couponCode};

  factory CouponDetails.fromJson(Map<String, dynamic> map) {
    return CouponDetails(
      couponCode: map['coupon_code'] ?? "",
      message: map['message'] ?? "",
      description: map['description'] ?? "",
      isApplied: map['is_applied'] ?? false,
    );
  }

  CouponDetails copyWith({
    String? couponCode,
    bool? isApplied,
    String? message,
    String? description,
  }) {
    return CouponDetails(
      couponCode: couponCode ?? this.couponCode,
      isApplied: isApplied ?? this.isApplied,
      message: message ?? this.message,
      description: description ?? this.description,
    );
  }
}
