import 'dart:convert';

FireEmergencyRequest fireEmergencyRequestFromJson(String str) =>
    FireEmergencyRequest.fromJson(json.decode(str));

String fireEmergencyRequestToJson(FireEmergencyRequest data) =>
    json.encode(data.toJson());

class FireEmergencyRequest {
  FireEmergencyRequest({
    this.location,
    this.incidentDetails,
    this.timestamp,
  });

  final String? location;
  final String? incidentDetails;
  final DateTime? timestamp;

  factory FireEmergencyRequest.fromJson(Map<String, dynamic> json) =>
      FireEmergencyRequest(
        location: json["location"],
        incidentDetails: json["incident_details"],
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
    "location": location,
    "incident_details": incidentDetails,
    "timestamp": timestamp?.toIso8601String(),
  };
}
