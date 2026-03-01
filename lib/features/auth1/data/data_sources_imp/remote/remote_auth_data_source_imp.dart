import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../core/network/common/api_result.dart';
import '../../../../../core/network/remote/api_manager.dart';
import '../../../../../core/utils/app_shared_preference.dart';
import '../../models/login_model.dart';
import '../../models/register_model.dart';
import '../../api/auth_retrofit_client.dart';
import 'remote_auth_data_source.dart';

@Injectable(as: RemoteAuthDataSource)
class RemoteAuthDataSourceImpl extends RemoteAuthDataSource {
  final ApiManager _apiManager;
  final AuthRetrofitClient _apiService;

  RemoteAuthDataSourceImpl(this._apiManager, this._apiService);

  @override
  Future<Result<LoginModel>> login({
    required String phone,
    required String password,
    required String countryCode,

  }) async {
    final result = await _apiManager.execute<LoginModel>(() async {
      return await _apiService.login(phone, password, countryCode);
    });

    switch (result) {
      case SuccessResult<LoginModel>():
        final data = result.data;
        final token = result.data.token;
        if (token != null && token.isNotEmpty) {
          await SharedPreferencesUtils.saveData(
            key: AppValues.token,
            value: token,
          );
        }


        if (data.user != null) {
          await SharedPreferencesUtils.saveData(
            key: AppValues.user,
            value: jsonEncode(data.user!.toJson()),
          );
          await SharedPreferencesUtils.saveData(
            key: AppValues.loggedIn,
            value: true,
          );
        }

        return SuccessResult(data);

      case FailureResult<LoginModel>():
        return FailureResult(
          exception: result.exception,
          apiError: result.apiError,
        );
    }
  }

  @override
  Future<Result<RegisterModel>> register({
    required FormData formData,
  }) async {
    final result = await _apiManager.execute<RegisterModel>(() async {
      return await _apiService.register(formData);
    });

    switch (result) {
      case SuccessResult<RegisterModel>():
        final data = result.data;
        final token = result.data.token;
        if (token != null && token.isNotEmpty) {
          await SharedPreferencesUtils.saveData(
            key: AppValues.token,
            value: token,
          );
        }


        if (data.user != null) {
          await SharedPreferencesUtils.saveData(
            key: AppValues.user,
            value: jsonEncode(data.user!.toJson()),
          );
          await SharedPreferencesUtils.saveData(
            key: AppValues.loggedIn,
            value: true,
          );
        }
        return SuccessResult(data);
      case FailureResult<RegisterModel>():
        return FailureResult(
          exception: result.exception,
          apiError: result.apiError,
        );
    }
  }
}
