import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stackexchange/widgets/contact.dart';
import '../../models/user.dart' as u;

class GetContact extends StatefulWidget {
  const GetContact({super.key});

  @override
  State<GetContact> createState() => _GetContactState();
}

class _GetContactState extends State<GetContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Contacts'),
        ),
        body: Container(
            height: double.infinity,
            width: double.infinity,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Contact Us")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasData) {
                    final data = snapshot.data!.docs;

                    return ListView.separated(
                      itemCount: data.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SelectableText(
                                  "User name: ${data[index]["Full name"]}",
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 10,
                                  child: Divider(
                                    thickness: 1,
                                  ),
                                ),
                                SelectableText(
                                  "Email: ${data[index]["User Email"]}",
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                    height: 10,
                                    child: Divider(
                                      thickness: 1,
                                    )),
                                SelectableText(
                                  "${data[index]["message"]}",
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ));
                      },
                    );
                  }
                  return Text("There is no data");
                })));
  }
}
