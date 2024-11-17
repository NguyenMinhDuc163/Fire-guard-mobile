import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/viewModel/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class RegisterCoordinatesScreen extends StatefulWidget {
  const RegisterCoordinatesScreen({super.key});
  static const String routeName = '/register_coordinates_screen';

  @override
  State<RegisterCoordinatesScreen> createState() =>
      _RegisterCoordinatesScreenState();
}

class _RegisterCoordinatesScreenState extends State<RegisterCoordinatesScreen> {
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  LatLng? _selectedPosition;
  final MapController _mapController = MapController();
  bool _isLoading = false; // Trạng thái loading

  @override
  void initState() {
    super.initState();
    _initializeCurrentPosition();
  }

  Future<void> _initializeCurrentPosition() async {
    try {
      setState(() {
        _isLoading = true; // Bắt đầu loading
      });

      // Lấy vị trí hiện tại
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _selectedPosition = LatLng(position.latitude, position.longitude);
        _latitudeController.text = position.latitude.toString();
        _longitudeController.text = position.longitude.toString();

        // Di chuyển bản đồ đến vị trí hiện tại
        _mapController.move(
          _selectedPosition!,
          13.0,
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể lấy tọa độ hiện tại!')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Kết thúc loading
      });
    }
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedPosition = position;
      _latitudeController.text = position.latitude.toString();
      _longitudeController.text = position.longitude.toString();
    });
  }

  Future<void> _saveCoordinates() async {
    if (_selectedPosition != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final bool isSave = await Provider.of<HomeViewModel>(context, listen: false)
            .saveLocation(
          longitude: _selectedPosition!.longitude.toString(),
          latitude: _selectedPosition!.latitude.toString(),
          // isFire: true,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
            Text(isSave ? 'Tọa độ đã được lưu!' : 'Lưu tọa độ thất bại!'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xảy ra lỗi khi lưu tọa độ!')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn một vị trí!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: const [GestureType.onTap],
      child: Scaffold(
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
                initialCenter: _selectedPosition ?? LatLng(21.028511, 105.804817),
                initialZoom: 13.0,
                onTap: (tapPosition, point) => _onMapTap(point),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _longitudeController,
                      decoration: InputDecoration(
                        labelText: 'Kinh độ (Longitude)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                      ),
                      onPressed: _isLoading ? null : _saveCoordinates,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text('Lưu Tọa Độ'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
