class UserModel {
  final String name;
  final String? avatar;
  final String email;
  final String phone;
  final double? latitude;
  final double? longitude;
  final String? pushNotificationsToken;
  final String? accountType;
  final String? certification;
  final bool? isPaid;

  UserModel({
    required this.name,
    this.avatar,
    required this.email,
    required this.phone,
    this.latitude,
    this.longitude,
    this.pushNotificationsToken,
    this.accountType,
    this.certification,
    this.isPaid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    double? _toDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    return UserModel(
      name: json['name'] as String? ?? '',
      avatar: json['avatar'] as String?,
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      pushNotificationsToken: json['push_notifications_token'] as String?,
      accountType: json['account_type'] as String?,
      certification: json['certification'] as String?,
      isPaid: json['is_paid'] is bool ? json['is_paid'] as bool : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatar': avatar,
      'email': email,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'push_notifications_token': pushNotificationsToken,
      'account_type': accountType,
      'certification': certification,
      'is_paid': isPaid,
    };
  }
}
