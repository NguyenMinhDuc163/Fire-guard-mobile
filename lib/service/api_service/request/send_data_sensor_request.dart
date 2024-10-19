import 'dart:convert';

SendDataSensorRequest sendDataSensorRequestFromJson(String str) =>
    SendDataSensorRequest.fromJson(json.decode(str));

String sendDataSensorRequestToJson(SendDataSensorRequest data) =>
    json.encode(data.toJson());

class SendDataSensorRequest {
  SendDataSensorRequest({
    this.deviceId,
    this.flameSensor,
    this.mq2GasLevel,
    this.mq135AirQuality,
    this.timestamp,
  });

  final String? deviceId;
  final bool? flameSensor;
  final int? mq2GasLevel;
  final int? mq135AirQuality;
  final DateTime? timestamp;

  factory SendDataSensorRequest.fromJson(Map<String, dynamic> json) =>
      SendDataSensorRequest(
        deviceId: json["device_id"],
        flameSensor: json["flame_sensor"],
        mq2GasLevel: json["mq2_gas_level"],
        mq135AirQuality: json["mq135_air_quality"],
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
    "device_id": deviceId,
    "flame_sensor": flameSensor,
    "mq2_gas_level": mq2GasLevel,
    "mq135_air_quality": mq135AirQuality,
    "timestamp": timestamp?.toIso8601String(),
  };
}
