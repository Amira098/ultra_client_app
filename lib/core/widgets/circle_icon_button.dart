import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final Color backgroundColor;
  final Color iconColor;
  final BoxShadow? shadow;
  final VoidCallback? onTap;

  const CircleIconButton({
    Key? key,
    required this.icon,
    this.size = 44,
    this.iconSize = 24,
    this.backgroundColor = AppColors.amber,
    this.iconColor = Colors.white,
    this.shadow,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color:AppColors.amber.withOpacity(0.8),
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
          child: Icon(icon, size: iconSize, color: iconColor),
        ),
      ),
    );
  }
}
