import 'package:flutter/material.dart';
import 'app_colors.dart';


RoundedRectangleBorder roundedShape = RoundedRectangleBorder(
  borderRadius: new BorderRadius.circular(30.0),
);



InputDecoration textFieldDecoration(
    {String? hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    double? borderWidth,
    double? radius,
    BoxConstraints? prefixIconConstraints,
    Color? textColor,
    Color? borderColor,
    EdgeInsetsGeometry? padding,
    Color? fillColor,
    TextStyle? hintStyle}) {
  return InputDecoration(
    prefixIconConstraints: prefixIconConstraints,
    fillColor: fillColor ?? AppColors.white,
    filled: true,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,

    hintText: hintText,
    //  labelText: labelText ?? hintText,
    hintStyle: hintStyle,
    labelStyle: hintStyle,
    contentPadding:
        padding ?? EdgeInsets.only(top: 16, bottom: 16, left: 12, right: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
      borderSide: BorderSide(
          width: borderWidth ?? 1,
          color: borderColor ?? AppColors.gray),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
      borderSide: BorderSide(
          width: borderWidth ?? 1,
          color: borderColor ?? AppColors.paleBlue),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
      borderSide: BorderSide(width: borderWidth??1, color: borderColor??AppColors.gray),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(width: borderWidth??1, color: borderColor??AppColors.gray),
    ),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius??10)),
        borderSide: BorderSide(color: Colors.red, width: borderWidth??1)),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius??10)),
        borderSide: BorderSide(
          color: Colors.red,
          width: borderWidth??1,
        )),
  );
}


InputDecoration textFieldDecorationWithoutAnyBorders(
    {String? hintText,
      String? labelText,
      Widget? prefixIcon,
      Widget? suffixIcon,
      Color? textColor,
      EdgeInsetsGeometry? padding,
      Color? fillColor,
      TextStyle? hintStyle}) {
  return InputDecoration(
    fillColor: fillColor ?? AppColors.white,
    filled: true,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    hintText: hintText,
    //  labelText: labelText ?? hintText,
    hintStyle: hintStyle,
    labelStyle: hintStyle,
    contentPadding:
    padding ?? EdgeInsets.only(top: 16, bottom: 16, left: 12, right: 12),
    border: InputBorder.none,
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1)),
  );
}


InputDecoration textFieldDecorationWithoutBorders(
    {String? hintText,
      String? labelText,
      Widget? prefixIcon,
      Widget? suffixIcon,
      double? borderWidth,
      double? radius,
      Color? textColor,
      Color? borderColor,
      Color? fillColor,
      EdgeInsetsGeometry? contentPadding,
      TextStyle? hintStyle}) {
  return InputDecoration(
    fillColor: fillColor?? AppColors.white,
    filled: true,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    hintText: hintText,
    //  labelText: labelText ?? hintText,
    hintStyle: hintStyle,
    labelStyle: hintStyle,

    focusColor: AppColors.amber,
    hoverColor: AppColors.amber,
    contentPadding: contentPadding??EdgeInsets.only(top: 16, bottom: 16, left: 12, right: 12),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(width: 2, color: borderColor??AppColors.amber),
    ),
    disabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(width: 2, color: AppColors.paleBlue),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(width: 2, color: AppColors.paleBlue),
    ),
    border: UnderlineInputBorder(
      borderSide: BorderSide(width: 2, color: AppColors.paleBlue),
    ),
    errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2)),
    focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 2,
        )),
  );
}
