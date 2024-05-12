import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Setnotification extends StatefulWidget {
  const Setnotification({super.key});

  @override
  State<Setnotification> createState() => _Setnotification();
}

class firebaseapi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print("Token : $fCMToken");
  }
}

class _Setnotification extends State<Setnotification> {
  late PlatformFile _fileData;
  final picker = ImagePicker();
  FirebaseStorage storage = FirebaseStorage.instance;
  bool? student = false, rc = false, parent = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notification'),
        ),
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade800,
                  Colors.blue.shade600,
                  Colors.blue.shade400,
                ],
              ),
            ),
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextField(
                                  controller: _titleController,
                                  decoration:
                                      const InputDecoration(labelText: 'Title'),
                                ),
                                TextField(
                                  controller: _descriptionController,
                                  decoration: const InputDecoration(
                                      labelText: 'description'),
                                ),
                                TextField(
                                  controller: _messageController,
                                  decoration: const InputDecoration(labelText: 'Message'),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(onPressed: (){
                                  _pickAndUploadImage();
                                }, child: const Text("Add a file")),
                                const SizedBox(height: 20.0),
                                ElevatedButton(
                                  onPressed: () {
                                    sendNotification("Circular", "Tap to open circular");
                                    _uploadFile();
                                  },
                                  child: const Text('Send notification'),
                                ),
                              ],
                            ),
                          ),
                        ))))));
  }

  Future<void> _pickAndUploadImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result != null) {
      final file = result.files.single;
      setState(() {
        _fileData = file;
      });
    }
  }

  Future<void> _uploadFile() async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('circulars/${_fileData.name}');
    UploadTask uploadTask = storageReference.putData(
        _fileData.bytes as Uint8List, SettableMetadata(contentType: 'file/${_fileData.extension}'));
    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();
    _firestore.collection('circulars').doc(DateTime.now().toString()).set({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'message': _messageController.text,
      'file_url': downloadURL
        }).then((value) {
      AlertDialog(
        title: const Text('Success'),
        content: const Text('Data is saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
    });
  }

  Future<void> sendNotification(String title, String body) async {
    const String serverKey =
        'AAAAtg0EEYo:APA91bHEknCCD7mV_OSnna70d6xnOyMyakKbxqgo_WyD-5k95XATGcxS2ju7a1I51Z1Nf05tRNwB8kX1BFxembwOuZw1KOrsC5OO9Yc5K__irXdpiaz9Tl4Xcw3UOI_l5cvb40P_KQy4'; // Your Firebase server key

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

    if (parent == true) {
      to = "parent";
    }
    if (student == true) {
      to = "student";
    }
    final Map<String, dynamic> payload = {
      'notification': notification,
      'data': data,
      'to':
          "eeoQGorxTkuetcZxpHsRbh:APA91bGv49g0namwv4y4n9Mytn44huh0irFb15B9T8tupgfkKJnN_8hueFsI5oVSO-7X5FIAxg4pH8KUgCbQBwpXd9HXCxcR0ZBKX-OG8-MQw_afCQSQc2o39GLempVfrPaa-EZIIAfK",
    };

    final String url = 'https://fcm.googleapis.com/fcm/send';

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
