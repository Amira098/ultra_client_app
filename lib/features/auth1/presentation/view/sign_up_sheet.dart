import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_field/intl_phone_number_field.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/font_size.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/utils/show_pretty_snack.dart';
import '../../../../core/utils/utils/customTextField.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../home_screen/presentation/view/map_screen.dart';
import '../../data/models/login_model.dart';
import '../view_model/register/register_cubit.dart';
import '../view_model/register/register_state.dart';
import 'auth_container_widget.dart';
import 'sign_in_sheet.dart';


class SignUpSheet extends StatefulWidget {
  const SignUpSheet({super.key});

  @override
  State<SignUpSheet> createState() => _SignUpSheetState();
}

class _SignUpSheetState extends State<SignUpSheet> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final CountryCodeModel _initialCountry =
  CountryCodeModel(name: "Itaiy", dial_code: "+39", code: "IT");

  IntPhoneNumber _phoneNumber =
  IntPhoneNumber(code: "IT", dial_code: '+39', number: '');

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  bool _nameValid = true;
  bool _emailValid = true;
  bool _phoneValid = true;
  bool _passwordValid = true;
  bool _confirmPasswordValid = true;

  final RegisterCubit _registerCubit = serviceLocator<RegisterCubit>();

  @override
  void dispose() {
    nameController.dispose();
    _phoneController.dispose();
    emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _navigateToSignIn() {
    Navigator.pop(context);
    Future.delayed(const Duration(milliseconds: 120), () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const SignInSheet(),
      );
    });
  }

  bool _simpleEmail(String v) {
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return re.hasMatch(v);
  }

  bool _simplePassword(String v) => v.length >= 6;

  // استخراج رسالة بشكل مرن من أي نوع
  String? _extractMsg(dynamic raw) {
    if (raw == null) return null;
    if (raw is String) return raw.trim();
    if (raw is Map) {
      final ar = raw['ar']?.toString();
      final en = raw['en']?.toString();
      if (ar != null && ar.trim().isNotEmpty) return ar;
      if (en != null && en.trim().isNotEmpty) return en;
      // أول قيمة متاحة
      if (raw.values.isNotEmpty) {
        final first = raw.values.first;
        if (first != null) return first.toString();
      }
    }
    return raw.toString();
  }

  void _submitWithCubit(BuildContext context) {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final phone = _phoneNumber.number.trim();
    final dial = _phoneNumber.dial_code;

    setState(() {
      _nameValid = name.isNotEmpty;
      _emailValid = _simpleEmail(email);
      _phoneValid = phone.isNotEmpty;
      _passwordValid = _simplePassword(password);
      _confirmPasswordValid =
          confirmPassword == password && confirmPassword.isNotEmpty;
    });

    if (!_nameValid ||
        !_emailValid ||
        !_phoneValid ||
        !_passwordValid ||
        !_confirmPasswordValid) {
      return;
    }

    final formData = FormData.fromMap({
      'name': name,
      'email': email,
      'phone': phone,
      'country_code': dial,
      'password': password,
      'password_confirmation': confirmPassword,
    });

    context.read<RegisterCubit>().register(formData: formData);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _registerCubit,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) async {
            FocusScope.of(context).unfocus();
            final messenger = ScaffoldMessenger.of(context);
            messenger.clearSnackBars();
           if (state is RegisterFailure) {
             final currentLang = context.locale.languageCode;

             String errorText = LocaleKeys.Error_somethingWentWrong.tr();

             if (state.apiError != null) {

               final msgMap = state.apiError!.message;
               if (msgMap != null) {
                 errorText = msgMap[currentLang] ??
                     msgMap["en"] ??
                     msgMap["ar"] ??
                     msgMap["it"] ??
                     errorText;
               }
             }

             await showErrorDialog(errorText, context);
            }

            if (state is RegisterSuccess) {
              showPrettySnack(
                context,
                getMessageByLocale(
                  state.registerModel.message?.ar,
                  state.registerModel.message?.en,
                  state.registerModel.message?.it,
                  context,
                ),
              );

              if (Navigator.of(context).canPop()) {
                Navigator.of(context, rootNavigator: true).pop();
              }
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MapScreen()),
              );

            }
          },
          builder: (context, state) {
            final isLoading = state is RegisterLoading;

            return AuthContainer(
              initialSize: 0.65,
              maxChildSize: 0.65,
              minChildSize: 0.65,
              controllerBuilder: (controller) => AuthContent(
                controller: controller,
                title: LocaleKeys.Authentication_signUpTitle.tr(),
                fields: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Full name
                        CommonTextFormField(
                          controller: nameController,
                          hint: LocaleKeys.Authentication_fullNameHint.tr(),
                          fillColor: _nameValid
                              ? AppColors.grey200
                              : AppColors.red.withOpacity(0.08),
                          borderColor:
                          _nameValid ? AppColors.transparent : AppColors.red,
                          validateFunc: (_) => null,
                          suffixIcon: Icon(Icons.person, color: AppColors.grey500),
                        ),
                        const SizedBox(height: 12),

                        // Phone
                        Container(
                          decoration: BoxDecoration(
                            color: _phoneValid
                                ? AppColors.grey200
                                : AppColors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _phoneValid
                                  ? AppColors.transparent
                                  : AppColors.red,
                              width: 1,
                            ),
                          ),
                          child: InternationalPhoneNumberInput(
                            controller: _phoneController,
                            height: 50,
                            onInputChanged: (number) => _phoneNumber = number,
                            initCountry: _initialCountry,
                            betweenPadding: 8,
                            phoneConfig: PhoneConfig(
                              showCursor: true,
                              focusedColor: Colors.transparent,
                              enabledColor: Colors.transparent,
                              errorColor: AppColors.red,
                              radius: 8,
                              hintText: LocaleKeys.Authentication_phoneHint.tr(),
                              borderWidth: 0,
                              backgroundColor: Colors.transparent,
                              textInputAction: TextInputAction.next,
                              textStyle: TextStyle(
                                color: AppColors.black,
                                fontSize: AppSizes.BODY_TEXT4_SIZE,
                              ),
                              hintStyle: TextStyle(
                                color: AppColors.grey500,
                                fontSize: AppSizes.BODY_TEXT4_SIZE,
                              ),
                            ),
                            dialogConfig: DialogConfig(
                              backgroundColor: AppColors.white,
                              searchBoxBackgroundColor: AppColors.grey200,
                              searchBoxIconColor:
                              AppColors.black.withOpacity(0.5),
                              countryItemHeight: 50,
                              topBarColor: AppColors.grey200,
                              selectedItemColor: AppColors.grey200,
                              textStyle: TextStyle(
                                color: AppColors.black,
                                fontSize: AppSizes.BODY_TEXT3_SIZE,
                              ),
                              searchBoxTextStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              titleStyle: TextStyle(
                                color: AppColors.black,
                                fontSize: AppSizes.BODY_TEXT2_SIZE,
                              ),
                              searchBoxHintStyle: TextStyle(
                                color: AppColors.black.withOpacity(0.5),
                                fontSize: AppSizes.BODY_TEXT3_SIZE,
                              ),
                            ),
                            countryConfig: CountryConfig(
                              noFlag: false,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              flagSize: AppSizes.BODY_TEXT4_SIZE,
                              textStyle: TextStyle(
                                color: AppColors.black,
                                fontSize: AppSizes.BODY_TEXT4_SIZE,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Email
                        CommonTextFormField(
                          controller: emailController,
                          hint: LocaleKeys.Authentication_emailHint.tr(),
                          fillColor: _emailValid
                              ? AppColors.grey200
                              : AppColors.red.withOpacity(0.08),
                          borderColor:
                          _emailValid ? AppColors.transparent : AppColors.red,
                          validateFunc: (_) => null,
                          suffixIcon:
                          Icon(Icons.email_outlined, color: AppColors.grey500),
                        ),
                        const SizedBox(height: 12),

                        // Password
                        CommonTextFormField(
                          controller: _passwordController,
                          hint: LocaleKeys.Authentication_passwordHint.tr(),
                          obscureText: !_passwordVisible,
                          fillColor: _passwordValid
                              ? AppColors.grey200
                              : AppColors.red.withOpacity(0.08),
                          borderColor:
                          _passwordValid ? AppColors.transparent : AppColors.red,
                          validateFunc: (_) => null,
                          suffixIcon: InkWell(
                            onTap: () =>
                                setState(() => _passwordVisible = !_passwordVisible),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Icon(
                                _passwordVisible
                                    ? Icons.lock_open_rounded
                                    : Icons.lock_outline_rounded,
                                size: 18,
                                color: _passwordVisible
                                    ? AppColors.black
                                    : AppColors.grey500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Confirm Password
                        CommonTextFormField(
                          controller: _confirmPasswordController,
                          hint: LocaleKeys.Authentication_confirmPasswordHint.tr(),
                          obscureText: !_confirmPasswordVisible,
                          fillColor: _confirmPasswordValid
                              ? AppColors.grey200
                              : AppColors.red.withOpacity(0.08),
                          borderColor: _confirmPasswordValid
                              ? AppColors.transparent
                              : AppColors.red,
                          validateFunc: (_) => null,
                          suffixIcon: InkWell(
                            onTap: () => setState(
                                    () => _confirmPasswordVisible = !_confirmPasswordVisible),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Icon(
                                _confirmPasswordVisible
                                    ? Icons.lock_open_rounded
                                    : Icons.lock_outline_rounded,
                                size: 18,
                                color: AppColors.grey500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                buttonText: isLoading
                    ? LocaleKeys.Authentication_signingUp.tr()
                    : LocaleKeys.Authentication_signUpTitle.tr(),
                footerText: LocaleKeys.Authentication_alreadyHaveAccount.tr(),
                footerAction: LocaleKeys.Authentication_signInTitle.tr(),
                onFooterTap: _navigateToSignIn,
                isLoading: isLoading,
                onSubmit: () {
                  if (!(context.read<RegisterCubit>().state is RegisterLoading)) {
                    _submitWithCubit(context);
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
