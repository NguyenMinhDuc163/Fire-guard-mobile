class BaseResponse<T> {
  BaseResponse({
    this.code,
    this.data,
    this.status,
    this.message,
    this.error,
  });

  final int? code;
  final T? data;
  final String? status;
  final String? message;
  final String? error;

  factory BaseResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json) fromJsonT,
      ) =>
      BaseResponse<T>(
        code: json["code"],
        data: json["data"] != null ? fromJsonT(json["data"]) : null,
        status: json["status"],
        message: json["message"],
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data,
    "status": status,
    "message": message,
    "error": error,
  };
}
