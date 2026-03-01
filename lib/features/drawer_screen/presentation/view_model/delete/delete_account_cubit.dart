import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/network/common/api_result.dart';
import '../../../data/data_sources_imp/remote/delete_account_data_sources.dart';
import '../../../data/models/delete_model.dart';
import 'delete_account_state.dart';

@injectable
class DeleteCubit extends Cubit<DeleteState> {
  final DeleteDataSources _deleteDataSources;

  DeleteCubit(this._deleteDataSources) : super(DeleteInitial());

  Future<void> deleteAccount() async {
    emit(DeleteLoading());
    final result = await _deleteDataSources.deleteAccount();
    if (result is SuccessResult<DeleteModel>) {
      emit(DeleteSuccess(result.data));
    } else if (result is FailureResult<DeleteModel>) {
      emit(DeleteError(
        result.exception,
        result.apiError,
      ));
    }
  }
}
