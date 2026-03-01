import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/font_family.dart';
import '../../../../core/constants/font_size.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../generated/locale_keys.g.dart';
import 'intro_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/splashScreen";

  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with AfterLayoutMixin<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Image.asset(
          "assets/images/splash.png",
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    final hasConnection = await InternetConnectionChecker().hasConnection;

    if (!mounted) return;

    if (hasConnection) {
      // انتظار بسيط عشان تأثير السبلش
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;

        // لا نستخدم configProvider/AppCommon/MainScreen هنا
        // نوجّه مباشرة لـ IntroScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const IntroScreen()),
        );
      });
    } else {
      // No internet connection
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        titleTextStyle: TextStyle(
          fontSize: AppSizes.BODY_TEXT3_SIZE,
          fontFamily: AppFontFamily.BOLD,
        ),
        title: LocaleKeys.Error_checkInternetConnection.tr(),
        btnOk: CustomButton(
          onTap: () => _retryConnection(context),
          text: LocaleKeys.Ok.tr(),
          fontSize: AppSizes.BUTTON_SIZE,
        ),
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
      ).show();
    }
  }

  Future<void> _retryConnection(BuildContext context) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      Navigator.of(context).pop();
      afterFirstLayout(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.Error_NoInternetConnection.tr())),
      );
    }
  }
}
