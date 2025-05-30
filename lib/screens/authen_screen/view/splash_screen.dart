import 'package:fire_guard/screens/authen_screen/view/intro_screen.dart';
import 'package:fire_guard/screens/authen_screen/view/login_screen.dart';
import 'package:flutter/cupertino.dart';
import '../../../init.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = '/splash_screen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    redirectIntroScreen(); // doi tre 2s
  }
  void redirectIntroScreen() async{
    // man hinh nay chi xuat hien trong lan khoi dong dau tien
    final ignoreIntroScreen = LocalStorageHelper.getValue('ignoreIntroScreen') as bool?;
    await Future.delayed(const Duration(milliseconds: 1000));
    if(ignoreIntroScreen != null && ignoreIntroScreen){
      Navigator.of(context).pushNamed(LoginScreen.routeName);
      // Navigator.of(context).pushNamed(IntroScreen.routeName);

    }
    else{
      LocalStorageHelper.setValue('ignoreIntroScreen', true);
      Navigator.of(context).pushNamed(IntroScreen.routeName);
    }
    // Navigator.of(context).pushNamed(RouteNames.introScreen);
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          // child: Container(color: const Color(0xFFF5EDE2),),
          child: Container(color: ColorPalette.slateGray,),
        ), // cho full man hinh
        Center( // Sử dụng Center để hình ảnh nằm giữa
          child: ImageHelper.loadFromAsset(
            AssetHelper.icoLogo,
            width: 250,
            height: 250,
            alignment: Alignment.center,
          ),
        ),
      ],
    );
  }
}
