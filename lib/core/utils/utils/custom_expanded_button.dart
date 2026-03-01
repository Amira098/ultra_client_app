import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/font_family.dart';
import '../../constants/font_size.dart';
import '../custom_text.dart';

class CustomExpandedButton extends StatefulWidget {
  String text;
  bool isExpanded;
  bool startWithIcon;

  CustomExpandedButton(
      {required this.text,
      required this.isExpanded,
      required this.startWithIcon});

  @override
  State<CustomExpandedButton> createState() => _CustomExpandedButtonState();
}

class _CustomExpandedButtonState extends State<CustomExpandedButton> {
  @override
  Widget build(BuildContext context) {
    return widget.startWithIcon == true
        ? Container(
            width: 105,
            height: 40,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: widget.isExpanded == false
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: AppColors.paleBlue)
                : BoxDecoration(
                    border: Border.all(
                      color: AppColors.paleBlue,
                    ),
                    borderRadius: BorderRadius.circular(35),
                  ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.isExpanded == false
                    ? Icon(
                        Icons.arrow_downward,
                        size: 15,
                        color: AppColors.black,
                      )
                    : Icon(
                        Icons.arrow_upward,
                        size: 15,
                        color: AppColors.black,
                      ),
                CustomText(widget.text,
                    style: TextStyle(
                        fontSize: AppSizes.HEADLINE3_SIZE,
                        fontFamily: AppFontFamily.BOLD,
                        color: AppColors.black)),
              ],
            ),
          )
        : Container(
            width: 120,
            height: 38,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.paleBlue,
              ),
              borderRadius: BorderRadius.circular(35),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.text,
                    style: TextStyle(
                        fontSize: AppSizes.HEADLINE3_SIZE,
                        fontFamily: AppFontFamily.BOLD,
                        color: AppColors.amber)),
                widget.isExpanded == false
                    ? Icon(
                        Icons.arrow_downward,
                        size: 15,
                        color: AppColors.amber,
                      )
                    : Icon(
                        Icons.arrow_upward,
                        size: 15,
                        color: AppColors.amber,
                      ),
              ],
            ),
          );
  }
}
