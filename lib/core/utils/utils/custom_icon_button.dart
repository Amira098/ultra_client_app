import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import 'custom_progress_indicator.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onTap;
  Color? btnColor, iconColor, borderColor;
  final double? btnWidth, borderWidth;
  final bool showLoading;
  final EdgeInsets? padding;
  final IconData icon;
  final double? iconSize, borderRadius;

  CustomIconButton(
      {required this.onTap,
      this.btnColor,
      this.iconColor,
      this.borderColor,
      this.borderWidth,
      this.btnWidth,
      this.showLoading = false,
      this.padding,
      required this.icon,
      this.iconSize,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    if (btnColor == null) btnColor = AppColors.amber;
    if (iconColor == null) iconColor = AppColors.white;
    if (borderColor == null) borderColor = btnColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: btnWidth == null ? double.infinity : btnWidth,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 4, vertical: 14),
        decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 10)),
            border: Border.all(width: borderWidth == null ? 1: borderWidth!, color: borderColor!),
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                AppColors.amber,
                AppColors.amber,
              ],
            )
        ),
        child: Center(
          child: showLoading ?
          SizedBox(child: circularProgressIndicator, width: 24, height: 24,)
          :
          Center(
            child: Icon(
                    icon,
                    color: iconColor,
                    size: iconSize ?? 24,
                  ),
                ),
        ),
      ),
    );
  }
}
