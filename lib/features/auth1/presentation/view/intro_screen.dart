
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ultra_client/features/auth1/presentation/view/sign_in_sheet.dart';
import 'package:ultra_client/generated/locale_keys.g.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/custom_button.dart';


class IntroScreen extends StatelessWidget {
  static final routeName = '/introScreen';
  const IntroScreen({super.key});

  void _showSheet(BuildContext context, Widget sheet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => sheet,
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.asset(
            "assets/images/splash.png",
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          SafeArea(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                  color: AppColors.primary),
              height: 44,
              width: 200,
              child: CustomButton(
                btnColor: AppColors.primary,
                borderRadius: 44,
                onTap: () => _showSheet(context, const SignInSheet()),
            
                text:  LocaleKeys.SPLASH_GetStartedWithUltra.tr(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}