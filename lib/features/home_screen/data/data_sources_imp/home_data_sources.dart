import 'package:ultra_client/core/network/common/api_result.dart';

import '../model/avalible_cars_model.dart';
import '../model/cancel_model.dart';
import '../model/cancelling_reasons_model.dart';
import '../model/confirm_locations_model.dart';
import '../model/select_car_model.dart';

abstract class HomeDataSource {
  Future<Result<ConfirmLocationsModel>> confirmLocations({
    required double fromLatitude,
    required double fromLongitude,
    required double toLatitude,
    required double toLongitude,
    required String fromAddress,
    required String toAddress,
    required int isSpecial
  });
  Future<Result<AvalibleCarsModel>> avalibleCars();
  Future<Result<SelectCarModel>> selectCar({
    required int tripId,
    required int carId,
  });
  Future<Result<CancellingModel>> cancellTrip({
    required int tripId,
    required int cancellingReasonId,
  });

  Future<Result<CancellingReasonsModel>> cancellingReasons();
}