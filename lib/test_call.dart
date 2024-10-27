// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: AutoCallScreen(),
//     );
//   }
// }
//
// class AutoCallScreen extends StatelessWidget {
//   final String phoneNumber = '0123456789'; // Thay số điện thoại
//
//   // Hàm xin quyền gọi điện
//   Future<bool> _requestCallPermission() async {
//     var status = await Permission.phone.status;
//     if (!status.isGranted) {
//       status = await Permission.phone.request();
//     }
//     return status.isGranted;
//   }
//
//   // Hàm thực hiện cuộc gọi tự động
//   Future<void> _directCall() async {
//     final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
//
//     // Kiểm tra và xin quyền
//     bool permissionGranted = await _requestCallPermission();
//     if (permissionGranted) {
//       try {
//         // Thực hiện gọi trực tiếp bằng externalApplication mode
//         await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
//       } catch (e) {
//         print('Lỗi khi gọi: $e');
//       }
//     } else {
//       print('Quyền gọi điện bị từ chối.');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Gọi trực tiếp'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: ,
//           child: const Text('Gọi ngay'),
//         ),
//       ),
//     );
//   }
// }
