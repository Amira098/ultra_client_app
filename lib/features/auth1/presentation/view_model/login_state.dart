
import 'package:equatable/equatable.dart';

import '../../../../core/models/api_error.dart';
import '../../data/models/login_model.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginModel loginModel;

  const LoginSuccess(this.loginModel);

  @override
  List<Object?> get props => [loginModel];
}


class LoginFailure extends LoginState {
  final ApiError? apiError;
  final Exception? exception;

  LoginFailure({this.apiError, this.exception});
}
