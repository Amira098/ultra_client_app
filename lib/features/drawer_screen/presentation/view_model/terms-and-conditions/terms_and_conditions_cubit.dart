import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:ultra_client/features/drawer_screen/presentation/view_model/terms-and-conditions/terms_and_conditions_state.dart';
import '../../../../../core/network/common/api_result.dart';
import '../../../data/models/drawer_model.dart';
import '../../../data/usecase/terms-and-conditions_usecase.dart';

@injectable
class TermsAndConditionsCubit extends Cubit<TermsAndConditionsState> {
  final termsAndConditionsUseCase _termsAndConditionsUseCase;
  TermsAndConditionsCubit(this._termsAndConditionsUseCase) : super(TermsAndConditionsInitial());
  Future<void> gettermsAndConditions() async {
    emit(TermsAndConditionsLoading());

    try {
      final result = await _termsAndConditionsUseCase.execute();

      switch (result) {
        case SuccessResult<DrawerModel>():
          emit(TermsAndConditionsSuccess(result.data));
        case FailureResult<DrawerModel>():
          emit(TermsAndConditionsFailure(result.exception.toString()?? "حدث خطأ ما"));
      }
    } catch (e) {
      emit(TermsAndConditionsFailure("حدث خطأ غير متوقع"));
    }
  }
}
