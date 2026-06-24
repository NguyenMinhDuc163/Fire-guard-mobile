import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../init.dart';

class PrimaryTextFormFieldWidget extends StatelessWidget {
  const PrimaryTextFormFieldWidget(
      {super.key,
      required this.hintText,
      this.keyboardType,
      required this.controller,
      required this.width,
      required this.height,
      this.hintTextColor,
      this.onChanged,
      this.onTapOutside,
      this.prefixIcon,
      this.prefixIconColor,
      this.inputFormatters,
      this.maxLines,
      this.borderRadius});
  final BorderRadiusGeometry? borderRadius;

  final String hintText;

  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Function(PointerDownEvent)? onTapOutside;
  final Function(String)? onChanged;
  final double width, height;
  final TextEditingController controller;
  final Color? hintTextColor, prefixIconColor;
  final TextInputType? keyboardType;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    InputBorder enabledBorder = InputBorder.none;
    InputBorder focusedErrorBorder = InputBorder.none;
    InputBorder errorBorder = InputBorder.none;
    InputBorder focusedBorder = InputBorder.none;
    final fieldHeight = height < 48 ? 48.0 : height;

    return Container(
      width: width,
      constraints: BoxConstraints(minHeight: fieldHeight),
      decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: ColorPalette.kBackground,
          border: Border.all(color: ColorPalette.kLine)),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines ?? 1,
        keyboardType: keyboardType,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorPalette.kWhite)
            .copyWith(
          color: ColorPalette.kGrayscaleDark100,
        ),
        decoration: InputDecoration(
          isDense: false,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorPalette.kWhite)
              .copyWith(
                  color: hintTextColor ?? ColorPalette.kGrayscale40,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
          prefixIcon: prefixIcon,
          prefixIconColor: prefixIconColor,
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          errorBorder: errorBorder,
          focusedErrorBorder: focusedErrorBorder,
        ),
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        onTapOutside: onTapOutside,
      ),
    );
  }
}
