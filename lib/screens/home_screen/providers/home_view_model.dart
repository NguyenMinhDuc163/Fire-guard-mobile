import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/screens/home_screen/models/home_model.dart';
import 'package:fire_guard/service/api_service/api_service.dart';
import 'package:fire_guard/service/api_service/request/fire_emergency_request.dart';
import 'package:fire_guard/service/api_service/request/send_notification_request.dart';
import 'package:fire_guard/service/api_service/request/user_location_request.dart';
import 'package:fire_guard/service/api_service/response/base_response.dart';
import 'package:fire_guard/service/api_service/response/fire_emergency_response.dart';
import 'package:fire_guard/service/api_service/response/send_notification_response.dart';
import 'package:fire_guard/service/api_service/response/user_list_response.dart';
import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';
import 'package:fire_guard/providers/BaseViewModel.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeViewModel extends BaseViewModel {
  final ApiServices apiServices = ApiServices();
  HomeModel homeModel = HomeModel();
  HomeModel get model => homeModel;
  String get phoneNumber {
    final value = LocalStorageHelper.getValue("alertPhone")?.toString().trim();
    return value == null || value.isEmpty ? '114' : value;
  }

  Future<bool> sendNotification() async {
    return await execute(() async {
      SendNotificationRequest request = SendNotificationRequest(
        familyMemberId: LocalStorageHelper.getValue('userId'),
        message: "home_screen.warning".tr(),
        timestamp: DateTime.now().toUtc(),
      );
      final BaseResponse<SendNotificationResponse> response =
          await apiServices.sendNotification(request);
      notifyListeners();
      return response.code == 200 || response.code == 201;
    });
  }

  Future<int?> sendFireEmergency() async {
    return await execute(() async {
      FireEmergencyRequest request = FireEmergencyRequest(
        location: 'home_screen.location_example'.tr(),
        incidentDetails: 'home_screen.fire_detected'.tr(),
        phoneNumber: 'home_screen.contact_example'.tr(),
        familyMemberId: LocalStorageHelper.getValue('userId'),
        timestamp: DateTime.now().toUtc(),
      );
      final BaseResponse<FireEmergencyResponse> response =
          await apiServices.sendFireEmergency(request);
      notifyListeners();
      return response.code;
    });
  }

  // Hàm thực hiện cuộc gọi tự động
  Future<bool> directCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      final launched =
          await launchUrl(phoneUri, mode: LaunchMode.externalApplication);

      if (!launched) {
        print('Không mở được trình gọi điện: $phoneUri');
        print(
          'Nếu đang chạy iOS Simulator, tel: thường không được hỗ trợ. '
          'Hãy test trên thiết bị thật hoặc Android emulator có ứng dụng Phone.',
        );
      }

      return launched;
    } catch (e, stackTrace) {
      print('Lỗi khi gọi: $e');
      print(stackTrace);
      return false;
    }
  }

// Hàm sửa lại để trả về dữ liệu
  Future<List<Map<String, dynamic>>> fetchHistory(
      {required DateTime startDate, required DateTime endDate}) async {
    return await execute(() async {
      try {
        // Chuyển đổi startDate và endDate thành chuỗi với định dạng yyyy-MM-dd
        final String formattedStartDate =
            DateFormat('yyyy-MM-dd').format(startDate);
        final String formattedEndDate =
            DateFormat('yyyy-MM-dd').format(endDate);

        final response = await apiServices.getHistory(
          // Truyền các giá trị đã chuẩn hóa vào API
          startDate: formattedStartDate,
          endDate: formattedEndDate,
        );

        print('->>>>>> response: $response');
        print('Code: ${response.code}');
        print('Status: ${response.status}');
        print('Message: ${response.message}');
        print('data: ${response.data}');

        if (response.data != null) {
          List<Map<String, dynamic>> notifications = [];
          for (var incident in response.data!) {
            DateTime timestamp;
            if (incident.timestamp is String) {
              timestamp = DateTime.parse(incident.timestamp as String);
            } else {
              timestamp = incident.timestamp;
            }

            notifications.add({
              'incidentId': incident.incidentId,
              'message': incident.message,
              'title': incident.title,
              'body': incident.body,
              'imageUrl': incident.imageUrl,
              'timestamp':
                  DateFormat('dd/MM/yyyy HH:mm:ss').format(timestamp.toLocal()),
            });
          }
          print('Notifications: $notifications');
          return notifications;
        } else {
          return [];
        }
      } catch (e) {
        print('Error: $e');
        return [];
      }
    });
  }

  Future<List<dynamic>> sendUserList() async {
    return await execute(() async {
      UserLocationRequest request = UserLocationRequest(
        type: "all",
      );
      final BaseResponse<UserListResponse> response =
          await apiServices.sendUserList(request);
      print('Code: ${response.code}');
      print('Status: ${response.status}');
      print('Message: ${response.message}');
      print('Error: ${response.error}');
      print('Data: ${response.data}');
      List<UserListResponse> data = response.data!;
      notifyListeners();
      return data;
    });
  }
}
