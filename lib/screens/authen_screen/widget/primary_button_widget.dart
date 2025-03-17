import 'package:flutter/material.dart';
import '../../../init.dart';
class PrimaryButtonWidget extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final double? width;
  final double? height;
  final double? borderRadius, elevation;
  final double? fontSize;
  final IconData? iconData;
  final Color? textColor, bgColor;
  const PrimaryButtonWidget(
      {Key? key,
        required this.onTap,
        required this.text,
        this.width,
        this.height,
        this.elevation = 5,
        this.borderRadius,
        this.fontSize,
        required this.textColor,
        required this.bgColor,
        this.iconData})
      : super(key: key);

  @override
  State<PrimaryButtonWidget> createState() => _PrimaryButtonWidgetState();
}
class _PrimaryButtonWidgetState extends State<PrimaryButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _tween.animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        ),
        child: Card(
          elevation: widget.elevation ?? 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius!),
          ),
          child: Container(
            height: widget.height ?? 55,
            alignment: Alignment.center,
            width: widget.width ?? double.maxFinite,
            decoration: BoxDecoration(
              color: widget.bgColor,
              borderRadius: BorderRadius.circular(widget.borderRadius!),
            ),
            child: Text(
              widget.text,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorPalette.kWhite)
                  .copyWith(
                  color: widget.textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: widget.fontSize),
            ),
          ),
        ),
      ),
    );
  }
}
