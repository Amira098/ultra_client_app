import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/network/common/api_result.dart';
import '../../../../core/network/remote/api_manager.dart';
import '../../../../core/utils/app_shared_preference.dart';
import '../api/home_retrofit_client.dart';
import '../model/avalible_cars_model.dart';
import '../model/cancel_model.dart';
import '../model/cancelling_reasons_model.dart';
import '../model/confirm_locations_model.dart';
import '../model/select_car_model.dart';
import 'home_data_sources.dart';
@Injectable(as: HomeDataSource)
class HomeDataSourceImp implements HomeDataSource {
final HomeRetrofitClient _apiService;
final ApiManager _apiManager;
HomeDataSourceImp(this._apiService, this._apiManager);


@override
Future<Result<ConfirmLocationsModel>> confirmLocations({
  required double fromLatitude,
  required double fromLongitude,
  required double toLatitude,
  required double toLongitude,
  required String fromAddress,
  required String toAddress,
  required int isSpecial,
}) async {
  final result = await _apiManager.execute<ConfirmLocationsModel>(() async {
    final token = await SharedPreferencesUtils.getString(AppValues.token);
    if (token!.isEmpty) {
      throw Exception("Token is missing");
    }
    final auth = 'Bearer $token';

    final response = await _apiService.confirmLocations(
      auth,
      toLatitude,
      toLongitude,
      fromLongitude,
      fromLatitude,
      toAddress,
      fromAddress,
      isSpecial,
    );

    return response;
  });

  switch (result) {
    case SuccessResult<ConfirmLocationsModel>():
      return SuccessResult<ConfirmLocationsModel>(result.data);
    case FailureResult<ConfirmLocationsModel>():
      return FailureResult<ConfirmLocationsModel>(
        exception: result.exception,
        apiError: result.apiError,
      );
  }
}

  @override
  Future<Result<AvalibleCarsModel>> avalibleCars() async {
    final result = await _apiManager.execute<AvalibleCarsModel>(() async {
      final token = await SharedPreferencesUtils.getString(AppValues.token);
      if (token!.isEmpty) {
        throw Exception("Token is missing");
      }
      final auth = 'Bearer $token';
      final response = await _apiService.avalibleCars(auth);
      return response;
    });
    switch (result) {
      case SuccessResult<AvalibleCarsModel>():
        return SuccessResult<AvalibleCarsModel>(result.data);
      case FailureResult<AvalibleCarsModel>():
        return FailureResult<AvalibleCarsModel>(
          exception: result.exception,
          apiError: result.apiError,
        );
    }
  }
  @override
  Future<Result<SelectCarModel>> selectCar({
    required int tripId,
    required int carId,
  }) async {
    final result = await _apiManager.execute<SelectCarModel>(() async {
      print("tripId: $tripId");
      print("carId: $carId");

      final token = await SharedPreferencesUtils.getString(AppValues.token);

      if (token!.isEmpty) {
        throw Exception("Token is missing");
      }
      final auth = 'Bearer $token';
      final response = await _apiService.selectCar(auth, tripId, carId);
      return response;

    });
    switch (result) {

      case SuccessResult<SelectCarModel>():
        return SuccessResult<SelectCarModel>(result.data);

      case FailureResult<SelectCarModel>():
        return FailureResult<SelectCarModel>(
          exception: result.exception,
          apiError: result.apiError,
        );
    }

  }
@override
Future<Result<CancellingReasonsModel>> cancellingReasons() async {
  final result = await _apiManager.execute<CancellingReasonsModel>(() async {
    final response = await _apiService.cancellingReasons();
    return response;
  });
  switch (result) {
    case SuccessResult<CancellingReasonsModel>():
      return SuccessResult<CancellingReasonsModel>(result.data);
    case FailureResult<CancellingReasonsModel>():
      return FailureResult<CancellingReasonsModel>(
        exception: result.exception,
        apiError: result.apiError,
      );
  }
}
@override
Future<Result<CancellingModel>> cancellTrip({
  required int tripId,
  required int cancellingReasonId,
}) async {
  final result = await _apiManager.execute<CancellingModel>(() async {
    final token = await SharedPreferencesUtils.getString(AppValues.token);
    if (token!.isEmpty) {
      throw Exception("Token is missing");
    }
    final auth = 'Bearer $token';
    final response = await _apiService.cancellTrip(auth, tripId, cancellingReasonId);
    return response;
  });
  switch (result) {
    case SuccessResult<CancellingModel>():
      return SuccessResult<CancellingModel>(result.data);
    case FailureResult<CancellingModel>():
      return FailureResult<CancellingModel>(
        exception: result.exception,
        apiError: result.apiError,
      );
  }
}



}