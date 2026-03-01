import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomSnackBar extends StatelessWidget {
  final String message;

  const CustomSnackBar({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnackBar(content: Text(message,
    style: const TextStyle(color: AppColors.white),),
   backgroundColor: AppColors.amber,
    
    duration: const Duration(seconds: 2),
    );
   
  }
}
