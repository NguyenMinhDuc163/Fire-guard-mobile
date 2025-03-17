import 'package:fire_guard/screens/setting_screen/models/personal_profile_model.dart';
import 'package:fire_guard/service/api_service/api_service.dart';
import 'package:fire_guard/providers/BaseViewModel.dart';

class PersonalProfileViewModel extends BaseViewModel {
  final ApiServices apiServices = ApiServices();
  PersonalProfileModel personalProfileModel = PersonalProfileModel();

  PersonalProfileModel get model => personalProfileModel;

  void setPersonalProfile({required String name, required String email}) {
    model.name = name;
    model.email = email;
    notifyListeners();
  }

}
