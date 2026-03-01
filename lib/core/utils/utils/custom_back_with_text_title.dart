import 'dart:io' show Platform;
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/font_family.dart';
import '../../constants/font_size.dart';
import 'custom_text.dart';

class CustomBackWithTextTitle extends StatelessWidget {

  final Color? iconColor;
  final Color? backGroundColor;
  final String title;
  final bool alignCenter;

  const CustomBackWithTextTitle({this.iconColor,this.backGroundColor, required this.title, this.alignCenter = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backGroundColor ?? Colors.transparent,
      padding: EdgeInsets.only(right: 16, bottom: 16, left: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Icon(Platform.isAndroid ?
                //  ? Localizations.localeOf(context).languageCode == 'ar' ? Icons.arrow_forward_outlined :
              Icons.arrow_back_ios_outlined :
               //   : Localizations.localeOf(context).languageCode == 'ar' ? Icons.arrow_forward_ios_outlined :
              Icons.arrow_back_ios_outlined, color: iconColor ?? AppColors.black,size: 30,),
            ),
          ),
       if(!alignCenter)
         SizedBox(width: 32,),

          Expanded(
            child: CustomText(
                title,
                textAlign: alignCenter ? TextAlign.center : TextAlign.start,
                style: TextStyle(
                    color: iconColor ??AppColors.black,
                    fontSize: AppSizes.SUBTITLE2_SIZE,
                    fontFamily: AppFontFamily.REGULAR )),
          ),
          if(alignCenter)
            SizedBox(width: 30,),
        ],
      ),
    );
  }
}
