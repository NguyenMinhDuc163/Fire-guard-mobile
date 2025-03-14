import 'package:fire_guard/service/api_service/api_service.dart';
import 'package:fire_guard/viewModel/BaseViewModel.dart';
import 'package:fire_guard/service/api_service/response/guide_and_news_response.dart';

class FireSafetySkillsViewModel extends BaseViewModel {
  final ApiServices apiServices = ApiServices();
  List<GuideAndNewsResponse> fireSafetySkills = [];
  List<GuideAndNewsResponse> escapeSkills = [];
  bool isLoading = false;
  String? error;

  void fetchFireSafetySkills() async {
    try {
      print('Fetching fire safety skills...');
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await apiServices.getGuidesAndNews(
        category: "fire_safety",
        limit: 9,
      );

      print('Fire safety skills response: ${response.data?.length} items');
      if (response.data != null) {
        fireSafetySkills = response.data!;
        print('Fire safety skills loaded: ${fireSafetySkills.length} items');
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching fire safety skills: $e');
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  void fetchEscapeSkills() async {
    try {
      print('Fetching escape skills...');
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await apiServices.getGuidesAndNews(
        category: "escape_skills",
        limit: 9,
      );

      print('Escape skills response: ${response.data?.length} items');
      if (response.data != null) {
        escapeSkills = response.data!;
        print('Escape skills loaded: ${escapeSkills.length} items');
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching escape skills: $e');
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }
}
