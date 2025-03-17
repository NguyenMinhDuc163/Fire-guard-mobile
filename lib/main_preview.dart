import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:error_stack/error_stack.dart';
import 'package:fire_guard/init.dart';
import 'package:fire_guard/utils/routers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'providers/provider_setup.dart';
import 'screens/authen_screen/view/splash_screen.dart';
import 'service/service_config/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  await LocalStorageHelper.initLocalStorageHelper();
  await dotenv.load(fileName: ".env");
  await Geolocator.requestPermission();

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
        child: DevicePreview(
          enabled: !kReleaseMode,
          builder: (context) => const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NotificationService _notificationService = NotificationService();
    // Khởi tạo Notification Service với context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationService.init(context);
    });

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          title: 'Fire Guard',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
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
