import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<T> executeWithLoading<T>(Future<T> Function() action) async {
    setLoading(true); // Bật trạng thái loading
    try {
      return await action(); // Thực hiện hành động
    } finally {
      setLoading(false); // Tắt trạng thái loading
    }
  }
}
