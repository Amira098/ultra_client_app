import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class LoadingCircleIconButton extends StatelessWidget {
  final double size;
  final double iconSize;
  final Color backgroundColor;
  final Color iconColor;
  final BoxShadow? shadow;
  final VoidCallback? onTap;

  const LoadingCircleIconButton({
    Key? key,
    this.size = 44,
    this.iconSize = 24,
    this.backgroundColor = AppColors.amber,
    this.iconColor = Colors.white,
    this.shadow,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.amber.withOpacity(0.8),
        shape: BoxShape.circle,
        boxShadow: shadow != null
            ? [shadow!]
            : const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
      ),
      child: Center(
        child: SizedBox(
          width: iconSize,
          height: iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(iconColor),
          ),
        ),
      ),
    );
  }
}
