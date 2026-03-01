class ContactModel {
  final bool? status;
  final Message? message;
  final dynamic payload;

  ContactModel({
    this.status,
    this.message,
    this.payload,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      status: json['status'] as bool?,
      message: json['message'] != null
          ? Message.fromJson(json['message'])
          : null,
      payload: json['payload'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message?.toJson(),
      'payload': payload,
    };
  }
}

class Message {
  final String? ar;
  final String? en;

  Message({this.ar, this.en});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      ar: json['ar'] as String?,
      en: json['en'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ar': ar,
      'en': en,
    };
  }
}
