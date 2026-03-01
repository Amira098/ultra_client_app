import 'package:flutter/material.dart';

abstract class AppValues {
  static const String googleMapsApiKey = 'AIzaSyAK2Eq_TjfuzPJlGx00vCe_XmwGXm0V7wQ';
  static const appTitle = 'Flowery';
  static const String pathTranslation = "assets/translations";
  static const Locale arabicLocale = Locale("ar");
  static const Locale englishLocale = Locale("en");
  static const Locale italianLocale = Locale("it");
  static const String arabic = "ar";
  static const String english = "en";
  static const String italian = "it";
  static const List<Locale> supportedLocales = [englishLocale, arabicLocale, italianLocale];
  static const String emailRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  static const String passwordRegex = r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d@]{6,}$';
  static const String usernameRegex = r'^[a-zA-Z0-9,.-]+$';
  static const String pendingState = "pending";
  static const String inProgressState = "inProgress";
  static const String completedState = "completed";
  static const String canceledState = "canceled";

  static const String stateUser = "StateUser";
  static const user = 'user_json';
  static const token = 'auth_token';
  static const loggedIn = 'logged_in';
  static const tenantId = 'tenantId';
  static const agentId = 'agentId';
  static const String kPrefAgentIdKey = 'chat_agent_id';
  static const String kPrefAgentNameKey = 'chat_agent_name';

}
