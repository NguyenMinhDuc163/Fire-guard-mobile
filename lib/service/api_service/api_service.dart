import 'package:dio/dio.dart';
import 'package:fire_guard/service/api_service/BaseApiService.dart';

import 'request/send_data_sensor_request.dart';
import 'response/api_response.dart';
import 'response/send_data_sensor_response.dart';


class ApiServices extends BaseApiService {
  // Phương thức gửi dữ liệu cảm biến
  Future<ApiResponse<SendDataSensorResponse>> sendSensorData(
      SendDataSensorRequest request) async {
    return await sendRequest<SendDataSensorResponse>(
      '/api/v1/sensors/data',
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => SendDataSensorResponse.fromJson(json),
    );
  }

  // Bạn có thể thêm nhiều phương thức API khác tương tự
  Future<ApiResponse<List<SendDataSensorResponse>>> fetchSensorList() async {
    return await sendRequest<List<SendDataSensorResponse>>(
      '/api/v1/sensors',
      fromJson: (json) {
        List<dynamic> data = json['data'] ?? [];
        return data.map((item) => SendDataSensorResponse.fromJson(item)).toList();
      },
    );
  }
}
