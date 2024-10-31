import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thư viện để định dạng ngày giờ

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  static const String routeName = '/notifications';

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Dữ liệu giả từ API
  final Map<String, dynamic> apiResponse = {
    "code": 200,
    "data": [
      {
        "incident_id": 1,
        "message": "Cảnh báo! Phát hiện cháy.",
        "timestamp": "2024-10-13T07:05:00.000Z"
      },
      {
        "incident_id": 2,
        "message": "Cảnh báo! Phát hiện cháy.",
        "timestamp": "2024-10-13T07:05:00.000Z"
      },
      {
        "incident_id": 3,
        "message": "Cảnh báo! Phát hiện cháy.",
        "timestamp": "2024-10-13T07:05:00.000Z"
      },
      {
        "incident_id": 4,
        "message": "Cảnh báo! Phát hiện cháy.",
        "timestamp": "2024-10-13T07:05:00.000Z"
      }
    ],
    "status": "success",
    "message": "Lịch sử đã được truy xuất thành công.",
    "error": ""
  };

  // Danh sách thông báo sau khi chuẩn hóa
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    _normalizeData(); // Chuẩn hóa dữ liệu khi khởi tạo
  }

  // Hàm chuẩn hóa dữ liệu từ API
  void _normalizeData() {
    notifications = (apiResponse['data'] as List).map((item) {
      return {
        'incidentId': item['incident_id'],
        'message': item['message'],
        'timestamp': DateFormat('dd/MM/yyyy HH:mm:ss')
            .format(DateTime.parse(item['timestamp']).toLocal()),
      };
    }).toList();
    setState(() {}); // Cập nhật trạng thái để xây dựng lại giao diện
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông Báo Cảnh Báo'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Dismissible(
            key: Key(notification['incidentId'].toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                notifications.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã xóa thông báo: ${notification['message']}')),
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                leading: const Icon(Icons.warning, color: Colors.red),
                title: Text(
                  notification['message'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Thời gian: ${notification['timestamp']}',
                  style: const TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  // Thêm logic xử lý khi ấn vào thông báo (nếu cần)
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
