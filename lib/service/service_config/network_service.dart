import 'package:dio/dio.dart';
import 'package:fire_guard/service/base_connect.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  static NetworkService get instance => _instance;

  late Dio dio;
  late BaseConnect baseConnect;

  NetworkService._internal() {
    baseConnect = BaseConnect();
    dio = baseConnect.httpClient;

    // Thêm interceptor nếu cần
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  BaseConnect getBaseConnect() => baseConnect;

  // Phương thức cập nhật URL cho Dio
  void updateBaseUrl(String newBaseUrl) {
    dio.options.baseUrl = newBaseUrl;
    print('--Dio baseUrl updated to: $newBaseUrl--');
  }
}