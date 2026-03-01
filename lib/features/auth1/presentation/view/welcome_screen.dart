
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/font_family.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../home_screen/presentation/view/map_screen.dart';



class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 1),
            Image.asset(
              "assets/images/Welcome Screen.png",
              width: 300,
              height: 300,
            ),
            const SizedBox(height: 24),
            CustomText(
            LocaleKeys.Authentication_welcome.tr(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.black.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            CustomText(
             LocaleKeys.Authentication_betterSharingExperience.tr(),
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey700,
              ),
            ),
            const Spacer(flex: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: CustomButton(
                borderRadius: 8,
                btnWidth: double.infinity,
                text: LocaleKeys.Home_Next.tr(),
                btnColor: AppColors.amber,
                textColor: AppColors.white,
                fontSize: 16,
                fontFamily: AppFontFamily.BOLD,
                onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => const MapScreen()));
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
