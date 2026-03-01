class AvalibleCarsModel {
  bool? status;
  Message? message;
  List<Data>? data;
  Links? links;
  Meta? meta;

  AvalibleCarsModel(
      {this.status, this.message, this.data, this.links, this.meta});

  AvalibleCarsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.links != null) {
      data['links'] = this.links!.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
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

class Data {
  int? id;
  String? year;
  String? color;
  String? registrationNumber;
  bool? isUsingIt;
  Driver? driver;
  int? driverRatingAverage;
  int? driverRatingCount;
  String? carMaker;
  String? carLicenseCode;
  String? image;

  Data(
      {this.id,
        this.year,
        this.color,
        this.registrationNumber,
        this.isUsingIt,
        this.driver,
        this.driverRatingAverage,
        this.driverRatingCount,
        this.carMaker,
        this.carLicenseCode,
        this.image});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    year = json['year'];
    color = json['color'];
    registrationNumber = json['registration_number'];
    isUsingIt = json['is_using_it'];
    driver =
    json['driver'] != null ? new Driver.fromJson(json['driver']) : null;
    driverRatingAverage = json['driver_rating_average'];
    driverRatingCount = json['driver_rating_count'];
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
    if (this.driver != null) {
      data['driver'] = this.driver!.toJson();
    }
    data['driver_rating_average'] = this.driverRatingAverage;
    data['driver_rating_count'] = this.driverRatingCount;
    data['car_maker'] = this.carMaker;
    data['car_license_code'] = this.carLicenseCode;
    data['image'] = this.image;
    return data;
  }
}

class Driver {
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

  Driver(
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

  Driver.fromJson(Map<String, dynamic> json) {
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

class Links {
  String? first;
  String? last;
  String? prev;
  String? next;

  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    data['prev'] = this.prev;
    data['next'] = this.next;
    return data;
  }
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<Links>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta(
      {this.currentPage,
        this.from,
        this.lastPage,
        this.links,
        this.path,
        this.perPage,
        this.to,
        this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}
