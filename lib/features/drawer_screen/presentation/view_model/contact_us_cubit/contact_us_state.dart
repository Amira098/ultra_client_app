

import '../../../../../core/models/api_error.dart';
import '../../../data/models/contact_us.dart';

abstract class ContactUsState {}

class ContactUsInitial extends ContactUsState {}

class ContactUsLoading extends ContactUsState {}

class ContactUsSuccess extends ContactUsState {
  final ContactModel message;
  ContactUsSuccess(this.message);
}

class ContactUsFailure extends ContactUsState {
  final ApiError? error;
  final Exception? exception;
  ContactUsFailure(this.error,this.exception);
}
