import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/font_family.dart';
import 'custom_text.dart';




Widget customClickableText({
  required String text,
  double? fontSize,
  Color? textColor,
  required Function()? onTap,
  String? fontFamily,
  TextAlign? textAlign,
  bool? isUnderLine,
  Widget? startSideWidget,
  Widget? endSideWidget
}) {
  return InkWell(
    onTap: onTap,
    child:
        CustomText(text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontFamily: fontFamily?? AppFontFamily.REGULAR,
          ),
          textAlign: TextAlign.start,
        ),

  );
}