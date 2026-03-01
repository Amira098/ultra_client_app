class RegisterModel {
  bool? status;
  Message? message;
  String? token;
  User? user;

  RegisterModel({this.status, this.message, this.token, this.user});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ar'] = this.ar;
    data['en'] = this.en;
    data['it'] = this.it;
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
  String? personalIdNumber;
  String? vichileNumber;
  String? lisenseDriving;
  String? idImage;

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
        this.createdAt,
        this.personalIdNumber,
        this.vichileNumber,
        this.lisenseDriving,
        this.idImage});

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
    personalIdNumber = json['personal_id_number'];
    vichileNumber = json['vichile_number'];
    lisenseDriving = json['lisense_driving'];
    idImage = json['id_image'];
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
    data['personal_id_number'] = this.personalIdNumber;
    data['vichile_number'] = this.vichileNumber;
    data['lisense_driving'] = this.lisenseDriving;
    data['id_image'] = this.idImage;
    return data;
  }
}
