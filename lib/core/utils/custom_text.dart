import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class CustomText extends StatelessWidget {
  final String content;
  final TextStyle? style;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final int? maxLines;

  const CustomText(
      this.content, {
        Key? key,
        this.style,
        this.overflow,
        this.maxLines,
        this.textAlign = TextAlign.start,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      textAlign: textAlign,
      style: style ?? Theme.of(context).textTheme.bodySmall,
      overflow: overflow,
      textScaleFactor: 1.0,
      maxLines: maxLines,
    );
  }
}
