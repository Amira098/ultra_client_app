import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ultra_client/features/auth1/presentation/view_model/register/register_state.dart';
import '../../../../../core/network/common/api_result.dart';
import '../../../data/data_sources_imp/remote/remote_auth_data_source.dart';
import '../../../data/models/register_model.dart';


@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final RemoteAuthDataSource _remoteAuthDataSource;

  RegisterCubit(this._remoteAuthDataSource) : super(RegisterInitial());

  Future<void> register({
    required FormData formData
  }) async {
    emit(RegisterLoading());

    final result = await _remoteAuthDataSource.register(
      formData: formData,
    );

    if (result is SuccessResult<RegisterModel>) {
      emit(RegisterSuccess(result.data));
    } else if (result is FailureResult<RegisterModel>) {
      emit(RegisterFailure(
        apiError: result.apiError,
        exception: result.exception,
      ));
    }
  }
}
