import 'dart:async';
import 'package:fire_guard/utils/core/constants/textstyle_ext.dart';
import 'package:flutter/material.dart';
import '../../../init.dart';
import 'package:fire_guard/utils/router_names.dart';
import 'package:fire_guard/view/userAuth/widget/button_intro_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:easy_localization/easy_localization.dart';




class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  final StreamController<int> _streamController = StreamController<int>();

  // tao ra widget dung trung: truyen cac tham so
  Widget _buildItemIntroScreen(String image, String title, String descripton,
      AlignmentGeometry alignmentDirectional, String icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Positioned(child: Image(image: AssetImage(icon))),
            Positioned(child: Container(
                alignment: alignmentDirectional,
                child: ImageHelper.loadFromAsset(image, height: 430, fit: BoxFit.fitHeight))),

          ],
        ),
        const SizedBox(
          height: kMediumPadding * 2, // cach khoang 50 px
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyles.defaultStyle.bold,

              ),
              const SizedBox(
                height: kMediumPadding, // cach khoang 50 px
              ),
              Text(
                descripton,
                style: TextStyles.defaultStyle,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSkipButton( {required Function() onPressed}) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(20), // Khoảng cách từ mép phải và trên của màn hình
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Colors.black, backgroundColor: Colors.white, // Màu chữ
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Khoảng cách padding trong nút
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Đặt bo tròn các góc
            ),
              minimumSize: const Size(75, 20)
          ),
          child:  Text(
            'skip'.tr(),
            style: const TextStyle(
              fontSize: 16, // Kích thước chữ
            ),
          ),
        ),
      ),
    );
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController.addListener(() {
      _streamController.add(_pageController.page!.toInt());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Stack(
          children: [
            Positioned.fill(
              child: Container(color: const Color(0xFFF5EDE2),),
            ),

            PageView(
              controller: _pageController,
              children: [
                _buildItemIntroScreen(
                    AssetHelper.slide1,
                    "titleIntro1".tr(),
                    "contentIntro1".tr(),
                    Alignment.center,
                    AssetHelper.icoRectanglePink),
                _buildItemIntroScreen(
                    AssetHelper.slide2,
                    "titleIntro2".tr(),
                    "contentIntro2".tr(),
                    Alignment.center,
                    AssetHelper.icoRectangleBlue),
                _buildItemIntroScreen(
                    AssetHelper.slide3,
                    "titleIntro3".tr(),
                    "contentIntro3".tr(),
                    Alignment.center,
                    AssetHelper.icoRectanglePink),
              ],
            ),
            Positioned(
              left: kMediumPadding,
              right: kMediumPadding,
              bottom: kMediumPadding * 2,
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: 3,
                      effect: const ExpandingDotsEffect(
                        dotWidth: kMinPadding,
                        dotHeight: kMinPadding,
                        activeDotColor: Colors.orange,
                      ),
                    ),
                  ),
                  StreamBuilder<int>(
                    // neu dung nhu the nay chi rendew buttom chu khong render ca man hinh
                      stream: _streamController.stream,
                      initialData: 0, // tranh gt null
                      builder: (context, snapshot) {
                        return Expanded(
                          flex: 4,
                          child: ButtonIntroWidget(
                            title: (snapshot.data != 2) ? "buttonNext".tr() : "buttonGetStarted".tr(),
                            ontap: () {
                              if (_pageController.page != 2) {
                                _pageController.nextPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInSine);
                              } else {
                                Navigator.of(context).pushNamed(RouteNames.loginScreen);
                              }
                            },
                            opacity: ColorPalette.blue,
                          ),
                        );
                      }),

                ],
              ),
            ),
            _buildSkipButton(onPressed: () {
              Navigator.of(context).pushNamed(RouteNames.loginScreen);
            }),
          ],

        ));
  }
}
