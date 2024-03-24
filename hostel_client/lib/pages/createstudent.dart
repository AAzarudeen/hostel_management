import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

class CreateStudent extends StatefulWidget {
  const CreateStudent({super.key});

  @override
  State<CreateStudent> createState() => _CreateStudentState();
}

class _CreateStudentState extends State<CreateStudent> {
  Uint8List? _imageData;
  
  final picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _registerController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _blockController = TextEditingController();
  final TextEditingController _roomNumberController = TextEditingController();
  final TextEditingController _parentEmailController = TextEditingController();
  final TextEditingController _parentNumberController = TextEditingController();

  List<String> hostels = ['A', 'B', 'C', 'D'];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const Text("Student details"),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(label: Text("Name")),
        ),
        TextField(
          controller: _registerController,
          decoration: const InputDecoration(label: Text("Register number")),
        ),
        TextField(
          controller: _phoneController,
          decoration: const InputDecoration(label: Text("Phone number")),
        ),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(label: Text("Email id")),
        ),
        TextField(
          controller: _blockController,
          decoration: const InputDecoration(label: Text("Hostel Block")),
        ),
        TextField(
          controller: _roomNumberController,
          decoration: const InputDecoration(label: Text("Room number")),
        ),
        TextField(
          controller: _parentEmailController,
          decoration: const InputDecoration(label: Text("Parent Email ID")),
        ),
        TextField(
          controller: _parentNumberController,
          decoration: const InputDecoration(label: Text("Parent Phone number")),
        ),
        const SizedBox(height: 20.0),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          if (_imageData != null)
              Image.memory(
                _imageData!,
                width: 100,
                height: 100,
              )
            else
              const Text('No image selected'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _getImage,
            child: const Text('Select Image'),
          )
        ]),
        const SizedBox(height: 20.0),
        ElevatedButton(
            onPressed: uploadFile,
            child: const Text("Create student")),
      ],
    ));
  }

  Future uploadFile() async {
    print("hello");
    final blob = html.Blob([_imageData], 'image/jpeg');
    final file = html.File([blob], 'image.jpg');
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('students/2022179017.jpg');
    UploadTask uploadTask = storageReference.putBlob(file);
    print("file updloaded");
    await uploadTask.whenComplete(() => {
            _firestore.collection('students').doc("2022179017").set({
            'name': "Azarudeen",
            'register': "2022179017",
            'email': "2022179017@student.annauniv.edu",
            'number': "8667288997",
            'block': "thazam",
            'room_number': "66",
            'parent_email_id': "azarcrackzz@gmail.com",
            'parent_number': "9789291871"
          }).then((value) {
            FirebaseAuth auth = FirebaseAuth.instance;
            auth.createUserWithEmailAndPassword(email: "2022179017@student.annauniv.edu", password: "2022179017");
            print('Data added successfully!');
            auth.createUserWithEmailAndPassword(email: "azarcrackzz@gmail.com", password: "9789291871");
            print("data uploaded");
          }).catchError((error) {
            print('Failed to add data: $error');
          })
        });
        print("hello end");
  }

  void _getImage() async {
    final imageData = await ImagePickerWeb.getImageAsBytes();
    if (imageData != null) {
      setState(() {
        _imageData = Uint8List.fromList(imageData);
      });
    }
  }
}
