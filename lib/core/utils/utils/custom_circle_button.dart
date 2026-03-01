import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'custom_progress_indicator.dart';
import 'custom_text.dart';

class CustomCircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
   Color? btnColor, textColor, borderColor;
  final double? btnWidth, borderWidth;
  final bool showLoading;
  final EdgeInsets? padding;


  CustomCircleButton({ required this.onTap, this.btnColor, this.textColor, required this.text,this.borderColor,this.borderWidth,this.btnWidth, this.showLoading = false, this.padding});

  @override
  Widget build(BuildContext context) {
    if(btnColor == null)
      btnColor = AppColors.amber;
    if(textColor == null)
      textColor = AppColors.white;
    if(borderColor == null)
      borderColor = btnColor;
    return GestureDetector(
      onTap: !showLoading ? onTap : null,
      child: Container(
        width: btnWidth == null ? double.infinity : btnWidth,
        padding: padding ?? EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
            color: btnColor,

            border: Border.all(width: borderWidth == null ? 1: borderWidth!, color: borderColor!)),
        child: Center(
          child: showLoading ?
          SizedBox(child: circularProgressIndicator, width: 24, height: 24,)
          :
         Icon(Icons.keyboard_arrow_right_outlined,
           size: 32,
           color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
