



import '../../../data/models/drawer_model.dart';

abstract class TermsAndConditionsState {}

class TermsAndConditionsInitial extends TermsAndConditionsState {}

class TermsAndConditionsLoading extends TermsAndConditionsState {}

class TermsAndConditionsSuccess extends TermsAndConditionsState {
  final DrawerModel data;
  TermsAndConditionsSuccess(this.data);
}

class TermsAndConditionsFailure extends TermsAndConditionsState {
  final String message;
  TermsAndConditionsFailure(this.message);
}
