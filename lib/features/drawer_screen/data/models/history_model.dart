class HistoryModel {
  bool? status;
  Message? message;
  List<Data>? data;
  Links? links;
  Meta? meta;

  HistoryModel({this.status, this.message, this.data, this.links, this.meta});

  HistoryModel.fromJson(Map<String, dynamic> json) {
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
  bool? isSpecial;
  String? status;
  String? startLatitude;
  String? startLongitude;
  String? startAddress;
  String? endLatitude;
  String? endLongitude;
  String? endAddress;
  String? driverProfit;
  String? appProfit;
  int? ratedTrip;
  ClientId? clientId;
  int? cancelResons;
  String? startDateSpecial;
  String? endDate;

  Data(
      {this.id,
        this.isSpecial,
        this.status,
        this.startLatitude,
        this.startLongitude,
        this.startAddress,
        this.endLatitude,
        this.endLongitude,
        this.endAddress,
        this.driverProfit,
        this.appProfit,
        this.ratedTrip,
        this.clientId,
        this.cancelResons,
        this.startDateSpecial,
        this.endDate});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isSpecial = json['is_special'];
    status = json['status'];
    startLatitude = json['start_latitude'];
    startLongitude = json['start_longitude'];
    startAddress = json['start_address'];
    endLatitude = json['end_latitude'];
    endLongitude = json['end_longitude'];
    endAddress = json['end_address'];
    driverProfit = json['driver_profit'];
    appProfit = json['app_profit'];
    ratedTrip = json['rated_trip'];
    clientId = json['client_id'] != null
        ? new ClientId.fromJson(json['client_id'])
        : null;
    cancelResons = json['cancel_resons'];
    startDateSpecial = json['start_date_special'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_special'] = this.isSpecial;
    data['status'] = this.status;
    data['start_latitude'] = this.startLatitude;
    data['start_longitude'] = this.startLongitude;
    data['start_address'] = this.startAddress;
    data['end_latitude'] = this.endLatitude;
    data['end_longitude'] = this.endLongitude;
    data['end_address'] = this.endAddress;
    data['driver_profit'] = this.driverProfit;
    data['app_profit'] = this.appProfit;
    data['rated_trip'] = this.ratedTrip;
    if (this.clientId != null) {
      data['client_id'] = this.clientId!.toJson();
    }
    data['cancel_resons'] = this.cancelResons;
    data['start_date_special'] = this.startDateSpecial;
    data['end_date'] = this.endDate;
    return data;
  }
}

class ClientId {
  int? id;
  String? name;
  String? phone;
  String? avatar;

  ClientId({this.id, this.name, this.phone, this.avatar});

  ClientId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['avatar'] = this.avatar;
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


