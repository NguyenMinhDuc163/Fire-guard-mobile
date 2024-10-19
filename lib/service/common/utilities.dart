//tạo ra chuỗi xác thực với Bearer token cho HTTP request.
import 'package:fire_guard/service/api_service/response/base_response.dart';

class HttpUtility {
  static String getBearerAuthentication(String token) {
    return "Bearer $token";
  }


}

class StringUtility {
  static String trimLeft(String from, String pattern) {
    if ((from ?? '').isEmpty ||
        (pattern ?? '').isEmpty ||
        pattern.length > from.length) return from;

    while (from.startsWith(pattern)) {
      from = from.substring(pattern.length);
    }
    return from;
  }

  static String trimRight(String from, String pattern) {
    if ((from ?? '').isEmpty ||
        (pattern ?? '').isEmpty ||
        pattern.length > from.length) return from;

    while (from.endsWith(pattern)) {
      from = from.substring(0, from.length - pattern.length);
    }
    return from;
  }
}

String handleApiResponse<T>(BaseResponse<T> response, {String? successMessage}) {
  if (response.code != 200 || response.error?.isNotEmpty == true) {
    return 'Lỗi: ${response.error ?? "Không xác định"}';
  } else {
    return successMessage ?? 'Thành công: ${response.message}';
  }
}
