class UserModel {
  String uid;
  String phoneNumber;
  String firstName;
  String lastName;
  String countryCode;
  DateTime createdAt;
  DateTime updatedAt;
  String? profileImageUrl;
  String? email;

  UserModel({
    required this.uid,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.countryCode,
    required this.createdAt,
    required this.updatedAt,
    this.profileImageUrl,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'countryCode': countryCode,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'profileImageUrl': profileImageUrl,
      'email': email,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      phoneNumber: json['phoneNumber'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      countryCode: json['countryCode'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      profileImageUrl: json['profileImageUrl'] as String?,
      email: json['email'] as String?,
    );
  }
}
