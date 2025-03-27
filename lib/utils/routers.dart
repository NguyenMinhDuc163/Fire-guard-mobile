import 'package:fire_guard/init.dart';
import 'package:fire_guard/screens/authen_screen/view/forgot_password_screen.dart';
import 'package:fire_guard/screens/authen_screen/view/intro_screen.dart';
import 'package:fire_guard/screens/authen_screen/view/login_screen.dart';
import 'package:fire_guard/screens/authen_screen/view/seslect_preferences_screen.dart';
import 'package:fire_guard/screens/authen_screen/view/sign_up_screen.dart';
import 'package:fire_guard/screens/authen_screen/view/splash_screen.dart';
import 'package:fire_guard/screens/family_manager_screen/views/family_management_screen.dart';
import 'package:fire_guard/screens/fire_map_screen/views/fire_alert_map_screen.dart';
import 'package:fire_guard/screens/fire_map_screen/views/register_coordinates_screen.dart';
import 'package:fire_guard/screens/fire_news_screen/providers/fire_news_view_model.dart';
import 'package:fire_guard/screens/fire_safety_skills_screen/providers/fire_safety_skills_view_model.dart';
import 'package:fire_guard/screens/home_screen/providers/home_view_model.dart';
import 'package:fire_guard/screens/home_screen/views/home_screen.dart';
import 'package:fire_guard/screens/home_screen/views/notification_screen.dart';
import 'package:fire_guard/screens/profile_screen/providers/persional_profile_view_model.dart';
import 'package:fire_guard/screens/profile_screen/views/personal_profile_screen.dart';
import 'package:fire_guard/screens/setting_screen/views/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final Map<String, WidgetBuilder> routes = {
  // noi tong hop ca routes
  IntroScreen.routeName: (context) => const IntroScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
// HomeScreen.routeName: (context) => const HomeScreen(),
  MainApp.routeName: (context) => const MainApp(),
  SelectPreferencesScreen.routeName: (context) => const SelectPreferencesScreen(),
  FamilyManagementScreen.routeName: (context) =>  FamilyManagementScreen(),
  NotificationsScreen.routeName: (context) => const NotificationsScreen(),
  SettingsScreen.routeName: (context) => const SettingsScreen(),
  FireAlertMapScreen.routeName: (context) => const FireAlertMapScreen(),
  RegisterCoordinatesScreen.routeName: (context) => const RegisterCoordinatesScreen(),
};

MaterialPageRoute<dynamic>? generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => ChangeNotifierProvider<HomeViewModel>(
          create: (_) => HomeViewModel(),
          child: const HomeScreen(),
        ),
      );

    case FireNewsScreen.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => ChangeNotifierProvider<FireNewsViewModel>(
          create: (_) => FireNewsViewModel(),
          child: const FireNewsScreen(),
        ),
      );

    case FireSafetySkillsScreen.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => ChangeNotifierProvider<FireSafetySkillsViewModel>(
          create: (_) => FireSafetySkillsViewModel(),
          child: const FireSafetySkillsScreen(),
        ),
      );


    case PersonalProfileScreen.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => ChangeNotifierProvider<PersonalProfileViewModel>(
          create: (_) => PersonalProfileViewModel(),
          child: const PersonalProfileScreen(),
        ),
      );

    default:
      final routeBuilder = routes[settings.name];
      if (routeBuilder != null) {
        return MaterialPageRoute(
          builder: routeBuilder,
          settings: settings,
        );
      }
      return null;
  }
}
