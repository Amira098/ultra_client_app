import 'dart:io' show Platform;
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';


class CustomBack extends StatelessWidget {
  final Color? color;
  final VoidCallback? onBackClicked;
  final EdgeInsetsGeometry? padding;
  const CustomBack({this.color, this.padding,this.onBackClicked});

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        GestureDetector(
          onTap: (){
            if(onBackClicked != null)
              onBackClicked!();
              else
              Navigator.of(context).pop();
          },
          child:  Container(
            padding: padding?? EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Icon(Platform.isAndroid ?
            //  ? Localizations.localeOf(context).languageCode == 'ar' ? Icons.arrow_forward_outlined :
            Icons.arrow_back_outlined :
            //   : Localizations.localeOf(context).languageCode == 'ar' ? Icons.arrow_forward_ios_outlined :
            Icons.arrow_back_ios_outlined, color: color ?? AppColors.black,size: 30,),
          ),
        ),
      ],
    );
  }
}
