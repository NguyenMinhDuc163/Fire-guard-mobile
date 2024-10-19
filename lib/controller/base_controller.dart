import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../models/base_model.dart';


abstract class BaseController {
  BaseModel get model;

  onError(error, {required String source}) {
    print("onError: $error");
    if(error is String){
      model.setError(error: error, source: source);
    }
    model.setLoading(loading: false, source: source);
  }

  onLoading({required String source}) {
    model.clearError(source: source);
    model.setLoading(loading: true, source: source);
  }

  onCompleted(result, {required String source}) {
    model.clearError(source: source);
    model.setLoading(loading: false, source: source);
  }

  Future<void> execute<T>(
      FutureOr<T> computation(), {
        required Function onLoading,
        required Function onCompleted,
        required Function onError,
        required String source,
      }) async {
    // Kiểm tra nếu có hàm onLoading thì gọi
    if (onLoading != null) {
      onLoading();
    } else {
      // Nếu không có thì thực thi một phương thức mặc định của lớp nếu có
      this.onLoading(source: source);
    }

    try {
      // Thực thi hàm tính toán và chờ kết quả
      final result = await Future.sync(computation);

      // Kiểm tra nếu có hàm onCompleted thì gọi với kết quả
      if (onCompleted != null) {
        onCompleted(result);
      } else {
        // Nếu không có thì thực thi phương thức mặc định của lớp
        this.onCompleted(result, source: source);
      }
    } catch (error) {
      // Nếu có lỗi, kiểm tra hàm onError và gọi với lỗi
      if (onError != null) {
        onError(error);
      } else {
        // Nếu không có thì thực thi phương thức mặc định của lớp
        this.onError(error, source: source);
      }
    }
  }
}
