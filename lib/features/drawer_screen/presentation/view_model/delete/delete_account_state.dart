
import '../../../../../core/models/api_error.dart';

import '../../../data/models/delete_model.dart';


abstract class DeleteState {}

class DeleteInitial extends DeleteState {}

class DeleteLoading extends DeleteState {}

class DeleteSuccess extends DeleteState {
  final DeleteModel data;
  DeleteSuccess(this.data);
}

class DeleteError extends DeleteState {
  final ApiError? apiError;
  final Exception? exception;
  DeleteError(this.exception,this.apiError);
}
