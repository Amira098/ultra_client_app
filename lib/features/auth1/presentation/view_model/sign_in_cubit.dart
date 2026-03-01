import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/common/api_result.dart';
import '../../data/data_sources_imp/remote/remote_auth_data_source.dart';
import '../../data/models/login_model.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final RemoteAuthDataSource _remoteAuthDataSource;

  LoginCubit(this._remoteAuthDataSource) : super(LoginInitial());

  Future<void> login({
    required String phone,
    required String password,
    required String countryCode,
  }) async {
    emit(LoginLoading());

    final result = await _remoteAuthDataSource.login(
      phone: phone,
      password: password,
      countryCode: countryCode,
    );

    if (result is SuccessResult<LoginModel>) {
      emit(LoginSuccess(result.data));
    } else if (result is FailureResult<LoginModel>) {
      emit(LoginFailure(
        apiError: result.apiError,
        exception: result.exception,
      ));
    }
  }
}
