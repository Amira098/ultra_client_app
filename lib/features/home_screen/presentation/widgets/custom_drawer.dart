import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../drawer_screen/presentation/view/contact_us_form.dart';
import '../../../drawer_screen/presentation/view/instruction_screen.dart';
import '../../../drawer_screen/presentation/view/language_screen.dart';
import '../../../drawer_screen/presentation/view/privacy_screen.dart';
import '../../../drawer_screen/presentation/view/delete_confirm_dialog.dart';
import '../../../drawer_screen/presentation/widget/logout_dialog.dart';
import '../../../drawer_screen/presentation/view/history_screen.dart';

class CustomDrawer extends StatelessWidget {
  final String userName;
  final String email;
  final String avatarUrl;

  const CustomDrawer({
    super.key,
    required this.userName,
    required this.email,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(80),
          bottomRight: Radius.circular(80),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 38),
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.grey200,
                backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                    ? NetworkImage(avatarUrl)
                    : null,
                child: (avatarUrl == null || avatarUrl.isEmpty)
                    ? Icon(Icons.person, size: 38,color: AppColors.amber,)
                    : null,
              ),

              const SizedBox(height: 8),
              CustomText(userName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              CustomText(email,
                  style: TextStyle(color: AppColors.grey600, fontSize: 14)),
              //const Divider(),
              const SizedBox(height: 30),
              DrawerItem(
                icon: Icons.history,
                text: LocaleKeys.Authentication_rideHistory.tr(),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HistoryScreen())),
              ),
              // DrawerItem(icon: Icons.card_giftcard, text: 'Promocode',onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PromocodeScreen()))),
              DrawerItem(
                  icon: Icons.language,
                  text: LocaleKeys.profile_Language.tr(),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeLanguageScreen()))),
              DrawerItem(
                icon: Icons.lock_outline,
                text: LocaleKeys.ultra_PrivacyPolicy.tr(),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyScreen()),
                ),
              ),
              DrawerItem(
                icon: Icons.contact_support,
                text: LocaleKeys.Authentication_contactUs.tr(),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactUsScreen()),
                ),
              ),
              DrawerItem(
                  icon: Icons.info_outline,
                  text: LocaleKeys.Authentication_instructions.tr(),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InstructionScreen()))),
              DrawerItem(
                  icon: Icons.delete_forever_outlined,
                  text: LocaleKeys.Authentication_deleteAccount.tr(),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeleteConfirmDialog()))),

              const Spacer(),
              const Divider(),
              InkWell(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: false,
                      barrierLabel: '',
                      barrierColor: Colors.black.withOpacity(0.5),
                      pageBuilder: (_, __, ___) {
                        return const LogoutDialog();
                      },
                      transitionBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: CurvedAnimation(
                                parent: animation, curve: Curves.easeOutBack),
                            child: child,
                          ),
                        );
                      },
                    );
                  },
                  child: DrawerItem(
                      icon: Icons.logout,
                      text: LocaleKeys.profile_Logout.tr())),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.amber),
      title: CustomText(
        text,
        style: const TextStyle(fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}
