import 'package:fire_guard/providers/LoadingInterceptor.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fire_guard/service/base_connect.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  static NetworkService get instance => _instance;

  late Dio dio;
  late BaseConnect baseConnect;

  // Quản lý trạng thái loading
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  NetworkService._internal() {
    baseConnect = BaseConnect();
    dio = baseConnect.httpClient;

    // Thêm interceptor
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    // Thêm LoadingInterceptor
    dio.interceptors.add(LoadingInterceptor(isLoading));
  }

  BaseConnect getBaseConnect() => baseConnect;

  // Phương thức cập nhật URL cho Dio
  void updateBaseUrl(String newBaseUrl) {
    // dio.options.baseUrl = newBaseUrl;
    baseConnect.updateURL(newBaseUrl);
    print('--Dio baseUrl updated to: $newBaseUrl--');
  }

  void updateAuthToken(String newToken) {
    baseConnect.updateToken(newToken);
  }


}
