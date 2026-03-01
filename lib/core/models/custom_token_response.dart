class CustomTokenResponse {
  final String firebaseCustomToken;
  final String? tenantId;
  final String? role;

  const CustomTokenResponse({
    required this.firebaseCustomToken,
    this.tenantId,
    this.role,
  });

  factory CustomTokenResponse.fromJson(Map<String, dynamic> json) {
    return CustomTokenResponse(
      firebaseCustomToken: (json['firebase_custom_token'] ?? json['token'] ?? '') as String,
      tenantId: json['tenantId'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'firebase_custom_token': firebaseCustomToken,
    if (tenantId != null) 'tenantId': tenantId,
    if (role != null) 'role': role,
  };
}
