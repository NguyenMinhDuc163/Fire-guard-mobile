import 'package:fire_guard/models/personal_profile_model.dart';
import 'package:fire_guard/service/api_service/api_service.dart';
import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';
import 'package:flutter/cupertino.dart';

class PersonalProfileViewModel extends ChangeNotifier{
  final ApiServices apiServices = ApiServices();
  PersonalProfileModel personalProfileModel = PersonalProfileModel();
  PersonalProfileModel get model => personalProfileModel;

  void setPersonalProfile({required String name, required String email}){
    model.name = name;
    model.email = email;
    notifyListeners();
  }

}