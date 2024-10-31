import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/utils/core/constants/color_constants.dart';
import 'package:fire_guard/utils/core/helpers/asset_helper.dart';
import 'package:fire_guard/utils/router_names.dart';
import 'package:fire_guard/view/home/widget/drawer_widget.dart';
import 'package:fire_guard/viewModel/sensor_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalProfileScreen extends StatefulWidget {
  const PersonalProfileScreen({super.key});
  static const String routeName = '/personalProfileScreen';

  @override
  State<PersonalProfileScreen> createState() => _PersonalProfileScreenState();
}

class _PersonalProfileScreenState extends State<PersonalProfileScreen> {
  // State variables to control device status
  bool isFlameSensorOn = true;
  bool isGasSensorOn = true;
  bool isAirQualitySensorOn = true;
  bool isAlarmOn = false;

  @override
  Widget build(BuildContext context) {

    final sensorViewModel = Provider.of<SensorViewModel>(context);
    final model = sensorViewModel.model;

    return Scaffold(
      appBar: AppBar(
        title: Text('personal_info_iot_system'.tr()),
        backgroundColor: ColorPalette.colorFFBB35,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.notifications);
              print('Notification button pressed');
            },
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(AssetHelper.avatar),
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
            const ListTile(
              leading: Icon(Icons.device_hub, color: Colors.orange),
              title: Text('Thiết bị IoT: Fire Detector 1'),
              subtitle: Text('Serial: FD123456'),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.settings_remote, color: Colors.orange),
              title: const Text('Trạng thái thiết bị'),
              subtitle: const Text('Đang hoạt động từ ngày: 10/10/2023'),
              trailing: const Icon(Icons.check_circle, color: Colors.green),
              onTap: () {
                _showDeviceStatusSheet(context, sensorViewModel);
              },
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
            const Text(
              'Lịch sử cảnh báo gần đây',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildAlertHistoryItem(
              context,
              'Cảnh báo nhiệt độ cao',
              'Ngày: 05/10/2024 - 13:00',
              Icons.warning,
              Colors.red,
              'fire',
            ),
            _buildAlertHistoryItem(
              context,
              'Cảnh báo khói',
              'Ngày: 02/10/2024 - 16:20',
              Icons.smoke_free,
              Colors.orange,
              'smoke',
            ),
            _buildAlertHistoryItem(
              context,
              'Kiểm tra hệ thống định kỳ',
              'Ngày: 01/10/2024 - 09:00',
              Icons.check_circle_outline,
              Colors.green,
              'system_check',
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Add system check logic
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Kiểm tra hệ thống'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Add report issue logic
                    },
                    icon: const Icon(Icons.report_problem),
                    label: const Text('Báo cáo sự cố'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
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

  // Function to show the bottom sheet with toggle switches
  void _showDeviceStatusSheet(BuildContext context, SensorViewModel sensorViewModel) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Chi tiết trạng thái thiết bị',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(Icons.fireplace, color: Colors.red),
                    title: const Text('Cảm biến nhiệt độ'),
                    trailing: Switch(
                      value: isFlameSensorOn,
                      onChanged: (value) {
                        sensorViewModel.saveDeviceStatus(deviceName: 'FlameSensor', status: isFlameSensorOn ? "active" : "inactive");

                        setState(() {
                          isFlameSensorOn = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.gas_meter, color: Colors.orange),
                    title: const Text('Cảm biến khí gas MQ-2'),
                    trailing: Switch(
                      value: isGasSensorOn,
                      onChanged: (value) {
                        sensorViewModel.saveDeviceStatus(deviceName: 'GasSensor', status: isGasSensorOn ? "active" : "inactive");
                        setState(() {
                          isGasSensorOn = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.air, color: Colors.blue),
                    title: const Text('Cảm biến chất lượng không khí MQ-135'),
                    trailing: Switch(
                      value: isAirQualitySensorOn,
                      onChanged: (value) {
                        sensorViewModel.saveDeviceStatus(deviceName: 'QualitySensor', status: isAirQualitySensorOn ? "active" : "inactive");
                        setState(() {
                          isAirQualitySensorOn = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications, color: Colors.green),
                    title: const Text('Còi báo'),
                    trailing: Switch(
                      value: isAlarmOn,
                      onChanged: (value) {
                        sensorViewModel.saveDeviceStatus(deviceName: 'Alarm', status: isAlarmOn ? "active" : "inactive");

                        setState(() {
                          isAlarmOn = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    child: const Text('Đóng'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildAlertHistoryItem(
      BuildContext context,
      String title,
      String dateTime,
      IconData iconData,
      Color iconColor,
      String alertType,
      ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: Icon(iconData, color: iconColor),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(dateTime),
        trailing: Icon(
          alertType == 'fire' ? Icons.local_fire_department : Icons.smoke_free,
          color: alertType == 'fire' ? Colors.red : Colors.orange,
        ),
        onTap: () {
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
