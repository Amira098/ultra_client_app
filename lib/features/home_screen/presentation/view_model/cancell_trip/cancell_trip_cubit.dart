import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../../core/models/api_error.dart';
import '../../../../../core/network/common/api_result.dart';
import '../../../data/data_sources_imp/home_data_sources.dart';
import '../../../data/model/cancel_model.dart';
import '../../../data/model/select_car_model.dart';
import 'cancell_trip_state.dart';


@injectable
class CancellTripCubit extends Cubit<CancellTripState> {
  CancellTripCubit(this.homeDataSource) : super(CancellTripInitial());
  final HomeDataSource homeDataSource;
  Future<void> cancellTrip({required int tripId, required int cancellingReasonId}) async {
    emit(CancellTripLoading());
    final result = await homeDataSource.cancellTrip(tripId: tripId, cancellingReasonId: cancellingReasonId);
    if (result is SuccessResult<CancellingModel>) {
      emit(CancellTripSuccess(cancelTrip: result.data));
    } else if (result is FailureResult<CancellingModel>) {
      emit(CancellTripError(
        apiError: result.apiError?.message as ApiError,
      ));
    }
  }

}
