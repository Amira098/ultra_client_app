import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/dialogs/app_dialogs.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/utils/custom_icon_button.dart';
import '../../../../generated/locale_keys.g.dart';
import '../view_model/terms-and-conditions/terms_and_conditions_cubit.dart';
import '../view_model/terms-and-conditions/terms_and_conditions_state.dart';

class InstructionScreen extends StatefulWidget {
  const InstructionScreen({super.key});

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  final TermsAndConditionsCubit cubit = serviceLocator<
      TermsAndConditionsCubit>();

  @override
  void initState() {
    super.initState();
    cubit.gettermsAndConditions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocListener<TermsAndConditionsCubit, TermsAndConditionsState>(
        listener: (context, state) {

          if (state is TermsAndConditionsFailure) {
            AppDialogs.showFailureDialog(context, message: state.message);
          } else if (state is TermsAndConditionsSuccess) {
            debugPrint('تم تحميل سياسة الخصوصية بنجاح');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.white,
            title: CustomText(
              LocaleKeys.profile_TermsConditions.tr(),
              style: TextStyle(
                color: AppColors.amber,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: CustomIconButton(
                btnColor: AppColors.transparent,
                onTap:() {
                  Navigator.pop(context);

                },
                icon: Icons.arrow_back_ios,
                iconColor: AppColors.amber,
              ),
            ),

          ),
          body: BlocBuilder<TermsAndConditionsCubit, TermsAndConditionsState>(
        builder: (context, state) {
          if (state is TermsAndConditionsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TermsAndConditionsSuccess) {
            return Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Html(
                      data: _getLocalizedTermsName(state),
                      style: {
                        'body': Style(
                          color: AppColors.black,
                          fontSize: FontSize(22),
                          fontWeight: FontWeight.bold,
                        ),
                      },
                    ),
                    const SizedBox(height: 8),
                    Html(
                      data: _getLocalizedTermsText(state),
                      style: {
                        'body': Style(
                          color: AppColors.black,
                          fontSize: FontSize(14),
                          fontWeight: FontWeight.normal,
                        ),
                      },
                    ),

                  ],
                ),
              ),
            );
          } else if (state is TermsAndConditionsFailure) {
            return Center(
              child: Text(
                LocaleKeys.Authentication_termsError.tr(),
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
        ),
      ),
      )
    );
  }


  String _getLocalizedTermsText(TermsAndConditionsSuccess state) {
    final lang = context.locale.languageCode;
    final body = state.data.data?.body;
    final message = state.data.message;

    switch (lang) {
      case 'ar':
        return body?.ar ??
            message?.ar ??
            LocaleKeys.Authentication_noContent.tr();
      case 'en':
        return body?.en ??
            message?.en ??
            LocaleKeys.Authentication_noContent.tr();
      case 'it':
        return message?.it ?? LocaleKeys.Authentication_noContent.tr();
      default:
        return body?.en ?? '';
    }
  }

  String _getLocalizedTermsName(TermsAndConditionsSuccess state) {
    final lang = context.locale.languageCode;
    final name = state.data.data?.name;
    final message = state.data.message;

    switch (lang) {
      case 'ar':
        return name?.ar ??
            message?.ar ??
            LocaleKeys.profile_TermsConditions.tr();
      case 'en':
        return name?.en ??
            message?.en ??
            LocaleKeys.profile_TermsConditions.tr();
      case 'it':
        return message?.it ?? LocaleKeys.profile_TermsConditions.tr();
      default:
        return name?.en ?? LocaleKeys.profile_TermsConditions.tr();
    }
  }


}

