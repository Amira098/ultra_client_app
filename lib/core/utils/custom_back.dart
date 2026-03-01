import 'dart:io' show Platform;
import 'package:flutter/material.dart';


import '../constants/app_colors.dart';

class CustomBack extends StatelessWidget {
  final Color? color,backgroundColor;
  final VoidCallback? onBackClicked;
  final EdgeInsetsGeometry? padding;
  final BoxShape? shape;
  final double? iconSize;

  const CustomBack({this.color, this.padding,this.onBackClicked,this.backgroundColor,this.shape,this.iconSize});
  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
            Future.delayed(Duration(milliseconds: 500), () {
              if(onBackClicked != null)
                onBackClicked!();
              else
                Navigator.of(context).pop();
            });

          },
          child:  Container(
            padding: padding?? EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: AppColors.lightGray),
              shape: shape ?? BoxShape.rectangle,
            ),
            child: Center(
              child: Icon(Platform.isAndroid ?
              //  ? Localizations.localeOf(context).languageCode == 'ar' ? Icons.arrow_forward_outlined :
              Icons.arrow_back_outlined :
              //   : Localizations.localeOf(context).languageCode == 'ar' ? Icons.arrow_forward_ios_outlined :
              Icons.arrow_back_ios_outlined, color: color ?? AppColors. white,size: 24,),
            ),
          ),
        ),
      ],
    );
  }
}
