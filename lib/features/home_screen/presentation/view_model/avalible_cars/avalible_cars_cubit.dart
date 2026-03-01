

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/common/api_result.dart';
import '../../../data/data_sources_imp/home_data_sources.dart';
import '../../../data/model/avalible_cars_model.dart';
import 'avalible_cars_state.dart';

@injectable
class AvalibleCarsCubit extends Cubit<AvalibleCarsState> {
  AvalibleCarsCubit(this.homeDataSource) : super(AvalibleCarsInitial());
  final HomeDataSource homeDataSource;
  Future<void> getAvalibleCars() async {
    emit(AvalibleCarsLoading());
    final result = await homeDataSource.avalibleCars();
    if (result is SuccessResult<AvalibleCarsModel>) {
      emit(AvalibleCarsSuccess(data: result.data));
    } else if (result is FailureResult<AvalibleCarsModel>) {
      emit(AvalibleCarsError( result.apiError, result.exception));
    }
  }
}
