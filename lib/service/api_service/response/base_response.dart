class BaseResponse<T> {
  BaseResponse({
    this.code,
    this.data,
    this.status,
    this.message,
    this.error,
  });

  final int? code;
  final List<T>? data; // data là một danh sách các đối tượng T
  final String? status;
  final String? message;
  final String? error;

  factory BaseResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json) fromJsonT,
      ) =>
      BaseResponse<T>(
        code: json["code"],
        data: json["data"] != null || json["data"] != {}
            ? List<T>.from(json["data"].map((x) => fromJsonT(x)))
            : [],
        status: json["status"],
        message: json["message"],
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data != null ? data!.map((e) => e).toList() : [],
    "status": status,
    "message": message,
    "error": error,
  };
}
