import 'package:ultra_client/core/models/api_error.dart';
import '../../../data/model/confirm_locations_model.dart';

sealed class ConfirmLocationsState {}

final class ConfirmLocationsInitial extends ConfirmLocationsState {}

final class ConfirmLocationsLoading extends ConfirmLocationsState {}

final class ConfirmLocationsSuccess extends ConfirmLocationsState {
  final ConfirmLocationsModel data;

  ConfirmLocationsSuccess({required this.data});
}

final class ConfirmLocationsError extends ConfirmLocationsState {
  final ApiError apiError;
  final Exception exception;
  final String message;

  ConfirmLocationsError({
    required this.apiError,
    required this.exception,
    required this.message,
  });
}
