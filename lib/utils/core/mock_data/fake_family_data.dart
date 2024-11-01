import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

class FamilyMember {
  final String name;
  final LatLng position;
  final Color color;

  FamilyMember({
    required this.name,
    required this.position,
    required this.color,
  });
}

List<FamilyMember> fakeFamilyMembers = [
  FamilyMember(
    name: 'Người thân 1',
    position: LatLng(21.028511, 105.804817), // Trung tâm Hà Nội
    color: Colors.red,
  ),
  FamilyMember(
    name: 'Người thân 2',
    position: LatLng(21.038511, 105.834817), // Gần quận Cầu Giấy
    color: Colors.green,
  ),
  FamilyMember(
    name: 'Người thân 3',
    position: LatLng(21.048511, 105.854817), // Gần quận Tây Hồ
    color: Colors.orange,
  ),
];

