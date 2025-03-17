import 'package:fire_guard/service/api_service/api_service.dart';
import 'package:fire_guard/providers/BaseViewModel.dart';
import 'package:fire_guard/service/api_service/response/guide_and_news_response.dart';

class FireNewsViewModel extends BaseViewModel {
  final ApiServices apiServices = ApiServices();
  List<GuideAndNewsResponse> fireNews = [];
  List<GuideAndNewsResponse> goodPeopleStories = [];
  bool isLoading = false;
  String? error;

  void fetchGuidesAndNews() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await apiServices.getGuidesAndNews(
        category: "guide",
        limit: 5,
      );

      print('Code: ${response.code}');
      print('Status: ${response.status}');
      print('Message: ${response.message}');

      if (response.data != null) {
        for (var guide in response.data!) {
          print(
              'ID: ${guide.id}, Title: ${guide.title}, Type: ${guide.type}, URL: ${guide.url}, Content: ${guide.content}');
        }
        // Phân loại dữ liệu theo type
        fireNews = response.data!; // Hiển thị tất cả bài viết trong fireNews
        goodPeopleStories = []; // Tạm thời để trống vì chưa có dữ liệu
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      print('Error: $e');
    }
  }
}
