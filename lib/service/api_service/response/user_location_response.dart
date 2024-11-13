class UserLocationResponse {
  final String longitude;
  final String latitude;

  UserLocationResponse({
    required this.longitude,
    required this.latitude,
  });

  factory UserLocationResponse.fromJson(Map<String, dynamic> json) =>
      UserLocationResponse(
        longitude: json["longitude"],
        latitude: json["latitude"],
      );

  Map<String, dynamic> toJson() => {
    "longitude": longitude,
    "latitude": latitude,
  };

  @override
  String toString() {
    return 'UserLocationResponse{longitude: $longitude, latitude: $latitude}';
  }
}
