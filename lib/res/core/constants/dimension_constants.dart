import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const double kMediumPadding = 24.0; // bigger default padding
const double kBottomBarIconSize = 20.0; // size of icon on the bottom bar
const double kDefaultPadding = 16.0; // standard padding using default items
const double kItemPadding = 10.0; // default padding between child widgets
const double kMinPadding = 5.0; // minimum default padding
const double kTopPadding = 8.0; // default top padding

const double kDefaultIconSize = 18;

const BorderRadius kDefaultBorderRadius = BorderRadius.all(Radius.circular(8));

//? font icon
const String fontIconApp = 'MyFlutterApp';

//!modeOrange

//! height //! width //! size  //! weight
double heightInputCombobox = 40;
const double fontsizeInputCombobox = 16;
const double heightButton = 40;

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

double margin_16 = 16.h;
double margin_24 = 24.h;
double margin_32 = 32.h;
double margin_56 = 56.h;
double margin_405 = 450.h;
double margin_325 = 325.h;
double margin_200 = 200.h;
double margin_775 = 775.h;


double padding_5 = 5.h;
double padding_16 = 16.h;
double padding_24 = 24.h;
double padding_32 = 32.h;
double padding_40 = 40.h;
double padding_80 = 80.h;


double getParentWidth(BuildContext context) => MediaQuery.of(context).size.width;
double width_2 = 2.w;
double width_8 = 8.w;
double width_16 = 16.w;
double width_20 = 20.w;
double width_24 = 24.w;
double width_28 = 28.w;
double width_30 = 30.w;
double width_32 = 32.w;
double width_38 = 38.w;
double width_40 = 40.w;
double width_50 = 50.w;
double width_56 = 56.w;
double width_70 = 70.w;
double width_100 = 100.w;
double width_120 = 120.w;
double width_130 = 130.w;
double width_150 = 150.w;
double width_200 = 200.w;
double width_250 = 250.w;
double width_300 = 300.w;
double width_320 = 320.w;
double width_400 = 400.w;
double width_600 = 600.w;
double width_800 = 800.w;


double height_2 = 2.h;
double height_4 = 4.h;
double height_8 = 8.h;
double height_16 = 16.h;
double height_20 = 20.h;
double height_24 = 24.h;
double height_30 = 30.h;
double height_32 = 32.h;
double height_38 = 38.h;
double height_40 = 40.h;
double height_50 = 50.h;
double height_56 = 56.h;
double height_64 = 64.h;
double height_70 = 70.h;
double height_100 = 100.h;
double height_120 = 120.h;
double height_130 = 130.h;
double height_140 = 140.h;
double height_150 = 150.h;
double height_160 = 160.h;
double height_400 = 400.h;
double height_550 = 550.h;
double height_500 = 500.h;


double fontSize_12 = 12;
double fontSize_14 = 14;
double fontSize_16 = 16;

double fontSize_32sp = 32.sp;
double fontSize_35sp = 35.sp;
double fontSize_38sp = 38.sp;
double fontSize_40sp = 40.sp;
double fontSize_43sp = 43.sp;
double fontSize_45sp = 45.sp;
double fontSize_48sp = 48.sp;
double fontSize_50sp = 50.sp;
double fontSize_60sp = 60.sp;


double icon_40sp = 40.sp;
double icon_50sp = 50.sp;
double icon_60sp = 60.sp;
double icon_70sp = 70.sp;
double icon_80sp = 80.sp;
double icon_90sp = 90.sp;
double icon_145sp = 145.sp;
double icon_400sp = 400.sp;


double radius_10 = 10.r;
double radius_30 = 30.r;
double radius_32 = 32.r;
double radius_34 = 34.r;
double radius_44 = 44.r;
double radius_55 = 55.r;
double radius_60 = 60.r;
double radius_124 = 124.r;



const FontWeight w500 = FontWeight.w500;

//! color
const Color colorBorderInputCombobox = Color(0xFFB2B8BB);
const Color colorlabelInputCombobox = Color(0xFFA3A3A3);

const Color colorBlack = Color(0xFF000000);
const Color colorRed = Color(0xFFD51515);
const Color colorRedBlack = Color(0xFF9C1111);
const Color colorWhite = Color(0xFFFFFFFF);
const Color colorPink = Color(0xFFFCF5E3);
const Color colorYellow100 = Color(0xFFECBC3C);
const Color mau_vangbaca_50 = Color(0xFFFCF5E3);
const Color mau_vangbaca_100 = Color(0xFFF5D98D);
// màu sắc button
Color color_button = Color.fromRGBO(201, 137, 18, 1);

const Color colorPrimary = Color(0xFF02215A);
const Color color000031 = Color(0xFF000031);
const Color colorGrey = Color(0xFF696D76);
const Color colorBlue = Color(0xFF0099BF);
const Color colorYellow = Color(0xFFDBB309);
const Color colorPrimaryLogin = Color(0xFF030303);
const Color colorBg = Color(0xFFDEDEDE);
const Color txtColorAction = Color(0xFF0D4A87);
const Color paymentBackgroundColor = Color(0xFFEAF0F8);
const Color colorBackground = Color(0xFFFBEEE2);
const Color colorEBEFF2 = Color(0xFFEBEFF2);
const Color colorEAF0F8 = Color(0xFFEAF0F8);
const Color colorE5E5E5 = Color(0xFFE5E5E5);
const Color color106EC3 = Color(0xFF106EC3);
const Color colorF48120 = Color(0xFFF48120);
const Color colorEDEDED = Color(0xFFEDEDED);
const Color color757575 = Color(0xFF757575);
const Color colorFAFAFA = Color(0xFFFAFAFA);
const Color colorCB262A = Color(0xFFCB262A);
const Color colorAE393F = Color(0xFFAE393F);
const Color colorD12129 = Color(0xFFD12129);
const Color color3991F9 = Color(0xFF3991F9);
const Color color59A5FE = Color(0xFF59A5FE);
const Color colorF3F9FF = Color(0xFFF3F9FF);
const Color color_background = Color(0xFF0D4A87);
const Color color406BAC = Color(0xFF406BAC);
const Color color_gray = Color(0xFF717788);
const Color color141F29 = Color(0xFF141F29);
const Color colorF9F9F9 = Color(0xFFF9F9F9);
const Color color219653 = Color(0xFF219653);
const Color color2981DA = Color(0xFF2981DA);
const Color colorF2F2F2 = Color(0xFFF2F2F2);
const Color color828282 = Color(0xFF828282);
const Color colorF4FAFF = Color(0xFFF4FAFF);
Color color_icon = Color.fromRGBO(50, 68, 134, 1.0);

TextStyle text_default_black = TextStyle(
    color: colorBlack,
    fontSize: fontSize_40sp
);

TextStyle text_default = TextStyle(
    fontSize: 38.sp,
    color: Colors.black87
);

TextStyle text_button_white = TextStyle(
  fontSize: 43.sp,
  color: Colors.white,
  fontWeight: FontWeight.w500,
);


TextStyle text_label_in_register = TextStyle(
  fontSize: 43.sp,
  color: colorlabelInputCombobox,
  fontWeight: FontWeight.w400,
);

TextStyle text_default_white_home = TextStyle(
  color: Color(0xFFFFFFFF),
  fontSize: 32.sp,
);

TextStyle text_fontSize14_717788 = TextStyle(
    fontSize: 38.sp,
    color: color141F29.withOpacity(0.7)
);

TextStyle text_action_font12 = TextStyle(
  fontSize: 32.sp,
  color: txtColorAction,
  fontWeight: FontWeight.w400,
);

TextStyle text_action_font14 = TextStyle(
  fontSize: 38.sp,
  color: txtColorAction,
  fontWeight: FontWeight.w400,
);

TextStyle text_action_font14_underLine = TextStyle(
  fontSize: 38.sp,
  color: txtColorAction,
  fontWeight: FontWeight.w400,
  decoration: TextDecoration.underline,
);

TextStyle text_action_Bold600 = TextStyle(
  fontSize: 38.sp,
  color: txtColorAction,
  fontWeight: FontWeight.w600,
);



TextStyle text_action_font16 = TextStyle(
  fontSize: 43.sp,
  color: txtColorAction,
  fontWeight: FontWeight.w500,
);

TextStyle text_action_font18 = TextStyle(
  fontSize: 48.sp,
  color: txtColorAction,
  fontWeight: FontWeight.w500,
);


TextStyle text12Bold400 = TextStyle(
  fontSize: 32.sp,
  color: Colors.black,
  fontWeight: FontWeight.w400,
);

TextStyle text12Bold600 = TextStyle(
  fontSize: 32.sp,
  color: Colors.black87,
  fontWeight: FontWeight.w600,
);


TextStyle text12Bold500White = TextStyle(
  fontSize: 32.sp,
  color: Colors.white,
  fontWeight: FontWeight.w500,
);

TextStyle text14bold400White = TextStyle(
  fontSize: 38.sp,
  color: Colors.white,
  fontWeight: FontWeight.w400,
);
TextStyle text18bold600White = TextStyle(
  fontSize: 48.sp,
  color: Colors.white,
  fontWeight: FontWeight.w600,
);

TextStyle text14Bold400 = TextStyle(
  fontSize: 38.sp,
  color: Colors.black,
  fontWeight: FontWeight.w400,
);

TextStyle text14Bold600 = TextStyle(
  fontSize: 38.sp,
  color: Colors.black,
  fontWeight: FontWeight.w600,
);

TextStyle text16Bold400 = TextStyle(
  fontSize: 43.sp,
  color: Colors.black,
  fontWeight: FontWeight.w400,
);
TextStyle text16Bold600 = TextStyle(
  fontSize: 43.sp,
  color: Colors.black,
  fontWeight: FontWeight.w600,
);

TextStyle text18Bold500 = TextStyle(
  fontSize: 48.sp,
  color: Colors.black,
  fontWeight: FontWeight.w500,
);

TextStyle text20Bold500 = TextStyle(
  fontSize: 54.sp,
  color: Colors.black,
  fontWeight: FontWeight.w500,
);

TextStyle text18Bold700 = TextStyle(
    fontSize: 48.sp,
    color: Colors.black87,
    fontWeight: FontWeight.w700);

TextStyle text20Bold500White = TextStyle(
  fontSize: 54.sp,
  color: Colors.white,
  fontWeight: FontWeight.w500,
);
TextStyle text20Bold300White = TextStyle(
  fontSize: 54.sp,
  color: Colors.white,
  fontWeight: FontWeight.w300,
);

TextStyle text50Bold900White = TextStyle(
  shadows: [
    Shadow(
      blurRadius: 10.0,
      color: Colors.black12,
      offset: Offset(0, 5.0),
    ),
  ],
  fontSize: 106.sp,
  color: Colors.white,
  fontWeight: FontWeight.w700,
);




TextStyle text40sp = TextStyle(
    fontSize: fontSize_40sp,
    color: Colors.black
);

TextStyle text43sp = TextStyle(
    fontSize: fontSize_43sp,
    color: Colors.black
);

TextStyle text43spWhite = TextStyle(
    fontSize: fontSize_43sp,
    color: Colors.white
);

TextStyle text45sp = TextStyle(
    fontSize: fontSize_45sp,
    color: Colors.black
);

TextStyle text45spItalic = TextStyle(
    fontSize: fontSize_45sp,
    color: Colors.black,
    fontStyle: FontStyle.italic
);

TextStyle text45spColorBlue = TextStyle(
  fontSize: fontSize_45sp,
  color: Color(0xff0039e6),
);

TextStyle text45spColorBackground = TextStyle(
  fontSize: fontSize_45sp,
  color: color_background,
);

TextStyle text45spBold700ColorBackground = TextStyle(
  fontSize: fontSize_45sp,
  color: color_background,
  fontWeight: FontWeight.w700,
);

TextStyle text45spBold700 = TextStyle(
    fontSize: fontSize_45sp,
    fontWeight: FontWeight.w700
);

TextStyle text50sp = TextStyle(
    fontSize: fontSize_50sp,
    color: Colors.black
);

TextStyle text50spBold700 = TextStyle(
    fontSize: fontSize_50sp,
    fontWeight: FontWeight.w700
);

TextStyle text50spBold700Red = TextStyle(
    fontSize: fontSize_50sp,
    color: colorRed,
    fontWeight: FontWeight.w700
);

TextStyle text60spRed = TextStyle(
  fontSize: fontSize_60sp,
  color: colorRed,
);

TextStyle text14OpacityBold400 = TextStyle(
  fontSize: 38.sp,
  color: Colors.black.withOpacity(0.3),
  fontWeight: FontWeight.w400,
);
TextStyle text12OpacityBold400 = TextStyle(
  fontSize: 32.sp,
  color: Colors.black.withOpacity(0.3),
  fontWeight: FontWeight.w400,
);

TextStyle text12Red400 = TextStyle(
  fontSize: 32.sp,
  color: colorD12129,
  fontWeight: FontWeight.w400,
);
TextStyle text14Red400 = TextStyle(
  fontSize: 38.sp,
  color: colorD12129,
  fontWeight: FontWeight.w400,
);

TextStyle text14Red600 = TextStyle(
  fontSize: 38.sp,
  color: colorD12129,
  fontWeight: FontWeight.w600,
);

TextStyle text24Red600 = TextStyle(
  fontSize: 48.sp,
  color: colorD12129,
  fontWeight: FontWeight.w600,
);

TextStyle text14OBold400 = TextStyle(
  fontSize: 38.sp,
  color: color828282,
  fontWeight: FontWeight.w400,
);
TextStyle text14OBold600 = TextStyle(
  fontSize: 38.sp,
  color: color828282,
  fontWeight: FontWeight.w600,
);

