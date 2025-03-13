import 'dart:convert';

import 'package:fire_guard/service/api_service/api_service.dart';
import 'package:fire_guard/service/api_service/request/delete_family_request.dart';
import 'package:fire_guard/service/init.dart';
import 'BaseViewModel.dart';

class FamilyManagerViewModel extends BaseViewModel {
  final ApiServices apiServices = ApiServices();
  List<dynamic> familyMembers = [];
  bool isLoading = false;

  Future<void> fetchFamily(int userId) async {
    try {
      setLoading(true);
      final response = await apiServices.getFamily(userId: userId);
      if (response.code == 200) {
        familyMembers = response.data ?? [];
        print("======>familyMembers: ${jsonEncode(familyMembers)}");
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching family: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> addFamily({required int ownerID, required String email}) async {
    try {
      setLoading(true);
      AddFamilyRequest request = AddFamilyRequest(
        ownerID: ownerID,
        email: email,
      );

      final response = await apiServices.addFamily(request);

      if (response.code == 201) {
        // Refresh danh sách sau khi thêm thành công
        await fetchFamily(ownerID);
      }
    } catch (e) {
      print('Error adding family member: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteFamily({required int userId, required int familyMemberId}) async {
    try {
      setLoading(true);
      DeleteFamilyRequest request = DeleteFamilyRequest( // dung chung
        ownerID: userId,
        familyMemberId: familyMemberId,
      );

      final response = await apiServices.deleteFamily(request);

      if (response.code == 200) {
        // Refresh danh sách sau khi thêm thành công
        await fetchFamily(userId);
      }
    } catch (e) {
      print('Error delete family member: $e');
    } finally {
      setLoading(false);
    }
  }
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
