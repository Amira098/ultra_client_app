import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_colors.dart';
import '../../constants/font_family.dart';
import '../../constants/font_size.dart';
import 'custom_progress_indicator.dart';
import 'custom_text.dart';

class CustomButtonWithWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final String? fontFamily;
  Color? btnColor, textColor, borderColor;
  final double? btnWidth, borderWidth, borderRadius;
  final bool showLoading;
  final EdgeInsets? padding;
  final Widget icon;
  final MainAxisAlignment? mainAxisAlignment;
  final double? spaceBetweenIconAndText;

  CustomButtonWithWidget(
      {required this.onTap,
      this.spaceBetweenIconAndText,
      this.btnColor,
      this.textColor,
      this.fontFamily,
      required this.text,
      this.borderColor,
      this.borderRadius,
      this.borderWidth,
      this.mainAxisAlignment,
      this.btnWidth,
      this.showLoading = false,
      this.padding,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    if (btnColor == null) btnColor = AppColors.amber;
    if (textColor == null) textColor = AppColors.amber;
    if (borderColor == null) borderColor = btnColor;
    return GestureDetector(
      onTap: !showLoading ? onTap : null,
      child: Container(
        width: btnWidth == null ? double.infinity : btnWidth,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 32)),
            border: Border.all(width: borderWidth == null ? 1: borderWidth!, color: borderColor!)),
        child: Center(
          child: showLoading ?
          SizedBox(child: circularProgressIndicator, width: 24, height: 24,)
          :
         Row(
           mainAxisAlignment:
                      mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
                  children: [
                    icon,
                    SizedBox(
                      width: spaceBetweenIconAndText ?? 0.0,
                    ),
                    CustomText(
                      text,
                      style: TextStyle(
                          fontSize: AppSizes.BUTTON_SIZE,
                          color: textColor,
                          fontFamily: fontFamily ?? AppFontFamily.MEDIUM),
                    ),
                    SizedBox(
                      width: spaceBetweenIconAndText ?? 0.0,
                    ),
                    Opacity(opacity: 0,
                    child: icon,)
                  ],
                ),
        ),
      ),
    );
  }
}

