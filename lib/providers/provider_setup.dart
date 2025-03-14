import 'package:fire_guard/viewModel/fire_safety_skills_view_model.dart';
import 'package:fire_guard/viewModel/home_view_model.dart';
import 'package:fire_guard/viewModel/personal_profile_view_model.dart';
import 'package:fire_guard/viewModel/sensor_view_model.dart';
import 'package:fire_guard/viewModel/setting_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:fire_guard/viewModel/auth_view_model.dart';
import 'package:fire_guard/viewModel/family_manager_view_model.dart';

class ProviderSetup {
  static List<SingleChildWidget> getProviders() {
    return [
      ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ChangeNotifierProvider(create: (_) => SensorViewModel()),
      ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ChangeNotifierProvider(create: (_) => PersonalProfileViewModel()),
      ChangeNotifierProvider(create: (_) => FamilyManagerViewModel()),
      ChangeNotifierProvider(create: (_) => FireSafetySkillsViewModel()),
      ChangeNotifierProvider(create: (_) => SettingViewModel()),
      // Thêm các Provider khác ở đây
    ];
  }
}
