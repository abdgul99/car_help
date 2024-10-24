import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType {
  serviceProvider,
  normalUser,
}

class UserModel {
  final String name;
  final String email;
  final String phoneNumber;

  final String image;
  final String message;
  final Timestamp createdAt;
  final Timestamp modifiedAt;

  UserModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.createdAt,
    required this.image,
    required this.message,
    required this.modifiedAt,
  });

  // Convert a Map to a UserModel instance
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      image: map["image"] ?? "",
      phoneNumber: map['phone_number'] as String,
      createdAt: map['created_at'] as Timestamp,
      message: map["message"] ?? "",
      modifiedAt: map['modified_at'] as Timestamp,
    );
  }

  // Convert a UserModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      "message": message,
      "image": image,
      'created_at': createdAt,
      'modified_at': modifiedAt,
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
    String? message,
    String? image,
    UserType? userType,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      image: image ?? this.image,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
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
