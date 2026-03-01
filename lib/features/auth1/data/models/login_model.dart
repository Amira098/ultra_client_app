import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class LoginModel {
  bool? status;
  Message? message;
  String? token;
  User? user;

  LoginModel({
    this.status,
    this.message,
    this.token,
    this.user,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
    json['message'] != null ? Message.fromJson(json['message']) : null;
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (message != null) {
      data['message'] = message!.toJson();
    }
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class Message {
  String? ar;
  String? en;
  String? it;

  Message({this.ar, this.en, this.it});

  Message.fromJson(Map<String, dynamic> json) {
    ar = json['ar'];
    en = json['en'];
    it = json['it'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['ar'] = ar;
    data['en'] = en;
    data['it'] = it;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? countryCode;
  String? avatar;
  String? accountType;
  String? address;
  double? latitude;
  double? longitude;
  bool? isVeriefied;
  String? createdAt;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.countryCode,
    this.avatar,
    this.accountType,
    this.address,
    this.latitude,
    this.longitude,
    this.isVeriefied,
    this.createdAt,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    countryCode = json['country_code'];
    avatar = json['avatar']?.toString();
    accountType = json['account_type']?.toString();
    address = json['address']?.toString();
    latitude = json['latitude'] != null
        ? double.tryParse(json['latitude'].toString())
        : null;
    longitude = json['longitude'] != null
        ? double.tryParse(json['longitude'].toString())
        : null;
    isVeriefied = json['is_veriefied'] == true || json['is_veriefied'] == 1;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['country_code'] = countryCode;
    data['avatar'] = avatar;
    data['account_type'] = accountType;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['is_veriefied'] = isVeriefied;
    data['created_at'] = createdAt;
    return data;
  }
}
String getMessageByLocale(String? messageAr, String? messageEn, String? messageIt, BuildContext context) {
  final langCode = context.locale.languageCode;
  switch(langCode) {
    case 'ar':
      return messageAr ?? messageEn ?? messageIt ?? '';
    case 'it':
      return messageIt ?? messageEn ?? messageAr ?? '';
    case 'en':
    default:
      return messageEn ?? messageAr ?? messageIt ?? '';
  }
}
