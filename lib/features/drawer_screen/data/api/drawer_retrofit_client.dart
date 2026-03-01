import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import '../../../../core/network/remote/api_constants.dart';
import '../models/contact_us.dart';
import '../models/delete_model.dart';
import '../models/drawer_model.dart';
import '../models/history_model.dart';
part 'drawer_retrofit_client.g.dart';

@lazySingleton
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class DrowerRetrofitClient {
  @factoryMethod
  factory DrowerRetrofitClient(Dio dio) = _DrowerRetrofitClient;

  @GET(ApiConstants.privacy)
  Future<DrawerModel> privacy();

  @GET(ApiConstants.termsAndConditions)
  Future<DrawerModel> termsAndConditions();
  @DELETE(ApiConstants.deleteAccount)
  @FormUrlEncoded()
  Future<DeleteModel> deleteAccount(
      @Header("Authorization") String authorization,
      );
  @POST(ApiConstants.contactUs)
  @FormUrlEncoded()
  Future<ContactModel> contactUs(
      @Field('subject') String subject,
      @Field('name') String name,
      @Field('email') String email,
      @Field('phone') String phone,
      @Field('message') String message,
      );
  @GET(ApiConstants.history)
  Future<HistoryModel> history(
      @Header("Authorization") String authorization,
      @Query("status") String status,
      );




}
