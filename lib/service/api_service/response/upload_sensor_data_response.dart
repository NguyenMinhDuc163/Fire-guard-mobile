class UploadSensorDataResponse {
  UploadSensorDataResponse({this.a});
  final String? a;
  factory UploadSensorDataResponse.fromJson(Map<String, dynamic> json) =>
      UploadSensorDataResponse(
        a: json["a"],
      );

  Map<String, dynamic> toJson() => {
        "a": a,
  };
  @override
  String toString() {
    print('a: $a');
    return super.toString();
  }
}
