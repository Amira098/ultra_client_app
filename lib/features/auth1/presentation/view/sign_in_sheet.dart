import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_field/intl_phone_number_field.dart';
import 'package:ultra_client/core/di/service_locator.dart';
import 'package:ultra_client/features/auth1/presentation/view/sign_up_sheet.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/font_size.dart';
import '../../../../core/utils/show_pretty_snack.dart';
import '../../../../core/utils/utils/customTextField.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../home_screen/presentation/view/map_screen.dart';
import '../../data/models/login_model.dart';
import '../view_model/login_state.dart';
import '../view_model/sign_in_cubit.dart';
import 'auth_container_widget.dart';

class SignInSheet extends StatefulWidget {
  const SignInSheet({super.key});

  @override
  State<SignInSheet> createState() => _SignInSheetState();
}

class _SignInSheetState extends State<SignInSheet> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final LoginCubit _loginCubit = serviceLocator<LoginCubit>();
  IntPhoneNumber _phoneNumber =
  IntPhoneNumber(code: 'IT', dial_code: '+39', number: '');
  final CountryCodeModel _initialCountry =
  CountryCodeModel(name: 'Itaiy', dial_code: '+39', code: 'IT');

  bool _passwordVisible = false;
  bool _phoneValid = true;
  bool _passwordValid = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _phoneController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _navigateToSignUp() {
    Navigator.pop(context);
    Future.delayed(const Duration(milliseconds: 100), () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const SignUpSheet(),
      );
    });
  }

  void _submitWithCubit(BuildContext context) {
    final phone = _phoneNumber.number.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _phoneValid = phone.isNotEmpty;
      _passwordValid = password.length >= 6;
    });
    if (!_phoneValid || !_passwordValid) return;

    // استدعاء Cubit
    context.read<LoginCubit>().login(
      phone: phone,
      password: password,
      countryCode: _phoneNumber.dial_code, // أو _phoneNumber.code حسب API
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: BlocProvider.value(
        value: _loginCubit,
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) async {
            if (state is LoginFailure) {
              final currentLang = context.locale.languageCode;

              String errorText = LocaleKeys.Error_somethingWentWrong.tr();

              if (state.apiError != null) {
                // استخدم الـ message من الـ API مباشرة
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



            if (state is LoginSuccess) {
              showPrettySnack(
                context,
                getMessageByLocale(
                  state.loginModel.message?.ar,
                  state.loginModel.message?.en,
                  state.loginModel.message?.it,
                  context,
                ),
              );



              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MapScreen(),));
            }
          },
          builder: (context, state) {
            final isLoading = state is LoginLoading;

            return AuthContainer(
              initialSize: 0.45,
              maxChildSize: 0.45,
              minChildSize: 0.45,
              controllerBuilder: (controller) => AuthContent(
                controller: controller,
                title: LocaleKeys.Authentication_signInTitle.tr(),

                fields: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // حقل الهاتف
                        Container(
                          decoration: BoxDecoration(
                            color: _phoneValid
                                ? AppColors.grey100
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
                              selectedItemColor: AppColors.grey500,
                              textStyle: TextStyle(
                                color: AppColors.black,
                                fontSize: AppSizes.BODY_TEXT3_SIZE,
                              ),
                              searchBoxTextStyle:
                              const TextStyle(color: Colors.black, fontSize: 14),
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

                        // حقل كلمة المرور
                        CommonTextFormField(
                          textInputType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          maxLines: 1,
                          obscureText: !_passwordVisible,
                          fillColor: _passwordValid
                              ? AppColors.grey100
                              : AppColors.red.withOpacity(0.08),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 8),
                          hintColor: AppColors.grey500,
                          hint: LocaleKeys.Authentication_passwordHint.tr(),
                          borderRadius: 8,
                          fontSize: AppSizes.BODY_TEXT3_SIZE,
                          borderWidth: 1.2,
                          borderColor: _passwordValid
                              ? AppColors.transparent
                              : AppColors.red,
                          errorBorderColor: AppColors.red,
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
                          validateFunc: (_) => null, // UI فقط
                        ),
                      ],
                    ),
                  ),
                ],
                buttonText: isLoading
                    ? LocaleKeys.Authentication_signingIn.tr()
                    : LocaleKeys.Authentication_signInTitle.tr(),
                footerText: LocaleKeys.Authentication_DonotHaveAnAccount.tr(),
                footerAction: LocaleKeys.Authentication_SignUp.tr(),
                onFooterTap: _navigateToSignUp,
                isLoading: isLoading,
                onSubmit: () {
                  if (!isLoading) _submitWithCubit(context);
                },
              ),
            );
          },
        ),
      ),
    );
  }


}
