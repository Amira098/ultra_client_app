
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/network/common/api_result.dart';
import '../../../data/data_sources_imp/home_data_sources.dart';
import '../../../data/model/cancelling_reasons_model.dart';
import 'cancelling_reasons_state.dart';
@injectable
class CancellingReasonsCubit extends Cubit<CancellingReasonsState> {
  CancellingReasonsCubit(this.homeDataSource) : super(CancellingReasonsInitial());
  final HomeDataSource homeDataSource;

  Future<void> getCancellingReasons() async {
    emit(CancellingReasonsLoading());
    final result = await homeDataSource.cancellingReasons();
    if (result is SuccessResult<CancellingReasonsModel>) {
      emit(CancellingReasonsSuccess( cancellingReasons: result.data));
    } else if (result is FailureResult<CancellingReasonsModel>) {
      emit(CancellingReasonsError( message: result.exception.toString()));
    }
  }

}
