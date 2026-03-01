

import '../../../../../core/network/common/api_result.dart';

import '../../models/contact_us.dart';
import '../../models/drawer_model.dart';
import '../../models/history_model.dart';


abstract class RemoteDrawerDataSource {
  Future<Result<DrawerModel>> privacy();
  Future<Result<DrawerModel>> termsAndConditions();

  Future<Result<ContactModel>> contactUs({
    required String subject,
    required  String name,
    required String email,
    required  String phone,
    required  String message,

  });
Future<Result<HistoryModel>> history({
  required String status,
});

}
