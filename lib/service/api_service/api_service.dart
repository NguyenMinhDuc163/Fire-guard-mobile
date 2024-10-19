import 'package:dio/dio.dart';
import 'package:fire_guard/service/api_service/BaseApiService.dart';
import 'package:fire_guard/service/api_service/request/upload_sensor_data_request.dart';
import 'package:fire_guard/service/api_service/response/base_response.dart';
import 'package:fire_guard/service/api_service/response/upload_sensor_data_response.dart';

import 'request/send_data_sensor_request.dart';
import 'response/api_response.dart';
import 'response/send_data_sensor_response.dart';


class ApiServices extends BaseApiService {
  // Phương thức gửi dữ liệu cảm biến
  Future<BaseResponse<SendDataSensorResponse>> sendSensorData(
      SendDataSensorRequest request) async {
    return await sendRequest<SendDataSensorResponse>(
      '/api/v1/sensors/data',
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => SendDataSensorResponse.fromJson(json),
    );
  }

  Future<BaseResponse<UploadSensorDataResponse>> uploadSensorData(
      UploadSensorDataRequest request) async {
    return await sendRequest<UploadSensorDataResponse>(
      '/api/v1/data/save',
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => UploadSensorDataResponse.fromJson(json),
    );
  }
}
