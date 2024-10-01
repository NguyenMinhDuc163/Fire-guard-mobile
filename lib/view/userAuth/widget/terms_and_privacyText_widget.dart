import 'package:flutter/material.dart';
import 'package:fire_guard/res/core/constants/color_constants.dart';

class TermsAndPrivacyTextWidget extends StatelessWidget {
  const TermsAndPrivacyTextWidget(
      {super.key,
        required this.title1,
        required this.title2,
        required this.title3,
        this.color2,
        required this.title4});
  final Color? color2;
  final String title1, title2, title3, title4;
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ColorPalette.kWhite)
            .copyWith(
            color: ColorPalette.kGrayscale40,
            fontWeight: FontWeight.w500,
            fontSize: 14),
        children: [
          TextSpan(
            text: title1,
          ),
          TextSpan(
            text: title2,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorPalette.kWhite)
                .copyWith(
                color: color2 ?? ColorPalette.kGrayscaleDark100,
                fontWeight: FontWeight.w500,
                fontSize: 14),
          ),
          TextSpan(
            text: title3,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorPalette.kWhite)
                .copyWith(
                color: ColorPalette.kGrayscale40,
                fontWeight: FontWeight.w500,
                fontSize: 14),
          ),
          TextSpan(
            text: title4,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorPalette.kWhite)
                .copyWith(
                color: ColorPalette.kGrayscaleDark100,
                fontWeight: FontWeight.w500,
                fontSize: 14),
          ),
        ],
      ),
    );
  }
}