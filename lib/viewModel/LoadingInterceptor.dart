import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoadingInterceptor extends Interceptor {
  final ValueNotifier<bool> isLoading;

  LoadingInterceptor(this.isLoading);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    isLoading.value = true; // Bắt đầu hiển thị loading
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    isLoading.value = false; // Dừng hiển thị loading
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    isLoading.value = false; // Dừng hiển thị loading nếu có lỗi
    super.onError(err, handler);
  }
}
