import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stackexchange/models/notifications.dart';
import 'dart:io' as i;
import '../models/question.dart';
import '../models/user.dart' as u;

class CommentSheet extends StatefulWidget {
  const CommentSheet({super.key});
  // final String? description;
  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final List<XFile> images = [];
  Future pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      setState(() {
        images.add(image);
      });
    }
    return;
  }

  final TextEditingController _solutionController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> details =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    String questiOwnerId = details['questionOwnerId'].toString();
    String questionTitle = details['questionTitle'].toString();
    DateTime now = new DateTime.now();
    final String currentTime = now.format(DateTimeFormats.american);
    Notifications x = new Notifications();

    return Scaffold(
      appBar: AppBar(
        title: Text("Add comment"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                images.clear();
              });
            },
            child: Text(
              "Clear",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    onPressed: () async {
                      try {
                        setState(() {
                          _isLoading = !_isLoading;
                        });
                        if (details['isComment']) {
                          await Question.addNewComment(
                            {
                              "comment": _solutionController.text,
                              "images": images,
                            },
                            details['id'],
                          );

                          x.PushNotification(questiOwnerId, questionTitle,
                              details['comment'], true, currentTime);
                        } else {
                          await Question.addNewReply(
                            {
                              "comment": _solutionController.text,
                              "images": images,
                            },
                            details['id'],
                          );
                          x.PushNotification(
                              details['commentOwnerId'].toString(),
                              questionTitle,
                              details['comment'],
                              false,
                              currentTime);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                              "Comment Added Successfully",
                            ),
                          ),
                        );
                        Navigator.of(context).pop();
                      } catch (err) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              err.toString(),
                            ),
                          ),
                        );
                      }
                      setState(() {
                        _isLoading = !_isLoading;
                      });
                    },
                    child: const Text("Post"),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _solutionController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Write your solution'),
              ),
            ),
            Column(
              children: List.generate(images.length, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                        i.File(images[index].path),
                      ),
                    ),
                  ),
                );
              }),
            ),
            TextButton.icon(
              onPressed: () async {
                await pickImage();
              },
              icon: const FaIcon(FontAwesomeIcons.images),
              label: const Text("Add photo"),
            ),
          ],
        ),
      ),
    );
  }
}
