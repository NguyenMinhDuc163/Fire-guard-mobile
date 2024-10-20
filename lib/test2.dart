import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart'; // Import Hive

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

    // Nhận token FCM và lưu vào Hive
    _firebaseMessaging.getToken().then((token) async {
      print("FCM Token: $token");
      if (token != null) {
        await _saveTokenToLocal(token);
      }
    });

    // Xử lý khi ứng dụng đang mở (foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Nhận được thông báo: ${message.notification?.title}');
      _playAlarm();
      _showDialog(context, message.notification?.body ?? 'Có tín hiệu cháy!');
    });
  }

  // Lưu token vào Hive
  Future<void> _saveTokenToLocal(String token) async {
    var box = Hive.box('settings');
    await box.put('fcm_token', token);
    print('Token đã được lưu vào local storage!');
  }

  // Lấy token từ Hive
  Future<String?> getTokenFromLocal() async {
    var box = Hive.box('settings');
    return box.get('fcm_token');
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
    final navigatorContext = Navigator.of(context);
    if (navigatorContext != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Cảnh Báo Cháy!'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () {
                    _stopAlarm();
                    Navigator.of(context).pop();
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
