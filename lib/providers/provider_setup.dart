import 'package:fire_guard/viewModel/home_view_model.dart';
import 'package:fire_guard/viewModel/sensor_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:fire_guard/viewModel/auth_view_model.dart';

class ProviderSetup {
  static List<SingleChildWidget> getProviders() {
    return [
      ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ChangeNotifierProvider(create: (_) => SensorViewModel()),
      // ChangeNotifierProvider(create: (_) => HomeViewModel()),
      // Thêm các Provider khác ở đây
    ];
  }
}
