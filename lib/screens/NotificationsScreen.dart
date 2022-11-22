import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_time_format/date_time_format.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  CollectionReference Notifications = FirebaseFirestore.instance
      .collection('Notifications')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('NewNotifications');

  @override
  Widget build(BuildContext context) {
    // DateTime now = new DateTime.now();
    // final String currentTime = now.format(DateTimeFormats.american);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Notifications'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: StreamBuilder(
          stream:
              Notifications.orderBy('timestamp', descending: true).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 5,
                  );
                },
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Color.fromARGB(255, 234, 231, 231),
                      child: ListTile(
                        onTap: () {},
                        dense: true,
                        isThreeLine: true,
                        title: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                color: Colors.black, fontSize: 17),
                            children: <TextSpan>[
                              TextSpan(
                                text: documentSnapshot['CommentatorName'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: ' '),
                              TextSpan(text: documentSnapshot['title'])
                            ],
                          ),
                        ),
                        // title: Text(documentSnapshot['title']),
                        subtitle: Text(
                            '${documentSnapshot['subtitle']} -\n${documentSnapshot['actionTime']}'),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
