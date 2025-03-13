import 'package:flutter/material.dart';

class ErrorConstants {
  static const Map<int, String> errorMessages = {
    400: 'Yêu cầu không hợp lệ. Vui lòng kiểm tra lại thông tin.',
    401: 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.',
    403: 'Bạn không có quyền truy cập tài nguyên này.',
    404: 'Không tìm thấy thông tin yêu cầu.',
    500: 'Lỗi máy chủ. Vui lòng thử lại sau.',
    503: 'Dịch vụ tạm thời không khả dụng. Vui lòng thử lại sau.',
  };

  static const Map<String, IconData> errorIcons = {
    '400': Icons.error_outline,
    '401': Icons.lock_outline,
    '403': Icons.block,
    '404': Icons.search_off,
    '500': Icons.cloud_off,
    '503': Icons.wifi_off,
  };

  static const Map<String, Color> errorColors = {
    '400': Color(0xFFFFA726), // Orange
    '401': Color(0xFF42A5F5), // Blue
    '403': Color(0xFFEF5350), // Red
    '404': Color(0xFF66BB6A), // Green
    '500': Color(0xFF7E57C2), // Purple
    '503': Color(0xFF26A69A), // Teal
  };

  static String getErrorMessage(String errorMessage) {
    if (errorMessage.contains('status code')) {
      final code = errorMessage.split('status code ')[1].split(',')[0];
      return errorMessages[int.parse(code)] ?? 'Đã xảy ra lỗi không xác định.';
    }
    return 'Đã xảy ra lỗi không xác định.';
  }

  static IconData getErrorIcon(String errorMessage) {
    if (errorMessage.contains('status code')) {
      final code = errorMessage.split('status code ')[1].split(',')[0];
      return errorIcons[code] ?? Icons.error_outline;
    }
    return Icons.error_outline;
  }

  static Color getErrorColor(String errorMessage) {
    if (errorMessage.contains('status code')) {
      final code = errorMessage.split('status code ')[1].split(',')[0];
      return errorColors[code] ?? Colors.red;
    }
    return Colors.red;
  }
}
