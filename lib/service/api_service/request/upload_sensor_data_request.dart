import 'dart:convert';

UploadSensorDataRequest uploadSensorDataRequestFromJson(String str) =>
    UploadSensorDataRequest.fromJson(json.decode(str));

String uploadSensorDataRequestToJson(UploadSensorDataRequest data) =>
    json.encode(data.toJson());

class UploadSensorDataRequest {
  UploadSensorDataRequest({
    this.deviceId,
    this.flameSensor,
    this.mq2GasLevel,
    this.mq135AirQuality,
    this.timestamp,
  });

  final String? deviceId;
  final bool? flameSensor;
  final dynamic mq2GasLevel;
  final dynamic mq135AirQuality;
  final DateTime? timestamp;

  factory UploadSensorDataRequest.fromJson(Map<String, dynamic> json) =>
      UploadSensorDataRequest(
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
