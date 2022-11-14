import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart' as u;

class AppDrawer extends StatefulWidget {
  AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  //only for testing:
  String imageURL = "https://cdn-icons-png.flaticon.com/512/149/149071.png";
  final u.User _user = u.User.getInstance();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          color: Colors.black,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    _user.userData['Full name'],
                    style: TextStyle(fontSize: 24),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  accountEmail: Text(
                    FirebaseAuth.instance.currentUser!.email!,
                  ),
                  currentAccountPicture: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: ((context) {
                          return Dialog(
                            insetPadding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InteractiveViewer(
                                  child: Container(
                                    height: constraints.maxHeight * 0.9,
                                    child: Image(
                                      image: NetworkImage(
                                          _user.userData['User image']),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ); //Create item
                        }),
                      );
                    },
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(_user.userData['User image']),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    "My profile",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  leading: const Icon(Icons.person),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/profile', arguments: _user.userData.id);
                  },
                ),
                ListTile(
                  title: Text(
                    "My questions",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  leading: const Icon(Icons.my_library_books),
                  onTap: () {
                    Navigator.of(context).pushNamed('/my_questions');
                  },
                ),
                ListTile(
                  title: Text(
                    "My Saves",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  leading: const Icon(Icons.bookmark),
                  onTap: () {
                    Navigator.of(context).pushNamed('/my_saves');
                  },
                ),
                ListTile(
                  title: Text(
                    "Search on Stackoverflow",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  leading: const FaIcon(FontAwesomeIcons.stackOverflow),
                  onTap: () {
                    Navigator.of(context).pushNamed('/stackoverflow');
                  },
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.368,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      await GoogleSignIn().signOut();
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Logout",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    await Navigator.of(context).pushNamed('/Contact_Us');
                  },
                  title: Text(
                    "Contact us",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  leading: Icon(Icons.contact_support_outlined),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
