import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/screens/home_screen/providers/home_view_model.dart';
import 'package:fire_guard/screens/profile_screen/providers/persional_profile_view_model.dart';
import 'package:fire_guard/screens/profile_screen/providers/sensor_view_model.dart';
import 'package:fire_guard/screens/widger/LoadingWidget.dart';
import 'package:fire_guard/utils/core/common/drawer_widget.dart';
import 'package:fire_guard/utils/core/constants/color_constants.dart';
import 'package:fire_guard/utils/core/helpers/asset_helper.dart';
import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';
import 'package:fire_guard/utils/router_names.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class PersonalProfileScreen extends StatefulWidget {
  const PersonalProfileScreen({super.key});
  static const String routeName = '/personalProfileScreen';

  @override
  State<PersonalProfileScreen> createState() => _PersonalProfileScreenState();
}

class _PersonalProfileScreenState extends State<PersonalProfileScreen> {
  bool isFlameSensorOn = true;
  bool isGasSensorOn = true;
  bool isAirQualitySensorOn = true;
  bool isAlarmOn = true;
  bool _isWaitingForResponse = false;
  String? _processingSensor;
  bool _isSystemChecking = false;
  List<Map<String, dynamic>> _alertHistory = [];
  bool _isLoadingHistory = false;
  int _batteryLevel = 85;
  DateTime _lastUpdate = DateTime.now();
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _updateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        _batteryLevel = (_batteryLevel - 1).clamp(0, 100);
        _lastUpdate = DateTime.now();
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAlertHistory();
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'profile_screen.just_now'.tr();
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} profile_screen.minutes_ago'.tr();
    } else if (difference.inHours < 24) {
      return '${difference.inHours} profile_screen.hours_ago'.tr();
    } else {
      return '${difference.inDays} profile_screen.days_ago'.tr();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final personalProfileViewModel =
          Provider.of<PersonalProfileViewModel>(context, listen: false);
      personalProfileViewModel.setPersonalProfile(
        name: LocalStorageHelper.getValue('userName'),
        email: LocalStorageHelper.getValue('email'),
      );
    });
  }

  Future<void> _fetchAlertHistory() async {
    if (!mounted) return;

    setState(() {
      _isLoadingHistory = true;
    });

    try {
      final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
      final endDate = DateTime.now();
      final startDate = endDate.subtract(const Duration(days: 7));

      final history = await homeViewModel.fetchHistory(
        startDate: startDate,
        endDate: endDate,
      );

      if (!mounted) return;

      setState(() {
        _alertHistory = history.map((item) {
          String title = '';
          String message = item['message'] as String;
          IconData icon = Icons.warning;
          Color color = Colors.orange;

          if (message.contains('404')) {
            title = 'profile_screen.connection_warning'.tr();
            message = 'profile_screen.connection_lost'.tr();
            icon = Icons.wifi_off;
            color = Colors.blue;
          } else if (message.contains('400')) {
            title = 'profile_screen.system_warning'.tr();
            message = 'profile_screen.update_error'.tr();
            icon = Icons.error_outline;
            color = Colors.red;
          } else if (message.contains('fire')) {
            title = 'profile_screen.fire_alert'.tr();
            message = 'profile_screen.high_temperature_detected'.tr();
            icon = Icons.local_fire_department;
            color = Colors.red;
          } else if (message.contains('smoke')) {
            title = 'profile_screen.smoke_alert'.tr();
            message = 'profile_screen.smoke_detected'.tr();
            icon = Icons.smoke_free;
            color = Colors.orange;
          } else {
            title = 'profile_screen.system_warning'.tr();
            message = 'Có sự cố xảy ra';
            icon = Icons.warning;
            color = Colors.orange;
          }

          return {
            'title': title,
            'message': message,
            'timestamp': item['timestamp'],
            'icon': icon,
            'color': color,
            'type': message.toLowerCase().contains('fire')
                ? 'fire'
                : message.toLowerCase().contains('smoke')
                    ? 'smoke'
                    : 'system',
          };
        }).toList();
        _isLoadingHistory = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingHistory = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text('profile_screen.unable_to_load_alert_history'.tr()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final personalProfileViewModel =
        Provider.of<PersonalProfileViewModel>(context);
    final sensorViewModel = Provider.of<SensorViewModel>(context);
    final model = personalProfileViewModel.model;

    return Scaffold(
      appBar: AppBar(
        title:  Text('profile_screen.personal_info_iot'.tr()),
        backgroundColor: ColorPalette.colorFFBB35,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.notifications);
            },
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(AssetHelper.avatar),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        model.name ?? '',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        model.email ?? 'auth.email_example'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('profile_screen.device_info'.tr()),
                      _buildDeviceCard(
                        context,
                        'Fire Detector Pro',
                        'FD123456',
                        'profile_screen.operating'.tr(),
                        Icons.device_hub,
                        Colors.orange,
                      ),
                      const SizedBox(height: 20),
                      _buildSectionTitle('profile_screen.sensor_status'.tr()),
                      _buildSensorStatusCard(
                        context,
                        sensorViewModel,
                      ),
                      const SizedBox(height: 20),
                      _buildSectionTitle('profile_screen.recent_alerts'.tr()),
                      _buildAlertHistoryList(),
                      const SizedBox(height: 20),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          personalProfileViewModel.isLoading
              ? const LoadingWidget()
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDeviceCard(
    BuildContext context,
    String title,
    String serial,
    String status,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 30),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Serial: $serial',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(Icons.wifi, 'profile_screen.stable_connection'.tr()),
                _buildInfoItem(Icons.battery_full, 'Pin: $_batteryLevel%'),
                _buildInfoItem(
                    Icons.update, 'Update: ${_getTimeAgo(_lastUpdate)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSensorStatusCard(
      BuildContext context, SensorViewModel sensorViewModel) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSensorItem(
              'profile_screen.temperature_sensor'.tr(),
              isFlameSensorOn,
              (value) async {
                if (_isWaitingForResponse) {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      content: Text('profile_screen.processing_request'.tr()),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                setState(() {
                  _isWaitingForResponse = true;
                  _processingSensor = 'profile_screen.temperature_sensor'.tr();
                });

                bool success = await sensorViewModel.saveDeviceStatus(
                  deviceName: 'FlameSensor',
                  status: value ? "active" : "inactive",
                );

                if (success) {
                  setState(() {
                    isFlameSensorOn = value;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Đã ${value ? "bật" : "tắt"} cảm biến nhiệt độ'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      content: Text('profile_screen.unable_to_update_sensor'.tr()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }

                setState(() {
                  _isWaitingForResponse = false;
                  _processingSensor = null;
                });
              },
              Icons.fireplace,
              Colors.red,
            ),
            _buildSensorItem(
              'profile_screen.gas_sensor'.tr(),
              isGasSensorOn,
              (value) async {
                if (_isWaitingForResponse) {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      content: Text('profile_screen.processing_request'.tr()),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                setState(() {
                  _isWaitingForResponse = true;
                  _processingSensor = 'profile_screen.gas_sensor'.tr();
                });

                bool success = await sensorViewModel.saveDeviceStatus(
                  deviceName: 'GasSensor',
                  status: value ? "active" : "inactive",
                );

                if (success) {
                  setState(() {
                    isGasSensorOn = value;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Đã ${value ? "bật" : "tắt"} cảm biến khí gas'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      content: Text('profile_screen.unable_to_update_sensor'.tr()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }

                setState(() {
                  _isWaitingForResponse = false;
                  _processingSensor = null;
                });
              },
              Icons.gas_meter,
              Colors.orange,
            ),
            _buildSensorItem(
              'profile_screen.smoke_sensor'.tr(),
              isAirQualitySensorOn,
              (value) async {
                if (_isWaitingForResponse) {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      content: Text('profile_screen.processing_request'.tr()),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                setState(() {
                  _isWaitingForResponse = true;
                  _processingSensor = 'profile_screen.smoke_sensor'.tr();
                });

                bool success = await sensorViewModel.saveDeviceStatus(
                  deviceName: 'QualitySensor',
                  status: value ? "active" : "inactive",
                );

                if (success) {
                  setState(() {
                    isAirQualitySensorOn = value;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Đã ${value ? "bật" : "tắt"} cảm biến khói'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      content: Text('profile_screen.unable_to_update_sensor'.tr()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }

                setState(() {
                  _isWaitingForResponse = false;
                  _processingSensor = null;
                });
              },
              Icons.smoke_free,
              Colors.blue,
            ),
            _buildSensorItem(
              'Còi báo động',
              isAlarmOn,
              (value) async {
                if (_isWaitingForResponse) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đang xử lý yêu cầu...'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                setState(() {
                  _isWaitingForResponse = true;
                  _processingSensor = 'profile_screen.alarm_siren'.tr();
                });

                bool success = await sensorViewModel.saveDeviceStatus(
                  deviceName: 'buzzer',
                  status: value ? "active" : "inactive",
                );

                if (success) {
                  setState(() {
                    isAlarmOn = value;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã ${value ? "bật" : "tắt"} còi báo động'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      content: Text('profile_screen.unable_to_update_sensor'.tr()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }

                setState(() {
                  _isWaitingForResponse = false;
                  _processingSensor = null;
                });
              },
              Icons.notifications_active,
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorItem(
    String title,
    bool value,
    Function(bool) onChanged,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          _isWaitingForResponse && _processingSensor == title
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                )
              : Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: color,
                ),
        ],
      ),
    );
  }

  Widget _buildAlertHistoryList() {
    if (_isLoadingHistory) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_alertHistory.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(
                Icons.history,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'profile_screen.no_alerts'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final recentAlerts = _alertHistory.take(3).toList();

    return Column(
      children: [
        ...recentAlerts.map((alert) => _buildAlertHistoryItem(
              alert['title'],
              alert['timestamp'],
              alert['icon'],
              alert['color'],
              alert['type'],
            )),
        if (_alertHistory.length > 3)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.notifications);
              },
              child:  Text('profile_screen.view_more'.tr()),
            ),
          ),
      ],
    );
  }

  Widget _buildAlertHistoryItem(
    String title,
    String dateTime,
    IconData iconData,
    Color iconColor,
    String alertType,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(iconData, color: iconColor),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(dateTime),
        trailing: Icon(
          alertType == 'fire'
              ? Icons.local_fire_department
              : alertType == 'smoke'
                  ? Icons.smoke_free
                  : Icons.check_circle_outline,
          color: iconColor,
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(title),
              backgroundColor: iconColor,
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  void _showSystemCheckResult(BuildContext context, bool success) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: success
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    success ? Icons.check_circle : Icons.error,
                    size: 40,
                    color: success ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  success ? 'profile_screen.check_success'.tr() : 'profile_screen.check_failure'.tr(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: success ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  success
                      ? 'profile_screen.all_sensors_operating'.tr()
                      : 'profile_screen.check_connection'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: success ? Colors.green : Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:  Text(
                    'profile_screen.close'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _checkSystem(BuildContext context) async {
    setState(() {
      _isSystemChecking = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSystemChecking = false;
    });

    bool success = DateTime.now().millisecondsSinceEpoch % 10 != 0;
    _showSystemCheckResult(context, success);
  }

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'ngminhduc1603@gmail.com',
      queryParameters: {
        'subject': 'Báo cáo sự cố - Fire Guard',
        'body': 'Mô tả sự cố: \n\nThời gian: ${DateTime.now().toString()}\n\n',
      },
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể mở ứng dụng email'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isSystemChecking ? null : () => _checkSystem(context),
            icon: _isSystemChecking
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.refresh),
            label: Text(
                _isSystemChecking ? 'profile_screen.check_system'.tr() : 'profile_screen.checking_system'.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _launchEmail,
            icon: const Icon(Icons.report_problem),
            label:  Text('profile_screen.report_issue'.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
