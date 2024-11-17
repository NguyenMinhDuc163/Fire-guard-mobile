import 'package:fire_guard/init.dart';
import 'package:fire_guard/viewModel/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
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
  bool _isHomeOnFire = false; // Trạng thái cháy tại vị trí hiện tại
  String _selectedMapStyle = "World Street Map";

  final Map<String, String> _mapStyles = {
    "OpenStreetMap": "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
    "World Street Map":
    "https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}",
    "World Imagery":
    "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
    "Topographic":
    "https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}",
  };

  List<Map<String, dynamic>> familyMembers = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getCurrentPosition();
      _loadLocation();
    });
  }

  Future<void> _loadLocation() async {
    try {
      final response =
      await Provider.of<HomeViewModel>(context, listen: false).sendLocation();

      if (response.data != null) {
        final apiFamilyMembers = response.data!
            .map<Map<String, dynamic>>((location) => {
          'name': 'Vị trí từ API',
          'position': LatLng(
            double.parse(location.latitude),
            double.parse(location.longitude),
          ),
          'isFire': location.isFire,
          'imageURL': location.isFire
              ? AssetHelper.icoFire
              : AssetHelper.icoFamilyMap,
        })
            .toList();

        // Kiểm tra cháy tại vị trí hiện tại
        if (_currentPosition != null) {
          final LatLng currentPosition = LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          );

          // Kiểm tra vị trí hiện tại có cháy hay không
          final currentLocationFire = apiFamilyMembers.firstWhere(
                (location) =>
            (location['position'] as LatLng).latitude.toStringAsFixed(5) ==
                currentPosition.latitude.toStringAsFixed(5) &&
                (location['position'] as LatLng).longitude.toStringAsFixed(5) ==
                    currentPosition.longitude.toStringAsFixed(5) &&
                location['isFire'] == true,
            orElse: () => {
              'name': 'No Fire',
              'position': currentPosition,
              'isFire': false,
              'imageURL': AssetHelper.icoHomeMap,
            },
          );

          setState(() {
            _isHomeOnFire = currentLocationFire['isFire'] == true;
          });

          setState(() {
            _isHomeOnFire = currentLocationFire != null;
          });
        }

        setState(() {
          familyMembers = apiFamilyMembers; // Cập nhật danh sách từ API
        });
      }
    } catch (e) {
      print('Error loading location data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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

  void _openGoogleMaps(LatLng destination) async {
    final Uri googleMapsUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}',
    );

    if (await canLaunchUrl(googleMapsUri)) {
      try {
        await launchUrl(
          googleMapsUri,
          mode: LaunchMode.externalApplication, // Cố mở trong ứng dụng trước
        );
      } catch (e) {
        print("Lỗi khi mở Google Maps trong ứng dụng: $e");
        _openInWebBrowser(googleMapsUri); // Fallback mở trong trình duyệt
      }
    } else {
      print("Không thể mở Google Maps ứng dụng.");
      _openInWebBrowser(googleMapsUri); // Fallback mở trong trình duyệt
    }
  }

  void _openInWebBrowser(Uri googleMapsUri) async {
    if (await canLaunchUrl(googleMapsUri)) {
      try {
        await launchUrl(
          googleMapsUri,
          mode: LaunchMode.inAppWebView, // Mở trong trình duyệt nếu ứng dụng không hoạt động
        );
      } catch (e) {
        print("Lỗi khi mở Google Maps trong trình duyệt: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Không thể mở Google Maps. Vui lòng kiểm tra kết nối mạng."),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Không thể mở Google Maps. Vui lòng kiểm tra ứng dụng hoặc trình duyệt."),
        ),
      );
    }
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              setState(() {
                _isLoading = true; // Hiển thị trạng thái loading
              });
              await _loadLocation(); // Tải lại dữ liệu từ API
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(
            _currentPosition?.latitude ?? 21.028511,
            _currentPosition?.longitude ?? 105.804817,
          ),
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: _mapStyles[_selectedMapStyle]!,
          ),
          MarkerLayer(
            markers: [
              // Vị trí hiện tại
              if (_currentPosition != null)
                Marker(
                  point: LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  ),
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onTap: () {
                      _openGoogleMaps(LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ));
                    },
                    child: SvgPicture.asset(
                      _isHomeOnFire
                          ? AssetHelper.icoFire
                          : AssetHelper.icoHomeMap,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
              // Các vị trí từ API
              ...familyMembers.map((member) => Marker(
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
