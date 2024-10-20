import 'package:fire_guard/models/sensor_model.dart';
import 'package:fire_guard/service/api_service/api_service.dart';
import 'package:fire_guard/service/api_service/request/add_guide_and_news_request.dart';
import 'package:fire_guard/service/api_service/request/device_status_request.dart';
import 'package:fire_guard/service/api_service/request/fire_emergency_request.dart';
import 'package:fire_guard/service/api_service/request/login_request.dart';
import 'package:fire_guard/service/api_service/request/register_request.dart';
import 'package:fire_guard/service/api_service/request/save_device_status_request.dart';
import 'package:fire_guard/service/api_service/request/send_data_sensor_request.dart';
import 'package:fire_guard/service/api_service/request/send_family_alert_request.dart';
import 'package:fire_guard/service/api_service/request/send_notification_request.dart';
import 'package:fire_guard/service/api_service/request/upload_sensor_data_request.dart';
import 'package:fire_guard/service/api_service/response/add_guide_and_news_response.dart';
import 'package:fire_guard/service/api_service/response/base_response.dart';
import 'package:fire_guard/service/api_service/response/device_status_response.dart';

import 'package:fire_guard/service/api_service/response/fire_emergency_response.dart';
import 'package:fire_guard/service/api_service/response/login_response.dart';
import 'package:fire_guard/service/api_service/response/register_response.dart';
import 'package:fire_guard/service/api_service/response/save_device_status_response.dart';
import 'package:fire_guard/service/api_service/response/send_data_sensor_response.dart';
import 'package:fire_guard/service/api_service/response/send_family_alert_response.dart';
import 'package:fire_guard/service/api_service/response/send_notification_response.dart';
import 'package:fire_guard/service/api_service/response/upload_sensor_data_response.dart';
import 'package:flutter/cupertino.dart';


class SensorViewModel extends ChangeNotifier {
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
    print('Code: ${response.code}');
    print('Status: ${response.status}');
    print('Message: ${response.message}');
    print('Error: ${response.error}');
    print('Data: ${response.data}');

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
    final BaseResponse<UploadSensorDataResponse> response =
        await apiServices.uploadSensorData(request);
    print('Code: ${response.code}');
    print('Status: ${response.status}');
    print('Message: ${response.message}');
    print('Error: ${response.error}');
    print('Data: ${response.data}');

    notifyListeners();
  }

  void sendNotification() async {
    SendNotificationRequest request = SendNotificationRequest(
      userId: "user_001",
      message: "Cảnh báo! Phát hiện cháy.",
      timestamp: DateTime.now().toUtc(),
    );
    final BaseResponse<SendNotificationResponse> response =
        await apiServices.sendNotification(request);
    print('Code: ${response.code}');
    print('Status: ${response.status}');
    print('Message: ${response.message}');
    print('Error: ${response.error}');
    print('Data: ${response.data}');

    notifyListeners();
  }

  void sendFamilyAlert() async {
    SendFamilyAlertRequest request = SendFamilyAlertRequest(
      userId: "user_002",
      message: "Người thân của bạn đang gặp nguy hiểm.",
      familyMemberId: 'family_002',
      timestamp: DateTime.now().toUtc(),
    );
    final BaseResponse<SendFamilyAlertResponse> response =
    await apiServices.sendFamilyAlert(request);
    print('Code: ${response.code}');
    print('Status: ${response.status}');
    print('Message: ${response.message}');
    print('Error: ${response.error}');
    print('Data: ${response.data}');

    notifyListeners();
  }


  void saveDeviceStatus() async {
    List<SaveDeviceStatusRequest> requests = [
      SaveDeviceStatusRequest(
        deviceName: 'esp8266_001',
        status: 'active',
        timestamp: DateTime.now().toUtc(),
      )
    ];

    // final BaseResponse<AddDocumentResponse> response =
    // await apiServices.addDocument(requests);
    final BaseResponse<SaveDeviceStatusResponse> response =
    await apiServices.saveDeviceStatus(requests);
    print('Code: ${response.code}');
    print('Status: ${response.status}');
    print('Message: ${response.message}');
    print('Error: ${response.error}');
    print('Data: ${response.data}');

    notifyListeners();
  }


  void sendFireEmergency() async {
    FireEmergencyRequest request = FireEmergencyRequest(
      location: 'Hà Nội',
      incidentDetails: 'Phát hiện cháy lớn.',
      timestamp: DateTime.now().toUtc(),
    );
    final BaseResponse<FireEmergencyResponse> response =
    await apiServices.sendFireEmergency(request);
    print('Code: ${response.code}');
    print('Status: ${response.status}');
    print('Message: ${response.message}');
    print('Error: ${response.error}');
    print('Data: ${response.data}');

    notifyListeners();
  }


  void addGuideAndNewsResponse() async {
    // Tạo danh sách các tài liệu
    List<AddGuideAndNewsRequest> requests = [
      AddGuideAndNewsRequest(
        title: "Cách sử dụng bình chữa cháy",
        type: "video",
        url: "https://example.com/video1",
        content: null,
        category: "guide",
      ),
      AddGuideAndNewsRequest(
        title: "Cách thoát hiểm khi có cháy",
        type: "article",
        url: null,
        content: "Hướng dẫn cách thoát hiểm khi có cháy",
        category: "guide",
      ),
    ];

    try {

      final BaseResponse<AddGuideAndNewsResponse> response =
      await apiServices.addDocument(requests);

      print('Code: ${response.code}');
      print('Status: ${response.status}');
      print('Message: ${response.message}');
      print('Error: ${response.error}');
      print('Data: ${response.data}');
    } catch (e) {
      print('Error: $e');
    }

    notifyListeners();
  }


  void getDeviceStatus() async {
    try {
      final BaseResponse<DeviceStatusResponse> response =
      await apiServices.getDeviceStatus();

      print('Code: ${response.code}');
      print('Status: ${response.status}');
      print('Message: ${response.message}');
      print('Error: ${response.error}');
      print('Data: ${response.data}');
    } catch (e) {
      print('Error: $e');
    }

    notifyListeners();
  }

  void fetchHistory() async {
    try {
      final response = await apiServices.getHistory(
        userId: "user_001",
        startDate: "2024-10-13",
        endDate: "2024-10-13",
      );

      print('Code: ${response.code}');
      print('Status: ${response.status}');
      print('Message: ${response.message}');

      if (response.data != null) {
        for (var incident in response.data!) {
          print(
              'Incident ID: ${incident.incidentId}, Message: ${incident.message}, Timestamp: ${incident.timestamp}');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void fetchGuidesAndNews() async {
    try {
      final response = await apiServices.getGuidesAndNews(
        category: "guide",
        limit: 5,
      );

      print('Code: ${response.code}');
      print('Status: ${response.status}');
      print('Message: ${response.message}');

      if (response.data != null) {
        for (var guide in response.data!) {
          print(
              'ID: ${guide.id}, Title: ${guide.title}, Type: ${guide.type}, URL: ${guide.url}, Content: ${guide.content}');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void sendLogin() async {
    LoginRequest request = LoginRequest(
      email: 'testuser@example.com',
      password: 'password123',
    );
    final BaseResponse<LoginResponse> response =
    await apiServices.sendLogin(request);
    print('Code: ${response.code}');
    print('Status: ${response.status}');
    print('Message: ${response.message}');
    print('Error: ${response.error}');
    print('Data: ${response.data}');

    notifyListeners();
  }


  void sendRegister() async {
    RegisterRequest request = RegisterRequest(
        username: "testusser",
        email: "testudssssssaser@exasdssdasdsdsmsple.com",
        password: "password123",
        tokenFcm: "abc123xyz"
    );
    final BaseResponse<RegisterResponse> response =
    await apiServices.sendRegister(request);
    print('Code: ${response.code}');
    print('Status: ${response.status}');
    print('Message: ${response.message}');
    print('Error: ${response.error}');
    print('Data: ${response.data}');

    notifyListeners();
  }

}
