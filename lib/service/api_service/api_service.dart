import 'package:fire_guard/service/init.dart';
import 'package:fire_guard/service/common/url_static.dart';

import 'response/delete_family_response.dart';


class ApiServices extends BaseApiService {
  // Phương thức gửi dữ liệu cảm biến
  Future<BaseResponse<SendDataSensorResponse>> sendSensorData(SendDataSensorRequest request) async {
    return await sendRequest<SendDataSensorResponse>(
      UrlStatic.API_SENSORS_DATA,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => SendDataSensorResponse.fromJson(json),
    );
  }

  //Lưu Dữ Liệu Vào Cơ Sở Dữ Liệu
  Future<BaseResponse<UploadSensorDataResponse>> uploadSensorData(
      UploadSensorDataRequest request) async {
    return await sendRequest<UploadSensorDataResponse>(
      UrlStatic.API_SAVE_DATA,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => UploadSensorDataResponse.fromJson(json),
    );
  }

//Gửi Thông Báo Đến Người Dùng
  Future<BaseResponse<SendNotificationResponse>> sendNotification(
      SendNotificationRequest request) async {
    return await sendRequest<SendNotificationResponse>(
      UrlStatic.API_SEND_NOTIFICATIONS,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => SendNotificationResponse.fromJson(json),
    );
  }

  //Gửi Thông Báo Đến Người than
  Future<BaseResponse<SendFamilyAlertResponse>> sendFamilyAlert(
      SendFamilyAlertRequest request) async {
    return await sendRequest<SendFamilyAlertResponse>(
      UrlStatic.API_FAMILY_NOTIFICATIONS,
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
      UrlStatic.API_SAVE_IOT_STATUS,
      method: 'POST',
      data: data,
      fromJson: (json) => SaveDeviceStatusResponse.fromJson(json),
    );
  }

  //Gọi Lực Lượng Cứu Hỏa
  Future<BaseResponse<FireEmergencyResponse>> sendFireEmergency(
      FireEmergencyRequest request) async {
    return await sendRequest<FireEmergencyResponse>(
      UrlStatic.API_EMERGENCY_CALL,
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
      UrlStatic.API_ADD_GUIDES_AND_NEWS,
      method: 'POST',
      data: data,
      fromJson: (json) => AddGuideAndNewsResponse.fromJson(json),
    );
  }

  // Kiểm Tra Trạng Thái Hệ Thống IoT
  Future<BaseResponse<DeviceStatusResponse>> getDeviceStatus() async {
    return await sendRequest<DeviceStatusResponse>(
      UrlStatic.API_IOT_STATUS,
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
      UrlStatic.API_HISTORY,
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
      UrlStatic.API_GUIDES_AND_NEWS,
      method: 'GET',
      data: queryParams,
      fromJson: (json) => GuideAndNewsResponse.fromJson(json),
    );
  }


  // api login
  Future<BaseResponse<LoginResponse>> sendLogin(LoginRequest request) async {
    return await sendRequest<LoginResponse>(
      UrlStatic.API_LOGIN,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => LoginResponse.fromJson(json),
    );
  }


  // api register

  Future<BaseResponse<RegisterResponse>> sendRegister(RegisterRequest request) async {
    return await sendRequest<RegisterResponse>(
      UrlStatic.API_REGISTER,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => RegisterResponse.fromJson(json),
    );
  }

  // forgot password
  Future<BaseResponse<ForgotPasswordResponse>> sendForgotPassword(ForgotPasswordRequest request) async {
    return await sendRequest<ForgotPasswordResponse>(
      UrlStatic.API_FORGOT_PASSWORD,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => ForgotPasswordResponse.fromJson(json),
    );
  }


  //Lay danh sach User
  Future<BaseResponse<UserListResponse>> sendUserList(
      UserLocationRequest request) async {
    return await sendRequest<UserListResponse>(
      UrlStatic.API_USER_LOCATION,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => UserListResponse.fromJson(json),
    );
  }

  // lay DS toa do
  Future<BaseResponse<UserLocationResponse>> sendLocationUser(
      UserLocationRequest request) async {
    return await sendRequest<UserLocationResponse>(
      UrlStatic.API_USER_LOCATION,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => UserLocationResponse.fromJson(json),
    );
  }

  // luu toa do user
  Future<BaseResponse<SaveLocationResponse>> saveLocationUser(
      UserLocationRequest request) async {
    return await sendRequest<SaveLocationResponse>(
      UrlStatic.API_USER_LOCATION,
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
      UrlStatic.API_CHANGE_PASSWORD,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => ChangePasswordResponse.fromJson(json),
    );
  }

  // cap nhat thong tin user
  Future<BaseResponse<UpdateInfoUserResponse>> updateInfoUser(
      UpdateInfoUserRequest request) async {
    return await sendRequest<UpdateInfoUserResponse>(
      UrlStatic.API_UPDATE_AUTH,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => UpdateInfoUserResponse.fromJson(json),
    );
  }

  // cap nhat thong tin user
  Future<BaseResponse<AddFamilyResponse>> addFamily(
      AddFamilyRequest request) async {
    return await sendRequest<AddFamilyResponse>(
      UrlStatic.API_ADD_FAMILY,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => AddFamilyResponse.fromJson(json),
    );
  }

  Future<BaseResponse<DeleteFamilyResponse>> deleteFamily(
      AddFamilyRequest request) async {
    return await sendRequest<DeleteFamilyResponse>(
      UrlStatic.API_DELETE_FAMILY,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => DeleteFamilyResponse.fromJson(json),
    );
  }
  // api lấy lịch sử cảnh báo
  Future<BaseResponse<GetFamilyResponse>> getFamily({
    int? userId,
  }) async {
    final queryParams = <String, int>{};

    // Thêm tham số vào queryParams nếu chúng không null hoặc không rỗng
    if (userId != null) {
      queryParams["user_id"] = userId;
    }


    return await sendRequest<GetFamilyResponse>(
      UrlStatic.API_FAMILY_LIST,
      method: 'GET',
      data: queryParams, // Truyền queryParams vào đây
      fromJson: (json) => GetFamilyResponse.fromJson(json),
    );
  }

}




