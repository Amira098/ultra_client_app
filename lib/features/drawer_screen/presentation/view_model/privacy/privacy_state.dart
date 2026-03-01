part of 'privacy_cubit.dart';

abstract class PrivacyState {}

class PrivacyInitial extends PrivacyState {}

class PrivacyLoading extends PrivacyState {}

class PrivacySuccess extends PrivacyState {
  final DrawerModel data;
  PrivacySuccess(this.data);
}

class PrivacyFailure extends PrivacyState {
  final String message;
  PrivacyFailure(this.message);
}
