import 'package:error_stack/error_stack.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:fire_guard/utils/routers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

import 'providers/provider_setup.dart';
import '../../../init.dart';
import 'service/service_config//notification_service.dart';
import 'service/service_config/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  await LocalStorageHelper.initLocalStorageHelper();
  await dotenv.load(fileName: ".env");
  await Geolocator.requestPermission();

  // await Firebase.initializeApp(
  //   options: FirebaseOptions(
  //     apiKey: dotenv.env['API_KEY']!,
  //     appId: dotenv.env['APP_ID']!,
  //     messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
  //     projectId: dotenv.env['PROJECT_ID']!,
  //   ),
  // );
  // final firebaseService = FirebaseService();
  // print("Current base URL from Firebase Remote Config: ${firebaseService.getBaseURLServer()}");
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.playIntegrity,
  // );
  //
  // await Supabase.initialize(
  //   url: dotenv.env['SUPABASE_URL']!,
  //   anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  // );

  // Khởi tạo FirebaseService để kích hoạt Remote Config

  Locale defaultLocale = const Locale('en', 'US');
  String? savedLocale = LocalStorageHelper.getValue('languageCode');
  if (savedLocale != null) {
    defaultLocale = Locale(savedLocale);
  }

  await ErrorStack.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('vi', 'VN')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: MultiProvider(
        providers: ProviderSetup.getProviders(),
        child: const MyApp(),
      ),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final NotificationService _notificationService = NotificationService();
    // Khởi tạo Notification Service với context
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _notificationService.init(context);
    // });

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,

      builder: (context, child) {
        return MaterialApp(
          title: 'Fire Guard',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: const SplashScreen(),
          navigatorKey: NavigationService.navigatorKey,
          routes: routes,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: generateRoutes,
        );
      },
    );
  }
}
