import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/decorations.dart';
import '../../constants/font_family.dart';
import '../../constants/font_size.dart';

class CommonTextFormField extends StatefulWidget {
  final TextAlign? align;
  final TextInputType? textInputType;
  final double? fontSize;
  final FontWeight? fontWeight;
  final int? maxLines;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? hintColor;
  final Color? inputColor;
  final FocusNode? focusNode;
  final String? hint;
  final String? initValue;
  final Function(String)? onChanged;
  final Function(String?)? onSaved;
  final String? Function(String?)? validateFunc;
  final VoidCallback? onTap;
  final Key? key;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon, suffixIcon;
  final bool? obscureText, readOnly;
  final BoxConstraints? prefixIconConstraints;
  final EdgeInsetsGeometry? contentPadding;
  final double? borderRadius;
  final double? borderWidth;
  final void Function(String)? onFieldSubmitted;

  CommonTextFormField({
    this.align,
    this.textInputType,
    this.fontSize,
    this.fontWeight,
    this.maxLines,
    this.hintColor,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.focusNode,
    this.hint,
    this.initValue,
    this.borderRadius,
    this.prefixIconConstraints,
    this.onChanged,
    this.onSaved,
    this.validateFunc,
    this.onTap,
    this.key,
    this.controller,
    this.textInputAction,
    this.prefixIcon,
    this.borderWidth,
    this.suffixIcon,
    this.obscureText,
    this.inputColor,
    this.readOnly,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    this.onFieldSubmitted, // ✅ هنا
  }) : super(key: key);

  @override
  State<CommonTextFormField> createState() => _CommonTextFormFieldState();
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {
  late final FocusNode _internalFocusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = widget.focusNode ?? FocusNode();
    _internalFocusNode.addListener(() {
      setState(() {
        _isFocused = _internalFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color resolvedBorderColor = widget.borderColor ?? AppColors.grey200;
    final Color resolvedFocusedColor = widget.focusedBorderColor ?? AppColors.amber;
    final Color resolvedErrorColor = widget.errorBorderColor ?? AppColors.red;

    return TextFormField(
      keyboardType: widget.textInputType ?? TextInputType.text,
      key: widget.key,
      initialValue: widget.controller == null ? widget.initValue : null,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      controller: widget.controller,
      focusNode: _internalFocusNode,
      textAlign: widget.align ?? TextAlign.start,
      obscureText: widget.obscureText ?? false,
      maxLines: widget.maxLines ?? 1,
      readOnly: widget.readOnly ?? false,
      style: TextStyle(
        color: widget.inputColor ?? AppColors.black,
        fontSize: widget.fontSize ?? AppSizes.BODY_TEXT3_SIZE,
        fontFamily: AppFontFamily.REGULAR,
      ),
      decoration: InputDecoration(
        contentPadding: widget.contentPadding,
        filled: true,
        fillColor: widget.fillColor ?? AppColors.white,
        hintText: widget.hint ?? "",
        hintStyle: TextStyle(
          color: widget.hintColor ?? AppColors.grey500,
          fontSize: widget.fontSize ?? AppSizes.BODY_TEXT3_SIZE,
          fontFamily: AppFontFamily.REGULAR,
        ),
        prefixIcon: widget.prefixIcon,
        prefixIconConstraints: widget.prefixIconConstraints,
        suffixIcon: widget.suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
          borderSide: BorderSide(
            color: resolvedBorderColor,
            width: widget.borderWidth ?? 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
          borderSide: BorderSide(
            color: resolvedFocusedColor,
            width: widget.borderWidth ?? 1.2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
          borderSide: BorderSide(
            color: resolvedErrorColor,
            width: widget.borderWidth ?? 1.2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
          borderSide: BorderSide(
            color: resolvedErrorColor,
            width: widget.borderWidth ?? 1.2,
          ),
        ),
      ),
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      onTap: widget.onTap,
      validator: widget.validateFunc,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}

class CommonTextFormFieldWithoutBorders extends StatefulWidget {
  TextAlign? align;
  TextInputType? textInputType;
  double? fontSize;
  FontWeight? fontWeight;
  int? maxLines;
  Color? fillColor;
  Color? borderColor;
  FocusNode? focusNode;
  String? hint;
  String? initValue;
  Function(String val) ? onChanged;
  Function(String? val) ? onSaved;
  String? Function(String? val) ? validateFunc;
  Function()? onTap;
  Key? key;
  TextEditingController? controller;
  TextInputAction? textInputAction;
  TextStyle? labelStyle;
  Widget? prefixIcon,suffixIcon;
  bool? obscureText,readOnly;
  EdgeInsetsGeometry? contentPadding;

  CommonTextFormFieldWithoutBorders({this.align, this.textInputType,
    this.fontSize, this.fontWeight, this.maxLines, this.fillColor,
    this.borderColor, this.focusNode, this.hint, this.initValue,
    this.onChanged, this.onSaved, this.validateFunc, this.onTap, this.key,
    this.controller, this.textInputAction, this.labelStyle, this.prefixIcon,
    this.suffixIcon, this.obscureText, this.readOnly, this.contentPadding}): super(key: key);

  @override
  State<CommonTextFormFieldWithoutBorders> createState() => _CommonTextFormFieldWithoutBordersState();
}

class _CommonTextFormFieldWithoutBordersState extends State<CommonTextFormFieldWithoutBorders> {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        keyboardType: widget.textInputType ?? TextInputType.text,
        key: widget.key,
        initialValue: widget.initValue,
        textInputAction: widget.textInputAction ?? TextInputAction.done,
        controller: widget.controller,
        focusNode: widget.focusNode,
        textAlign: widget.align??TextAlign.start,
        obscureText: widget.obscureText ?? false,
        maxLines: widget.maxLines ?? 1,
        readOnly: widget.readOnly ?? false,
        style: TextStyle(
            color: AppColors.grey500,
            fontSize: widget.fontSize ?? AppSizes.HEADLINE5_SIZE,
            fontFamily: AppFontFamily.REGULAR),
        decoration: textFieldDecorationWithoutAnyBorders(
          padding: widget.contentPadding ?? EdgeInsets.zero,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            fillColor: widget.fillColor ?? AppColors.white,
            hintText: widget.hint ?? "",
            labelText: widget.hint ?? "",
            hintStyle: TextStyle(
                color: AppColors.grey500,
                fontSize: widget.fontSize ?? AppSizes.HEADLINE5_SIZE,
                fontFamily: AppFontFamily.REGULAR)),
        onChanged: widget.onChanged,
        onSaved: widget.onSaved,
        onTap: widget.onTap,
        validator: widget.validateFunc
    );
  }
}