import 'package:flutter/material.dart';

class PrimaryTextButtonWidget extends StatelessWidget {
  const PrimaryTextButtonWidget(
      {super.key,
        required this.onPressed,
        required this.title,
        required this.textStyle});
  final Function() onPressed;
  final String title;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        title,
        style: textStyle,
      ),
    );
  }
}