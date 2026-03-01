
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ultra_client/features/auth1/presentation/view/welcome_screen.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/font_family.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../generated/locale_keys.g.dart';


class VerifiedDone extends StatelessWidget {
  const VerifiedDone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          const Spacer(flex: 2),
          Lottie.asset(
            LottieAsset.checkmark,
            width: 120,
            height: 120,
            repeat: false,
          ),
          const SizedBox(height: 24),
          CustomText(
            LocaleKeys.Authentication_thankYou.tr(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.black.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          CustomText(
           LocaleKeys.Authentication_verificationComplete.tr(),
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey600,
            ),
          ),
          const Spacer(flex: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: CustomButton(
              borderRadius: 8,
              btnWidth: double.infinity,
              text:LocaleKeys.Home_Next.tr(),
              btnColor: AppColors.amber,
              textColor: AppColors.white,
              fontSize: 16,
              fontFamily: AppFontFamily.BOLD,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()));
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
}}
