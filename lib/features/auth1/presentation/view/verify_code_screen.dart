// import 'dart:async';
// import 'package:after_layout/after_layout.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// import 'package:pinput/pinput.dart';
// import 'package:ultra_client/features/auth1/presentation/view/verification_done_screen.dart';
//
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/constants/font_size.dart';
// import '../../../../core/utils/custom_button.dart';
// import '../../../../core/utils/custom_text.dart';
// import '../../../../generated/locale_keys.g.dart';
//
// class VerifyCodeScreen extends StatefulWidget {
//   final String phone;
//   final String phoneCode;
//   final bool deleteAccount;
//   final bool registerNewAccount;
//
//   const VerifyCodeScreen({
//     super.key,
//     required this.phoneCode,
//     required this.phone,
//     required this.registerNewAccount,
//     required this.deleteAccount,
//   });
//
//   @override
//   _VerifyCodeScreenState createState() => _VerifyCodeScreenState();
// }
//
// class _VerifyCodeScreenState extends State<VerifyCodeScreen>
//     with AfterLayoutMixin<VerifyCodeScreen> {
//   static const int kVerificationCodeLength = 6; // ✅ بديل VERIFICATION_CODE_LENGTH
//
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _verifyController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   String? _verificationId;
//   bool _isCodeSent = false;
//   bool _errorCode = false;
//
//   Timer? _timer;
//   int _resetTimerSeconds = 0;
//
//   @override
//   void initState() {
//     _startResetTimer();
//     super.initState();
//   }
//
//   @override
//   void afterFirstLayout(BuildContext context) {
//     _sendCode();
//   }
//
//   void _sendCode() async {
//     await _auth.verifyPhoneNumber(
//       phoneNumber: '${widget.phoneCode}${widget.phone}',
//       timeout: const Duration(seconds: 60),
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await _auth.signInWithCredential(credential);
//         _navigateAfterSuccess();
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("${e.message}")),
//         );
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         setState(() {
//           _verificationId = verificationId;
//           _isCodeSent = true;
//           _errorCode = false;
//         });
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         _verificationId = verificationId;
//       },
//     );
//   }
//
//   void _navigateAfterSuccess() async {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const VerifiedDone()),
//     );
//   }
//
//   void _startResetTimer() {
//     _resetTimerSeconds = 60;
//     const oneSec = Duration(seconds: 1);
//     _timer = Timer.periodic(oneSec, (Timer timer) {
//       if (_resetTimerSeconds == 0) {
//         setState(() => timer.cancel());
//       } else {
//         setState(() => _resetTimerSeconds--);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     _verifyController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Form(
//         key: _formKey,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 22),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 32),
//               Center(
//                 child: CustomText(
//                   LocaleKeys.Authentication_verifyCodeTitle.tr(),
//                   style: TextStyle(
//                     color: const Color(0xFFF3A94E),
//                     fontSize: AppSizes.HEADLINE3_SIZE,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Center(
//                 child: CustomText(
//                   LocaleKeys.Authentication_codeHasBeenSentTo
//                       .tr(args: [widget.phone]),
//                   style: TextStyle(
//                     color: AppColors.grey600,
//                     fontSize: AppSizes.BODY_TEXT3_SIZE,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(height: 32),
//               Directionality(
//                 textDirection: TextDirection.ltr,
//                 child: Center(
//                   child: Pinput(
//                     controller: _verifyController,
//                     length: kVerificationCodeLength, // ✅ طول الكود
//                     defaultPinTheme: PinTheme(
//                       height: 56,
//                       width: 56,
//                       textStyle: TextStyle(
//                         fontSize: 24,
//                         color: AppColors.primary,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppColors.white,
//                         border: Border.all(
//                           color: AppColors.grey500,
//                           width: 1,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     focusedPinTheme: PinTheme(
//                       height: 56,
//                       width: 56,
//                       textStyle: TextStyle(
//                         fontSize: 24,
//                         color: AppColors.primary,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppColors.white,
//                         border: Border.all(
//                           color: AppColors.primary,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     errorPinTheme: PinTheme(
//                       height: 56,
//                       width: 56,
//                       textStyle: TextStyle(
//                         fontSize: 24,
//                         color: AppColors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppColors.red,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     errorText: _errorCode
//                         ? LocaleKeys.Authentication_enterValidCode.tr()
//                         : null, // ✅ تصحيح المنطق
//                     validator: (value) {
//                       final v = (value ?? '').trim();
//                       if (v.isEmpty || v.length < kVerificationCodeLength) {
//                         return LocaleKeys.Authentication_enterValidCode.tr();
//                       }
//                       return null;
//                     },
//                     onCompleted: (code) async {
//                       // bypass للتجربة
//                       if (code.trim() == "0000") {
//                         _navigateAfterSuccess();
//                         return;
//                       }
//
//                       if (_formKey.currentState!.validate() && _verificationId != null) {
//                         try {
//                           final credential = PhoneAuthProvider.credential(
//                             verificationId: _verificationId!,
//                             smsCode: code,
//                           );
//                           await _auth.signInWithCredential(credential);
//                           setState(() => _errorCode = false);
//                           _navigateAfterSuccess();
//                         } catch (e) {
//                           setState(() => _errorCode = true);
//                         }
//                       } else {
//                         setState(() => _errorCode = true);
//                       }
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Center(
//                 child: _resetTimerSeconds > 0
//                     ? CustomText(
//                   LocaleKeys.Authentication_resendCodeIn.tr(args: [
//                     _resetTimerSeconds.toString().padLeft(2, '0')
//                   ]),
//                   style: TextStyle(
//                     color: AppColors.grey500,
//                     fontSize: AppSizes.BODY_TEXT3_SIZE,
//                   ),
//                 )
//                     : CustomButton(
//                   btnColor: AppColors.transparent,
//                   onTap: () {
//                     _startResetTimer();
//                     _verifyController.clear();
//                     setState(() => _errorCode = false);
//                     _sendCode();
//                   },
//                   text: LocaleKeys.Authentication_smsCodeDidNotArrive.tr(),
//                   textColor: AppColors.grey600,
//                   fontSize: AppSizes.BODY_TEXT3_SIZE,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
