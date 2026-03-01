import '../../../../../core/network/common/api_result.dart';
import '../../models/delete_model.dart';


abstract class DeleteDataSources {
  Future<Result<DeleteModel>>deleteAccount();
}