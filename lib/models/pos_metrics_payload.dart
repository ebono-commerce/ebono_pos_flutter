class PosMetricsPayload {
  final String outletId;
  final String dmsId;
  final String type;
  final String upstreamType;
  final String terminalId;
  final String registerId;
  final String macAddress;
  final String userId;
  final String appVersion;
  final String lastOrderAt;
  final String currentCartId;
  final String weighingScaleStatus;
  final String edcType;
  final String triggerType;

  const PosMetricsPayload({
    this.outletId = '',
    this.dmsId = '',
    this.type = 'CLIENT',
    this.upstreamType = '',
    this.terminalId = '',
    this.registerId = '',
    this.macAddress = '',
    this.userId = '',
    this.appVersion = '',
    this.lastOrderAt = '',
    this.currentCartId = '',
    this.weighingScaleStatus = 'NA',
    this.edcType = '',
    this.triggerType = '',
  });

  PosMetricsPayload copyWith({
    String? outletId,
    String? dmsId,
    String? type,
    String? upstreamType,
    String? terminalId,
    String? registerId,
    String? macAddress,
    String? userId,
    String? appVersion,
    String? lastOrderAt,
    String? currentCartId,
    String? weighingScaleStatus,
    String? edcType,
    String? triggerType,
  }) {
    return PosMetricsPayload(
      outletId: outletId ?? this.outletId,
      dmsId: dmsId ?? this.dmsId,
      type: type ?? this.type,
      upstreamType: upstreamType ?? this.upstreamType,
      terminalId: terminalId ?? this.terminalId,
      registerId: registerId ?? this.registerId,
      macAddress: macAddress ?? this.macAddress,
      userId: userId ?? this.userId,
      appVersion: appVersion ?? this.appVersion,
      lastOrderAt: lastOrderAt ?? this.lastOrderAt,
      currentCartId: currentCartId ?? this.currentCartId,
      weighingScaleStatus: weighingScaleStatus ?? this.weighingScaleStatus,
      edcType: edcType ?? this.edcType,
      triggerType: triggerType ?? this.triggerType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'outlet_id': outletId,
      'dms_id': dmsId,
      'type': type,
      'upstream_type': upstreamType,
      'terminal_id': terminalId,
      'register_id': registerId,
      'mac_address': macAddress,
      'user_id': userId,
      'app_version': appVersion,
      'last_order_at': lastOrderAt,
      'current_cart_id': currentCartId,
      'weighing_scale_status': weighingScaleStatus,
      'edc_type': edcType,
      'trigger_type': triggerType,
    };
  }

  factory PosMetricsPayload.fromMap(Map<String, dynamic> map) {
    return PosMetricsPayload(
      outletId: map['outlet_id'] as String,
      dmsId: map['dms_id'] as String,
      type: map['type'] as String,
      upstreamType: map['upstream_type'] as String,
      terminalId: map['terminal_id'] as String,
      registerId: map['register_id'] as String,
      macAddress: map['mac_address'] as String,
      userId: map['user_id'] as String,
      appVersion: map['app_version'] as String,
      lastOrderAt: map['last_order_at'] as String,
      currentCartId: map['current_cart_id'] as String,
      weighingScaleStatus: map['weighing_scale_status'] as String,
      edcType: map['edc_type'] as String,
      triggerType: map['trigger_type'] as String,
    );
  }
}
