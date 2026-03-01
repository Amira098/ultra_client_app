import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ultra_client/core/utils/utils/custom_progress_indicator.dart';

import '../constants/app_colors.dart' show AppColors;
import '../constants/app_constants.dart' as AppFontFamily;
import '../constants/app_fonts_family.dart';
import '../constants/font_size.dart';
import 'custom_text.dart';
class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final double? fontSize;
  final String? fontFamily;
  Color? btnColor, textColor, borderColor;
  final double? btnWidth, borderWidth, borderRadius;
  final bool showLoading;
  final bool? isEnabled;
  final EdgeInsets? padding;

  CustomButton({
    required this.onTap,
    this.fontSize,
    this.btnColor,
    this.textColor,
    this.fontFamily,
    required this.text,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.btnWidth,
    this.showLoading = false,
    this.isEnabled,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveEnabled = isEnabled ?? true;
    final effectiveBtnColor = effectiveEnabled
        ? (btnColor ?? AppColors.amber)
        : (btnColor ?? AppColors.amber).withOpacity(0.4);
    final effectiveTextColor = effectiveEnabled
        ? (textColor ?? AppColors.white)
        : (textColor ?? AppColors.white).withOpacity(0.7);
    final effectiveBorderColor = effectiveEnabled
        ? (borderColor ?? btnColor ?? AppColors.amber)
        : (borderColor ?? btnColor ?? AppColors.amber)
        .withOpacity(0.4);

    return GestureDetector(
      onTap: (!showLoading && effectiveEnabled) ? onTap : null,
      child: Container(
        width: btnWidth ?? double.infinity,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: effectiveBtnColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          border: Border.all(
            width: borderWidth ?? 1,
            color: effectiveBorderColor,
          ),
        ),
        child: Center(
          child: showLoading
              ? SizedBox(
            width: 24,
            height: 24,
            child: circularProgressIndicator,
          )
              : CustomText(
            text,
            style: TextStyle(
              fontSize: fontSize ?? AppSizes.BUTTON_SIZE,
              color: effectiveTextColor,
              fontFamily: fontFamily ?? AppFontFamily.MEDIUM,
            ),
          ),
        ),
      ),
    );
  }
}



class CustomImageButton extends StatelessWidget {
  final VoidCallback onTap;
  final String image;
  Color? btnColor, imageColor, borderColor;
  final double? btnWidth, borderWidth, borderRadius;
  final EdgeInsets? padding;

  CustomImageButton(
      {super.key, required this.onTap,
      this.btnColor,
      this.imageColor,
      required this.image,
      this.borderColor,
      this.borderWidth,
      this.btnWidth,
      this.borderRadius,
      this.padding});

  @override
  Widget build(BuildContext context) {
    if (btnColor == null) btnColor = AppColors.amber;
    if (imageColor == null) imageColor = AppColors.black;
    if (borderColor == null) borderColor = btnColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: btnWidth == null ? double.infinity : btnWidth,
        padding: padding ?? EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 24)),
            border: Border.all(
                width: borderWidth == null ? 1 : borderWidth!,
                color: borderColor!)),
        child: Center(
          child: SvgPicture.asset(
            image,
            fit: BoxFit.cover,
            color: imageColor,
          ),
        ),
      ),
    );
  }
}
