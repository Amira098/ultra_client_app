
import 'package:equatable/equatable.dart';

import '../../../../../core/models/api_error.dart';
import '../../../data/models/register_model.dart';

abstract class RegisterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final RegisterModel registerModel;
  RegisterSuccess(this.registerModel);

  @override
  List<Object?> get props => [registerModel];
}

class RegisterFailure extends RegisterState {
  final ApiError? apiError;
  final Exception? exception;
  RegisterFailure({this.apiError, this.exception});
}
