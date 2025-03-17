import 'package:flutter/material.dart';
import '../../../init.dart';
class CustomRichTextWidget extends StatelessWidget {
  const CustomRichTextWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTab,
    required this.subtitleTextStyle,
  });
  final String title, subtitle;
  final TextStyle subtitleTextStyle;
  final VoidCallback onTab;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: title,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ColorPalette.kWhite)
              .copyWith(
              color: ColorPalette.kGrayscale40,
              fontWeight: FontWeight.w600,
              fontSize: 14),
          children: <TextSpan>[
            TextSpan(
              text: subtitle,
              style: subtitleTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
