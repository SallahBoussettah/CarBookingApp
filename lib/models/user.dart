/// User model representing a user in the system
class User {
  /// Unique identifier for the user
  final String id;

  /// User's full name
  final String name;

  /// User's email address
  final String email;

  /// User's phone number
  final String phoneNumber;

  /// URL to user's profile picture
  final String? profilePicture;

  /// User's home address
  final String address;

  /// User's preferred payment method
  final String preferredPaymentMethod;

  /// User's driver's license number
  final String driverLicenseNumber;

  /// Date when the driver's license was issued
  final DateTime driverLicenseIssueDate;

  /// Date when the driver's license expires
  final DateTime driverLicenseExpiryDate;

  /// Whether the user has verified their email
  final bool isEmailVerified;

  /// Whether the user has verified their phone number
  final bool isPhoneVerified;

  /// Date when the user joined the platform
  final DateTime joinedDate;

  /// Constructor
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profilePicture,
    required this.address,
    required this.preferredPaymentMethod,
    required this.driverLicenseNumber,
    required this.driverLicenseIssueDate,
    required this.driverLicenseExpiryDate,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.joinedDate,
  });

  /// Create a User from JSON data
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      profilePicture: json['profilePicture'] as String?,
      address: json['address'] as String,
      preferredPaymentMethod: json['preferredPaymentMethod'] as String,
      driverLicenseNumber: json['driverLicenseNumber'] as String,
      driverLicenseIssueDate: DateTime.parse(json['driverLicenseIssueDate'] as String),
      driverLicenseExpiryDate: DateTime.parse(json['driverLicenseExpiryDate'] as String),
      isEmailVerified: json['isEmailVerified'] as bool,
      isPhoneVerified: json['isPhoneVerified'] as bool,
      joinedDate: DateTime.parse(json['joinedDate'] as String),
    );
  }

  /// Convert User to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'address': address,
      'preferredPaymentMethod': preferredPaymentMethod,
      'driverLicenseNumber': driverLicenseNumber,
      'driverLicenseIssueDate': driverLicenseIssueDate.toIso8601String(),
      'driverLicenseExpiryDate': driverLicenseExpiryDate.toIso8601String(),
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'joinedDate': joinedDate.toIso8601String(),
    };
  }

  /// Create a copy of this User with the given fields replaced with new values
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? profilePicture,
    String? address,
    String? preferredPaymentMethod,
    String? driverLicenseNumber,
    DateTime? driverLicenseIssueDate,
    DateTime? driverLicenseExpiryDate,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    DateTime? joinedDate,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      address: address ?? this.address,
      preferredPaymentMethod: preferredPaymentMethod ?? this.preferredPaymentMethod,
      driverLicenseNumber: driverLicenseNumber ?? this.driverLicenseNumber,
      driverLicenseIssueDate: driverLicenseIssueDate ?? this.driverLicenseIssueDate,
      driverLicenseExpiryDate: driverLicenseExpiryDate ?? this.driverLicenseExpiryDate,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }
}