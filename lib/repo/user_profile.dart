import 'package:car_help_app/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileProvider = FutureProvider.autoDispose<UserModel>((ref) async {
  final firebase = await FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .withConverter(
          fromFirestore: (snapshot, options) =>
              UserModel.fromMap(snapshot.data()!),
          toFirestore: (value, options) => value.toMap())
      .get();
  return firebase.data()!;
});
