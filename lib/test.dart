import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewModel/sensor_view_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SensorViewModel(), // Cung cấp SensorViewModel cho ứng dụng
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SensorDataPage(),
    );
  }
}

class SensorDataPage extends StatefulWidget {
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
        title: Text('Gửi Dữ Liệu Cảm Biến'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // sensorViewModel.saveDeviceStatus(deviceName: 'buzzer', status: 'active');
                sensorViewModel.fetchFamily();
              },
              child: Text('Gửi Dữ Liệu'),
            ),
            SizedBox(height: 20),
            Text(
              model.responseMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
