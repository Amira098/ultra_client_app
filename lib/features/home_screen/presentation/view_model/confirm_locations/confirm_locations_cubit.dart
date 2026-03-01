import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/models/api_error.dart';
import '../../../../../core/network/common/api_result.dart';
import '../../../data/data_sources_imp/home_data_sources.dart';
import '../../../data/model/confirm_locations_model.dart';
import 'confirm_locations_state.dart';

@Injectable()
class ConfirmLocationsCubit extends Cubit<ConfirmLocationsState> {
  ConfirmLocationsCubit(this._homeDataSource)
      : super(ConfirmLocationsInitial());

  final HomeDataSource _homeDataSource;

  Future<void> confirmLocations({
    required double fromLatitude,
    required double fromLongitude,
    required double toLatitude,
    required double toLongitude,
    required String fromAddress,
    required String toAddress,
    required int isSpecial,
  }) async {
    emit(ConfirmLocationsLoading());

    try {
      final result = await _homeDataSource.confirmLocations(
        fromLatitude: fromLatitude,
        fromLongitude: fromLongitude,
        toLatitude: toLatitude,
        toLongitude: toLongitude,
        fromAddress: fromAddress,
        toAddress: toAddress,
        isSpecial: isSpecial,
      );

      if (result is SuccessResult<ConfirmLocationsModel>) {
        emit(ConfirmLocationsSuccess(data: result.data));
      } else if (result is FailureResult<ConfirmLocationsModel>) {
        final apiError = result.apiError as ApiError?;

        String message = 'حدث خطأ ما، يرجى المحاولة مرة أخرى';

        if (apiError != null) {
          if (apiError.message != null && apiError.message!.isNotEmpty) {
            message = apiError.message! as String;
          } else if (apiError.errors != null &&
              apiError.errors!.isNotEmpty) {
            try {
              final firstKey = apiError.errors!.keys.first;
              final firstList = apiError.errors![firstKey];
              if (firstList != null && firstList.isNotEmpty) {
                message = firstList.first;
              }
            } catch (_) {}
          }
        }

        emit(
          ConfirmLocationsError(
            apiError: apiError ?? ApiError(),
            exception: result.exception ?? Exception(message),
            message: message,
          ),
        );
      }
    } catch (e) {
      final message = e.toString();
      emit(
        ConfirmLocationsError(
          apiError: ApiError(),
          exception: e is Exception ? e : Exception(message),
          message: message,
        ),
      );
    }
  }
}
