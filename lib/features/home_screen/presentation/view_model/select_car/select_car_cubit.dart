
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ultra_client/features/home_screen/presentation/view_model/select_car/select_car_state.dart';
import '../../../../../core/network/common/api_result.dart';
import '../../../data/data_sources_imp/home_data_sources.dart';
import '../../../data/model/select_car_model.dart';
@injectable
class SelectCarCubit extends Cubit<SelectCarState> {
  SelectCarCubit( this.homeDataSource) : super(SelectCarInitial());
  final HomeDataSource homeDataSource;
  Future<void> selectCar({required int tripId, required int carId}) async {
    emit(SelectCarLoading());
    final result = await homeDataSource.selectCar(tripId: tripId, carId: carId);
    if (result is SuccessResult<SelectCarModel>) {
      emit(SelectCarSuccess(selectCarModel: result.data));
    } else if (result is FailureResult<SelectCarModel>) {
      emit(SelectCarError(message: result.exception.toString()));
    }
  }
}
