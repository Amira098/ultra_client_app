import 'dart:convert';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/utils/app_shared_preference.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/show_pretty_snack.dart';
import '../../../../core/utils/utils/customTextField.dart';
import '../../../../generated/locale_keys.g.dart';
import '../view_model/contact_us_cubit/contact_us_cubit.dart';
import '../view_model/contact_us_cubit/contact_us_state.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final ContactUsCubit _cubit = serviceLocator<ContactUsCubit>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final userJson = SharedPreferencesUtils.getData(key: AppValues.user);
    if (userJson != null && userJson is String && userJson.isNotEmpty) {
      try {
        final userMap = jsonDecode(userJson);
        _nameController.text = userMap['name'] ?? '';
        _emailController.text = userMap['email'] ?? '';
        _phoneController.text = userMap['phone'] ?? '';
      } catch (e) {
        debugPrint('Error decoding user data: $e');
      }
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(LocaleKeys.Authentication_contactUs.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocProvider(
        create: (_) => _cubit,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CommonTextFormField(
                    fillColor: AppColors.white,
                    controller: _subjectController,
                    hint: LocaleKeys.Authentication_subject.tr(),
                    prefixIcon: const Icon(Icons.subject_rounded),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextFormField(
                          fillColor: AppColors.white,
                          controller: _nameController,
                          hint: LocaleKeys.Authentication_fullNameHint.tr(),
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CommonTextFormField(
                          fillColor: AppColors.white,
                          controller: _emailController,
                          hint: LocaleKeys.Authentication_emailHint.tr(),
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CommonTextFormField(
                    fillColor: AppColors.white,
                    controller: _phoneController,
                    hint: LocaleKeys.Authentication_phoneHint.tr(),
                    prefixIcon: const Icon(Icons.phone_outlined),
                  ),
                  const SizedBox(height: 12),
                  CommonTextFormField(
                    fillColor: AppColors.white,
                    controller: _messageController,
                    hint: LocaleKeys.Authentication_message.tr(),
                    maxLines: 6,
                  ),
                  const SizedBox(height: 30),
                  BlocConsumer<ContactUsCubit, ContactUsState>(
                    listener: (context, state) {
                      if (state is ContactUsSuccess) {
                        showPrettySnack(
                          context,
                          state.message.message?.en?.toString() ??
                              state.message.message?.ar?.toString() ??
                              '',
                        );

                      } else if (state is ContactUsFailure) {
                      showPrettySnack(
                      context,
                      state.error?.message?.toString() ??
                      state.exception?.toString() ??
                      LocaleKeys.Error_somethingWentWrong.tr(),
                      success: false,
                      );
                      }
                    },
                      builder: (context, state) {
                        final isLoading = state is ContactUsLoading;

                        return CustomButton(
                          btnColor: AppColors.amber,
                          btnWidth: double.infinity,
                          text: isLoading
                              ? ""
                              : LocaleKeys.Authentication_send.tr(),
                          onTap: isLoading
                              ? null
                              : () {
                            if (formKey.currentState!.validate()) {
                              _cubit.contactUs(
                                subject: _subjectController.text,
                                name: _nameController.text,
                                email: _emailController.text,
                                phoneNumber: _phoneController.text,
                                message: _messageController.text,
                              );

                            }
                          },

                        );
                      }

                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
