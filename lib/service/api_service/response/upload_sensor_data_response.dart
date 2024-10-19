class UploadSensorDataResponse {
  UploadSensorDataResponse({
    this.message,
  });

  final String? message;

  factory UploadSensorDataResponse.fromJson(Map<String, dynamic> json) =>
      UploadSensorDataResponse(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
