
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../generated/locale_keys.g.dart';
import '../constants/app_colors.dart';

class ErrorBox extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorBox({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: const TextStyle(color: Colors.black,
          fontSize: 12)),
          const SizedBox(height: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.white,
             disabledBackgroundColor:  AppColors.amber,
             disabledForegroundColor: AppColors.amber,

            ),
            onPressed: onRetry,
            child: Text("LocaleKeys.sanad_Reload.tr()"),
          ),
        ],
      ),
    );
  }}

