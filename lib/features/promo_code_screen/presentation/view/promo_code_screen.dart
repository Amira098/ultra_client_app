import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/utils/custom_icon_button.dart';
import '../../../../generated/locale_keys.g.dart';


class PromocodeScreen extends StatelessWidget {
  const PromocodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final promoCodes = [
      {
        'code': 'SAVE20',
        'description': LocaleKeys.Authentication_save20Description.tr(),
        'validity':
        LocaleKeys.Authentication_validUntil.tr(args: ['31 يوليو 2025']),
      },
      {
        'code': 'FREESHIP',
        'description': LocaleKeys.Authentication_freeShipDescription.tr(),
        'validity':
        LocaleKeys.Authentication_validUntil.tr(args: ['15 أغسطس 2025']),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: CustomText(
          LocaleKeys.Authentication_promoCodes.tr(),
          style: TextStyle(
            color: AppColors.amber,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal:18),
          child: CustomIconButton(btnColor:AppColors.transparent,
            onTap: (){
              Navigator.pop(context);
            }, icon:  Icons.arrow_back_ios, iconColor: AppColors.amber,),
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: promoCodes.length,
          itemBuilder: (context, index) {
            final promo = promoCodes[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:AppColors.amber[10],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color:AppColors.black.withOpacity(0.6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    promo['code']!,
                    style:  TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomText(promo['description']!),
                  const SizedBox(height: 4),
                  CustomText(
                    promo['validity']!,
                    style: TextStyle(fontSize: 12, color: AppColors.grey500),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
