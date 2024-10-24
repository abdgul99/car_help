import 'dart:convert';

class ContactModel {
  String name;
  String contact;

  ContactModel({required this.name, required this.contact});

  // Convert the Item to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contact': contact,
    };
  }

  // Create an Item from a Map
  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      name: map['name'],
      contact: map['contact'],
    );
  }

  // Convert Item to a JSON string
  String toJson() => json.encode(toMap());

  // Create Item from a JSON string
  factory ContactModel.fromJson(String jsonStr) {
    final Map<String, dynamic> map = json.decode(jsonStr);
    return ContactModel.fromMap(map);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContactModel &&
        other.name == name &&
        other.contact == contact;
  }

  @override
  int get hashCode => name.hashCode ^ contact.hashCode;
}
