import 'dart:io' show Platform;

import 'package:easy_localization/easy_localization.dart';

class Constants {
  static const String NO_RELATIVES_FOUND = "NO_RELATIVES_FOUND";
  // Map chứa các mã lỗi và thông báo tương ứng
  static final Map<String, String> _errorMessages = {
    NO_RELATIVES_FOUND: "errors_message.no_relatives_found".tr(),
    // Thêm các cặp mã lỗi - thông báo khác
  };

  // Phương thức để lấy thông báo dựa trên mã lỗi
  static String getErrorMessage(String errorCode) {
    return _errorMessages[errorCode] ?? errorCode;
  }
}