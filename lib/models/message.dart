import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String name;
  String contact;
  String sendBy;
  Timestamp createdAt; // Unix timestamp (milliseconds since epoch)
  String message;

  MessageModel({
    required this.name,
    required this.contact,
    required this.sendBy,
    required this.createdAt,
    required this.message,
  });

  // From JSON (Map<String, dynamic>) to Dart Object
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      name: json['name'] as String,
      sendBy: json["sendBy"],
      contact: json['contact'] as String,
      createdAt: json['createdAt'] as Timestamp, // Expecting a timestamp (int)
      message: json['message'] as String,
    );
  }

  // From Dart Object to JSON (Map<String, dynamic>)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contact': contact,
      "sendBy": sendBy,
      'createdAt': createdAt, // Save the timestamp directly
      'message': message,
    };
  }
}
