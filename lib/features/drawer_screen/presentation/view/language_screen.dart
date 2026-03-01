

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/utils/custom_icon_button.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../home_screen/presentation/view/map_screen.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: CustomIconButton(
            btnColor: AppColors.transparent,
            onTap: () => Navigator.pop(context),
            icon: Icons.arrow_back_ios,
            iconColor: AppColors.amber,
          ),
        ),
        title: Text(
          LocaleKeys.profile_changeLanguage.tr(),
          style: const TextStyle(color: AppColors.amber),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),

          _buildLanguageTile(
            language: LocaleKeys.profile_English.tr(),
            locale: const Locale('en'),
            isSelected: currentLocale.languageCode == 'en',
            flag: "🇺🇸",
          ),

          _buildLanguageTile(
            language: LocaleKeys.profile_Arabic.tr(),
            locale: const Locale('ar'),
            isSelected: currentLocale.languageCode == 'ar',
            flag: "🇸🇦",
          ),

          _buildLanguageTile(
            language: LocaleKeys.Authentication_italian.tr(),
            locale: const Locale('it'),
            isSelected: currentLocale.languageCode == 'it',
            flag: "🇮🇹",
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MapScreen(),
                    ),
                  );
                },
                child: Text(LocaleKeys.Authentication_save.tr()),
              ),
            ),
          ),

          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget _buildLanguageTile({
    required String language,
    required Locale locale,
    required bool isSelected,
    required String flag,
  }) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 28)),
      title: Text(language),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Colors.amber)
          : const Icon(Icons.circle_outlined, color: Colors.grey),
      onTap: () async {
        await context.setLocale(locale);
        setState(() {});
      },
    );
  }
}
