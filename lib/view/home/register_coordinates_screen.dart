import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RegisterCoordinatesScreen extends StatefulWidget {
  const RegisterCoordinatesScreen({super.key});
  static const String routeName = '/register_coordinates_screen';

  @override
  State<RegisterCoordinatesScreen> createState() => _RegisterCoordinatesScreenState();
}

class _RegisterCoordinatesScreenState extends State<RegisterCoordinatesScreen> {
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  LatLng? _selectedPosition;
  final MapController _mapController = MapController();

  // Hàm để chọn vị trí khi người dùng chạm vào bản đồ
  void _onMapTap(LatLng position) {
    setState(() {
      _selectedPosition = position;
      _latitudeController.text = position.latitude.toString();
      _longitudeController.text = position.longitude.toString();
    });
  }

  // Hàm để lưu tọa độ đã chọn
  void _saveCoordinates() {
    if (_selectedPosition != null) {
      print('Tọa độ đã chọn: ${_selectedPosition!.latitude}, ${_selectedPosition!.longitude}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tọa độ đã được lưu!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn một vị trí!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng Ký Tọa Độ Giám Sát'),
        backgroundColor: Colors.orange,
      ),
      body: Stack(
        children: [
          // Bản đồ
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(21.028511, 105.804817), // Vị trí mặc định (Hà Nội)
              initialZoom: 13.0,
              onTap: (tapPosition, point) => _onMapTap(point),
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              if (_selectedPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedPosition!,
                      width: 60,
                      height: 60,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Layer nhập liệu và nút lưu
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _latitudeController,
                    decoration: InputDecoration(
                      labelText: 'Vĩ độ (Latitude)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _longitudeController,
                    decoration: InputDecoration(
                      labelText: 'Kinh độ (Longitude)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // Thay 'primary' bằng 'backgroundColor'
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    ),
                    onPressed: _saveCoordinates,
                    child: const Text('Lưu Tọa Độ'),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
