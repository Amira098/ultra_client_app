import 'package:flutter/material.dart';



import 'app_colors.dart';
import 'font_family.dart' show AppFontFamily;
import 'font_size.dart';

TextStyle BLACK_STYLE = TextStyle(
    fontSize: 16, color: AppColors.black, fontFamily: 'Arabic-Regular');
TextStyle WHITE_STYLE = TextStyle(
    fontSize: 25, color: AppColors.white, fontWeight: FontWeight.bold);
TextStyle TEXT_FIELD_STYLE = TextStyle(
    fontSize: 16, color: AppColors.black, fontWeight: FontWeight.bold);
TextStyle CARD_BLACK_TEXT_STYLE = TextStyle(
    color: AppColors.black,
    fontSize: AppSizes.HEADLINE3_SIZE,
    fontFamily: AppFontFamily.MEDIUM);
TextStyle CARD_GREY_TEXT_STYLE = TextStyle(
    color: AppColors.gray,
    fontSize: AppSizes.HEADLINE4_SIZE,
    fontFamily: AppFontFamily.LIGHT);

// TextStyle  SCREEN_TITLE_STYLE = TextStyle(fontSize: SIZE19, color:  AppColors.BLACK_COLOR ,fontFamily: REGULAR);