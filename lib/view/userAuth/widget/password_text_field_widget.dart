import 'package:flutter/material.dart';
import 'package:fire_guard/res/core/constants/color_constants.dart';

class PasswordTextFieldWidget extends StatefulWidget {
  final String hintText;

  final double width, height;
  final TextEditingController controller;
  final BorderRadiusGeometry borderRadius;
  const PasswordTextFieldWidget(
      {super.key,
        required this.hintText,
        required this.height,
        required this.controller,
        required this.width,
        required this.borderRadius});
  @override
  _PasswordTextFieldWidgetState createState() => _PasswordTextFieldWidgetState();
}

class _PasswordTextFieldWidgetState extends State<PasswordTextFieldWidget> {
  bool _obscureText = false;
  @override
  Widget build(BuildContext context) {
    InputBorder enabledBorder = InputBorder.none;
    InputBorder focusedErrorBorder = InputBorder.none;
    InputBorder errorBorder = InputBorder.none;
    InputBorder focusedBorder = InputBorder.none;

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          color: ColorPalette.kBackground2,
          border: Border.all(color: ColorPalette.kLine)),
      child: TextFormField(
          obscureText: _obscureText,
          controller: widget.controller,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ColorPalette.kWhite)
              .copyWith(
            color: ColorPalette.kGrayscaleDark100,
          ),
          decoration: InputDecoration(
            filled: true,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: ColorPalette.kGrayscaleDark100,
                size: 17,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            hintText: widget.hintText,
            hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorPalette.kWhite)
                .copyWith(
                color: ColorPalette.kGrayscale40,
                fontWeight: FontWeight.w600,
                fontSize: 14),
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: focusedErrorBorder,
          )),
    );
  }
}
