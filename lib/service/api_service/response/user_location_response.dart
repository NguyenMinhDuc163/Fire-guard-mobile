class UserLocationResponse {
  final String longitude;
  final String latitude;
  final bool isFire;

  UserLocationResponse({
    required this.longitude,
    required this.latitude,
    required this.isFire,
  });

  factory UserLocationResponse.fromJson(Map<String, dynamic> json) =>
      UserLocationResponse(
        longitude: json["longitude"],
        latitude: json["latitude"],
        isFire: json["is_fire"],
      );

  Map<String, dynamic> toJson() => {
    "longitude": longitude,
    "latitude": latitude,
    "is_fire": isFire,
  };

  @override
  String toString() {
    return 'UserLocationResponse{longitude: $longitude, latitude: $latitude, is_fire: $isFire}';
  }
}
