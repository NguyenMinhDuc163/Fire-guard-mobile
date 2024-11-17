  import 'dart:convert';

  UserLocationRequest userLocationRequestFromJson(String str) =>
      UserLocationRequest.fromJson(json.decode(str));

  String userLocationRequestToJson(UserLocationRequest data) =>
      json.encode(data.toJson());

  class UserLocationRequest {
    UserLocationRequest({
      required this.type,
      this.userID,
      this.longitude,
      this.latitude,
      this.isFire,
    });

    final String type;
    final int? userID;
    final String? longitude;
    final String? latitude;
    final bool? isFire;

    factory UserLocationRequest.fromJson(Map<String, dynamic> json) => UserLocationRequest(
      type: json["type"].toString(),
      userID: json["userID"],
      longitude: json["longitude"],
      latitude: json["latitude"],
      isFire: json["is_fire"],
    );

    Map<String, dynamic> toJson() => {
      "type": type,
      if (userID != null) "userID": userID,
      if (longitude != null) "longitude": longitude,
      if (latitude != null) "latitude": latitude,
      if (isFire != null) "is_fire": isFire,
    };
  }
