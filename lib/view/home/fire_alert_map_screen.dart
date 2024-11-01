import 'package:fire_guard/init.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class FireAlertMapScreen extends StatefulWidget {
  const FireAlertMapScreen({super.key});
  static const String routeName = '/fire_alert_map_screen';

  @override
  State<FireAlertMapScreen> createState() => _FireAlertMapScreenState();
}

class _FireAlertMapScreenState extends State<FireAlertMapScreen> {
  final MapController _mapController = MapController();
  Position? _currentPosition;
  bool _isLoading = true;
  String _selectedMapStyle = "World Street Map"; // Mặc định chọn World Street Map

  // Danh sách các kiểu bản đồ
  final Map<String, String> _mapStyles = {
    "OpenStreetMap": "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
    "World Street Map": "https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}",
    "World Imagery": "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
    "Topographic": "https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}",
  };

  // Dữ liệu giả định nghĩa trực tiếp
  final List<Map<String, dynamic>> fakeFamilyMembers = [
    {
      'name': 'Người thân 1',
      'position': LatLng(21.028511, 105.804817),
      'imageURL': AssetHelper.icoFire,
    },
    {
      'name': 'Người thân 2',
      'position': LatLng(21.038511, 105.814817),
      'imageURL': AssetHelper.icoFire,
    },
    {
      'name': 'Người thân 3',
      'position': LatLng(21.048511, 105.824817),
      'imageURL': AssetHelper.icoFamilyMap,
    },

    {
      'name': 'Người thân 4',
      'position': LatLng(21.0015463, 105.8045407),
      'imageURL': AssetHelper.icoFamilyMap,
    }
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }

  Future<void> _getCurrentPosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  // Hàm để mở Google Maps và chỉ đường
  void _openGoogleMaps(LatLng destination) async {
    final Uri googleMapsUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}',
    );

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } else {
      print("Không thể mở $googleMapsUri");
    }
  }

  // Hàm để hiển thị BottomSheet chọn kiểu bản đồ
  void _showMapStyleSelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: _mapStyles.keys.map((String style) {
            return ListTile(
              title: Text(style),
              onTap: () {
                setState(() {
                  _selectedMapStyle = style;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  // Hàm để quay lại vị trí hiện tại
  void _goToCurrentPosition() {
    if (_currentPosition != null) {
      _mapController.move(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        13.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bản Đồ Báo Cháy'),
        backgroundColor: Colors.orange,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: _mapStyles[_selectedMapStyle]!,
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                ),
                width: 40,
                height: 40,
                child: SvgPicture.asset(
                  AssetHelper.icoHomeMap,
                  width: 40,
                  height: 40,
                ),
              ),
              ...fakeFamilyMembers.map((member) => Marker(
                point: member['position'],
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () {
                    _openGoogleMaps(member['position']);
                  },
                  child: SvgPicture.asset(
                    member['imageURL'],
                    width: 40,
                    height: 40,
                  ),
                ),
              )),
            ],
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _showMapStyleSelector,
            child: const Icon(Icons.layers),
            backgroundColor: Colors.orange,
            heroTag: 'mapStyleSelector',
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _goToCurrentPosition,
            child: const Icon(Icons.my_location),
            backgroundColor: Colors.blue,
            heroTag: 'goToCurrentPosition',
          ),
        ],
      ),
    );
  }
}
