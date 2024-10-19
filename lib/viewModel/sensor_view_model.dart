import 'package:fire_guard/models/sensor_model.dart';
import 'package:fire_guard/service/api_service/api_service.dart';
import 'package:fire_guard/service/api_service/request/send_data_sensor_request.dart';
import 'package:fire_guard/service/api_service/request/upload_sensor_data_request.dart';
import 'package:fire_guard/service/api_service/response/api_response.dart';
import 'package:fire_guard/service/api_service/response/base_response.dart';
import 'package:fire_guard/service/api_service/response/send_data_sensor_response.dart';
import 'package:fire_guard/service/api_service/response/upload_sensor_data_response.dart';
import 'package:flutter/cupertino.dart';


class SensorViewModel extends ChangeNotifier{
  final ApiServices apiServices = ApiServices();
  SensorModel sensorModel = SensorModel();
  SensorModel get model => sensorModel;

  void sendSensorData() async {
    SendDataSensorRequest request = SendDataSensorRequest(
      deviceId: 'esp8266_001',
      flameSensor: true,
      mq2GasLevel: 500,
      mq135AirQuality: 300,
      timestamp: DateTime.now().toUtc(),
    );

    BaseResponse<SendDataSensorResponse> response = await apiServices.sendSensorData(request);
    print('Response: ${response.message} - ${response.code}');

      notifyListeners();
  }


  void uploadSensorData() async {
    UploadSensorDataRequest request = UploadSensorDataRequest(
      deviceId: 'esp8266_001',
      flameSensor: true,
      mq2GasLevel: 500,
      mq135AirQuality: 300,
      timestamp: DateTime.now().toUtc(),
    );
    final BaseResponse<UploadSensorDataResponse> response = await apiServices.uploadSensorData(request);
    print('Response: ${response.message} - ${response.code}');

    notifyListeners();
  }
}