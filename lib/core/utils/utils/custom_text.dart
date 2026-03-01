import 'package:flutter/material.dart';
class CustomText extends StatelessWidget {
  final String content;
  final TextStyle? style;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final int? maxLines;


  CustomText(this.content, {this.style, this.overflow, this.maxLines, this.textAlign = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return Text(content, textAlign: textAlign, style: style,overflow: overflow,textScaleFactor: 1.0, maxLines: maxLines,);
  }
}