class CancellingModel {
  bool? status;
  Message? message;
  List<Data>? data;

  CancellingModel({this.status, this.message, this.data});

  CancellingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
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
  Reason? reason;
  String? type;

  Data({this.id, this.reason, this.type});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reason =
    json['reason'] != null ? new Reason.fromJson(json['reason']) : null;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.reason != null) {
      data['reason'] = this.reason!.toJson();
    }
    data['type'] = this.type;
    return data;
  }
}

class Reason {
  String? en;
  String? ar;

  Reason({this.en, this.ar});

  Reason.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}
