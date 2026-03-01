
import '../../../data/model/select_car_model.dart';

sealed class SelectCarState {}

final class SelectCarInitial extends SelectCarState {}

final class SelectCarLoading extends SelectCarState {}

final class SelectCarSuccess extends SelectCarState {
  final SelectCarModel selectCarModel;
  SelectCarSuccess({required this.selectCarModel});
}

final class SelectCarError extends SelectCarState {
  final String message;
  SelectCarError({required this.message});
}

