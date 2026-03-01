class SelectCarModel {
  bool? status;
  Message? message;
  int? tripId;
  CarId? carId;
  String? driverId;
  String? tripPrice;
  String? tripStatus;

  SelectCarModel(
      {this.status,
        this.message,
        this.tripId,
        this.carId,
        this.driverId,
        this.tripPrice,
        this.tripStatus});

  SelectCarModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
    tripId = json['trip_id'];
    carId = json['car_id'] != null ? new CarId.fromJson(json['car_id']) : null;
    driverId = json['driver_id'];
    tripPrice = json['trip_price'];
    tripStatus = json['trip_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    data['trip_id'] = this.tripId;
    if (this.carId != null) {
      data['car_id'] = this.carId!.toJson();
    }
    data['driver_id'] = this.driverId;
    data['trip_price'] = this.tripPrice;
    data['trip_status'] = this.tripStatus;
    return data;
  }
}

class Message {
  String? ar;
  String? en;

  Message({this.ar, this.en});

  Message.fromJson(Map<String, dynamic> json) {
    ar = json['ar'];
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ar'] = this.ar;
    data['en'] = this.en;
    return data;
  }
}

class CarId {
  int? id;
  String? year;
  String? color;
  String? registrationNumber;
  String? isUsingIt;
  Driver? driver;
  int? driverRatingAverage;
  int? driverRatingCount;
  String? carMaker;
  String? carLicenseCode;
  String? image;

  CarId(
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

  CarId.fromJson(Map<String, dynamic> json) {
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
