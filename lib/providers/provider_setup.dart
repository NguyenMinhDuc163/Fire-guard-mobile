import 'package:fire_guard/screens/authen_screen/provider/auth_view_model.dart';
import 'package:fire_guard/screens/authen_screen/provider/auth_with_firebase.dart';
import 'package:fire_guard/screens/family_manager_screen/providers/family_manager_view_model.dart';
import 'package:fire_guard/screens/fire_map_screen/providers/fire_map_view_model.dart';
import 'package:fire_guard/screens/fire_safety_skills_screen/providers/fire_safety_skills_view_model.dart';
import 'package:fire_guard/screens/home_screen/providers/home_view_model.dart';
import 'package:fire_guard/screens/profile_screen/providers/persional_profile_view_model.dart';
import 'package:fire_guard/screens/profile_screen/providers/sensor_view_model.dart';
import 'package:fire_guard/screens/setting_screen/providers/setting_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

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
      ChangeNotifierProvider(create: (_) => FireMapViewModel()),
      // Thêm các Provider khác ở đây
    ];
  }
}
