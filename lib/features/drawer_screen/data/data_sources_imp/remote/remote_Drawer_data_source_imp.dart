
import 'package:injectable/injectable.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../core/network/common/api_result.dart';
import '../../../../../core/network/remote/api_manager.dart';
import '../../../../../core/utils/app_shared_preference.dart';
import '../../models/contact_us.dart';
import '../../models/drawer_model.dart';
import '../../models/history_model.dart';
import 'remote_Drawer_data_source.dart';
import '../../api/drawer_retrofit_client.dart';

@Injectable(as: RemoteDrawerDataSource)
class RemoteDrawerDataSourceImp extends RemoteDrawerDataSource {
  final ApiManager _apiManager;
  final DrowerRetrofitClient _apiService;

  RemoteDrawerDataSourceImp(
    this._apiManager,
    this._apiService,
  );

  @override
  Future<Result<DrawerModel>> privacy() async {
    final result = await _apiManager.execute<DrawerModel>(() async {
      final response = await _apiService.privacy();
      return response;
    });
    switch (result) {
      case SuccessResult<DrawerModel>():
        return SuccessResult<DrawerModel>(result.data);
      case FailureResult<DrawerModel>():
        return FailureResult<DrawerModel>(
          exception: result.exception,
          apiError: result.apiError,
        );
    }
  }

  @override
  Future<Result<DrawerModel>> termsAndConditions() async {
    final result = await _apiManager.execute<DrawerModel>(() async {
      final response = await _apiService.termsAndConditions();
      return response;
    });
    switch (result) {
      case SuccessResult<DrawerModel>():
        return SuccessResult<DrawerModel>(result.data);
      case FailureResult<DrawerModel>():
        return FailureResult<DrawerModel>(
          exception: result.exception,
          apiError: result.apiError,
        );
    }
  }

  @override
  Future<Result<ContactModel>> contactUs({
    required String subject,
    required String name,
    required String email,
    required String phone,
    required String message,
  }) async {
    final result = await _apiManager.execute<ContactModel>(() async {
      final response = await _apiService.contactUs(
        subject,
        name,
        email,
        phone,
        message,
      );
      return response;
    });
    switch (result) {
      case SuccessResult<ContactModel>():
        return SuccessResult<ContactModel>(result.data);
      case FailureResult<ContactModel>():
        return FailureResult<ContactModel>(
          exception: result.exception,
          apiError: result.apiError,
        );
    }
  }

  @override
  Future<Result<HistoryModel>> history({
    required String status,
  }) async {
    final result = await _apiManager.execute<HistoryModel>(() async {

      final token = await SharedPreferencesUtils.getString(AppValues.token);
      if (token!.isEmpty) {
        throw Exception("Token is missing");
      }
      final auth = 'Bearer $token';
      final response = await _apiService.history(auth, status);
      return response;
    });

    switch (result) {
      case SuccessResult<HistoryModel>():
        return SuccessResult<HistoryModel>(result.data);
      case FailureResult<HistoryModel>():
        return FailureResult<HistoryModel>(
          exception: result.exception,
          apiError: result.apiError,
        );
    }
  }





}
// ex
// @override
// Future<Result<ModelResponseEntity>> function() async {
//   final result = await _apiManager.execute<ModelResponseDto>(() async {
//     final response =
//         await _apiService.function(ModelRequestDto());
//     return response;
//   });
//   switch (result) {
//     case SuccessResult<ModelResponseDto>():
//       return SuccessResult<ModelResponseEntity>(result.data.toEntity());
//     case FailureResult<ModelResponseDto>():
//       return FailureResult<ModelResponseEntity>(result.exception);
//   }
// }
