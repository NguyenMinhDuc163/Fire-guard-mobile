import 'package:fire_guard/utils/core/constants/dimension_constants.dart';
import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  // Khởi tạo Notification Service
  Future<void> init(BuildContext context) async {
    // Yêu cầu quyền thông báo
    await _firebaseMessaging.requestPermission();

    // Cài đặt thông báo local
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    try {
      await _saveMessagingToken();
    } catch (e, stackTrace) {
      print("Không thể lấy FCM token: $e");
      print(stackTrace);
    }
    _firebaseMessaging.onTokenRefresh.listen((token) {
      LocalStorageHelper.setValue('fcm_token', token);
      print("FCM Token refreshed: $token");
    }, onError: (error, stackTrace) {
      print("Không thể refresh FCM token: $error");
      print(stackTrace);
    });

    // Xử lý khi ứng dụng đang mở (foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Nhận được thông báo: ${message.notification?.title}');
      _playAlarm();
      _showDialog(context, message.notification?.body ?? 'Có tín hiệu cháy!');
    });
  }

  // Phát âm thanh báo động
  Future<void> _playAlarm() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/alarm.wav'));
      print('Phát âm thanh thành công!');
    } catch (e, stackTrace) {
      print('Lỗi phát âm thanh: $e');
      print(stackTrace);
    }
  }

  Future<void> _saveMessagingToken() async {
    final apnsToken = await _waitForApnsToken();
    print("APNs Token: $apnsToken");

    if (apnsToken == null) {
      print(
        'APNs token is null. Bỏ qua lưu FCM token trên thiết bị hiện tại.',
      );
      return;
    }

    final token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");
    if (token != null) {
      LocalStorageHelper.setValue('fcm_token', token);
      print("Token đã được lưu vào local storage!");
    }
  }

  Future<String?> _waitForApnsToken() async {
    for (int attempt = 0; attempt < 10; attempt++) {
      final token = await _firebaseMessaging.getAPNSToken();
      if (token != null) return token;
      await Future.delayed(const Duration(milliseconds: 500));
    }
    return null;
  }

  // Hiển thị dialog với nút tắt âm thanh
  void _showDialog(BuildContext context, String message) {
    // Đảm bảo dialog chỉ được hiển thị khi khung giao diện đã sẵn sàng
    final navigatorContext = NavigationService.navigatorKey.currentContext;
    if (navigatorContext != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: navigatorContext,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Cảnh Báo Cháy!'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () {
                    _stopAlarm();
                    Navigator.of(context).pop(); // Đóng dialog
                  },
                  child: const Text('Tắt Âm Thanh'),
                ),
              ],
            );
          },
        );
      });
    }
  }

  // Dừng âm thanh báo động
  Future<void> _stopAlarm() async {
    try {
      await _audioPlayer.stop();
      print('Đã dừng âm thanh!');
    } catch (e, stackTrace) {
      print('Lỗi khi dừng âm thanh: $e');
      print(stackTrace);
    }
  }
}
