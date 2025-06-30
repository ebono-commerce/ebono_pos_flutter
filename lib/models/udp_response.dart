class UDPBroadCaseResponse {
  final String event;
  final Payload payload;

  const UDPBroadCaseResponse({
    this.event = '',
    this.payload = const Payload(),
  });

  Map<String, dynamic> toMap() {
    return {
      'event': event,
      'payload': payload,
    };
  }

  factory UDPBroadCaseResponse.fromMap(Map<String, dynamic> map) {
    return UDPBroadCaseResponse(
      event: map['event'] ?? '',
      payload: map['payload'] != null
          ? Payload.fromMap(map['payload'])
          : const Payload(),
    );
  }
}

class Payload {
  final String triggerType;
  final String outletId;
  final String dmsId;

  const Payload({
    this.triggerType = '',
    this.outletId = '',
    this.dmsId = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'trigger_type': triggerType,
      'outlet_id': outletId,
      'dms_id': dmsId,
    };
  }

  factory Payload.fromMap(Map<String, dynamic> map) {
    return Payload(
      triggerType: map['trigger_type'] ?? '',
      outletId: map['outlet_id'] ?? '',
      dmsId: map['dms_id'] ?? '',
    );
  }
}
