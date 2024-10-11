import 'package:error_stack/error_stack.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:fire_guard/res/core/helpers/local_storage_helper.dart';
import 'package:fire_guard/utils/routers.dart';
import 'package:fire_guard/view/userAuth/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

import 'providers/provider_setup.dart';
import 'res/core/constants/dimension_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  await LocalStorageHelper.initLocalStorageHelper();
  await dotenv.load(fileName: ".env");

  // await Firebase.initializeApp(
  //     options:  FirebaseOptions(
  //       apiKey: dotenv.env['API_KEY']!,
  //       appId: dotenv.env['APP_ID']!,
  //       messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
  //       projectId: dotenv.env['PROJECT_ID']!,
  //     )
  // );
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.playIntegrity, // Sử dụng SafetyNet cho Android
  // );
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );


  Locale defaultLocale = const Locale('en', 'US'); // Ngôn ngữ mặc định
  String? savedLocale = LocalStorageHelper.getValue('languageCode');
  if (savedLocale != null) {
    defaultLocale = Locale(savedLocale);
  }

  // Initialize ErrorStack
  await ErrorStack.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('vi', 'VN')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: MultiProvider(
        providers: ProviderSetup.getProviders(),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Kích thước màn hình thiết kế gốc
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Quizz Pro',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: const SplashScreen(),
          navigatorKey: NavigationService.navigatorKey, // Dieu huong toan cuc
          routes: routes, // Đã định nghĩa routes ở bên trên
          debugShowCheckedModeBanner: false,
          onGenerateRoute: generateRoutes, // Đã định nghĩa generateRoutes ở bên trên
        );
      },
    );
  }
}
