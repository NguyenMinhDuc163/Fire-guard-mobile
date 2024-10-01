import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../res/core/constants/color_constants.dart';
import '../../../res/core/constants/dimension_constants.dart';
import '../../../res/core/constants/textstyle_ext.dart';

class ButtonIntroWidget extends StatelessWidget {
  final String title;
  final Function()? ontap;
  final Color? opacity;
  final bool? isign;
  const ButtonIntroWidget(
      {super.key, required this.title, this.ontap, this.opacity, this.isign});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kMediumPadding),
          gradient:
          opacity != null ? null : Gradients.defaultGradientBackground,
          color: opacity,
        ),
        alignment: Alignment.center,
        child: (isign == true)
            ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
            ))
            : Text(
          title,
          style: TextStyles.defaultStyle.bold.copyWith(
            color: Colors.white
          ),
        ),
      ),
    );
  }
}
