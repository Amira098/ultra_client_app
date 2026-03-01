
import 'package:ultra_client/core/models/api_error.dart';

import '../../../data/model/cancel_model.dart';
import '../../../data/model/select_car_model.dart';

sealed class CancellTripState {}

final class CancellTripInitial extends CancellTripState {}

final class CancellTripLoading extends CancellTripState {}

final class CancellTripSuccess extends CancellTripState {
  final CancellingModel cancelTrip;

  CancellTripSuccess({required this.cancelTrip});
}

final class CancellTripError extends CancellTripState {
  final ApiError apiError;
  CancellTripError({required this.apiError});
}

