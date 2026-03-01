
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/font_family.dart';
import '../../../../core/constants/font_size.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_text.dart';


class AuthContainer extends StatelessWidget {
  final double initialSize;
  final double minChildSize;
  final double maxChildSize;
  final Widget Function(ScrollController controller) controllerBuilder;

  const AuthContainer({
    required this.initialSize,
    required this.controllerBuilder,
    required this.maxChildSize,
    required this.minChildSize,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: initialSize,
      maxChildSize: maxChildSize,
      minChildSize:minChildSize,

      builder: (_, controller) => controllerBuilder(controller),
    );
  }
}

class AuthContent extends StatelessWidget {
  final ScrollController controller;
  final String title;
  final List<Widget> fields;
  final String buttonText;
  final String footerText;
  final String footerAction;
  final VoidCallback onFooterTap;
  final VoidCallback onSubmit;
   bool isLoading = false;

   AuthContent({super.key,
    required this.isLoading,
    required this.controller,
    required this.title,
    required this.fields,
    required this.buttonText,
    required this.footerText,
    required this.footerAction,
    required this.onFooterTap,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color:AppColors.grey300,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                children: [

                  CustomText(title.tr(),
                      textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight:  FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black,

                    ),
                      ),
                  const SizedBox(height: 24),
                  ...fields.map((field) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: field,
                  )),
                  const SizedBox(height: 8),
                  CustomButton(
                      showLoading : isLoading,
                      btnColor: AppColors.amber,
                      onTap: onSubmit, text: buttonText, btnWidth: double.infinity,),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(footerText.tr(), style:TextStyle(
                            fontSize: AppSizes.BODY_TEXT3_SIZE ,
                            color:AppColors.grey500 ) ),
                        GestureDetector(
                          onTap: onFooterTap,
                          child: CustomText(
                            footerAction.tr(),
                            style:TextStyle(
                              fontSize: AppSizes.BODY_TEXT2_SIZE ,
                              color: AppColors.amber
                            )
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
