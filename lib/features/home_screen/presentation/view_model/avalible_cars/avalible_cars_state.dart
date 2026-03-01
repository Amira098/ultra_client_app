
import 'package:ultra_client/core/models/api_error.dart';

import '../../../data/model/avalible_cars_model.dart';


sealed class AvalibleCarsState {}

final class AvalibleCarsInitial extends AvalibleCarsState {}
final class AvalibleCarsLoading extends AvalibleCarsState {}
final class AvalibleCarsSuccess extends AvalibleCarsState {
  final AvalibleCarsModel data;
  AvalibleCarsSuccess({required this.data});
}
final class AvalibleCarsError extends AvalibleCarsState {
  final ApiError? apiError;
  final Exception? exception;
  AvalibleCarsError( this.apiError,  this.exception);
}

