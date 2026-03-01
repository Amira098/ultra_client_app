import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/dialogs/app_dialogs.dart';
import '../../../../core/utils/utils/custom_icon_button.dart';
import '../../../../generated/locale_keys.g.dart';
import '../view_model/privacy/privacy_cubit.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}
class _PrivacyScreenState extends State<PrivacyScreen> {
  final PrivacyCubit privacyCubit = serviceLocator<PrivacyCubit>();

  @override
  void initState() {
    super.initState();
    privacyCubit.getPrivacyPolicy();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => privacyCubit,
      child: Scaffold(
        appBar: AppBar(
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
          title: Text(LocaleKeys.ultra_PrivacyPolicy.tr()),
        ),
        body: BlocListener<PrivacyCubit, PrivacyState>(
          listener: (context, state) {
            if (state is PrivacyFailure) {
              AppDialogs.showFailureDialog(context, message: state.message);
            } else if (state is PrivacySuccess) {
              debugPrint('تم تحميل سياسة الخصوصية بنجاح');
            }
          },
          child: BlocBuilder<PrivacyCubit, PrivacyState>(
            builder: (context, state) {
              if (state is PrivacyLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PrivacySuccess) {
                return Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Html(
                          data: _getLocalizedPrivacyName(state),
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
                          data: _getLocalizedPrivacyText(state),
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
              } else if (state is PrivacyFailure) {
                return Center(
                  child: Text(
                    LocaleKeys.Authentication_privacyError.tr(),
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  String _getLocalizedPrivacyText(PrivacySuccess state) {
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

  String _getLocalizedPrivacyName(PrivacySuccess state) {
    final lang = context.locale.languageCode;
    final name = state.data.data?.name;
    final message = state.data.message;

    switch (lang) {
      case 'ar':
        return name?.ar ??
            message?.ar ??
            LocaleKeys.ultra_PrivacyPolicy.tr();
      case 'en':
        return name?.en ?? message?.en ?? LocaleKeys.ultra_PrivacyPolicy.tr();
      case 'it':
        return message?.it ?? LocaleKeys.ultra_PrivacyPolicy.tr();
      default:
        return name?.en ?? LocaleKeys.ultra_PrivacyPolicy.tr();
    }
  }



}