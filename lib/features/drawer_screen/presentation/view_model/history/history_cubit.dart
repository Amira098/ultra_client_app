import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/network/common/api_result.dart';
import '../../../data/data_sources_imp/remote/remote_Drawer_data_source.dart';
import '../../../data/models/history_model.dart';
import 'history_state.dart';

@Injectable()
class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this.remoteDrawerDataSource) : super(HistoryInitial());

  final RemoteDrawerDataSource remoteDrawerDataSource;

  Future<void> history({required String status}) async {
    emit(HistoryLoading());

    final result = await remoteDrawerDataSource.history(status: status);

    if (result is SuccessResult<HistoryModel>) {
      emit(HistorySuccess(result.data ));
    } else if (result is FailureResult<HistoryModel>) {
      emit(HistoryError(result.apiError?.message.toString() ?? ""));
    }
  }
}
