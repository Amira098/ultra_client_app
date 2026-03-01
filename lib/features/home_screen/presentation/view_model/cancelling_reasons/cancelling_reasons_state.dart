
import '../../../data/model/cancelling_reasons_model.dart';

sealed class CancellingReasonsState {}

final class CancellingReasonsInitial extends CancellingReasonsState {}

final class CancellingReasonsLoading extends CancellingReasonsState {}

final class CancellingReasonsSuccess extends CancellingReasonsState {
  final CancellingReasonsModel cancellingReasons;
  CancellingReasonsSuccess({required this.cancellingReasons});
}

final class CancellingReasonsError extends CancellingReasonsState {
  final String message;
  CancellingReasonsError({required this.message});
}

