import 'package:dio/dio.dart';

import 'common/status_api.dart';


class NetworkService    {
  static final NetworkService  _instance = NetworkService ._internal();
  factory NetworkService () => _instance;

  late Dio dio;

  NetworkService ._internal() {
    dio = Dio(BaseOptions(
      baseUrl: StatusApi.BASE_API_URL,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Thêm interceptor nếu cần
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }
}
