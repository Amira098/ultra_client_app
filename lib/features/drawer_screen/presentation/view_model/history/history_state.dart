import '../../../data/models/history_model.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistorySuccess extends HistoryState {
  final HistoryModel historyData;

  HistorySuccess(this.historyData);
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}

