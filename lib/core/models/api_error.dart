import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ApiError {

  final Map<String, dynamic>? message;

  final Map<String, dynamic>? errors;

  ApiError({this.message, this.errors});

  factory ApiError.fromJson(Map<String, dynamic> json) {

    Map<String, dynamic>? parsedMessage;
    final rawMessage = json['message'];

    if (rawMessage is Map<String, dynamic>) {
      parsedMessage = rawMessage;
    } else if (rawMessage != null) {

      parsedMessage = {
        'ar': rawMessage.toString(),
        'en': rawMessage.toString(),
        'it': rawMessage.toString(),
      };
    }


    Map<String, dynamic>? parsedErrors;
    final rawErrors = json['errors'];
    if (rawErrors is Map<String, dynamic>) {
      parsedErrors = rawErrors;
    }

    return ApiError(
      message: parsedMessage,
      errors: parsedErrors,
    );
  }


  String getLocalizedMessage(BuildContext context) {
    final currentLocale =
        EasyLocalization.of(context)?.locale.languageCode ?? "en";


    final fromErrorsMessage = errors?['message']?.toString();
    if (fromErrorsMessage != null && fromErrorsMessage.isNotEmpty) {
      return fromErrorsMessage;
    }

    if (message != null && message!.isNotEmpty) {
      final localized = message![currentLocale]?.toString();
      if (localized != null && localized.isNotEmpty) {
        return localized;
      }

      final en = message!['en']?.toString();
      if (en != null && en.isNotEmpty) return en;

      final ar = message!['ar']?.toString();
      if (ar != null && ar.isNotEmpty) return ar;
    }

    if (currentLocale == "ar") {
      return "حدث خطأ غير متوقع";
    } else {
      return "Unexpected error";
    }
  }

  String? get firstFieldError {
    final fieldErrors = errors?['errors'];

    if (fieldErrors is Map) {
      if (fieldErrors.isEmpty) return null;

      final firstKey = fieldErrors.keys.first;
      final value = fieldErrors[firstKey];

      if (value is List && value.isNotEmpty) {
        return value.first.toString();
      } else if (value != null) {
        return value.toString();
      }
    }

    return null;
  }
}
