import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/models/home_model.dart';
import 'package:fire_guard/service/api_service/api_service.dart';
import 'package:fire_guard/service/api_service/request/fire_emergency_request.dart';
import 'package:fire_guard/service/api_service/request/send_notification_request.dart';
import 'package:fire_guard/service/api_service/response/base_response.dart';
import 'package:fire_guard/service/api_service/response/fire_emergency_response.dart';
import 'package:fire_guard/service/api_service/response/send_notification_response.dart';
import 'package:fire_guard/utils/core/common/toast.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeViewModel extends ChangeNotifier{
  final ApiServices apiServices = ApiServices();
  HomeModel homeModel = HomeModel();
  HomeModel get model => homeModel;
  final String phoneNumber = '0123456789';

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
    if(response.code != null){
      showToast(message: 'send_alert_success'.tr(),);
    }else{
      showToast(message: 'send_alert_failure'.tr(),);
    }
    notifyListeners();
  }


  Future<int?> sendFireEmergency() async {
    FireEmergencyRequest request = FireEmergencyRequest(
      location: 'Hà Nội',
      incidentDetails: 'Phát hiện cháy lớn.',
      phoneNumber: '+84916562796',
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
    return response.code ;

  }


  Future<bool> _requestCallPermission() async {
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      status = await Permission.phone.request();
    }
    return status.isGranted;
  }

  // Hàm thực hiện cuộc gọi tự động
  Future<void> directCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    // Kiểm tra và xin quyền
    bool permissionGranted = await _requestCallPermission();
    if (permissionGranted) {
      try {
        // Thực hiện gọi trực tiếp bằng externalApplication mode
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      } catch (e) {
        print('Lỗi khi gọi: $e');
      }
    } else {
      print('Quyền gọi điện bị từ chối.');
    }
  }
}