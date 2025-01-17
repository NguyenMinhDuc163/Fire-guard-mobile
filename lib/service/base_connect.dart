import 'package:dio/dio.dart';
import 'package:fire_guard/service/common/status_api.dart';
import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';

class BaseConnect {
  late final Dio httpClient;

  BaseConnect() {

    String authToken = LocalStorageHelper.getValue('authToken') ?? "";
    httpClient = Dio(BaseOptions(
      baseUrl: StatusApi.BASE_API_URL, // Hiện tại se su dung ben RemoteConfigService nen gia tri nay khong can thiet
      connectTimeout: const Duration(milliseconds: StatusApi.TIME_OUT),
      receiveTimeout: const Duration(milliseconds: StatusApi.TIME_OUT),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken', // Gắn token vào header nếu có
      },
    ));
  }
}


