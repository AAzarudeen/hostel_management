import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:hostel_client/common/UserProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Setnotification extends StatefulWidget {

  const Setnotification({super.key});

  @override
  State<Setnotification> createState() => _Setnotification();
}
class firebaseapi{
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications( ) async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print("Token : $fCMToken");
  }
}
class _Setnotification extends State<Setnotification> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
      bool? student = false,
      rc = false,
      parent = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _blockController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _blockController,
              decoration: const InputDecoration(labelText: 'description'),
            ),
            //     Checkbox( //only check box
            //         value: student, //unchecked
            //         onChanged: (bool? value){
            //           //value returned when checkbox is clicked
            //           setState(() {
            //             student = value;
            //           });
            //         },
            // ),
            //   Center(
            CheckboxListTile(
              value: rc,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                setState(() {
                  rc = value;
                });
              },
              title: Text("RC"),
            ),
            CheckboxListTile(
              value: student,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                setState(() {
                  student = value;
                });
              },
              title: Text("Student"),
            ),

            CheckboxListTile(
              value: parent,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                setState(() {
                  parent = value;
                });
              },
              title: Text("Parent"),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                sendNotification("title","body");
              },
              child: const Text('Save Resident'),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> sendNotification( String title, String body) async {
    final String serverKey = 'AAAAtg0EEYo:APA91bHEknCCD7mV_OSnna70d6xnOyMyakKbxqgo_WyD-5k95XATGcxS2ju7a1I51Z1Nf05tRNwB8kX1BFxembwOuZw1KOrsC5OO9Yc5K__irXdpiaz9Tl4Xcw3UOI_l5cvb40P_KQy4'; // Your Firebase server key

    final Map<String, dynamic> notification = {
      'body': body,
      'title': title,
    };

    final Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done'
    };

    String to = "";

    if (parent == true){
      to="parent";
    }
    if (student == true){
      to="student";
    }
    final Map<String, dynamic> payload = {
      'notification': notification,
      'data': data,
      'to': "eeoQGorxTkuetcZxpHsRbh:APA91bGv49g0namwv4y4n9Mytn44huh0irFb15B9T8tupgfkKJnN_8hueFsI5oVSO-7X5FIAxg4pH8KUgCbQBwpXd9HXCxcR0ZBKX-OG8-MQw_afCQSQc2o39GLempVfrPaa-EZIIAfK",
    };

    final String url = 'https://fcm.googleapis.com/fcm/send';

    print("Hi");
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification. Error: ${response.body}');
      }
    } catch (e) {
      print('Failed to send notification. Error: $e');
    }
  }
}