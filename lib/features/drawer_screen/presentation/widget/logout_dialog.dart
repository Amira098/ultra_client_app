import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/app_shared_preference.dart';
import '../../../../generated/locale_keys.g.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.logout,
            color: AppColors.amber,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            LocaleKeys.Authentication_logoutConfirm.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.grey700,
            ),
          ),
        ],
      ),

      actions: [
        // Cancel
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.amber),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text(
            LocaleKeys.ultra_Cancel.tr(),
            style: const TextStyle(
              color: AppColors.amber,
              fontSize: 14,
            ),
          ),
        ),

        // Logout
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.amber,
          ),
          onPressed: () async {
            await Future.wait([
              SharedPreferencesUtils.removeData(key: 'token'),
              SharedPreferencesUtils.removeData(key: 'user'),
              SharedPreferencesUtils.removeData(key: 'user_id'),
              SharedPreferencesUtils.removeData(key: 'user_name'),
              SharedPreferencesUtils.removeData(key: 'user_phone'),

            ]);
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.onboardingScreen,
                  (route) => false,
            );
          },
          child: Text(
            LocaleKeys.profile_Logout.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
