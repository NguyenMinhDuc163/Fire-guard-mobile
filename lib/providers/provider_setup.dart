import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:fire_guard/viewModel/auth_view_model.dart';

class ProviderSetup {
  static List<SingleChildWidget> getProviders() {
    return [
      ChangeNotifierProvider(create: (_) => AuthViewModel()),
      // Thêm các Provider khác ở đây
    ];
  }
}
