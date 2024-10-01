//tạo ra chuỗi xác thực với Bearer token cho HTTP request.
class HttpUtility {
  static String getBearerAuthentication(String token) {
    return "Bearer $token";
  }
// static String getBearerAuthentication(String token) {
//   return '${Utils.getCurrentTimeStringRequest()}|${value.userName}|X-AUTH-TOKEN $token|DEVICE_ID ${value.deviceId}';
// }
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
