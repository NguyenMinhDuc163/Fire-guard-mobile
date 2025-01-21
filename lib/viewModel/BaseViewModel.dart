import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<T> execute<T>(
      Future<T> Function() action, {
        Function(dynamic error)? onError,
      }) async {
    setLoading(true);
    try {
      return await action();
    } catch (e) {
      setError(e.toString());
      if (onError != null) {
        onError(e);
      }
      rethrow;
    } finally {
      setLoading(false);
    }
  }
}
