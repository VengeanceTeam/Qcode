import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stackexchange/widgets/TextCode.dart';
import 'package:stackexchange/widgets/comments.dart';
import 'package:stackexchange/widgets/save_button.dart';
import '../widgets/Comment_component.dart';
import '../widgets/question_images.dart';
import 'package:url_launcher/url_launcher.dart';

class FullPost extends StatefulWidget {
  const FullPost({super.key});

  @override
  State<FullPost> createState() => _FullPostState();
}

class _FullPostState extends State<FullPost> {
  bool bookmark = false;

  bool _isNew(DateTime date) {
    final DateTime dateTime = DateTime.now();
    final diffirence = dateTime.difference(date);
    if (diffirence.inHours < 12) {
      return true;
    }
    return false;
  }

  String _getTime(String date) {
    String dif;
    final DateTime time = DateTime.now();
    final DateTime postTime = DateTime.parse(date);
    if (time.difference(postTime).inDays != 0) {
      dif = "${time.difference(postTime).inDays.toString()} days ago";
    } else if (time.difference(postTime).inHours != 0) {
      dif = "${time.difference(postTime).inHours.toString()} hours ago";
    } else if (time.difference(postTime).inMinutes != 0) {
      dif = "${time.difference(postTime).inMinutes.toString()} min ago";
    } else {
      dif = "${time.difference(postTime).inSeconds.toString()} sec ago";
    }
    return dif;
  }

  PageController _controller = PageController(
    initialPage: 0,
    viewportFraction: 0.9,
  );

  Widget _textCode(String code, String type) {
    TextCode.textCodeEditor = code;
    TextCode.type = type;
    return TextCode();
  }

  @override
  Widget build(BuildContext context) {
    final details =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${details['question']['userFullName'].toString().split(' ')[0]}'s post"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          padding: EdgeInsets.only(bottom: 100),
          children: [
            Container(
              padding: EdgeInsets.all(15),
              //color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    trailing: SaveButton(details['question'], false),
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      details['question']['userFullName'].toString(),
                    ),
                    subtitle: Text(
                      _getTime(details['question']['date'].toString()),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        details['question']['userImageUrl'],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  //title
                  SelectableText(
                    details['question']['questionTitle'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //subtitle
                  SelectableText(
                    details['question']['description'].toString(),
                    // style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    //     height: 1.4, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  if (details['question']['code'] != "null")
                    _textCode(
                      details['question']['code'],
                      details['question']['type'],
                    ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text(
                          details['question']['type'],
                          style: TextStyle(
                              fontSize: 15, color: Colors.blueGrey.shade300),
                        ),
                      ),
                      if (details['question']['code'] != "null")
                        ElevatedButton.icon(
                          onPressed: () async {
                            final Uri codeURL = Uri.parse(
                                'https://replit.com/new/${details['question']['type']}');

                            Future<void> CodeURL() async {
                              if (!await launchUrl(codeURL)) {
                                throw 'Could not launch $codeURL';
                              }
                            }

                            if (details['question']['code'] != "null") {
                              await Clipboard.setData(ClipboardData(
                                  text: details['question']['code']));
                              CodeURL();
                            }
                          },
                          icon: Icon(Icons.play_arrow),
                          label: Text("Run Code"),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  if (details['question']['images'].length != 0)
                    Container(
                      height: 300,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: QuestionImages(details['question']['images']),
                    ),
                ],
              ),
            ),

            Divider(
              thickness: 10,
              height: 10,
              //color: Colors.blueGrey.shade50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Comments",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            Comments(details['question'], details['rebuild']),
          ],
        ),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/CommentSheet',
            arguments: {
              "id": details['question'].id,
              "isComment": true,
              // "questionOwnerId": details['userId'],
              "questionOwnerId": details['questionOwnerId'],
              'questionTitle': details['question']['questionTitle'].toString()
            },
          );
        },
        //backgroundColor: Color(0xff2f3b47),
        label: Row(
          children: [
            Text(
              "Comment",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.add_comment_outlined,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
