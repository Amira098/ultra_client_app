class AddCarModel {
  bool? status;
  Message? message;
  Data? data;

  AddCarModel({this.status, this.message, this.data});

  AddCarModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Message {
  String? en;
  String? ar;
  String? it;

  Message({this.en, this.ar,this.it});

  Message.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
    it = json['it'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    data['it'] = this.it;
    return data;
  }
}

class Data {
  int? id;
  String? year;
  String? color;
  String? registrationNumber;
  String? isUsingIt;
  User? user;
  String? carMaker;
  int? carLicenseCode;
  String? image;

  Data(
      {this.id,
        this.year,
        this.color,
        this.registrationNumber,
        this.isUsingIt,
        this.user,
        this.carMaker,
        this.carLicenseCode,
        this.image});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    year = json['year'];
    color = json['color'];
    registrationNumber = json['registration_number'];
    isUsingIt = json['is_using_it'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    carMaker = json['car_maker'];
    carLicenseCode = json['car_license_code'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['year'] = this.year;
    data['color'] = this.color;
    data['registration_number'] = this.registrationNumber;
    data['is_using_it'] = this.isUsingIt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['car_maker'] = this.carMaker;
    data['car_license_code'] = this.carLicenseCode;
    data['image'] = this.image;
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
  String? latitude;
  String? longitude;
  bool? isVeriefied;
  String? createdAt;

  User(
      {this.id,
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
        this.createdAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    countryCode = json['country_code'];
    avatar = json['avatar'];
    accountType = json['account_type'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isVeriefied = json['is_veriefied'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['country_code'] = this.countryCode;
    data['avatar'] = this.avatar;
    data['account_type'] = this.accountType;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['is_veriefied'] = this.isVeriefied;
    data['created_at'] = this.createdAt;
    return data;
  }
}
