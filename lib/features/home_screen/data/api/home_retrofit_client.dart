import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import '../../../../core/network/remote/api_constants.dart';
import '../model/avalible_cars_model.dart';
import '../model/cancel_model.dart';
import '../model/cancelling_reasons_model.dart';
import '../model/confirm_locations_model.dart';
import '../model/select_car_model.dart';

part 'home_retrofit_client.g.dart';

@lazySingleton
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class HomeRetrofitClient {
  @factoryMethod
  factory HomeRetrofitClient(Dio dio) = _HomeRetrofitClient;

  @POST(ApiConstants.confirmLocations)
  @FormUrlEncoded()
  Future<ConfirmLocationsModel> confirmLocations(
    @Header("Authorization") String authorization,
    @Field('end_latitude') double endLatitude,
    @Field('end_longitude') double endLongitude,
    @Field('start_longitude') double startLongitude,
    @Field('start_latitude') double startLatitude,
    @Field('end_address') String endAddress,
    @Field('start_address') String startAddress,
    @Field('is_special') int isSpecial,
  );

  @GET(ApiConstants.avalibleCars)
  Future<AvalibleCarsModel> avalibleCars(
    @Header("Authorization") String authorization,
  );

  @POST("https://ultrap.online/api/trip/{trip_id}/select-car")
  @FormUrlEncoded()
  Future<SelectCarModel> selectCar(
    @Header("Authorization") String authorization,
    @Path("trip_id") int tripId,
    @Field("car_id") int carId,
  );

  @POST("https://ultrap.online/api/trip/{trip_id}/cancel")
  @FormUrlEncoded()
  Future<CancellingModel> cancellTrip(
    @Header("Authorization") String authorization,
    @Path("trip_id") int tripId,
    @Field("cancelling_reason_id") int cancellingReasonId,
  );

  @GET(ApiConstants.cancellingReasons)
  Future<CancellingReasonsModel> cancellingReasons();
}
