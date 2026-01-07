/// Modelo de Usuario para la app
/// Compatible con WordPress/WooCommerce customer
class UserModel {
  final int id;
  final String email;
  final String? displayName;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final String? role;
  final DateTime? dateCreated;
  final bool isVerified;

  // Campos adicionales de WooCommerce customer
  final String? phone;
  final BillingAddress? billing;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.role,
    this.dateCreated,
    this.isVerified = false,
    this.phone,
    this.billing,
  });

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName'.trim();
    }
    return displayName ?? email.split('@').first;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      displayName: json['name'] ?? json['display_name'] ?? json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatarUrl: _extractAvatarUrl(json),
      role: json['role'],
      dateCreated: json['date_created'] != null
          ? DateTime.tryParse(json['date_created'])
          : null,
      isVerified: json['is_paying_customer'] ?? false,
      phone: json['billing']?['phone'],
      billing: json['billing'] != null
          ? BillingAddress.fromJson(json['billing'])
          : null,
    );
  }

  static String? _extractAvatarUrl(Map<String, dynamic> json) {
    // WordPress format
    if (json['avatar_urls'] is Map) {
      final avatars = json['avatar_urls'] as Map;
      return avatars['96'] ?? avatars['48'] ?? avatars.values.firstOrNull;
    }
    // WooCommerce format
    return json['avatar_url'];
  }

  /// Factory para datos de Cloud Functions (formato simplificado)
  factory UserModel.fromCloudFunction(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'first_name': firstName,
      'last_name': lastName,
      'avatar_url': avatarUrl,
      'role': role,
      'phone': phone,
    };
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? displayName,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    String? role,
    DateTime? dateCreated,
    bool? isVerified,
    String? phone,
    BillingAddress? billing,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      dateCreated: dateCreated ?? this.dateCreated,
      isVerified: isVerified ?? this.isVerified,
      phone: phone ?? this.phone,
      billing: billing ?? this.billing,
    );
  }
}

class BillingAddress {
  final String? firstName;
  final String? lastName;
  final String? company;
  final String? address1;
  final String? address2;
  final String? city;
  final String? state;
  final String? postcode;
  final String? country;
  final String? email;
  final String? phone;

  BillingAddress({
    this.firstName,
    this.lastName,
    this.company,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.postcode,
    this.country,
    this.email,
    this.phone,
  });

  factory BillingAddress.fromJson(Map<String, dynamic> json) {
    return BillingAddress(
      firstName: json['first_name'],
      lastName: json['last_name'],
      company: json['company'],
      address1: json['address_1'],
      address2: json['address_2'],
      city: json['city'],
      state: json['state'],
      postcode: json['postcode'],
      country: json['country'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'company': company,
      'address_1': address1,
      'address_2': address2,
      'city': city,
      'state': state,
      'postcode': postcode,
      'country': country,
      'email': email,
      'phone': phone,
    };
  }
}
