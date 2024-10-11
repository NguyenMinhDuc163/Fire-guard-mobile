import 'package:fire_guard/res/core/helpers/asset_helper.dart';
import 'package:flutter/material.dart';

class PersonalProfileScreen extends StatefulWidget {
  const PersonalProfileScreen({super.key});

  @override
  State<PersonalProfileScreen> createState() => _PersonalProfileScreenState();
}

class _PersonalProfileScreenState extends State<PersonalProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân & Hệ thống IoT'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Avatar và thông tin cá nhân cơ bản
            const Center(
              child: Column(
                children:  [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(AssetHelper.avatar), // Thay bằng link ảnh thật
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Nguyễn Minh Đức',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'ngminhduc1603@gmail.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Thông tin thiết bị IoT
            const ListTile(
              leading: Icon(Icons.device_hub, color: Colors.orange),
              title: Text('Thiết bị IoT: Fire Detector 1'),
              subtitle: Text('Serial: FD123456'),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.settings_remote, color: Colors.orange),
              title: Text('Trạng thái thiết bị'),
              subtitle: Text('Đang hoạt động từ ngày: 10/10/2023'),
              trailing: Icon(Icons.check_circle, color: Colors.green),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.network_check, color: Colors.orange),
              title: Text('Kết nối thiết bị'),
              subtitle: Text('Wi-Fi: Kết nối ổn định'),
              trailing: Icon(Icons.wifi, color: Colors.green),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.date_range, color: Colors.orange),
              title: Text('Bảo hành thiết bị'),
              subtitle: Text('Hạn bảo hành đến: 01/01/2025'),
              trailing: Icon(Icons.verified, color: Colors.green),
            ),
            const SizedBox(height: 20),

            // Phần lịch sử cảnh báo
            const Text(
              'Lịch sử cảnh báo gần đây',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Cảnh báo 1: Nhiệt độ cao (báo cháy)
            _buildAlertHistoryItem(
              context,
              'Cảnh báo nhiệt độ cao',
              'Ngày: 05/10/2024 - 13:00',
              Icons.warning,
              Colors.red,
              'fire',
            ),

            // Cảnh báo 2: Cảnh báo khói
            _buildAlertHistoryItem(
              context,
              'Cảnh báo khói',
              'Ngày: 02/10/2024 - 16:20',
              Icons.smoke_free,
              Colors.orange,
              'smoke',
            ),

            // Cảnh báo 3: Kiểm tra định kỳ hệ thống
            _buildAlertHistoryItem(
              context,
              'Kiểm tra hệ thống định kỳ',
              'Ngày: 01/10/2024 - 09:00',
              Icons.check_circle_outline,
              Colors.green,
              'system_check',
            ),
            const SizedBox(height: 20),

            // Nút hành động
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Thêm logic kiểm tra hệ thống
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Kiểm tra hệ thống'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // Màu nút
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Thêm logic gửi báo cáo
                    },
                    icon: const Icon(Icons.report_problem),
                    label: const Text('Báo cáo sự cố'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Màu nút báo cáo
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  // Widget xây dựng mục lịch sử cảnh báo
  Widget _buildAlertHistoryItem(BuildContext context, String title,
      String dateTime, IconData iconData, Color iconColor, String alertType) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0, // Độ nổi của card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Bo tròn các góc của card
      ),
      child: ListTile(
        leading: Icon(iconData, color: iconColor), // Biểu tượng cảnh báo (cháy hoặc khói)
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(dateTime), // Thời gian cảnh báo
        trailing: Icon(
          alertType == 'fire' ? Icons.local_fire_department : Icons.smoke_free, // Biểu tượng loại cảnh báo
          color: alertType == 'fire' ? Colors.red : Colors.orange, // Màu sắc biểu tượng tùy thuộc vào loại cảnh báo
        ),
        onTap: () {
          // Hiển thị thông tin chi tiết về cảnh báo khi người dùng nhấn vào
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cảnh báo: $title'),
            ),
          );
        },
      ),
    );
  }
}
