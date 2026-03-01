import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/network/common/api_result.dart';
import '../../../data/models/drawer_model.dart';
import '../../../data/usecase/privacy_usecase.dart';


part 'privacy_state.dart';

@injectable
class PrivacyCubit extends Cubit<PrivacyState> {
  final PrivacyUseCase _privacyUseCase;

  PrivacyCubit(this._privacyUseCase) : super(PrivacyInitial());

  Future<void> getPrivacyPolicy() async {
    emit(PrivacyLoading());

    try {
      final result = await _privacyUseCase.execute();

      switch (result) {
        case SuccessResult<DrawerModel>():
          emit(PrivacySuccess(result.data));
        case FailureResult<DrawerModel>():
          emit(PrivacyFailure(result.exception.toString()?? "حدث خطأ ما"));
      }
    } catch (e) {
      emit(PrivacyFailure("حدث خطأ غير متوقع"));
    }
  }
}
