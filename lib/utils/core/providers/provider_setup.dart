import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fire_guard/viewModel/auth_view_model.dart';
import 'package:fire_guard/viewModel/home_view_model.dart';
import 'package:fire_guard/viewModel/fire_news_view_model.dart';
import 'package:fire_guard/viewModel/fire_safety_skills_view_model.dart';
import 'package:fire_guard/viewModel/setting_view_model.dart';

class ProviderSetup {
  static List<ChangeNotifierProvider> getProviders() {
    return [
      ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ChangeNotifierProvider(create: (_) => FireNewsViewModel()),
      ChangeNotifierProvider(create: (_) => FireSafetySkillsViewModel()),
      ChangeNotifierProvider(create: (_) => SettingViewModel()),
    ];
  }
}
