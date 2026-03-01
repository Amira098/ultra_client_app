import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'custom_progress_indicator.dart';

class CustomCircleIconButton extends StatelessWidget {
  final Function()? onTap;
   Color? btnColor, iconColor, borderColor;
  final double? btnWidth, borderWidth;
  final EdgeInsets? padding;
  final IconData icon;
  final double? iconSize,borderRadius;


  CustomCircleIconButton({ required this.onTap, this.btnColor, this.iconColor,
    this.borderColor,this.borderWidth,this.btnWidth,this.padding,
    required this.icon, this.iconSize, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    if(btnColor == null)
      btnColor = AppColors.red;
    if (iconColor == null) iconColor = AppColors.white;
    if (borderColor == null) borderColor = AppColors.red;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: btnWidth ??30,
        padding: padding ?? EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: btnColor,
          border: Border.all(
            color: borderColor!,
            width: borderWidth ?? 2,
          ),
          shape: BoxShape.circle,
        ),
        child:
          Center(
            child: Icon(icon, color: iconColor,size: iconSize??24,),
          ),

      ),
    );
  }
}

