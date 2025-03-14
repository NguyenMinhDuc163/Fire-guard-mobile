import 'package:fire_guard/view/fireNews/fire_news_screen.dart';
import 'package:fire_guard/view/home/family_management_screen.dart';
import 'package:fire_guard/view/home/fire_alert_map_screen.dart';
import 'package:fire_guard/view/home/notification_screen.dart';
import 'package:fire_guard/view/home/register_coordinates_screen.dart';
import 'package:fire_guard/view/personalProfile/personal_profile_screen.dart';
import 'package:fire_guard/view/personalProfile/settings_screen.dart';
import 'package:fire_guard/viewModel/fire_news_view_model.dart';
import 'package:fire_guard/viewModel/fire_safety_skills_view_model.dart';
import 'package:fire_guard/viewModel/home_view_model.dart';
import 'package:fire_guard/viewModel/personal_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fire_guard/init.dart';
import 'package:fire_guard/utils/router_names.dart';
import 'package:provider/provider.dart';

import '../view/fireSafetySkills/fire_safety_skills_screen.dart';

final Map<String, WidgetBuilder> routes = {
  // noi tong hop ca routes
  RouteNames.introScreen: (context) => const IntroScreen(),
  RouteNames.splashScreen: (context) => const SplashScreen(),
  RouteNames.loginScreen: (context) => const LoginScreen(),
  RouteNames.signUpScreen: (context) => const SignUpScreen(),
  RouteNames.forgotPasswordScreen: (context) => const ForgotPasswordScreen(),
  // RouteNames.homeScreen: (context) => const HomeScreen(),
  RouteNames.mainApp: (context) => const MainApp(),
  RouteNames.selectPreferencesScreen: (context) => const SelectPreferencesScreen(),
  RouteNames.familyManagementScreen: (context) =>  FamilyManagementScreen(),
  RouteNames.notifications: (context) => const NotificationsScreen(),
  RouteNames.settings: (context) => const SettingsScreen(),
  RouteNames.fireAlertMapScreen: (context) => const FireAlertMapScreen(),
  RouteNames.registerCoordinatesScreen: (context) => const RegisterCoordinatesScreen(),
};

MaterialPageRoute<dynamic>? generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case RouteNames.homeScreen:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => ChangeNotifierProvider<HomeViewModel>(
          create: (_) => HomeViewModel(),
          child: const HomeScreen(),
        ),
      );

    case RouteNames.fireNewsScreen:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => ChangeNotifierProvider<FireNewsViewModel>(
          create: (_) => FireNewsViewModel(),
          child: const FireNewsScreen(),
        ),
      );

    case RouteNames.fireSafetySkillsScreen:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => ChangeNotifierProvider<FireSafetySkillsViewModel>(
          create: (_) => FireSafetySkillsViewModel(),
          child: const FireSafetySkillsScreen(),
        ),
      );


    case RouteNames.personalProfileScreen:
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
