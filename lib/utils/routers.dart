
import 'package:flutter/material.dart';
import 'package:fire_guard/init.dart';
import 'package:fire_guard/utils/router_names.dart';


final Map<String, WidgetBuilder> routes = {
  // noi tong hop ca routes
  RouteNames.introScreen: (context) => const IntroScreen(),
  RouteNames.splashScreen: (context) => const SplashScreen(),
  RouteNames.loginScreen: (context) => const LoginScreen(),
  RouteNames.signUpScreen: (context) => const SignUpScreen(),
  RouteNames.forgotPasswordScreen: (context) => const ForgotPasswordScreen(),
  RouteNames.homeScreen: (context) => const HomeScreen(),
  RouteNames.friendScreen: (context) => const FriendScreen(),
  RouteNames.leaderBoardScreen: (context) => const LeaderBoard(),
  RouteNames.quizzesScreen: (context) => const QuizzesScreen(),
  RouteNames.mainApp: (context) => const MainApp(),
  RouteNames.selectPreferencesScreen: (context) => const SelectPreferencesScreen(),



};

MaterialPageRoute<dynamic>? generateRoutes(RouteSettings settings) {
  // switch (settings.name) {
  //   case RouteNames.hotelDetailScreen:
  //     final HotelModel hotelModel = (settings.arguments as HotelModel);
  //     return MaterialPageRoute<dynamic>(
  //       settings: settings,
  //       builder: (context) => HotelDetailScreen(
  //         hotelModel: hotelModel,
  //       ),
  //     );
  //
  //   case RouteNames.checkOutScreen:
  //     final RoomModel roomModel = (settings.arguments as RoomModel);
  //     return MaterialPageRoute<dynamic>(
  //       settings: settings,
  //       builder: (context) => CheckOutScreen(
  //         roomModel: roomModel,
  //       ),
  //     );
  //
  //   case RouteNames.hotelBookingScreen:
  //     return MaterialPageRoute<dynamic>(builder: (context) {
  //       final String? nameDestination = (settings.arguments as String?);
  //       return HotelBookingScreen(
  //         nameDestination: nameDestination,
  //       );
  //     });
  // }
}
