import 'package:car_help_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FirestoreQueryBuilder<MessageModel>(
            query: FirebaseFirestore.instance
                .collection("messages")
                .where("sendBy",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .withConverter(
                  fromFirestore: (snapshot, options) =>
                      MessageModel.fromJson(snapshot.data()!),
                  toFirestore: (value, options) => value.toJson(),
                ),
            pageSize: 10,
            builder: (context, snapshot, _) {
              return snapshot.docs.isEmpty
                  ? const Center(child: Text("No Messages found!"))
                  : ListView.builder(
                      itemCount: snapshot.docs.length,
                      itemBuilder: (context, index) {
                        // if we reached the end of the currently obtained items, we try to
                        // obtain more items

                        if (snapshot.isFetching && snapshot.docs.isEmpty) {
                          return const Column(
                            children: [
                              CircularProgressIndicator(),
                            ],
                          );
                        }
                        if (snapshot.hasError) {
                          return Text(
                              'Something went wrong! ${snapshot.error}');
                        }

                        if (snapshot.hasMore &&
                            index + 1 == snapshot.docs.length) {
                          // Tell FirestoreQueryBuilder to try to obtain more items.
                          // It is safe to call this function from within the build method.
                          snapshot.fetchMore();
                        }

                        final message = snapshot.docs[index].data();

                        return Container(
                          padding: const EdgeInsets.all(8),
                          margin: EdgeInsets.all(10),
                          color: Colors.teal[100],
                          child: ListTile(
                            trailing:
                                Text(message.createdAt.toDate().toString()),
                            title: Text(
                              "${message.name}\n ${message.contact}",
                              style: TextStyle(fontSize: 11),
                            ),
                            subtitle: Text(message.message),
                          ),
                        );
                      },
                    );
            },
          ),
        ),
      ],
    );
  }
  // String getTime(){

  // }
}