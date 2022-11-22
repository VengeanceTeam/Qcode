import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart' as u;

class Notifications {
  Future<void> PushNotification(
      OwnerId, questionTitle, commentContent, isComment, actionTime) async {
    String notificationBody = '';
    String notificationSubTitle = '';

    if (isComment) {
      notificationBody = 'commented on your post';
      notificationSubTitle = questionTitle;
    } else {
      notificationBody = 'replied to your comment';
      notificationSubTitle = commentContent;
    }

    final u.User _user = u.User.getInstance();
    _user.getUserData();

    DocumentSnapshot? documentSnapshot;
    documentSnapshot = _user.userData;

    String CommentatorName = documentSnapshot['Full name'].toString();

    await FirebaseFirestore.instance
        .collection('Notifications')
        .doc(OwnerId)
        .collection('NewNotifications')
        .add({
      'CommentatorName': '$CommentatorName',
      'title': '$notificationBody',
      'subtitle': '$notificationSubTitle',
      'actionTime': '$actionTime',
      'timestamp': FieldValue.serverTimestamp()
    });
  }
}
