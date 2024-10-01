import 'package:flutter/material.dart';
import 'package:fire_guard/res/core/constants/color_constants.dart';

class DividerRowWidget extends StatelessWidget {
  final String title;
  const DividerRowWidget({
    required this.title,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Divider(
              color: ColorPalette.kLine,
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorPalette.kWhite)
                .copyWith(
                color: ColorPalette.kGrayscale40,
                fontWeight: FontWeight.w500,
                fontSize: 14),
          ),
        ),
        Expanded(
            flex: 2,
            child: Divider(
              color: ColorPalette.kLine,
            ))
      ],
    );
  }
}