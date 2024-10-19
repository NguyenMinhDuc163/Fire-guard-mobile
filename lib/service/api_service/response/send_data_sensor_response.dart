import 'dart:convert';

SendDataSensorResponse sendDataSensorResponseFromJson(String str) =>
    SendDataSensorResponse.fromJson(json.decode(str));

String sendDataSensorResponseToJson(SendDataSensorResponse data) => json.encode(data.toJson());

class SendDataSensorResponse {
  SendDataSensorResponse();

  factory SendDataSensorResponse.fromJson(Map<String, dynamic> json) => SendDataSensorResponse();

  Map<String, dynamic> toJson() => {};
}
