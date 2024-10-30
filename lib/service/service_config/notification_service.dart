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
    const InitializationSettings initializationSettings =
    InitializationSettings(android: androidSettings);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Nhận token FCM
    _firebaseMessaging.getToken().then((token) {
      print("FCM Token: $token");
      if(token != null) {
        LocalStorageHelper.setValue('fcm_token', token);
        print("Token đã được lưu vào local storage!");
      }
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
    } catch (e) {
      print('Lỗi phát âm thanh: $e');
    }
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
    } catch (e) {
      print('Lỗi khi dừng âm thanh: $e');
    }
  }
}
