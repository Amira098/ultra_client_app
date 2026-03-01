import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';


class CustomSwitcherButton extends StatefulWidget {
  Color? onBorderColor, offBorderColor, onCircleColor, offCircleColor;
  bool isOn;
  BorderRadius? borderRadius;
  double? btnWidth, diameter;
  EdgeInsets? borderPadding;
  Widget? onStateWidget, offStateWidget;
  Function(bool) onGenderSelected;

  CustomSwitcherButton(
      {this.onBorderColor,
      this.offBorderColor,
      this.onCircleColor,
      this.borderRadius,
      this.btnWidth,
      this.diameter,
      this.borderPadding,
      this.offCircleColor,
      this.onStateWidget,
      this.offStateWidget,
      required this.isOn,
      required this.onGenderSelected});

  @override
  State<CustomSwitcherButton> createState() => _CustomSwitcherButtonState();
}

class _CustomSwitcherButtonState extends State<CustomSwitcherButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.onBorderColor == null) {
      widget.onBorderColor = AppColors.amber;
    }
    if (widget.offBorderColor == null) {
      widget.offBorderColor = AppColors.paleBlue;
    }
    return InkWell(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(24),
      highlightColor: AppColors.white,
      onTap: () {
        widget.isOn = !widget.isOn;
        widget.onGenderSelected(widget.isOn);
        setState(() {});
      },
      child: Container(
        width: widget.btnWidth ?? 56,
        padding: widget.borderPadding ?? EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(24),
            border: Border.all(
              color: widget.isOn == true
                  ? widget.onBorderColor!
                  : widget.offBorderColor!,
              width: 2,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.isOn
                ? Visibility(
                    visible: widget.isOn,
                    child: Container(
                      height: widget.diameter ?? 22,
                      width: widget.diameter ?? 22,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: widget.onBorderColor),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: widget.onStateWidget ?? SizedBox(),
                  ),
            !widget.isOn
                ? Visibility(
              visible: !widget.isOn,
              child: Container(
                height: widget.diameter ?? 22,
                width: widget.diameter ?? 22,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: widget.offBorderColor),
              ),
            )
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: widget.offStateWidget ?? SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
