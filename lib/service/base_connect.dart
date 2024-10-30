import 'package:dio/dio.dart';
import 'package:fire_guard/service/common/status_api.dart';

class BaseConnect {
  late final Dio httpClient;

  BaseConnect() {
    httpClient = Dio(BaseOptions(
      baseUrl: StatusApi.BASE_API_URL, // Hiện tại se su dung ben RemoteConfigService nen gia tri nay khong can thiet
      connectTimeout: const Duration(milliseconds: StatusApi.TIME_OUT),
      receiveTimeout: const Duration(milliseconds: StatusApi.TIME_OUT),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
  }
}


