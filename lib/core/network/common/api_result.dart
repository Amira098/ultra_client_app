import '../../models/api_error.dart';

sealed class Result<T> {}

class SuccessResult<T> extends Result<T> {
  final T data;
  SuccessResult(this.data);
}

class FailureResult<T> extends Result<T> {
  final Exception? exception;
  final ApiError? apiError;

  FailureResult({this.exception, this.apiError});
}
