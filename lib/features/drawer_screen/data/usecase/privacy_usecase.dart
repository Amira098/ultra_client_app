import 'package:injectable/injectable.dart';

import '../../../../core/network/common/api_result.dart';
import '../../data/models/drawer_model.dart';
import '../data_sources_imp/remote/remote_Drawer_data_source.dart'; // لو غلط، غيريه لـ remote_privacy_data_source.dart

@injectable
class PrivacyUseCase {
  final RemoteDrawerDataSource remoteDataSource;

  PrivacyUseCase(this.remoteDataSource);

  Future<Result<DrawerModel>> execute() async {
    return await remoteDataSource.privacy();
  }
}
