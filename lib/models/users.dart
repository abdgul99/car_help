import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType {
  serviceProvider,
  normalUser,
}

class UserModel {
  final String name;
  final String email;
  final String phoneNumber;
  final Timestamp createdAt;
  final Timestamp modifiedAt;
  final UserType userType;

  UserModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.createdAt,
    required this.modifiedAt,
    required this.userType,
  });

  // Convert a Map to a UserModel instance
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      phoneNumber: map['phone_number'] as String,
      createdAt: map['created_at'] as Timestamp,
      modifiedAt: map['modified_at'] as Timestamp,
      userType: _userTypeFromString(map['user_type'] as String),
    );
  }

  // Convert a UserModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'created_at': createdAt,
      'modified_at': modifiedAt,
      'user_type': _userTypeToString(userType),
    };
  }

  // Convert Firestore Timestamps to DateTime objects for convenience
  DateTime get createdAtDateTime => createdAt.toDate();
  DateTime get modifiedAtDateTime => modifiedAt.toDate();

  // Create a copy of the UserModel instance with optional new values
  UserModel copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    Timestamp? createdAt,
    Timestamp? modifiedAt,
    UserType? userType,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      userType: userType ?? this.userType,
    );
  }

  // Helper methods for converting UserType to and from String
  static UserType _userTypeFromString(String userTypeString) {
    switch (userTypeString) {
      case 'serviceProvider':
        return UserType.serviceProvider;
      case 'normalUser':
        return UserType.normalUser;
      default:
        throw ArgumentError('Unknown user type: $userTypeString');
    }
  }

  static String _userTypeToString(UserType userType) {
    switch (userType) {
      case UserType.serviceProvider:
        return 'serviceProvider';
      case UserType.normalUser:
        return 'normalUser';
    }
  }
}
