import 'dart:convert';

DeviceStatusRequest deviceStatusRequestFromJson(String str) =>
    DeviceStatusRequest.fromJson(json.decode(str));

String deviceStatusRequestToJson(DeviceStatusRequest data) =>
    json.encode(data.toJson());

class DeviceStatusRequest {
  DeviceStatusRequest();

  factory DeviceStatusRequest.fromJson(Map<String, dynamic> json) =>
      DeviceStatusRequest();

  Map<String, dynamic> toJson() => {};
}
