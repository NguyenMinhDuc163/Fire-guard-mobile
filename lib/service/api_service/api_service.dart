
import 'package:fire_guard/service/api_service/BaseApiService.dart';
import 'package:fire_guard/service/api_service/request/add_guide_and_news_request.dart';
import 'package:fire_guard/service/api_service/request/change_password_request.dart';
import 'package:fire_guard/service/api_service/request/device_status_request.dart';
import 'package:fire_guard/service/api_service/request/fire_emergency_request.dart';
import 'package:fire_guard/service/api_service/request/login_request.dart';
import 'package:fire_guard/service/api_service/request/register_request.dart';
import 'package:fire_guard/service/api_service/request/save_device_status_request.dart';
import 'package:fire_guard/service/api_service/request/send_family_alert_request.dart';
import 'package:fire_guard/service/api_service/request/send_notification_request.dart';
import 'package:fire_guard/service/api_service/request/upload_sensor_data_request.dart';
import 'package:fire_guard/service/api_service/request/user_location_request.dart';
import 'package:fire_guard/service/api_service/response/add_guide_and_news_response.dart';
import 'package:fire_guard/service/api_service/response/base_response.dart';
import 'package:fire_guard/service/api_service/response/change_password_response.dart';
import 'package:fire_guard/service/api_service/response/device_status_response.dart';
import 'package:fire_guard/service/api_service/response/fire_emergency_response.dart';
import 'package:fire_guard/service/api_service/response/login_response.dart';
import 'package:fire_guard/service/api_service/response/register_response.dart';
import 'package:fire_guard/service/api_service/response/save_device_status_response.dart';
import 'package:fire_guard/service/api_service/response/save_location_response.dart';
import 'package:fire_guard/service/api_service/response/send_family_alert_response.dart';
import 'package:fire_guard/service/api_service/response/send_notification_response.dart';
import 'package:fire_guard/service/api_service/response/upload_sensor_data_response.dart';
import 'package:fire_guard/service/api_service/response/user_list_response.dart';
import 'package:fire_guard/service/api_service/response/user_location_response.dart';

import 'request/send_data_sensor_request.dart';
import 'response/guide_and_news_response.dart';
import 'response/HistoryResponse.dart';
import 'response/guide_and_news_response.dart';
import 'response/send_data_sensor_response.dart';

class ApiServices extends BaseApiService {
  // Phương thức gửi dữ liệu cảm biến
  Future<BaseResponse<SendDataSensorResponse>> sendSensorData(SendDataSensorRequest request) async {
    return await sendRequest<SendDataSensorResponse>(
      'sensors/data',
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => SendDataSensorResponse.fromJson(json),
    );
  }

  //Lưu Dữ Liệu Vào Cơ Sở Dữ Liệu
  Future<BaseResponse<UploadSensorDataResponse>> uploadSensorData(
      UploadSensorDataRequest request) async {
    return await sendRequest<UploadSensorDataResponse>(
      'data/save',
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => UploadSensorDataResponse.fromJson(json),
    );
  }

//Gửi Thông Báo Đến Người Dùng
  Future<BaseResponse<SendNotificationResponse>> sendNotification(
      SendNotificationRequest request) async {
    return await sendRequest<SendNotificationResponse>(
      'notifications/send',
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => SendNotificationResponse.fromJson(json),
    );
  }

  //Gửi Thông Báo Đến Người than
  Future<BaseResponse<SendFamilyAlertResponse>> sendFamilyAlert(
      SendFamilyAlertRequest request) async {
    return await sendRequest<SendFamilyAlertResponse>(
      'notifications/family',
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => SendFamilyAlertResponse.fromJson(json),
    );
  }

  //Lưu trạng thái thiết bị vào hệ thống
  Future<BaseResponse<SaveDeviceStatusResponse>> saveDeviceStatus(
      List<SaveDeviceStatusRequest> request) async {
    final data = saveDeviceStatusRequestToJson(request);
    return await sendRequest<SaveDeviceStatusResponse>(
      'iot/status/save',
      method: 'POST',
      data: data,
      fromJson: (json) => SaveDeviceStatusResponse.fromJson(json),
    );
  }

  //Gọi Lực Lượng Cứu Hỏa
  Future<BaseResponse<FireEmergencyResponse>> sendFireEmergency(
      FireEmergencyRequest request) async {
    return await sendRequest<FireEmergencyResponse>(
      'emergency/call',
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => FireEmergencyResponse.fromJson(json),
    );
  }

// Thêm Dữ Liệu Hướng Dẫn và Tin Tức
  Future<BaseResponse<AddGuideAndNewsResponse>> addDocument(
      List<AddGuideAndNewsRequest> request) async {
    final data = addGuideAndNewsRequestToJson(request);
    return await sendRequest<AddGuideAndNewsResponse>(
      'guides_and_news/add',
      method: 'POST',
      data: data,
      fromJson: (json) => AddGuideAndNewsResponse.fromJson(json),
    );
  }

  // Kiểm Tra Trạng Thái Hệ Thống IoT
  Future<BaseResponse<DeviceStatusResponse>> getDeviceStatus() async {
    return await sendRequest<DeviceStatusResponse>(
      'iot/status',
      method: 'GET',
      fromJson: (json) => DeviceStatusResponse.fromJson(json),
    );
  }

  // api lấy lịch sử cảnh báo
  Future<BaseResponse<HistoryResponse>> getHistory({
    String? userId,
    String? startDate,
    String? endDate,
  }) async {
    final queryParams = <String, String>{};

    // Thêm tham số vào queryParams nếu chúng không null hoặc không rỗng
    if (userId != null && userId.isNotEmpty) {
      queryParams["user_id"] = userId;
    }
    if (startDate != null && startDate.isNotEmpty) {
      queryParams["start_date"] = startDate;
    }
    if (endDate != null && endDate.isNotEmpty) {
      queryParams["end_date"] = endDate;
    }

    return await sendRequest<HistoryResponse>(
      'history',
      method: 'GET',
      data: queryParams, // Truyền queryParams vào đây
      fromJson: (json) => HistoryResponse.fromJson(json),
    );
  }




  // api lấy hướng dẫn và tin tức
  Future<BaseResponse<GuideAndNewsResponse>> getGuidesAndNews({
    required String category,
    required int limit,
  }) async {
    final queryParams = {
      "category": category,
      "limit": limit.toString(),
    };

    return await sendRequest<GuideAndNewsResponse>(
      'guides_and_news',
      method: 'GET',
      data: queryParams,
      fromJson: (json) => GuideAndNewsResponse.fromJson(json),
    );
  }


  // api login
  Future<BaseResponse<LoginResponse>> sendLogin(LoginRequest request) async {
    return await sendRequest<LoginResponse>(
      'auth/login',
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => LoginResponse.fromJson(json),
    );
  }


  // api register

  Future<BaseResponse<RegisterResponse>> sendRegister(RegisterRequest request) async {
    return await sendRequest<RegisterResponse>(
      'auth/register',
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => RegisterResponse.fromJson(json),
    );
  }

  //Lay danh sach User
  Future<BaseResponse<UserListResponse>> sendUserList(
      UserLocationRequest request) async {
    return await sendRequest<UserListResponse>(
      '/user_location',
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => UserListResponse.fromJson(json),
    );
  }

  // lay DS toa do
  Future<BaseResponse<UserLocationResponse>> sendLocationUser(
      UserLocationRequest request) async {
    return await sendRequest<UserLocationResponse>(
      '/user_location',
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => UserLocationResponse.fromJson(json),
    );
  }

  // luu toa do user
  Future<BaseResponse<SaveLocationResponse>> saveLocationUser(
      UserLocationRequest request) async {
    return await sendRequest<SaveLocationResponse>(
      '/user_location',
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => SaveLocationResponse.fromJson(json),
    );
  }

  // doi mat khau

  // luu toa do user
  Future<BaseResponse<ChangePasswordResponse>> changePassword(
      ChangePasswordRequest request) async {
    return await sendRequest<ChangePasswordResponse>(
      '/auth/change_password',
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => ChangePasswordResponse.fromJson(json),
    );
  }
}




