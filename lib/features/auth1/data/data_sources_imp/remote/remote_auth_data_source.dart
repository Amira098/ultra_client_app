import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/network/common/api_result.dart';
import '../../models/login_model.dart';
import '../../models/register_model.dart';


abstract class RemoteAuthDataSource {
  Future<Result<LoginModel>> login(
      {required String phone, required String password,required String countryCode});
  Future<Result<RegisterModel>>register(
      {required FormData formData});
// Future< RegisterEntity> register(FormData formData);
//
//   Future<void> sendOtp({
//     required String phoneNumber,
//     required Function(String verificationId) onCodeSent,
//     required Function(FirebaseAuthException e) onVerificationFailed,
//   });
//
//   Future<void> verifyOtp({
//     required String otpCode,
//     required String verificationId,
//   });

}
