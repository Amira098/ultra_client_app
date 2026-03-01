import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/network/common/api_result.dart';
import '../../../data/data_sources_imp/remote/remote_Drawer_data_source.dart';


import '../../../data/models/contact_us.dart';
import 'contact_us_state.dart';


@Injectable()
class ContactUsCubit extends Cubit<ContactUsState> {
  final   RemoteDrawerDataSource _contactUsDataSource;

  ContactUsCubit(this._contactUsDataSource) : super(ContactUsInitial());

  Future<void> contactUs({
    required String name,
    required String email,
    required String message,
    required String subject,
    required String phoneNumber,
  }) async {
    emit(ContactUsLoading());

    final result = await _contactUsDataSource.contactUs(
      name: name,
      email: email,
      message: message,
      subject: subject,
      phone: phoneNumber,
    );

    if (result is SuccessResult<ContactModel>) {
      emit(ContactUsSuccess(result.data));
    } else if (result is FailureResult<ContactModel>) {
      emit(ContactUsFailure(result.apiError,result.exception));
    }
  }
}
