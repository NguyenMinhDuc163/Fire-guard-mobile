import 'package:flutter/material.dart';
import 'service/api_service/response/api_response.dart';
import 'service/api_service/api_service.dart';
import 'service/api_service/request/send_data_sensor_request.dart';
import 'service/api_service/response/send_data_sensor_response.dart';

void main() {
  runApp(MyApp());
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
  final ApiServices _sensorService = ApiServices();
  String _responseMessage = 'Nhấn nút để gửi dữ liệu cảm biến';

  void _sendSensorData() async {
    SendDataSensorRequest request = SendDataSensorRequest(
      deviceId: 'esp8266_001',
      flameSensor: true,
      mq2GasLevel: 500,
      mq135AirQuality: 300,
      timestamp: DateTime.now().toUtc(),
    );

    ApiResponse<SendDataSensorResponse> response =
    await _sensorService.sendSensorData(request);

    setState(() {
      if (response.hasError) {
        _responseMessage = 'Lỗi: ${response.error}';
      } else {
        _responseMessage = 'Thành công: ${response.data?.message}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: _sendSensorData,
              child: Text('Gửi Dữ Liệu'),
            ),
            SizedBox(height: 20),
            Text(
              _responseMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
