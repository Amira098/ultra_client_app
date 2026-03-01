import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/app_colors.dart';
import '../../constants/font_family.dart';
import '../../constants/font_size.dart';
import 'custom_text.dart';

class CustomExpandButtonBody extends StatefulWidget {
  final String text;
  final String? fontFamily;
  Color? btnColor, textColor, borderColor;
  final double? btnWidth, borderWidth, borderRadius;
  final EdgeInsets? padding;
  final String icon;
  final Color? iconColor;
  final MainAxisAlignment? mainAxisAlignment;
  final double? spaceBetweenIconAndText;
  Widget body;

  CustomExpandButtonBody(
      {this.spaceBetweenIconAndText,
      required this.body,
      this.btnColor,
      this.textColor,
      this.fontFamily,
      required this.text,
      this.borderColor,
      this.borderRadius,
      this.borderWidth,
      this.mainAxisAlignment,
      this.btnWidth,
      this.padding,
      required this.icon,
      this.iconColor});

  @override
  State<CustomExpandButtonBody> createState() => _CustomExpandButtonBodyState();
}

class _CustomExpandButtonBodyState extends State<CustomExpandButtonBody> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.btnColor == null) widget.btnColor = AppColors.amber;
    if (widget.textColor == null) widget.textColor = AppColors.white;
    if (widget.borderColor == null) widget.borderColor = widget.btnColor;
    return GestureDetector(
      onTap: () {
        isExpanded = !isExpanded;
        setState(() {});
      },
      child: Container(
        width: widget.btnWidth == null ? double.infinity : widget.btnWidth,
        padding: widget.padding ?? EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: widget.btnColor,
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius ?? 32)),
            border: Border.all(
                width: widget.borderWidth == null ? 1 : widget.borderWidth!,
                color: widget.borderColor!)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment:
                  widget.mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(widget.icon,
                    width: 28, height: 28, color: widget.iconColor),
                SizedBox(
                  width: widget.spaceBetweenIconAndText ?? 0.0,
                ),
                CustomText(
                  widget.text,
                  style: TextStyle(
                      fontSize: AppSizes.BUTTON_SIZE,
                      color: widget.textColor,
                      fontFamily: widget.fontFamily ?? AppFontFamily.BOLD),
                ),
                SvgPicture.asset(
                  widget.icon,
                  color: AppColors.transparent,
                  width: 28,
                  height: 28,
                ),
              ],
            ),
            Visibility(
                visible: isExpanded,
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    widget.body,
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
