class ConfirmLocationsModel {
  bool? status;
  Message? message;
  int? tripId;
  bool? isSpecial;
  double? distanceKm;
  double? price;
  double? appProfit;
  double? driverProfit;
  int? etaMinutes;
  double? durationHours;
  String? durationHhmm;
  String? etaFinishAtIso;

  ConfirmLocationsModel(
      {this.status,
        this.message,
        this.tripId,
        this.isSpecial,
        this.distanceKm,
        this.price,
        this.appProfit,
        this.driverProfit,
        this.etaMinutes,
        this.durationHours,
        this.durationHhmm,
        this.etaFinishAtIso});

  ConfirmLocationsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
    tripId = json['trip_id'];
    isSpecial = json['is_special'];
    distanceKm = json['distance_km'];
    price = json['price'];
    appProfit = json['app_profit'];
    driverProfit = json['driver_profit'];
    etaMinutes = json['eta_minutes'];
    durationHours = json['duration_hours'];
    durationHhmm = json['duration_hhmm'];
    etaFinishAtIso = json['eta_finish_at_iso'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    data['trip_id'] = this.tripId;
    data['is_special'] = this.isSpecial;
    data['distance_km'] = this.distanceKm;
    data['price'] = this.price;
    data['app_profit'] = this.appProfit;
    data['driver_profit'] = this.driverProfit;
    data['eta_minutes'] = this.etaMinutes;
    data['duration_hours'] = this.durationHours;
    data['duration_hhmm'] = this.durationHhmm;
    data['eta_finish_at_iso'] = this.etaFinishAtIso;
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
