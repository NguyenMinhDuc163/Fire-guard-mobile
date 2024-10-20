import 'package:dio/dio.dart';

import 'common/status_api.dart';


class NetworkService    {
  static final NetworkService  _instance = NetworkService ._internal();
  factory NetworkService () => _instance;

  late Dio dio;

  NetworkService ._internal() {
    dio = Dio(BaseOptions(
      baseUrl: StatusApi.BASE_API_URL,
      connectTimeout: const Duration(milliseconds: StatusApi.TIME_OUT),
      receiveTimeout: const Duration(milliseconds: StatusApi.TIME_OUT),
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
