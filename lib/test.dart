import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/profile_screen/providers/sensor_view_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SensorViewModel(), // Cung cấp SensorViewModel cho ứng dụng
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SensorDataPage(),
    );
  }
}

class SensorDataPage extends StatefulWidget {
  const SensorDataPage({super.key});

  @override
  _SensorDataPageState createState() => _SensorDataPageState();
}

class _SensorDataPageState extends State<SensorDataPage> {
  @override
  Widget build(BuildContext context) {
    final sensorViewModel = Provider.of<SensorViewModel>(context);
    final model = sensorViewModel.model;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gửi Dữ Liệu Cảm Biến'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // sensorViewModel.saveDeviceStatus(deviceName: 'buzzer', status: 'active');
                sensorViewModel.sendLogin();
              },
              child: const Text('Gửi Dữ Liệu'),
            ),
            const SizedBox(height: 20),
            Text(
              model.responseMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
