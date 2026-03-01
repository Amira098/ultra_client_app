import 'package:injectable/injectable.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../core/network/common/api_result.dart';
import '../../../../../core/network/remote/api_manager.dart';
import '../../../../../core/utils/app_shared_preference.dart';

import '../../api/drawer_retrofit_client.dart';
import '../../models/delete_model.dart';
import 'delete_account_data_sources.dart';

@Injectable(as: DeleteDataSources)
class DeleteDataSourcesImpl implements DeleteDataSources {
  final DrowerRetrofitClient _deleteRetrofitClient;
  final ApiManager _apiManager;

  DeleteDataSourcesImpl(this._deleteRetrofitClient, this._apiManager);

  @override
  Future<Result<DeleteModel>> deleteAccount()async {
    final token = await SharedPreferencesUtils.getString(AppValues.token);
    final auth = 'Bearer $token';
    final result= await _apiManager.execute<DeleteModel>(() async {
      return await _deleteRetrofitClient.deleteAccount(auth);
    });
    if (result is SuccessResult<DeleteModel>) {
      return SuccessResult<DeleteModel>(result.data);
    } else if (result is FailureResult<DeleteModel>) {
      return FailureResult<DeleteModel>(
        exception: result.exception,
        apiError: result.apiError,
      );
    } else {
      return FailureResult<DeleteModel>(
          exception: Exception('Unknown result type'));
    }

  }
}
